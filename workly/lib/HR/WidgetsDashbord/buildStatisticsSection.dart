import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/HR/EmployeeCubit/employeescubit.dart';
import 'package:projects_flutter/HR/EmployeeCubit/employeesstate.dart';
import 'package:projects_flutter/HR/WidgetsDashbord/buildCompanyInfoCard.dart';
import '/l10n/app_localizations.dart';

Widget buildStatisticsSection(BuildContext context) {
  return BlocBuilder<EmployeesCubit, EmployeesState>(
    builder: (context, empState) {
      if (empState is EmployeesLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (empState is EmployeesLoaded) {
        final employees = empState.employees;

        final totalEmployees = employees.length;
        final approvedEmployees =
            employees.where((e) => e.hrStatus == "approved").length;
        final pendingEmployees =
            employees.where((e) => e.hrStatus == "pending").length;

        final loc = AppLocalizations.of(context)!;

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            buildCompanyInfoCard(
              loc.totalEmployees, // ترجمة
              "$totalEmployees",
              Icons.people_rounded,
              Colors.blue,
            ),
            buildCompanyInfoCard(
              loc.approvedEmployees, // ترجمة
              "$approvedEmployees",
              Icons.work_outline_rounded,
              Colors.green,
            ),
            buildCompanyInfoCard(
              loc.pendingEmployees, // ترجمة
              "$pendingEmployees",
              Icons.event_busy_rounded,
              Colors.redAccent,
            ),
          ],
        );
      }
      return const SizedBox();
    },
  );
}