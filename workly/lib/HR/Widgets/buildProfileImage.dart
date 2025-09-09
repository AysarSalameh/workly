import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildProfileImage(String? profileUrl) {
  return Center(
    child: Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: profileUrl != null
            ? Image.network(
          profileUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.person, size: 60, color: Colors.grey),
        )
            : const Icon(Icons.person, size: 60, color: Colors.grey),
      ),
    ),
  );
}
