import 'package:flutter/material.dart';

Widget buildTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  bool enabled = true,
  int maxLines = 1,
  bool isDark = false, // إضافة متغير للتحكم بالوضع الداكن
}) {
  final borderRadius = BorderRadius.circular(12);

  return TextField(
    controller: controller,
    enabled: enabled,
    maxLines: maxLines,
    style: TextStyle(color: isDark ? Colors.white : Colors.black),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
      prefixIcon: Icon(icon, color: isDark ? Colors.white70 : Colors.grey[700]),
      filled: true,
      fillColor: isDark ? const Color(0xFF1F1F1F) : Colors.white,
      border: OutlineInputBorder(borderRadius: borderRadius),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: isDark ? Colors.deepPurpleAccent : Colors.blue,
          width: 2,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        ),
      ),
    ),
  );
}
