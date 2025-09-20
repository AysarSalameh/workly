import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:projects_flutter/HR/EmployeeCubit/employeescubit.dart';
import 'package:projects_flutter/HR/EmployeeCubit/employeesstate.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class RecentActivityTable extends StatelessWidget {
  const RecentActivityTable({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocBuilder<EmployeesCubit, EmployeesState>(
      builder: (context, state) {
        if (state is EmployeesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is EmployeesError) {
          return Center(child: Text('حدث خطأ: ${state.message}'));
        } else if (state is EmployeesLoaded) {
          // فلتر الموظفين المعتمدين فقط
          final approvedEmployees = state.employees
              .where((emp) => emp.hrStatus?.toLowerCase() == 'approved')
              .toList();

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.recentActivity,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // جدول مع تمرير أفقي
                LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: constraints.maxWidth,
                        ),
                        child: DataTable(
                          columnSpacing: 30,
                          columns: [
                            DataColumn(
                              label: Text(
                                loc.employee,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                loc.status,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                loc.lastCheckIn,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: approvedEmployees.map((emp) {
                            final now = DateTime.now();

                            // نصّفّر الساعة والدقيقة والثانية عشان نقارن التواريخ بس
                            final todayDate = DateTime(now.year, now.month, now.day);

                            bool isPresent = false;
                            String checkInStr = "-";

                            if (emp.lastCheckIn != null) {
                              final lastCheckInDate = DateTime(
                                emp.lastCheckIn!.year,
                                emp.lastCheckIn!.month,
                                emp.lastCheckIn!.day,
                              );

                              // إذا التاريخ نفسه
                              isPresent = lastCheckInDate == todayDate;

                              checkInStr = DateFormat('yyyy-MM-dd – HH:mm')
                                  .format(emp.lastCheckIn!);
                            }

                            return DataRow(
                              cells: [
                                DataCell(Text(emp.name, overflow: TextOverflow.ellipsis)),
                                DataCell(Text(isPresent ? loc.present : loc.absent)),
                                DataCell(Text(checkInStr, overflow: TextOverflow.ellipsis)),
                              ],
                            );
                          }).toList(),

                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
