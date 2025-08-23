import 'dart:io';
import 'dart:convert'; // لازم للتحويل إلى Base64
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  File? profileImage;
  File? idImage;

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
      emit(ProfileLoading());

      String? profileBase64;
      String? idBase64;

      // تحويل صورة البروفايل إلى Base64
      if (profileImage != null) {
        print("Checking profile image exists at path: ${profileImage!.path}");
        if (await profileImage!.exists()) {
          final bytes = await profileImage!.readAsBytes();
          profileBase64 = base64Encode(bytes);
        }
      }

      // تحويل صورة الهوية إلى Base64
      if (idImage != null) {
        print("Checking ID image exists at path: ${idImage!.path}");
        if (await idImage!.exists()) {
          final bytes = await idImage!.readAsBytes();
          idBase64 = base64Encode(bytes);
        }
      }

      // حفظ البيانات في Firestore
      print("Saving profile to Firestore...");
      await FirebaseFirestore.instance.collection('Employee').add({
        'name': name,
        'email': email,
        'iban' : iban,
        'address' :address,
        'birthDate': birthDate,
        'companyCode': companyCode,
        'phoneNumer':phoneNumer,
        'Id':Id,
        'status': 'pending',
        'profileImage': profileBase64,
        'idImage': idBase64,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print("Profile saved successfully!");
      emit(ProfileSaved());

    } catch (e) {
      print("Profile save error: $e");
      emit(ProfileError(e.toString()));
    }
  }
}
