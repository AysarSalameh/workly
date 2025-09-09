import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  File? profileImage;
  File? idImage;

  double? companyLat;
  double? companyLng;

  Map<String, dynamic>? userData;

  final FirebaseStorage storage = FirebaseStorage.instance;

  // تحميل بيانات المستخدم
  Future<void> loadUser(String email) async {
    emit(ProfileLoading());
    try {
      final doc = await FirebaseFirestore.instance
          .collection('Employee')
          .doc(email)
          .get();
      userData = doc.data();
      emit(ProfileLoaded(userData!));
    } catch (e) {
      emit(ProfileError("Failed to load user: $e"));
    }
  }

  // الحصول على موقع الشركة من GPS
  Future<void> pickCompanyLocation(AppLocalizations loc) async {
    emit(CompanyLocationLoading());
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(ProfileError(loc.locationServicesDisabled));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(ProfileError(loc.locationPermissionDenied));
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        emit(ProfileError(loc.locationPermissionDeniedForever));
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      companyLat = pos.latitude;
      companyLng = pos.longitude;
      emit(CompanyLocationPicked(companyLat!, companyLng!));
    } catch (e) {
      emit(ProfileError("${loc.errorGettingLocation}: $e"));
    }
  }

  // اختيار صورة البروفايل
  Future<void> pickProfileImage(
    BuildContext context,
    AppLocalizations loc,
  ) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: Text(loc.camera),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: Text(loc.gallery),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );

    if (source != null) {
      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 80,
      );
      if (picked != null) {
        profileImage = File(picked.path);
        emit(ProfileImagePicked(profileImage!));
      }
    }
  }

  // اختيار صورة الهوية
  Future<void> pickIdImage(BuildContext context, AppLocalizations loc) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: Text(loc.camera),
            onTap: () => Navigator.pop(context, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: Text(loc.gallery),
            onTap: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );

    if (source != null) {
      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 80,
      );
      if (picked != null) {
        idImage = File(picked.path);
        emit(IdImagePicked(idImage!));
      }
    }
  }

  // رفع صورة إلى Firebase Storage وإرجاع رابطها
  Future<String?> _uploadImage(File file, String path) async {
    try {
      final ref = storage.ref().child(path);
      final task = await ref.putFile(file);
      final url = await task.ref.getDownloadURL();
      return url;
    } catch (e) {
      return null;
    }
  }

  Future<void> editSaveProfile({
    required String name,
    required String birthDate,
    required String phoneNumber,
    required String Id,
    required String address,
    required String iban,
    required String email,
    required AppLocalizations loc,
  }) async {
    if (name.isEmpty ||
        birthDate.isEmpty ||
        phoneNumber.isEmpty ||
        Id.isEmpty ||
        address.isEmpty ||
        iban.isEmpty ||
        email.isEmpty) {
      emit(ProfileError(loc.allFieldsRequired));
      return;
    }

    emit(ProfileLoading());
    try {
      String? profileUrl;
      String? idUrl;

      if (profileImage != null) {
        profileUrl = await _uploadImage(
          profileImage!,
          "profile_images/$email.jpg",
        );
      }

      if (idImage != null) {
        idUrl = await _uploadImage(idImage!, "id_images/$email.jpg");
      }

      final updateData = {
        'name': name,
        'birthDate': birthDate,
        'phoneNumber': phoneNumber,
        'Id': Id,
        'address': address,
        'iban': iban,
        if (profileUrl != null) 'profileImage': profileUrl,
        if (idUrl != null) 'idImage': idUrl,
      };

      await FirebaseFirestore.instance
          .collection('Employee')
          .doc(email)
          .update(updateData);

      final updatedUserData = {...?userData, ...updateData};

      emit(ProfileEdited(updatedUserData));
    } catch (e) {
      emit(ProfileError("${loc.failedToSaveProfile}: $e"));
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
    required AppLocalizations loc,
  }) async {
    try {
      if (name.isEmpty ||
          birthDate.isEmpty ||
          companyCode.isEmpty ||
          phoneNumer.isEmpty ||
          Id.isEmpty) {
        emit(ProfileError(loc.fillAllRequiredFields));
        return;
      }

      if (companyLat == null || companyLng == null) {
        emit(ProfileError(loc.setCompanyLocationFirst));
        return;
      }

      emit(ProfileLoading());

      String? profileUrl;
      String? idUrl;

      if (profileImage != null && await profileImage!.exists()) {
        profileUrl = await _uploadImage(
          profileImage!,
          "profile_images/$email.jpg",
        );
      }

      if (idImage != null && await idImage!.exists()) {
        idUrl = await _uploadImage(idImage!, "id_images/$email.jpg");
      }

      await FirebaseFirestore.instance.collection('Employee').doc(email).set({
        'name': name,
        'email': email,
        'iban': iban,
        'address': address,
        'birthDate': birthDate,
        'companyCode': companyCode,
        'phoneNumber': phoneNumer,
        'Id': Id,
        'hrStatus': 'pending',
        'profileImage': profileUrl,
        'idImage': idUrl,
        'companyLat': companyLat,
        'companyLng': companyLng,
        'createdAt': FieldValue.serverTimestamp(),
      });

      emit(ProfileSaved());
    } catch (e) {
      emit(ProfileError("${loc.failedToSaveProfile}: $e"));
    }
  }
}
