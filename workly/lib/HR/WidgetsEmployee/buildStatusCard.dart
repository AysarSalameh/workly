import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/HR/ModelsHR/Employee.dart';
import 'package:projects_flutter/HR/EmployeeCubit/employeescubit.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class StatusCard extends StatefulWidget {
  final Employee employee;
  final String initialStatus;

  const StatusCard({
    Key? key,
    required this.employee,
    required this.initialStatus,
  }) : super(key: key);

  @override
  State<StatusCard> createState() => _StatusCardState();
}

class _StatusCardState extends State<StatusCard> {
  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.initialStatus;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cubit = context.read<EmployeesCubit>();

    Color statusColor;
    IconData statusIcon;

    switch (selectedStatus.toLowerCase()) {
      case 'approved':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle_outline;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.access_time_outlined;
        break;
      case 'deleted':
        statusColor = Colors.red;
        statusIcon = Icons.cancel_outlined;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.2), width: 2),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(statusIcon, color: statusColor, size: 28),
              ),
              const SizedBox(width: 16),
              Text(
                loc.employeeStatus,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: statusColor.withOpacity(0.2), width: 1.5),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedStatus,
                isExpanded: true,
                icon: Icon(Icons.expand_more_rounded, color: statusColor, size: 28),
                style: TextStyle(color: statusColor, fontWeight: FontWeight.w700, fontSize: 18),
                items: [
                  DropdownMenuItem(
                    value: 'pending',
                    child: Row(
                      children: [
                        Icon(Icons.access_time_outlined, color: Colors.orange, size: 24),
                        const SizedBox(width: 12),
                        Text(loc.pendingReview, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'approved',
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.green, size: 24),
                        const SizedBox(width: 12),
                        Text(loc.approved, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'deleted',
                    child: Row(
                      children: [
                        Icon(Icons.cancel_outlined, color: Colors.red, size: 24),
                        const SizedBox(width: 12),
                        Text(loc.deleted, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ],
                onChanged: (newStatus) async {
                  if (newStatus != null) {
                    if (newStatus == 'deleted') {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          title: Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 32),
                              const SizedBox(width: 12),
                              Text(loc.confirmDelete),
                            ],
                          ),
                          content: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              loc.deleteMessage(widget.employee.name),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text(loc.cancel,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(loc.delete,
                                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await cubit.deleteEmployee(widget.employee.email);
                        if (mounted) Navigator.pop(context);
                      }
                    } else {
                      setState(() {
                        selectedStatus = newStatus;
                      });
                      cubit.updateStatus(widget.employee.email, newStatus);
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
