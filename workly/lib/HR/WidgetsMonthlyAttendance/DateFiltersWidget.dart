import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateFiltersWidget extends StatelessWidget {
  final int selectedMonth;
  final int selectedYear;
  final List<String> translatedMonths;
  final Function(int) onMonthChanged;
  final Function(int) onYearChanged;

  const DateFiltersWidget({
    Key? key,
    required this.selectedMonth,
    required this.selectedYear,
    required this.translatedMonths,
    required this.onMonthChanged,
    required this.onYearChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: selectedYear,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                dropdownColor: const Color(0xFF667EEA),
                items: List.generate(10, (i) => DateTime.now().year - i)
                    .map((year) => DropdownMenuItem(
                    value: year,
                    child: Text(year.toString())))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    onYearChanged(value);
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: selectedMonth,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                dropdownColor: const Color(0xFF667EEA),
                items: List.generate(12, (i) => i + 1)
                    .map((month) => DropdownMenuItem(
                    value: month,
                    child: Text(translatedMonths[month - 1])))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    onMonthChanged(value);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
