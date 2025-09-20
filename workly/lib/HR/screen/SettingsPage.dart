import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/HR/company/hrcompanycubit.dart';
import 'package:projects_flutter/HR/company/hrcompanystate.dart';
import 'package:projects_flutter/HR/screen/EditHrCompanyScreen.dart';
import 'package:projects_flutter/HR/screen/hrloginscreen.dart';
import 'package:projects_flutter/auth/cubit/auth_cubit.dart';
import 'package:projects_flutter/languge/cubit/language_cubit.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocBuilder<HrCompanyCubit, HrCompanyState>(
      builder: (context, state) {
        String hrName = '';
        String hrImageUrl = ''; // رابط الصورة من Firebase

        if (state is CompanyLoaded) {
          hrName = state.hrName;
          hrImageUrl = state.hrImageUrl;
        }

        return Scaffold(
          body: Column(
            children: [
              // AppBar حديث
              Container(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.indigo.shade600,
                      Colors.blue.shade600,
                      Colors.indigo.shade700,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.settings,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              loc.manageSettings, // مثال للوصف الصغير
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // محتوى الصفحة
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // تغيير اللغة
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: Text(loc.language),
                        onTap: () {
                          context.read<LanguageCubit>().toggleLanguage();
                        },
                      ),

                      // تعديل البروفايل
                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: Text(loc.editProfile),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditHrCompanyScreen(
                                hrName: hrName,
                                hrImageUrl: hrImageUrl, // تمرير رابط الصورة
                              ),
                            ),
                          );
                        },
                      ),

                      // تسجيل الخروج
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: Text(loc.logout),
                        onTap: () {
                          context.read<AuthCubit>().logout();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HrLoginScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
