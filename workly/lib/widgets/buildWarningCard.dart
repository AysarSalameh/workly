import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

Widget buildWarningCard(AppLocalizations loc) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.orange.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.orange.withOpacity(0.3)),
    ),
    child: Row(
      children: [
        Icon(Icons.warning_amber_rounded, color: Colors.orange),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            loc.warningNearCompany, // "You must be near the office to check in"
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}