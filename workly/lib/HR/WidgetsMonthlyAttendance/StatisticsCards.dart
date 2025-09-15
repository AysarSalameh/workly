
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projects_flutter/HR/WidgetsMonthlyAttendance/StatCard.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class StatisticsCards extends StatelessWidget {
  final int presentDays;
  final int absentDays;
  final double totalHours;

  const StatisticsCards({
    Key? key,
    required this.presentDays,
    required this.absentDays,
    required this.totalHours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: StatCard(
              title: loc.daysPresent,
              value: presentDays.toString(),
              icon: Icons.check_circle_outline,
              color: const Color(0xFF10B981),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(
              title: loc.daysAbsent,
              value: absentDays.toString(),
              icon: Icons.cancel_outlined,
              color: const Color(0xFFEF4444),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: StatCard(
              title: loc.totalHours,
              value: "${totalHours.floor()} ${loc.hours} ${((totalHours - totalHours.floor()) * 60).round()} ${loc.minutes}",
              icon: Icons.access_time,
              color: const Color(0xFF8B5CF6),
            ),
          ),
        ],
      ),
    );
  }
}
