import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/HR/EmployeeCubit/employeesstate.dart';

import '../ModelsHR/Employee.dart';

class EmployeesCubit extends Cubit<EmployeesState> {
  EmployeesCubit() : super(EmployeesLoading());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _subscription;
  List<Employee>? _cachedEmployees;
  // جلب الموظفين حسب كود الشركة
  void fetchEmployees(String companyCode) {
    final today = DateTime.now();

    // إذا موجود كاش مسبق، نرسل البيانات فوراً
    if (_cachedEmployees != null) {
      emit(EmployeesLoaded(_cachedEmployees!));
      return;
    }

    emit(EmployeesLoading());

    _subscription = _firestore.collection('Employee').where('companyCode', isEqualTo: companyCode).snapshots().listen((snapshot) {
          List<Employee> employees = [];

          for (var doc in snapshot.docs) {
            final emp = Employee.fromDoc(doc);
            DateTime? lastCheckIn;
            bool isPresentToday = false;

            if (doc.data().containsKey('lastCheckIn') && doc['lastCheckIn'] != null) {
              lastCheckIn = (doc['lastCheckIn'] as Timestamp).toDate();
              if (lastCheckIn.year == today.year && lastCheckIn.month == today.month && lastCheckIn.day == today.day) {
                isPresentToday = true;
              }
            }

            final updatedEmp = emp.copyWith(
              lastCheckIn: isPresentToday ? lastCheckIn : null,
            );

            employees.add(updatedEmp);
          }

          _cachedEmployees = employees; // حفظ الكاش
          emit(EmployeesLoaded(employees));
        }, onError: (e) => emit(EmployeesError(e.toString())));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<void> deleteEmployee(String email) async {
    try {
      await _firestore.collection('Employee').doc(email).delete(); //Employee

      if (state is EmployeesLoaded) {
        final currentState = state as EmployeesLoaded;

        final updatedList = currentState.employees
            .where((e) => e.email != email)
            .toList();
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
      await _firestore.collection('Employee').doc(employeeEmail).update({
        'hrStatus': newStatus,
      });
      // تحديث الحالة محليًا
      if (state is EmployeesLoaded) {
        final updatedEmployees = (state as EmployeesLoaded).employees.map((
          emp,
        ) {
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
  // تحديث ratePerHour لموظف
  Future<void> updateRatePerHour(String employeeEmail, double newRate) async {
    try {
      await _firestore.collection('Employee').doc(employeeEmail).update({
        'ratePerHour': newRate,
      });

      // تحديث القيمة محليًا
      if (state is EmployeesLoaded) {
        final updatedEmployees = (state as EmployeesLoaded).employees.map((emp) {
          if (emp.email == employeeEmail) {
            return emp.copyWith(ratePerHour: newRate);
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
