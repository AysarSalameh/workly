// شاشة المساعدة والدعم
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              "Frequently Asked Questions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ExpansionTile(
              leading: const Icon(Icons.help_outline),
              title: const Text("How to use the app?"),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      "You can navigate through the app using the bottom navigation bar or the side drawer."),
                ),
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.security),
              title: const Text("Is my data secure?"),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                      "Yes, we take privacy seriously and store your data securely."),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Contact Support",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text("Email us"),
              subtitle: const Text("support@example.com"),
              onTap: () {
                // TODO: open email client
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text("Call us"),
              subtitle: const Text("+123 456 789"),
              onTap: () {
                // TODO: initiate phone call
              },
            ),
          ],
        ),
      ),
    );
  }
}
