import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/HR/EmployeeCubit/employeescubit.dart';
import 'package:projects_flutter/HR/EmployeeCubit/employeesstate.dart';
import 'package:projects_flutter/HR/company/hrcompanycubit.dart';
import 'package:projects_flutter/HR/company/hrcompanystate.dart';
import 'package:projects_flutter/HR/screen/hrdashboardscreen.dart';

class HRMainPage extends StatelessWidget {
  const HRMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hrCompanyState = context.watch<HrCompanyCubit>().state;
    String companyCode = '';
    if (hrCompanyState is CompanyLoaded) companyCode = hrCompanyState.code;

    final employeesCubit = context.read<EmployeesCubit>();

    if (employeesCubit.state is EmployeesLoaded) {
      final employees = (employeesCubit.state as EmployeesLoaded).employees;
      if (employees.isEmpty && companyCode.isNotEmpty) {
        employeesCubit.fetchEmployees(companyCode);
      }
    } else if (companyCode.isNotEmpty) {
      employeesCubit.fetchEmployees(companyCode);
    }

    return const HrDashboardScreen();
  }
}
