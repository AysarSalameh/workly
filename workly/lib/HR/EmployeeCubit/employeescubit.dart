import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/HR/EmployeeCubit/employeesstate.dart';

import '../ModelsHR/Employee.dart';

class EmployeesCubit extends Cubit<EmployeesState> {
  EmployeesCubit() : super(EmployeesLoading());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // جلب الموظفين حسب كود الشركة
  Future<void> fetchEmployees(String companyCode) async {
    try {
      emit(EmployeesLoading());
      final snapshot = await _firestore
          .collection('Employee')
          .where('companyCode', isEqualTo: companyCode)
          .get();

      final employees = snapshot.docs.map((doc) => Employee.fromDoc(doc)).toList();
      emit(EmployeesLoaded(employees));
    } catch (e) {
      emit(EmployeesError(e.toString()));
    }
  }
  Future<void> deleteEmployee(String email) async {
    try {
      await _firestore.collection('Employee').doc(email).delete();//Employee


      if (state is EmployeesLoaded) {
        final currentState = state as EmployeesLoaded;

        final updatedList =
        currentState.employees.where((e) => e.email != email).toList();
        emit(EmployeesLoaded(updatedList));
      }
    } catch (e) {
      print('Error deleting employee: $e');
      emit(EmployeesError('Failed to delete employee'));
    }
  }

  // تحديث حالة الموظف
  Future<void> updateStatus(String employeeEmail, String newStatus) async {
    try {
      await _firestore
          .collection('Employee')
          .doc(employeeEmail)
          .update({'hrStatus': newStatus});
      // تحديث الحالة محليًا
      if (state is EmployeesLoaded) {
        final updatedEmployees = (state as EmployeesLoaded).employees.map((emp) {
          if (emp.email == employeeEmail) {
            return emp.copyWith(hrStatus: newStatus); // لو عندك copyWith
          }
          return emp;
        }).toList();

        emit(EmployeesLoaded(updatedEmployees));
      }
    } catch (e) {
      emit(EmployeesError(e.toString()));
    }
  }
}
