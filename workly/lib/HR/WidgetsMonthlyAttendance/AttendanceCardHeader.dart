
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projects_flutter/HR/WidgetsMonthlyAttendance/StatusBadge.dart';

class AttendanceCardHeader extends StatelessWidget {
  final Map<String, dynamic> day;
  final bool isPresent;

  const AttendanceCardHeader({
    Key? key,
    required this.day,
    required this.isPresent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('EEEE').format(day['date'].toDate()),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('d MMMM yyyy').format(day['date'].toDate()),
              style: const TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        StatusBadge(isPresent: isPresent),
      ],
    );
  }
}