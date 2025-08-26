import 'package:flutter/material.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

Widget buildLocationCard(BuildContext context, AppLocalizations loc, bool within, VoidCallback? onRefresh) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return InkWell(
    borderRadius: BorderRadius.circular(25),
    onTap: onRefresh,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: within
              ? [theme.colorScheme.secondary, theme.colorScheme.secondaryContainer]
              : [Colors.red.shade400, Colors.red.shade200],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: (within ? Colors.green : Colors.red).withOpacity(isDark ? 0.3 : 0.2),
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
              color: Colors.white.withOpacity(isDark ? 0.15 : 0.2),
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
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    offset: const Offset(0, 2),
                    blurRadius: 6,
                  )
                ],
              ),
            ),
          ),
          if (onRefresh != null)
            Icon(Icons.refresh, color: Colors.white, size: 28),
        ],
      ),
    ),
  );
}
