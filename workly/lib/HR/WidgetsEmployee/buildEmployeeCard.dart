import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projects_flutter/HR/ModelsHR/Employee.dart';
import 'package:projects_flutter/HR/WidgetsEmployee/buildAvatarFallback.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class buildEmployeeCard extends StatelessWidget {
  final Employee emp;
  final int index;
  final Function(Employee emp) onTap;
  final String Function(Employee emp)? trailingText;
  final Color Function(Employee emp)? trailingColor;

  const buildEmployeeCard({
    Key? key,
    required this.emp,
    required this.index,
    required this.onTap,
    this.trailingText,
    this.trailingColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isActive = emp.hrStatus == 'approved';
    final loc = AppLocalizations.of(context)!;

    // استدعاء الدوال مباشرة هنا لتجنب طباعة Closure
    final trailing = trailingText != null ? trailingText!(emp) : (isActive ? loc.approved : loc.appending);
    final trailingCol = trailingColor != null ? trailingColor!(emp) : (isActive ? Colors.green.shade700 : Colors.red.shade700);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTap: () => onTap(emp),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isActive ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Profile Section
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isActive
                        ? [Colors.green.shade400, Colors.green.shade600]
                        : [Colors.red.shade400, Colors.red.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: (isActive ? Colors.green : Colors.red).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: emp.profileImage.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    emp.profileImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        buildAvatarFallback(emp, isActive),
                  ),
                )
                    : buildAvatarFallback(emp, isActive),
              ),
              const SizedBox(width: 20),

              // Employee Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            emp.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF1E293B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: trailingCol.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            trailing,
                            style: TextStyle(
                              color: trailingCol,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.business_rounded,
                          size: 16,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${loc.companyCode}: ${emp.companyCode}",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.work_rounded,
                          size: 16,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${loc.idNumber}: ${emp.id}",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Action Button
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.indigo.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
