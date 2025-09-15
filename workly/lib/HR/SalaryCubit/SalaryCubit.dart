import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../ModelsHR/Employee.dart';
import '../ModelsHR/EmployeeSalary.dart';
import 'SalaryState.dart';

class SalaryCubit extends Cubit<SalaryState> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  SalaryCubit() : super(SalaryInitial());

  Future<void> loadSalaries(
    String monthDocId,
    List<Employee> approvedEmployees,
  ) async {
    emit(SalaryLoading());
    try {
      final snapshot = await _db
          .collection('monthlyHours')
          .where(FieldPath.documentId, isGreaterThanOrEqualTo: '${monthDocId}_')
          .where(FieldPath.documentId, isLessThan: '${monthDocId}_\uf8ff')
          .get();

      final List<EmployeeSalary> salaries = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final uid = data['emailEmployee'] ?? '';
        final bool salaryReleased= data['salaryReleased'] ?? false;
        final DateTime? releaseDate= data['releaseDate']?.toDate();
        final double? releasedAmount= data['releasedAmount'];

        final employee = approvedEmployees.firstWhere(
          (e) => e.email == uid,
          orElse: () => Employee(
            id: uid,
            name: '',
            email: uid,
            phoneNumber: '',
            iban: '',
            address: '',
            birthDate: '',
            hrStatus: '',
            profileImage: '',
            companyCode: '',
            companyLat: 0,
            companyLng: 0,
            createdAt: Timestamp.now(),
            idImage: '',
            ratePerHour: 0,
          ),
        );

        final rate = employee.ratePerHour ?? 0;

        salaries.add(
          EmployeeSalary(
            uid: uid,
            email: uid,
            totalMonthHours: (data['totalMonthHours'] as num).toDouble(),
            ratePerHour: rate,
            salaryReleased: salaryReleased,
            releaseDate: releaseDate,
            releasedAmount: releasedAmount,
          ),
        );
      }

      emit(SalaryLoaded(salaries));
    } catch (e) {
      emit(SalaryError(e.toString()));
    }
  }
}
