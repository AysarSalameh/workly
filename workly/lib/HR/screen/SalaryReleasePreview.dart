import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projects_flutter/HR/ModelsHR/Employee.dart';
import 'package:projects_flutter/HR/WidgetsSalaryPreVeiw/bottom_actions_widget.dart';
import 'package:projects_flutter/HR/WidgetsSalaryPreVeiw/employee_salary_card.dart';
import 'package:projects_flutter/HR/WidgetsSalaryPreVeiw/summary_card_widget.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class SalaryReleasePreview extends StatefulWidget {
  final List<dynamic> salaries;
  final List<Employee> approvedEmployees;
  final DateTime month;

  const SalaryReleasePreview({
    super.key,
    required this.salaries,
    required this.approvedEmployees,
    required this.month,
  });

  @override
  State<SalaryReleasePreview> createState() => _SalaryReleasePreviewState();
}

class _SalaryReleasePreviewState extends State<SalaryReleasePreview>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    double totalSalary = widget.salaries.fold(0.0, (sum, emp) => sum + emp.salary);
    int totalEmployees = widget.salaries.length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
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
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.salaryPreview,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('MMMM yyyy', loc.localeName)
                                .format(widget.month),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Summary Card
            SummaryCardWidget(
              totalSalary: totalSalary,
              totalEmployees: totalEmployees,
              animationController: _animationController,
              fadeAnimation: _fadeAnimation,
              slideAnimation: _slideAnimation,
            ),

            const SizedBox(height: 16),

            // Employee Cards
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.salaries.length,
              itemBuilder: (context, index) {
                final empSalary = widget.salaries[index];
                final employee = widget.approvedEmployees.firstWhere(
                      (e) => e.email == empSalary.email,
                  orElse: () => Employee(
                    id: '',
                    name: empSalary.email,
                    email: empSalary.email,
                    phoneNumber: '',
                    iban: '',
                    address: '',
                    birthDate: '',
                    hrStatus: '',
                    profileImage: '',
                    companyCode: '',
                    companyLat: 0,
                    companyLng: 0,
                    createdAt: Timestamp.now(),
                    idImage: '',
                    ratePerHour: 0,
                  ),
                );

                return EmployeeSalaryCard(
                  employee: employee,
                  empSalary: empSalary,
                );
              },
            ),

            const SizedBox(height: 16),

            // Bottom Actions
            BottomActionsWidget(
              salaries: widget.salaries,
              approvedEmployees: widget.approvedEmployees,
              month: widget.month,
            ),
          ],
        ),
      ),
    );
  }
}
