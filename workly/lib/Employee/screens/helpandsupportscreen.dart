import 'package:flutter/material.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.helpAndSupport),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              loc.frequentlyAskedQuestions,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ExpansionTile(
              leading: const Icon(Icons.help_outline),
              title: Text(loc.howToUseApp),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(loc.howToUseAppAnswer),
                ),
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.security),
              title: Text(loc.isMyDataSecure),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(loc.isMyDataSecureAnswer),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              loc.contactSupport,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.email),
            title: Text(loc.emailUs),
            subtitle: Text(loc.emailAddress),
            onTap: () async {
              final Uri emailUri = Uri(
                scheme: 'mailto',
                path: loc.emailAddress,
                query: 'subject=Support&body=Hello', // اختياري
              );
              if (await canLaunchUrl(emailUri)) {
                await launchUrl(emailUri);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Could not launch email client")),
                );
              }
            },
          ),

            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(loc.callUs),
              subtitle: Text(loc.phoneNumbersupport),
              onTap: () async {
                final Uri phoneUri = Uri(scheme: 'tel', path: loc.phoneNumbersupport);
                if (await canLaunchUrl(phoneUri)) {
                  await launchUrl(phoneUri);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Could not launch phone dialer")),
                  );
                }
              },
            ),

          ],
        ),
      ),
    );
  }
}
