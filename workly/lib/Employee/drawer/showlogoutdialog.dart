import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';
import 'package:projects_flutter/Employee/screens/login_screen.dart'; // ✅ استورد شاشة تسجيل الدخول

void showLogoutDialog(BuildContext context, AppLocalizations loc) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            const Icon(Icons.logout, color: Colors.red),
            const SizedBox(width: 10),
            Text(loc.logout),
          ],
        ),
        content: Text(loc.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              loc.cancel,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop(); // اغلاق الـDialog
              await FirebaseAuth.instance.signOut(); // تسجيل الخروج

              // الانتقال لشاشة تسجيل الدخول ومسح كل الـroutes السابقة
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              loc.logout,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}
