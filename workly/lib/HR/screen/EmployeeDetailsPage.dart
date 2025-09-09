import 'package:flutter/material.dart';
import 'package:projects_flutter/HR/EmployeeCubit/employeescubit.dart';
import 'package:projects_flutter/HR/ModelsHR/Employee.dart';
import 'package:projects_flutter/HR/Widgets/buildInfoGrid.dart';
import 'package:projects_flutter/HR/Widgets/buildProfileImage.dart';
import 'package:projects_flutter/HR/Widgets/buildStatusCard.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class EmployeeDetailsPage extends StatefulWidget {
  final Employee employee;
  final EmployeesCubit cubit;

  const EmployeeDetailsPage({
    super.key,
    required this.employee,
    required this.cubit,
  });

  @override
  State<EmployeeDetailsPage> createState() => _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage>
    with SingleTickerProviderStateMixin {
  late String selectedStatus;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.employee.hrStatus;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emp = widget.employee;
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 16), // قلل padding فوق
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // مهم لتجنب overflow
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        emp.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        loc.employeeInformation,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildProfileImage(emp.profileImage),
              const SizedBox(height: 24),
              buildInfoGrid(context, emp),
              const SizedBox(height: 24),
              StatusCard(
                employee: emp,
                cubit: widget.cubit,
                initialStatus: selectedStatus,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
