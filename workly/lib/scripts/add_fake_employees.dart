import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';

Future<void> addFakeEmployees(int count) async {
  final faker = Faker();
  final firestore = FirebaseFirestore.instance;

  for (int i = 0; i < count; i++) {
    final email = faker.internet.email(); // الإيميل
    await firestore.collection('Employee').doc(email).set({
      "Id": (100 + i).toString(),
      "name": faker.person.name(),
      "email": email,
      "phoneNumber": faker.phoneNumber.us(),
      "address": faker.address.streetAddress(),
      "birthDate": faker.date.dateTime(minYear: 1980, maxYear: 2002).toString(),
      "companyCode": "DFG",
      "companyLat": 32.1167045,
      "companyLng": 35.0762517,
      "createdAt": FieldValue.serverTimestamp(),
      "hrStatus": "Pending",
      "iban": "SA12345678901234567890",
      "idImage": "https://example.com/id_image.jpg",
      "profileImage": "https://example.com/profile_image.jpg",
    });
  }

  print("$count employees added successfully!");
}


Future<void> deleteAllFakeEmployees() async {
  final firestore = FirebaseFirestore.instance;
  final snapshot = await firestore.collection('Employee').get();

  for (var doc in snapshot.docs) {
    // إذا حاب تمسح بس اللي اضافتهم انت، ممكن تعمل شرط على companyCode أو أي علامة
    if (doc['companyCode'] == 'DFG') {
      await firestore.collection('Employee').doc(doc.id).delete();
    }
  }

  print("Deleted all fake employees!");
}
