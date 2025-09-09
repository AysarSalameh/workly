import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/HR/EmployeeCubit/employeescubit.dart';
import 'package:projects_flutter/l10n/app_localizations.dart'; // ✅ استيراد الترجمات

Widget buildErrorState(BuildContext context, String companyCode, String message, AppLocalizations loc) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.error_outline_rounded,
          size: 40,
          color: Colors.red.shade600,
        ),
      ),
      const SizedBox(height: 24),
      Text(
        loc.somethingWentWrong, // ✅ الترجمة
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E293B),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        message,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 24),
      ElevatedButton.icon(
        onPressed: () {
          context.read<EmployeesCubit>().fetchEmployees(companyCode);
        },
        icon: const Icon(Icons.refresh_rounded),
        label: Text(loc.tryAgain), // ✅ الترجمة
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ],
  );
}
