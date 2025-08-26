import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildLanguageOption(
    BuildContext context, {
      required String icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap,
    }) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey.withOpacity(0.2)),
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).primaryColor.withOpacity(0.1),
        ),
        child: Center(
          child: Text(icon, style: const TextStyle(fontSize: 24)),
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
  );
}