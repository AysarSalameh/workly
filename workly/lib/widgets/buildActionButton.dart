import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildActionButton(BuildContext context, String label, IconData icon, Gradient gradient, VoidCallback? onPressed) {
  return Container(
    height: 60,
    decoration: BoxDecoration(
      gradient: onPressed != null ? gradient : null,
      color: onPressed == null ? Colors.grey[300] : null,
      borderRadius: BorderRadius.circular(20),
      boxShadow: onPressed != null
          ? [
        BoxShadow(
          color: gradient.colors.first.withOpacity(0.4),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ]
          : null,
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: onPressed != null ? Colors.white : Colors.grey[600], size: 26),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: onPressed != null ? Colors.white : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
