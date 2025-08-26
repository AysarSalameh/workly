
import 'package:projects_flutter/Employee/Models/AttendanceModel.dart';

abstract class AttendanceState  {
  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final AttendanceModel? today;
  final bool isWithinOffice;
  final Map<String, dynamic>? employeeData; // <--- بيانات الموظف

  AttendanceLoaded({
    required this.today,
    required this.isWithinOffice,
    this.employeeData,
  });
}

class AttendanceError extends AttendanceState {
  final String message;
  AttendanceError(this.message);

  @override
  List<Object?> get props => [message];
}
