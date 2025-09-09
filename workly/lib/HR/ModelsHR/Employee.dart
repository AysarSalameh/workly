import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String iban;
  final String address;
  final String birthDate;
  final String hrStatus;
  final String profileImage;
  final String companyCode;
  final double companyLat;
  final double companyLng;
  final Timestamp createdAt;
  final String idImage;

  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.iban,
    required this.address,
    required this.birthDate,
    required this.hrStatus,
    required this.profileImage,
    required this.companyCode,
    required this.companyLat,
    required this.companyLng,
    required this.createdAt,
    required this.idImage,
  });

  // إنشاء نسخة جديدة مع إمكانية تعديل بعض الحقول
  Employee copyWith({
    String? id,
    String? hrStatus,
    String? name,
    String? email,
    String? phoneNumber,
    String? iban,
    String? address,
    String? birthDate,
    String? profileImage,
    double? companyLat,
    double? companyLng,
    String? idImage,
  }) {
    return Employee(
      id: this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      iban: iban ?? this.iban,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
      hrStatus: hrStatus ?? this.hrStatus,
      profileImage: profileImage ?? this.profileImage,
      companyCode: companyCode,
      companyLat: companyLat ?? this.companyLat,
      companyLng: companyLng ?? this.companyLng,
      createdAt: createdAt,
      idImage: idImage ?? this.idImage,
    );
  }

  // تحويل من Firestore
  factory Employee.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Employee(
      id: data['Id'] ?? 'No Id', // رقم الهوية الفعلي
      name: data['name'] ?? 'No Name',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      iban: data['iban'] ?? '',
      address: data['address'] ?? '',
      birthDate: data['birthDate'] ?? '',
      hrStatus: data['hrStatus'] ?? 'pending',
      profileImage: data['profileImage'] ?? '',
      companyCode: data['companyCode'] ?? '',
      companyLat: (data['companyLat'] ?? 0).toDouble(),
      companyLng: (data['companyLng'] ?? 0).toDouble(),
      createdAt: data['createdAt'] ?? Timestamp.now(),
      idImage: data['idImage'] ?? '',
    );
  }


  // تحويل لكائن Map (لرفع أو تحديث البيانات)
  Map<String, dynamic> toMap() {
    return {
      'Id':id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'iban': iban,
      'address': address,
      'birthDate': birthDate,
      'hrStatus': hrStatus,
      'profileImage': profileImage,
      'companyCode': companyCode,
      'companyLat': companyLat,
      'companyLng': companyLng,
      'createdAt': createdAt,
      'idImage': idImage,
    };
  }
}
