import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:projects_flutter/screens/login_screen.dart';
import 'package:projects_flutter/screens/profilesetupscreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// دالة تسجيل الخروج
  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      print("Sign out error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to sign out")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Sign Out",
            onPressed: () => signOut(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "nono",
            onPressed: () =>ProfileScreen(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              user != null ? "Welcome, ${user.email}" : "Welcome!",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 30),
            // زر Sign Out في وسط الشاشة
            ElevatedButton.icon(
              onPressed: () => signOut(context),
              icon: const Icon(Icons.logout),
              label: const Text("Sign Out"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
