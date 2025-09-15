import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projects_flutter/HR/WidgetsEmployee//buildStatItem.dart';
import 'package:projects_flutter/l10n/app_localizations.dart'; // ✅ استيراد الترجمات

Widget buildStatsHeader(List<dynamic> employees, AppLocalizations loc) {
  final approvedCount = employees.where((emp) => emp.hrStatus == 'approved').length;
  final pendingCount = employees.length - approvedCount;

  return Container(
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
    ),
    child: Row(
      children: [
        buildStatItem(loc.total, employees.length.toString(), Colors.blue),       // ✅ الترجمة
        const SizedBox(width: 32),
        buildStatItem(loc.approved, approvedCount.toString(), Colors.green),      // ✅ الترجمة
        const SizedBox(width: 32),
        buildStatItem(loc.appending, pendingCount.toString(), Colors.red),          // ✅ الترجمة
      ],
    ),
  );
}
