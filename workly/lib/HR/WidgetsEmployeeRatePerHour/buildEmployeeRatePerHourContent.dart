import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/HR/EmployeeCubit/employeescubit.dart';
import 'package:projects_flutter/HR/EmployeeCubit/employeesstate.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

import 'package:projects_flutter/HR/WidgetsEmployee/buildEmployeeCard.dart';

Widget buildEmployeeRatePerHourContent({
  required BuildContext context,
  required String companyCode,
  required String searchQuery,
}) {
  final loc = AppLocalizations.of(context)!;

  return BlocBuilder<EmployeesCubit, EmployeesState>(
    builder: (context, state) {
      if (state is EmployeesLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is EmployeesError) {
        return Center(child: Text(state.message));
      } else if (state is EmployeesLoaded) {
        final approvedEmployees = state.employees
            .where((emp) => emp.hrStatus == 'approved')
            .toList();

        if (approvedEmployees.isEmpty) {
          return Center(child: Text(loc.noEmployeesFound));
        }

        return Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: ListView.separated(
              itemCount: approvedEmployees.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final emp = approvedEmployees[index];
                return buildEmployeeCard(
                  emp: emp,
                  index: index,
                  trailingText: (emp) => "${emp.ratePerHour?.toStringAsFixed(2)} \$",
                    trailingColor: (emp) => Colors.indigo.shade700,
                  onTap: (emp) async {
                    final controller = TextEditingController(
                      text: emp.ratePerHour?.toString() ?? '',
                    );

                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                emp.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // حقل إدخال الراتب مع القيمة الحالية
                              TextField(
                                controller: controller,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: AppLocalizations.of(context)!.enterSalaryPerHours,
                                  border: const OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 24),

                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final value = controller.text.trim();

                                    if (value.isEmpty || double.tryParse(value) == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            AppLocalizations.of(context)!.enterValidNumber,
                                          ),
                                        ),
                                      );
                                      return;
                                    }

                                    final newRate = double.parse(value);

                                    // تحديث Firestore + الحالة محلياً
                                    context.read<EmployeesCubit>().updateRatePerHour(
                                      emp.email,
                                      newRate,
                                    );

                                    Navigator.pop(context);
                                  },
                                  child: Text(AppLocalizations.of(context)!.save),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },

                );
              },
            ),
          ),
        );
      }

      return const SizedBox();
    },
  );
}
