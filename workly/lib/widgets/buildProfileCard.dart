import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

Widget buildProfileCard(String name, String company, String imageBase64) {
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
      gradient: const LinearGradient(
        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: Colors.purple.withOpacity(0.4),
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
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 45,
            backgroundImage: imageBytes != null ? MemoryImage(imageBytes) : null,
            backgroundColor: Colors.white,
            child: imageBytes == null
                ? const Icon(Icons.person, size: 45, color: Color(0xFF667eea))
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
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
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
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
