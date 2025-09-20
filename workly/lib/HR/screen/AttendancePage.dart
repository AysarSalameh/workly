import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/HR/EmployeeCubit/employeescubit.dart';
import 'package:projects_flutter/HR/EmployeeCubit/employeesstate.dart';
import 'package:projects_flutter/HR/ModelsHR/Employee.dart';
import 'package:projects_flutter/HR/WidgetsAttendance/AnimatedEmployeeCard.dart';
import 'package:projects_flutter/HR/WidgetsAttendance/AttendanceHeader.dart';
import 'package:projects_flutter/HR/WidgetsEmployee/buildErrorState.dart';
import 'package:projects_flutter/HR/WidgetsEmployee/buildLoadingState.dart';
import 'package:projects_flutter/HR/WidgetsAttendance/buildStatsHeader.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

// فلتر ثابت لتجنب مشاكل الترجمة
enum FilterStatus { all, present, absent }

class AttendancePage extends StatefulWidget {
  final String companyCode;
  const AttendancePage({super.key, required this.companyCode});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String searchQuery = "";
  FilterStatus filterStatus = FilterStatus.all;

  List<Employee> _filterEmployees(List<Employee> employees) {
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);

    return employees.where((emp) {
      final nameMatch =
      emp.name.toLowerCase().contains(searchQuery.toLowerCase());

      // تحديد إذا حاضر بناءً على تاريخ اليوم
      bool isPresent = false;
      if (emp.lastCheckIn != null) {
        final lastCheckInDate = DateTime(
          emp.lastCheckIn!.year,
          emp.lastCheckIn!.month,
          emp.lastCheckIn!.day,
        );
        isPresent = lastCheckInDate == todayDate;
      }

      final statusMatch = filterStatus == FilterStatus.all ||
          (filterStatus == FilterStatus.present && isPresent) ||
          (filterStatus == FilterStatus.absent && !isPresent);

      // شرط إضافي: فقط الموظفين المعتمدين
      final approvedMatch = emp.hrStatus?.toLowerCase() == 'approved';

      return nameMatch && statusMatch && approvedMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: BlocBuilder<EmployeesCubit, EmployeesState>(
        builder: (context, state) {
          if (state is EmployeesLoading) {
            return buildLoadingState(context);
          } else if (state is EmployeesError) {
            return buildErrorState(
                context, widget.companyCode, state.message, loc);
          } else if (state is EmployeesLoaded) {
            final employees = _filterEmployees(state.employees);

            // حساب الإحصائيات بناءً على اليوم
            final now = DateTime.now();
            final todayDate = DateTime(now.year, now.month, now.day);

            int presentCount = 0;
            for (var e in employees) {
              if (e.lastCheckIn != null) {
                final lastCheckInDate = DateTime(
                  e.lastCheckIn!.year,
                  e.lastCheckIn!.month,
                  e.lastCheckIn!.day,
                );
                if (lastCheckInDate == todayDate) {
                  presentCount++;
                }
              }
            }

            final absentCount = employees.length - presentCount;

            return CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.indigo.shade600,
                          Colors.blue.shade600,
                          Colors.indigo.shade700,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: AttendanceHeader(
                        searchQuery: searchQuery,
                        filterStatus: filterStatus,
                        onSearchChanged: (query) =>
                            setState(() => searchQuery = query),
                        onFilterChanged: (filter) =>
                            setState(() => filterStatus = filter),
                        loc: loc,
                      ),
                    ),
                  ),
                ),

                // Stats Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    child: buildStatsHeader(
                        presentCount, absentCount, employees.length, loc),
                  ),
                ),

                // Employee Cards
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final emp = employees[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: AnimatedEmployeeCard(
                            key: ValueKey(emp.email),
                            emp: emp,
                            index: index,
                            loc: loc,
                          ),
                        );
                      },
                      childCount: employees.length,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
