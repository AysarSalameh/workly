import 'dart:io';
import 'dart:convert'; // لازم للتحويل إلى Base64
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  File? profileImage;
  File? idImage;

  double? companyLat;
  double? companyLng;

  // اختيار صورة البروفايل
  Future<void> pickProfileImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      profileImage = File(picked.path);
      emit(ProfileImagePicked(profileImage!));
    }
  }

  // اختيار صورة الهوية
  Future<void> pickIdImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      idImage = File(picked.path);
      emit(IdImagePicked(idImage!));
    }
  }

  // الحصول على موقع الشركة من GPS
  Future<void> pickCompanyLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(ProfileError("Location services are disabled."));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(ProfileError("Location permission denied."));
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        emit(ProfileError("Location permission denied forever."));
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      companyLat = pos.latitude;
      companyLng = pos.longitude;
      print(companyLat);
      print(companyLng);
      emit(CompanyLocationPicked(companyLat!, companyLng!));
    } catch (e) {
      emit(ProfileError("Error getting location: $e"));
    }
  }

  Future<void> saveProfile({
    required String name,
    required String email,
    required String birthDate,
    required String companyCode,
    required String address,
    required String iban,
    required String phoneNumer,
    required String Id,
  }) async {
    try {
      // التحقق من الحقول المطلوبة
      if (name.isEmpty ||
          birthDate.isEmpty ||
          companyCode.isEmpty ||
          phoneNumer.isEmpty ||
          Id.isEmpty) {
        emit(ProfileError("Please fill in all required fields."));
        return;
      }

      if (companyLat == null || companyLng == null) {
        print(companyLng);
        emit(ProfileError("Please set your company location before saving."));
        return;
      }

      emit(ProfileLoading());

      String? profileBase64;
      String? idBase64;

      // تحويل صورة البروفايل إلى Base64
      if (profileImage != null && await profileImage!.exists()) {
        final bytes = await profileImage!.readAsBytes();
        profileBase64 = base64Encode(bytes);
      }

      // تحويل صورة الهوية إلى Base64
      if (idImage != null && await idImage!.exists()) {
        final bytes = await idImage!.readAsBytes();
        idBase64 = base64Encode(bytes);
      }

      // حفظ البيانات في Firestore
      await FirebaseFirestore.instance.collection('Employee').doc(email).set({
        'name': name,
        'email': email,
        'iban': iban,
        'address': address,
        'birthDate': birthDate,
        'companyCode': companyCode,
        'phoneNumer': phoneNumer,
        'Id': Id,
        'hrStatus': 'pending',
        'profileImage': profileBase64,
        'idImage': idBase64,
        'companyLat': companyLat,
        'companyLng': companyLng,
        'createdAt': FieldValue.serverTimestamp(),
      });


      emit(ProfileSaved());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
