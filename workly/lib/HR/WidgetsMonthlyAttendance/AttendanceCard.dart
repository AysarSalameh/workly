
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projects_flutter/HR/WidgetsMonthlyAttendance/AttendanceCardHeader.dart';
import 'package:projects_flutter/HR/WidgetsMonthlyAttendance/TimeCardsRow.dart';
import 'package:projects_flutter/HR/WidgetsMonthlyAttendance/TotalHoursCard.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class AttendanceCard extends StatelessWidget {
  final Map<String, dynamic> day;
  final Function(double, double) onLocationTap;

  const AttendanceCard({
    Key? key,
    required this.day,
    required this.onLocationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isPresent = day['checkIn'] != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.05),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                AttendanceCardHeader(
                  day: day,
                  isPresent: isPresent,
                ),

                if (isPresent) ...[
                  const SizedBox(height: 20),
                  TimeCardsRow(
                    day: day,
                    onLocationTap: onLocationTap,
                  ),
                  const SizedBox(height: 16),
                  TotalHoursCard(
                    totalHours: day['totalHours'],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}