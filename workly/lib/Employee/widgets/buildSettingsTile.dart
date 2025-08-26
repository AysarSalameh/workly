import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildSettingsTile({
  required BuildContext context,
  required IconData icon,
  required String title,
  required String subtitle,
  Widget? trailing,
  VoidCallback? onTap,
  Color? iconColor,
  bool isFirst = false,
  bool isLast = false,
}) {
  return Container(
    decoration: BoxDecoration(
      border: !isLast
          ? Border(
        bottom: BorderSide(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      )
          : null,
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: (iconColor ?? Theme.of(context).primaryColor).withOpacity(
            0.1,
          ),
        ),
        child: Icon(
          icon,
          color: iconColor ?? Theme.of(context).primaryColor,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 14),
      ),
      trailing:
      trailing ??
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(20) : Radius.zero,
          bottom: isLast ? const Radius.circular(20) : Radius.zero,
        ),
      ),
    ),
  );
}
