import 'package:flutter/material.dart';

Widget buildDrawerItem({
  required BuildContext context,
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  final Color iconBackground = isDark
      ? theme.colorScheme.primary.withOpacity(0.1)
      : const Color(0xFF667eea).withOpacity(0.1);

  final Color iconColor = isDark
      ? theme.colorScheme.primary
      : const Color(0xFF667eea);

  final Color textColor = isDark
      ? theme.colorScheme.onSurface
      : const Color(0xFF2C3E50);

  final Color hoverColor = isDark
      ? theme.colorScheme.primary.withOpacity(0.05)
      : const Color(0xFF667eea).withOpacity(0.05);

  return ListTile(
    leading: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: iconBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 22,
      ),
    ),
    title: Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    ),
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    hoverColor: hoverColor,
  );
}
