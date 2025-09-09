import 'package:projects_flutter/HR/ModelsHR/Employee.dart';

abstract class EmployeesState {
  const EmployeesState();

  @override
  List<Object> get props => [];
}

class EmployeesLoading extends EmployeesState {}

class EmployeesLoaded extends EmployeesState {
  final List<Employee> employees;
  const EmployeesLoaded(this.employees);

  @override
  List<Object> get props => [employees];
}

class EmployeesError extends EmployeesState {
  final String message;
  const EmployeesError(this.message);

  @override
  List<Object> get props => [message];
}
