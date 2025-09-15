import 'package:projects_flutter/HR/ModelsHR/EmployeeSalary.dart';

abstract class SalaryState {}

class SalaryInitial extends SalaryState {}

class SalaryLoading extends SalaryState {}

class SalaryLoaded extends SalaryState {
  final List<EmployeeSalary> salaries;
  SalaryLoaded(this.salaries);
}

class SalaryError extends SalaryState {
  final String message;
  SalaryError(this.message);
}