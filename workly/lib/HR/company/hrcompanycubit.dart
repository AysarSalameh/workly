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

  Uint8List? logoBytes; // لتخزين الصورة للعرض فوراً

  /// اختيار صورة
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
          logoBytes = fileBytes;
          emit(LogoPicked(fileBytes));
        } else {
          emit(HrCompanyFailure("فشل قراءة الصورة"));
        }
      }
    } catch (e) {
      emit(HrCompanyFailure("فشل اختيار الصورة: $e"));
    }
  }
  /// رفع الصورة على Firebase Storage (ويب)
  Future<String?> uploadLogo(String uid) async {
    if (logoBytes == null) {
      emit(HrCompanyFailure("لا توجد صورة لرفعها"));
      return null;
    }
    try {
      emit(HrCompanyLoading());

      final safeUid = uid.replaceAll('@', '_').replaceAll('.', '_');
      final ref = _storage.ref().child('company_logos/$safeUid.png');

      await ref.putData(logoBytes!);
      final downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      emit(HrCompanyFailure("فشل رفع الصورة: $e"));
      return null;
    }
  }

  /// حفظ بيانات الشركة مع رابط الصورة
  Future<void> saveCompanyData({
    required String companyName,
    required String code,
    required String status,
    required String hrName,
    required String companyEmail,
    required String uid,
  }) async {
    try {
      emit(HrCompanyLoading());

      String hrImageUrl = "https://via.placeholder.com/150";

      final uploadedUrl = await uploadLogo(uid);
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
  /// جلب بيانات الشركة
  Future<void> fetchCompanyData(String companyEmailid) async {
    emit(HrCompanyLoading());
    try {
      final doc = await _firestore.collection('companies').doc(companyEmailid).get();
      if (doc.exists) {
        final data = doc.data()!;
        emit(CompanyLoaded(
          name: data['name'] ?? '',
          code: data['code'] ?? '',
          status: data['status'] ?? '',
          hrName: data['hrName'] ?? '',
          hrImageUrl: data['hrImageUrl'] ?? '',
        ));
      } else {
        emit(HrCompanyFailure('Company not found'));
      }
    } catch (e) {
      emit(HrCompanyFailure(e.toString()));
    }
  }




  /// تحديث الصورة واسم الـ HR فقط
  Future<void> updateHrData({
    required String uid,
    required String hrName,
    Uint8List? newLogoBytes,
  }) async {
    try {
      emit(HrCompanyLoading());

      String? hrImageUrl;

      // إذا فيه صورة جديدة، نرفعها
      if (newLogoBytes != null) {
        logoBytes = newLogoBytes;
        hrImageUrl = await uploadLogo(uid);
      }

      // تحديث فقط الحقول المطلوبة
      final Map<String, dynamic> updateData = {
        'hrName': hrName,
      };
      if (hrImageUrl != null) {
        updateData['hrImageUrl'] = hrImageUrl;
      }

      await _firestore.collection('companies').doc(uid).update(updateData);

      emit(HrCompanySuccess("تم تحديث بيانات الـ HR بنجاح"));
    } catch (e) {
      emit(HrCompanyFailure("فشل تحديث بيانات الـ HR: $e"));
    }
  }

}
