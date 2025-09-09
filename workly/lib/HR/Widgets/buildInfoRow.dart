import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildInfoRow(String label, String value, IconData icon) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[200]!, width: 1),
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: Colors.blueAccent),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Text(label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black54,
              )),
        ),
        Expanded(
          flex: 3,
          child: Text(value,
              style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              maxLines: 2),
        ),
      ],
    ),
  );
}