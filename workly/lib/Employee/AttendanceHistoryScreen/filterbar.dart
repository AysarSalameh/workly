import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class FilterBar extends StatelessWidget {
  final List<String> months;
  final String selectedMonth;
  final ValueChanged<String> onChanged;

  const FilterBar({
    required this.months,
    required this.selectedMonth,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? Color(0xFF2C2C3A) : Colors.white;
    final textColor = isDark ? Colors.white70 : Colors.grey[700]!;
    final iconColor = isDark ? Colors.white70 : Colors.grey[600]!;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.08),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.filter_list, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Text(
            loc.filterByMonth,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButton<String>(
              value: selectedMonth,
              isExpanded: true,
              underline: const SizedBox(),
              icon: Icon(Icons.keyboard_arrow_down, color: iconColor),
              onChanged: (v) => onChanged(v ?? months.first),
              dropdownColor: bgColor,
              items: months
                  .map((m) => DropdownMenuItem(
                value: m,
                child: Text(m, style: TextStyle(color: textColor)),
              ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

}
