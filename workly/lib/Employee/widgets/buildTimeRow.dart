import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildTimeRow(String label, String value, IconData icon, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
    decoration: BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [color.withOpacity(0.8), color]),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            "$label:",
            style: TextStyle(fontSize: 16, color: Colors.grey[700], fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    ),
  );
}
