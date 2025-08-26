import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildDrawerItem({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFF667eea).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        color: const Color(0xFF667eea),
        size: 22,
      ),
    ),
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Color(0xFF2C3E50),
      ),
    ),
    onTap: onTap,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    hoverColor: const Color(0xFF667eea).withOpacity(0.05),
  );
}
