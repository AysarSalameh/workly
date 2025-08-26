import 'package:flutter/material.dart';

// شاشة الإعدادات
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text("Language"),
            subtitle: const Text("Change app language"),
            onTap: () {
              // TODO: Add language change logic
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            subtitle: const Text("Enable/Disable dark mode"),
            trailing: Switch(
              value: false, // TODO: connect with theme state
              onChanged: (value) {
                // TODO: toggle theme
              },
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            subtitle: const Text("Manage notifications"),
            onTap: () {
              // TODO: navigate or show dialog
            },
          ),
        ],
      ),
    );
  }
}

