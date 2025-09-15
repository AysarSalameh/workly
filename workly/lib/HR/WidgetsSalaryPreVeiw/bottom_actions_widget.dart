import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:projects_flutter/HR/ModelsHR/Employee.dart';
import 'package:projects_flutter/HR/company/hrcompanycubit.dart';
import 'package:projects_flutter/HR/company/hrcompanystate.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';
import '../Reports/ExportAllPdfSalaries.dart';

class BottomActionsWidget extends StatefulWidget {
  final List<dynamic> salaries;
  final List<Employee> approvedEmployees;
  final DateTime month;

  const BottomActionsWidget({
    super.key,
    required this.salaries,
    required this.approvedEmployees,
    required this.month,
  });

  @override
  State<BottomActionsWidget> createState() => _BottomActionsWidgetState();
}

class _BottomActionsWidgetState extends State<BottomActionsWidget> {
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocBuilder<HrCompanyCubit, HrCompanyState>(
      builder: (context, state) {
        String companyCode = '';
        String comImageUrl='';
        if (state is CompanyLoaded) {
          companyCode = state.code;
          comImageUrl=state.hrImageUrl;
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ExportAllPdfSalaries(
                  employees: widget.approvedEmployees,
                  salaries: widget.salaries,
                  companyName: companyCode, // Replace with actual company name if available from state
                  companyLogoUrl: comImageUrl, // Replace with actual logo URL if available
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveSalaries,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    shadowColor: Colors.green.withOpacity(0.3),
                  ),
                  child: _isSaving
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        loc.saving,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.save_rounded, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        loc.saveAndReleaseSalaries,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveSalaries() async {
    final loc = AppLocalizations.of(context)!;
    setState(() => _isSaving = true);

    try {
      for (var empSalary in widget.salaries) {
        final docRef = FirebaseFirestore.instance
            .collection('monthlyHours')
            .doc('${DateFormat('yyyy-MM').format(widget.month)}_${empSalary.email}');

        await docRef.set({
          'salaryReleased': true,
          'releaseDate': Timestamp.now(),
          'salary': empSalary.salary,
        }, SetOptions(merge: true));
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 12),
                Text(loc.salariesSavedSuccess,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: Duration(seconds: 3),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));
        if (mounted) Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_rounded, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('${loc.salariesSavedError} $e',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
