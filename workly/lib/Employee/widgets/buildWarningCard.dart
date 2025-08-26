import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

Widget buildWarningCard(BuildContext context, AppLocalizations loc) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  final color = Colors.orange;

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? color.withOpacity(0.2) : color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isDark ? color.withOpacity(0.4) : color.withOpacity(0.3),
      ),
    ),
    child: Row(
      children: [
        Icon(Icons.warning_amber_rounded, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            loc.warningNearCompany,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}
