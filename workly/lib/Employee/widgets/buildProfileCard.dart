import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

Widget buildProfileCard(BuildContext context, String name, String company, String imageBase64) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  Uint8List? imageBytes;
  if (imageBase64.isNotEmpty) {
    try {
      imageBytes = base64Decode(imageBase64);
    } catch (e) {
      imageBytes = null;
    }
  }

  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: isDark
            ? [theme.colorScheme.surface, theme.colorScheme.surfaceVariant]
            : [const Color(0xFF667eea), const Color(0xFF764ba2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: isDark ? Colors.black54 : Colors.purple.withOpacity(0.4),
          blurRadius: 25,
          offset: const Offset(0, 15),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: theme.colorScheme.onPrimary, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.1 : 0.25),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 45,
            backgroundImage: imageBytes != null ? MemoryImage(imageBytes) : null,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: imageBytes == null
                ? Icon(
              Icons.person,
              size: 45,
              color: isDark
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onPrimary,
            )
                : null,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimary,
                  shadows: const [
                    Shadow(
                      color: Colors.black26,
                      offset: Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                company,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onPrimary.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
