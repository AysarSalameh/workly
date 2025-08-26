import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String msg;
  const EmptyWidget({required this.msg, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? Color(0xFF1E1E2C) : Colors.grey[50];
    final borderColor = isDark ? Colors.grey[700]! : Colors.grey[200]!;
    final textColor = isDark ? Colors.grey[300]! : Colors.grey[600]!;
    final iconColor = isDark ? Colors.grey[500]! : Colors.grey[400]!;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.history_toggle_off, color: iconColor, size: 80),
          const SizedBox(height: 20),
          Text(msg, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
        ]),
      ),
    );
  }
}
