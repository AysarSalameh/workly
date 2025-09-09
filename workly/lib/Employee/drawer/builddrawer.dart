import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/Employee/drawer/buildDrawerItem.dart';
import 'package:projects_flutter/Employee/drawer/showlogoutdialog.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';
import 'package:projects_flutter/Employee/screens/attendancehistoryscreen.dart';
import 'package:projects_flutter/Employee/screens/editprofil.dart';
import 'package:projects_flutter/Employee/screens/helpandsupportscreen.dart';
import 'package:projects_flutter/Employee/screens/monthly_schedule_screen.dart';
import 'package:projects_flutter/Employee/screens/settingsscreen.dart';

Widget buildDrawer(
  BuildContext context,
  AppLocalizations loc,
  Map<String, dynamic>? employeeData,
) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  final user = FirebaseAuth.instance.currentUser;
  final name = employeeData?['name'] ?? loc.employee;
  final company = employeeData?['companyCode'] ?? '';
  final imageUrl = employeeData?['profileImage'] ?? '';
  final email = user?.email ?? '';

  return Drawer(
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [theme.colorScheme.surface, theme.colorScheme.surfaceVariant]
              : [const Color(0xFFF8FAFF), const Color(0xFFE8F4FD)],
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [theme.colorScheme.primary, theme.colorScheme.secondary]
                    : [const Color(0xFF667eea), const Color(0xFF764ba2)],
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
                    border: Border.all(
                      color: isDark
                          ? theme.colorScheme.onPrimary
                          : Colors.white,
                      width: 4,
                    ),
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
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildDefaultAvatar(isDark, theme);
                            },
                          )
                        : _buildDefaultAvatar(isDark, theme),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  name,
                  style: TextStyle(
                    color: isDark ? theme.colorScheme.onPrimary : Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(isDark ? 0.1 : 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    company,
                    style: TextStyle(
                      color: isDark
                          ? theme.colorScheme.onPrimary
                          : Colors.white.withOpacity(0.9),
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
                buildDrawerItem(
                  context: context, // ضروري عشان نقدر نجيب الـ Theme
                  icon: Icons.dashboard,
                  title: loc.dashboard,
                  onTap: () => Navigator.pop(context),
                ),

                buildDrawerItem(
                  context: context,
                  icon: Icons.history,
                  title: loc.attendanceHistory,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AttendanceHistoryScreen(),
                    ),
                  ),
                ),
                buildDrawerItem(
                  context: context,
                  icon: Icons.calendar_month,
                  title: loc.monthlySchedule,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MonthlyScheduleScreen(),
                      ),
                    );
                  },
                ),
                buildDrawerItem(
                  context: context,
                  icon: Icons.person_outline,
                  title: loc.profile,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(thickness: 1),
                ),
                buildDrawerItem(
                  context: context,
                  icon: Icons.settings,
                  title: loc.settings,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                ),
                buildDrawerItem(
                  context: context,
                  icon: Icons.help_outline,
                  title: loc.help,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpAndSupportScreen(),
                      ),
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
                    Icon(
                      Icons.email_outlined,
                      color: isDark
                          ? theme.colorScheme.onSurfaceVariant
                          : Colors.grey[600],
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        email,
                        style: TextStyle(
                          color: isDark
                              ? theme.colorScheme.onSurfaceVariant
                              : Colors.grey[600],
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
                    onPressed: () {
                      showLogoutDialog(context, loc);
                    },
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

Widget _buildDefaultAvatar(bool isDark, ThemeData theme) {
  return Container(
    color: isDark ? theme.colorScheme.surface : Colors.white,
    child: Icon(
      Icons.person,
      size: 50,
      color: isDark ? theme.colorScheme.onSurface : Colors.grey[600],
    ),
  );
}
