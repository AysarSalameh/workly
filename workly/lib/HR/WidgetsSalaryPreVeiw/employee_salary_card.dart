import 'package:flutter/material.dart';
import 'package:projects_flutter/HR/ModelsHR/Employee.dart';
import 'package:projects_flutter/HR/screen/SalaryReleasePreview.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';
import '../Reports/ExportPdfSalary.dart';
import 'detail_row_widget.dart';

class EmployeeSalaryCard extends StatelessWidget {
  final Employee employee;
  final dynamic empSalary;

  const EmployeeSalaryCard({
    super.key,
    required this.employee,
    required this.empSalary,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    // قائمة التفاصيل لتسهيل Loop
    final List<Map<String, dynamic>> details = [
      {
        'label': loc.totalWorkHours,
        'value': empSalary?.totalMonthHours != null
            ? '${empSalary.totalMonthHours!.floor()} ${loc.hours} ${((empSalary.totalMonthHours - empSalary.totalMonthHours.floor()) * 60).round()} ${loc.minutes}'
            : '--',

        'icon': Icons.access_time_rounded,
        'color': Colors.blue.shade600,
      },
      {
        'label': loc.hourRate,
        'value': '${empSalary.ratePerHour.toStringAsFixed(2)} \$',
        'icon': Icons.schedule_rounded,
        'color': Colors.orange.shade600,
      },
      {
        'label': loc.idNumber,
        'value': employee.id.isNotEmpty ? employee.id : '',
        'icon': Icons.badge_rounded,
        'color': Colors.purple.shade600,
      },
      {
        'label': loc.iban,
        'value': employee.iban.isNotEmpty ? employee.iban : '',
        'icon': Icons.account_balance_rounded,
        'color': Colors.indigo.shade600,
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.green.shade100,
                  backgroundImage: employee.profileImage.isNotEmpty
                      ? NetworkImage(employee.profileImage)
                      : null,
                  child: employee.profileImage.isEmpty
                      ? Text(
                          employee.name.isNotEmpty
                              ? employee.name.substring(0, 1).toUpperCase()
                              : 'W',
                          style: TextStyle(
                            color: Colors.green.shade600,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        employee.email,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [ Colors.indigo.shade600,
                        Colors.blue.shade600,
                        Colors.indigo.shade700,],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${empSalary.salary.toStringAsFixed(2)} \$',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Details باستخدام Loop
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: details
                    .map(
                      (detail) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: DetailRowWidget(
                          label: detail['label'],
                          value: detail['value'],
                          icon: detail['icon'],
                          color: detail['color'],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Export PDF
            // ExportPdfSalary(
            //   employee: employee,
            //   empSalary: empSalary,
            //   companyName: "اسم شركتك",
            //   companyLogoUrl: "https://via.placeholder.com/150",
            // ),
          ],
        ),
      ),
    );
  }
}
