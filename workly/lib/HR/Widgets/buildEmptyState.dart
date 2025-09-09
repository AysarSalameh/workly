import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projects_flutter/l10n/app_localizations.dart'; // ✅ استيراد الترجمات

Widget buildEmptyState(AppLocalizations loc) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade100, Colors.grey.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Icon(
          Icons.people_outline_rounded,
          size: 60,
          color: Colors.grey.shade400,
        ),
      ),
      const SizedBox(height: 24),
      Text(
        loc.noEmployeesFound, // ✅ استخدم الترجمة
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E293B),
        ),
      ),
    ],
  );
}
