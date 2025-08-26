import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projects_flutter/drawer/buildDrawerItem.dart';
import 'package:projects_flutter/drawer/showlogoutdialog.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';
import 'package:projects_flutter/screens/helpandsupportscreen.dart';
import 'package:projects_flutter/screens/settingsscreen.dart';

Widget buildDrawer(BuildContext context, AppLocalizations loc, Map<String, dynamic>? employeeData) {
  final user = FirebaseAuth.instance.currentUser;
  final name = employeeData?['name'] ?? loc.employee;
  final company = employeeData?['companyCode'] ?? '';
  final imageUrl = employeeData?['profileImage'] ?? '';
  final email = user?.email ?? '';

  return Drawer(
    child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF8FAFF), Color(0xFFE8F4FD)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          // Drawer Header
          Container(
            height: 280,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // Profile Image
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),

                    child: ClipOval(
                      child: imageUrl.isNotEmpty
                          ? Image.memory(
                        base64Decode(imageUrl),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey[600],
                            ),
                          );
                        },
                      )
                          : Container(
                        color: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    company,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Drawer Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                buildDrawerItem(icon: Icons.dashboard, title: loc.dashboard, onTap: () => Navigator.pop(context)),
                buildDrawerItem(icon: Icons.history, title: loc.attendanceHistory, onTap: () => Navigator.pop(context)),
                buildDrawerItem(icon: Icons.calendar_month, title: loc.monthlySchedule, onTap: () => Navigator.pop(context)),
                // buildDrawerItem(icon: Icons.request_quote, title: loc.myRequests, onTap: () => Navigator.pop(context)),
                buildDrawerItem(icon: Icons.person_outline, title: loc.profile, onTap: () => Navigator.pop(context)),
                // buildDrawerItem(icon: Icons.notifications_outlined, title: loc.notifications, onTap: () => Navigator.pop(context)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(thickness: 1),
                ),
                buildDrawerItem(
                  icon: Icons.settings,
                  title: loc.settings,
                  onTap: () {
                    Navigator.pop(context); // اغلاق القائمة
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsScreen()),
                    );
                  },
                ),
                buildDrawerItem(
                  icon: Icons.help_outline,
                  title: loc.help,
                  onTap: () {
                    Navigator.pop(context); // اغلاق القائمة
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HelpAndSupportScreen()),
                    );
                  },
                ),

              ],
            ),
          ),
          // Logout Section
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Divider(thickness: 1),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.email_outlined, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        email,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => showLogoutDialog(context, loc),
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: Text(
                      loc.logout,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[400],
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
