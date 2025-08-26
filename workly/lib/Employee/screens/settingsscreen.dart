import 'package:flutter/material.dart';
import 'package:projects_flutter/Employee/ThemeCubit/themecubit.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';
import 'package:projects_flutter/Employee/widgets/buildSettingsSection.dart';
import 'package:projects_flutter/Employee/widgets/buildSettingsTile.dart';
import 'package:projects_flutter/Employee/widgets/showLanguageOptions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // يدعم Dark Mode
      appBar: AppBar(
        title: Text(
          loc.settings,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).appBarTheme.titleTextStyle?.color,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).iconTheme.color, // لتغيير لون أيقونات AppBar
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // قسم التخصيص
            buildSettingsSection(
              context: context,
              title: loc.customization,
              children: [
                buildSettingsTile(
                  context: context,
                  icon: Icons.language_rounded,
                  title: loc.language,
                  subtitle: loc.changeAppLanguage,
                  onTap: () => showLanguageOptions(context),
                  iconColor: Colors.blue,
                  isFirst: true,
                ),
                buildSettingsTile(
                  context: context,
                  icon: Icons.dark_mode_rounded,
                  title: loc.darkMode,
                  subtitle: loc.enableDisableDarkMode,
                  iconColor: Colors.indigo,
                  trailing: BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (context, themeMode) {
                      final isDark = themeMode == ThemeMode.dark;
                      return Transform.scale(
                        scale: 0.8,
                        child: Switch.adaptive(
                          value: isDark,
                          onChanged: (value) {
                            context.read<ThemeCubit>().toggleTheme(value);
                          },
                          activeColor: Colors.deepPurpleAccent, // لون المفتاح عند التفعيل
                          inactiveThumbColor: Colors.grey[300], // لون المفتاح عند إيقاف التفعيل
                          inactiveTrackColor: Colors.grey[600],

                        ),
                      );
                    },
                  ),
                  onTap: null,
                ),
              ],
            ),

            const SizedBox(height: 24),

            buildSettingsSection(
              context: context,
              title: loc.notificationsAndSecurity,
              children: [
                buildSettingsTile(
                  context: context,
                  icon: Icons.notifications_rounded,
                  title: loc.notifications,
                  subtitle: loc.manageNotifications,
                  iconColor: Colors.orange,
                  isFirst: true,
                  onTap: () {
                    // TODO: navigate or show dialog
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );

  }
}
