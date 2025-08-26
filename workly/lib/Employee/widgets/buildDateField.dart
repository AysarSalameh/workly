import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

Widget buildDateField({
  required BuildContext context,
  required TextEditingController controller,
  bool isDark = false, // دعم Dark Mode
}) {
  final loc = AppLocalizations.of(context)!;

  return TextField(
    controller: controller,
    readOnly: true,
    style: TextStyle(color: isDark ? Colors.white : Colors.black),
    decoration: InputDecoration(
      labelText: loc.birthDate,
      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
      prefixIcon: Icon(Icons.cake, color: isDark ? Colors.pink[200] : Colors.pinkAccent),
      suffixIcon: Icon(Icons.calendar_today, color: isDark ? Colors.white70 : Colors.grey[700]),
      filled: true,
      fillColor: isDark ? const Color(0xFF1F1F1F) : Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey[400]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: isDark ? Colors.deepPurpleAccent : Colors.blue, width: 2),
      ),
    ),
    onTap: () {
      DatePicker.showDatePicker(
        context,
        showTitleActions: true,
        minTime: DateTime(1900, 1, 1),
        maxTime: DateTime.now(),
        onChanged: (date) {},
        onConfirm: (date) {
          controller.text =
          "${date.day.toString().padLeft(2, '0')}/"
              "${date.month.toString().padLeft(2, '0')}/"
              "${date.year}";
        },
        currentTime: DateTime.now().subtract(const Duration(days: 365 * 25)),
        locale: LocaleType.en,
      );
    },
  );
}
