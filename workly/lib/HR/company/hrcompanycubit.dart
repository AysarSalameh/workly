import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:projects_flutter/HR/company/hrcompanystate.dart';

class HrCompanyCubit extends Cubit<HrCompanyState> {
  HrCompanyCubit() : super(HrCompanyInitial());

  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  /// اختيار صورة (Logo) للشركة من الجهاز
  Future<void> pickLogoImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final fileBytes = result.files.first.bytes;
        if (fileBytes != null) {
          emit(LogoPicked(fileBytes));
        } else {
          emit(HrCompanyFailure("فشل قراءة الصورة"));
        }
      }
    } catch (e) {
      emit(HrCompanyFailure("فشل اختيار الصورة: $e"));
    }
  }

  Future<String?> uploadLogo(Uint8List? imageBytes, String uid) async {
    if (imageBytes == null) {
      emit(HrCompanyFailure("لا توجد صورة لرفعها"));
      return null;
    }

    try {
      final ref = _storage.ref().child('company_logos/$uid.png');

      // emit حالة التحميل عند بدء رفع الصورة
      emit(HrCompanyLoading());

      await ref.putData(imageBytes);
      final downloadUrl = await ref.getDownloadURL();

      // emit حالة النجاح بعد رفع الصورة
      emit(HrCompanySuccess("تم رفع الصورة بنجاح"));

      return downloadUrl;
    } catch (e) {
      emit(HrCompanyFailure("فشل رفع الصورة: $e"));
      return null;
    }
  }




  /// حفظ بيانات الشركة مع رابط الصورة (لو موجود)
  Future<void> saveCompanyData({
    required String companyName,
    required String code,
    required String status,
    required String hrName,
    required String companyEmail,
    required String uid,
    Uint8List? logoImage,
  }) async {
   emit(HrCompanyLoading());
    try {
      String hrImageUrl = "https://via.placeholder.com/150";
      final uploadedUrl = await uploadLogo(logoImage, uid);
      if (uploadedUrl != null) hrImageUrl = uploadedUrl;

      await _firestore.collection('companies').doc(uid).set({
        'name': companyName,
        'code': code,
        'status': status,
        'hrName': hrName,
        'companyEmail': companyEmail,
        'hrImageUrl': hrImageUrl,
        'uid': uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      emit(HrCompanySuccess("تم حفظ بيانات الشركة بنجاح"));
    } catch (e) {
      emit(HrCompanyFailure("فشل الحفظ: $e"));
    }
  }
}
