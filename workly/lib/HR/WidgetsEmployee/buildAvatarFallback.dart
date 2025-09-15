import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildAvatarFallback(dynamic emp, bool isActive) {
  return Center(
    child: Text(
      emp.name.isNotEmpty ? emp.name[0].toUpperCase() : '?',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    ),
  );
}