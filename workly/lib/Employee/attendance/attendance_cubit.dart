import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:projects_flutter/Employee/Models/AttendanceModel.dart';
import 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit() : super(AttendanceInitial());

  final _db = FirebaseFirestore.instance;

  // Format today's document ID (yyyy-MM-dd)
  String _todayDocId(DateTime now) => DateFormat('yyyy-MM-dd').format(now);

  // Calculate distance between two points (meters) using Haversine formula
  double _distanceInMeters(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000; // meter
    final dLat = (lat2 - lat1) * pi / 180;
    final dLon = (lon2 - lon1) * pi / 180;
    final a = sin(dLat/2)*sin(dLat/2) +
        cos(lat1*pi/180)*cos(lat2*pi/180)*sin(dLon/2)*sin(dLon/2);
    final c = 2 * atan2(sqrt(a), sqrt(1-a));
    return R * c;
  }

  // Get the current location (latitude & longitude)
  Future<({double lat, double lng})?> _getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    return (lat: pos.latitude, lng: pos.longitude);
  }
  Future<void> updateLocation({required String uid}) async {
    try {
      emit(AttendanceLoading());

      // 1) Fetch employee data (company location)
      final empDoc = await _db.collection('Employee').doc(uid).get();
      if (!empDoc.exists) {
        emit(AttendanceError('Employee not found'));
        return;
      }
      final emp = empDoc.data()!;
      final officeLat = (emp['companyLat'] as num?)?.toDouble();
      final officeLng = (emp['companyLng'] as num?)?.toDouble();

      // 2) Get current location
      final current = await _getCurrentLocation();
      if (current == null) {
        emit(AttendanceError('Location permission not granted or GPS disabled.'));
        return;
      }

      // 3) Check if within office radius
      bool withinOffice = false;
      if (officeLat != null && officeLng != null) {
        final d = _distanceInMeters(current.lat, current.lng, officeLat, officeLng);
        withinOffice = d <= 200;
      }

      // 4) Reload today's attendance without modifying check-in/out
      final docId = _todayDocId(DateTime.now());
      final todayRef = _db.collection('Employee').doc(uid)
          .collection('attendance').doc(docId);
      final snap = await todayRef.get();
      AttendanceModel? today;
      if (snap.exists) {
        final data = snap.data()!;
        DateTime? toDate(dynamic v) =>
            v == null ? null : (v is Timestamp ? v.toDate() : v as DateTime);
        today = AttendanceModel(
          date: (data['date'] is Timestamp) ? (data['date'] as Timestamp).toDate() : DateTime.now(),
          checkIn: toDate(data['checkIn']),
          checkOut: toDate(data['checkOut']),
          totalHours: (data['totalHours'] as num?)?.toDouble(),
          checkInLat: (data['checkInLat'] as num?)?.toDouble(),
          checkInLng: (data['checkInLng'] as num?)?.toDouble(),
          checkOutLat: (data['checkOutLat'] as num?)?.toDouble(),
          checkOutLng: (data['checkOutLng'] as num?)?.toDouble(),
        );
      }

      emit(AttendanceLoaded(today: today, isWithinOffice: withinOffice));
    } catch (e) {
      emit(AttendanceError(e.toString()));
    }
  }

  Future<void> loadToday({required String uid}) async {
    try {
      emit(AttendanceLoading());

      // 1) Fetch employee data (company location + HR approval status)
      final empDoc = await _db.collection('Employee').doc(uid).get();
      if (!empDoc.exists) {
        emit(AttendanceError('Employee not found'));
        return;
      }
      final emp = empDoc.data()!;
      final officeLat = (emp['companyLat'] as num?)?.toDouble();
      final officeLng = (emp['companyLng'] as num?)?.toDouble();
      final hrStatus = emp['hrStatus'] ?? 'pending';
      if (hrStatus != 'approved') {
        emit(AttendanceError('Your request has not been approved by HR yet.'));
        return;
      }

      // 2) Get current location to check proximity to the company
      final current = await _getCurrentLocation();
      bool withinOffice = false;
      if (current != null && officeLat != null && officeLng != null) {
        final d = _distanceInMeters(current.lat, current.lng, officeLat, officeLng);
        withinOffice = d <= 200; // 200 meters radius allowed
      }

      // 3) Fetch today's attendance document
      final docId = _todayDocId(DateTime.now());
      final todayRef = _db.collection('Employee').doc(uid)
          .collection('attendance').doc(docId);
      final snap = await todayRef.get();
      AttendanceModel? today;
      if (snap.exists) {
        final data = snap.data()!;
        DateTime? toDate(dynamic v) =>
            v == null ? null : (v is Timestamp ? v.toDate() : v as DateTime);
        today = AttendanceModel(
          date: (data['date'] is Timestamp) ? (data['date'] as Timestamp).toDate() : DateTime.now(),
          checkIn: toDate(data['checkIn']),
          checkOut: toDate(data['checkOut']),
          totalHours: (data['totalHours'] as num?)?.toDouble(),
          checkInLat: (data['checkInLat'] as num?)?.toDouble(),
          checkInLng: (data['checkInLng'] as num?)?.toDouble(),
          checkOutLat: (data['checkOutLat'] as num?)?.toDouble(),
          checkOutLng: (data['checkOutLng'] as num?)?.toDouble(),
        );
      }
      emit(AttendanceLoaded(today: today, isWithinOffice: withinOffice));
    } catch (e) {
      emit(AttendanceError(e.toString()));
    }
  }

  Future<void> checkIn({required String uid}) async {
    try {
      emit(AttendanceLoading());

      // Get company location from employee document
      final empDoc = await _db.collection('Employee').doc(uid).get();
      final officeLat = (empDoc['companyLat'] as num?)?.toDouble();
      final officeLng = (empDoc['companyLng'] as num?)?.toDouble();

      final current = await _getCurrentLocation();
      if (current == null) {
        emit(AttendanceError('Location permission not granted.'));
        return;
      }

      // Enforce proximity check
      if (officeLat != null && officeLng != null) {
        final d = _distanceInMeters(current.lat, current.lng, officeLat, officeLng);
        if (d > 200) {
          emit(AttendanceError('You are outside the company radius (distance ${d.toStringAsFixed(0)} m).'));
          return;
        }
      }

      final now = DateTime.now();
      final docId = _todayDocId(now);
      final todayRef = _db.collection('Employee').doc(uid)
          .collection('attendance').doc(docId);

      final snap = await todayRef.get();
      if (snap.exists && (snap.data()?['checkIn'] != null)) {
        // Already checked in
        await loadToday(uid: uid);
        return;
      }

      await todayRef.set({
        'date': DateTime(now.year, now.month, now.day),
        'checkIn': now,
        'checkInLat': current.lat,
        'checkInLng': current.lng,
        'checkOut': null,
        'checkOutLat': null,
        'checkOutLng': null,
        'totalHours': null,
      }, SetOptions(merge: true));

      await loadToday(uid: uid);
    } catch (e) {
      emit(AttendanceError(e.toString()));
    }
  }

  Future<void> checkOut({required String uid}) async {
    try {
      emit(AttendanceLoading());

      final current = await _getCurrentLocation();
      final now = DateTime.now();
      final docId = _todayDocId(now);
      final todayRef = _db.collection('Employee').doc(uid)
          .collection('attendance').doc(docId);

      final snap = await todayRef.get();
      if (!snap.exists || snap.data()?['checkIn'] == null) {
        emit(AttendanceError('No check-in found for today.'));
        return;
      }

      final data = snap.data()!;
      final DateTime checkInTime = (data['checkIn'] as Timestamp).toDate();
      final double hours = now.difference(checkInTime).inMinutes / 60.0;

      await todayRef.set({
        'checkOut': now,
        'checkOutLat': current?.lat,
        'checkOutLng': current?.lng,
        'totalHours': double.parse(hours.toStringAsFixed(2)),
      }, SetOptions(merge: true));

      await loadToday(uid: uid);
    } catch (e) {
      emit(AttendanceError(e.toString()));
    }
  }
}