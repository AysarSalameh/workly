import 'package:flutter/cupertino.dart';
import 'package:projects_flutter/HR/WidgetsMonthlyAttendance/AttendanceCard.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class AttendanceList extends StatelessWidget {
  final List<Map<String, dynamic>> days;
  final Function(double, double) onLocationTap;

  const AttendanceList({
    Key? key,
    required this.days,
    required this.onLocationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.dailyAttendanceLog,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              return AttendanceCard(
                day: day,
                onLocationTap: onLocationTap,
              );
            },
          ),
        ],
      ),
    );
  }
}
