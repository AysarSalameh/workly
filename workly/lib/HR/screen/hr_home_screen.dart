import 'package:flutter/material.dart';

class HrHomeScreen extends StatelessWidget {
  const HrHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "HR Dashboard",
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "مرحباً بك في لوحة تحكم الـ HR 👋",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                // هون بتضيف منطق تسجيل الخروج أو التنقل لصفحة ثانية
              },
              icon: const Icon(Icons.logout),
              label: const Text("تسجيل خروج"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 18, fontFamily: 'Cairo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
