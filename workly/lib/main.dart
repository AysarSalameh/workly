import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:projects_flutter/languge/cubit/language_cubit.dart';
import 'l10n/app_localizations.dart'; // الملف يلي بيتولد تلقائياً

import 'auth/auth_service.dart';
import 'auth/cubit/auth_cubit.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug, // لتجربة المحاكي
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(AuthService()),
        ),
        BlocProvider(
          create: (context) => LanguageCubit(),
        ),
      ],
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Workly',

            // 🌍 دعم اللغات
            supportedLocales: const [
              Locale('en'), // English
              Locale('ar'), // Arabic
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            locale: locale, // ✅ يقرأ لغة التطبيق من LanguageCubit
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'Cairo', // ✅ يدعم العربي إذا ضفت الخط
            ),
            home: const LoginScreen(),
          );
        },
      ),
    );
  }
}
