import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projects_flutter/Employee/ThemeCubit/themecubit.dart';
import 'package:projects_flutter/Employee/data_profile/profile_cubit.dart';

import 'package:projects_flutter/Employee/languge/cubit/language_cubit.dart';
import '/l10n/app_localizations.dart'; // الملف يلي بيتولد تلقائياً

import '/Employee/auth/auth_service.dart';
import '/Employee/auth/cubit/auth_cubit.dart';
import '/Employee/screens/login_screen.dart';


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
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create: (context) => ProfileCubit(), // ✅ أضف هذا
        ),
        BlocProvider(
          create: (context) => AuthCubit(AuthService()),
        ),
        BlocProvider(
          create: (context) => LanguageCubit(),
        ),

      ],
      child:BlocBuilder<LanguageCubit, Locale>(
    builder: (context, locale) {
      return BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Workly',

            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            locale: locale,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.blue,
              fontFamily: 'Cairo',
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.blue,
              fontFamily: 'Cairo',
            ),
            themeMode: ThemeMode.system, // ✅ يقرأ الوضع الحالي من ThemeCubit
            home: const LoginScreen(),
          );
        },
      );
    },
    ),

    );
  }
}
