import 'package:flutter/material.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class TotalHoursCard extends StatelessWidget {
  final dynamic totalHours;

  const TotalHoursCard({
    Key? key,
    required this.totalHours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5CF6).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.schedule,
            color: Color(0xFF8B5CF6),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            "${loc.totalHours}: ${totalHours != null ? '${totalHours.floor()} ${loc.hours} ${((totalHours - totalHours.floor()) * 60).round()} ${loc.minutes}' : 'N/A'}",
            style: const TextStyle(
              color: Color(0xFF8B5CF6),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}