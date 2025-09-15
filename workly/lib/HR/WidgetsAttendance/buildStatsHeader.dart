import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projects_flutter/HR/WidgetsAttendance/buildStatItem.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

Widget buildStatsHeader(int present, int absent, int total, AppLocalizations loc) {
  return Container(
    margin: const EdgeInsets.all(20),
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.indigo.shade600, Colors.blue.shade500],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.indigo.withOpacity(0.3),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        buildStatItem(loc.total, total, Icons.people_rounded, Colors.white),
        Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
        buildStatItem(loc.present, present, Icons.check_circle_rounded, Colors.green.shade300),
        Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
        buildStatItem(loc.absent, absent, Icons.cancel_rounded, Colors.red.shade300),
      ],
    ),
  );
}