import 'package:flutter/material.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

Widget buildLocationCard(AppLocalizations loc, bool within, VoidCallback? onRefresh) {
  return InkWell(
    borderRadius: BorderRadius.circular(25),
    onTap: onRefresh, // هذا هو الحدث عند الضغط
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: within
              ? [Color(0xFF56ab2f), Color(0xFFa8e6cf)]
              : [Color(0xFFff6b6b), Color(0xFFffa5a5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: (within ? Colors.green : Colors.red).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              within ? Icons.location_on_rounded : Icons.location_off_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              within ? loc.withinCompany : loc.outsideCompany,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6,
                  )
                ],
              ),
            ),
          ),
          if (onRefresh != null)
            Icon(Icons.refresh, color: Colors.white, size: 28), // أيقونة تحديث
        ],
      ),
    ),
  );
}
