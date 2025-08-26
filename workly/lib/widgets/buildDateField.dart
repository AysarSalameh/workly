import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

Widget buildDateField({
  required BuildContext context,
  required TextEditingController controller,
}) {
  final loc = AppLocalizations.of(context)!;

  return TextField(
    controller: controller,
    readOnly: true,
    decoration: InputDecoration(
      labelText: loc.birthDate,
      prefixIcon: const Icon(Icons.cake, color: Colors.pinkAccent),
      suffixIcon: const Icon(Icons.calendar_today),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[400]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
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
