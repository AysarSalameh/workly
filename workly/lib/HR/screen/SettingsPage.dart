import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart'; // 👈 للترجمة

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // 👈 اختصار للنصوص المترجمة

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settings), // اسم الصفحة مترجم
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.settings, // عنوان رئيسي
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // مثال على خيار داخل الإعدادات
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(loc.language),
              onTap: () {
                // هنا تقدر تضيف فتح نافذة اختيار اللغة
              },
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: Text(loc.time),
              onTap: () {
                // هنا تقدر تضيف تغيير الوضع الليلي/النهاري
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(loc.signingIn),
              onTap: () {
                // هنا تقدر تضيف تسجيل الخروج
              },
            ),
          ],
        ),
      ),
    );
  }
}
