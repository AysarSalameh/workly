import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildStatItem(String label, int count, IconData icon, Color iconColor) {
  return Column(
    children: [
      Icon(icon, color: iconColor, size: 28),
      const SizedBox(height: 8),
      Text(
        '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        label,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}