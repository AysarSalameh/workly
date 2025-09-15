
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projects_flutter/HR/WidgetsMonthlyAttendance/TimeInfoCard.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class TimeCardsRow extends StatelessWidget {
  final Map<String, dynamic> day;
  final Function(double, double) onLocationTap;

  const TimeCardsRow({
    Key? key,
    required this.day,
    required this.onLocationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: TimeInfoCard(
            title: loc.checkIn,
            time: day['checkIn'] != null
                ? DateFormat('HH:mm').format(day['checkIn'].toDate())
                : "--:--",
            icon: Icons.login,
            color: const Color(0xFF3B82F6),
            hasLocation: day['checkInLat'] != null && day['checkInLng'] != null,
            onLocationTap: day['checkInLat'] != null && day['checkInLng'] != null
                ? () => onLocationTap(day['checkInLat'], day['checkInLng'])
                : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TimeInfoCard(
            title: loc.checkOut,
            time: day['checkOut'] != null
                ? DateFormat('HH:mm').format(day['checkOut'].toDate())
                : "--:--",
            icon: Icons.logout,
            color: const Color(0xFFF59E0B),
            hasLocation: day['checkOutLat'] != null && day['checkOutLng'] != null,
            onLocationTap: day['checkOutLat'] != null && day['checkOutLng'] != null
                ? () => onLocationTap(day['checkOutLat'], day['checkOutLng'])
                : null,
          ),
        ),
      ],
    );
  }
}