import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projects_flutter/Employee/ThemeCubit/themecubit.dart';
import 'package:projects_flutter/Employee/data_profile/profile_cubit.dart';
import 'package:projects_flutter/Employee/screens/HomeScreen.dart';
import 'package:projects_flutter/HR/EmployeeCubit/employeescubit.dart';
import 'package:projects_flutter/HR/company/hrcompanycubit.dart';
import 'package:projects_flutter/HR/screen/HRMainPage.dart';
import 'package:projects_flutter/HR/screen/hrloginscreen.dart';
import 'package:projects_flutter/auth/auth_service.dart';
import 'package:projects_flutter/auth/cubit/auth_cubit.dart';
import 'package:projects_flutter/hr/screen/hrdashboardscreen.dart';
import 'package:projects_flutter/languge/cubit/language_cubit.dart';
import 'package:projects_flutter/scripts/add_fake_employees.dart';
import '/l10n/app_localizations.dart';
import '/Employee/screens/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase App Check فقط على الموبايل
  if (!kIsWeb) {
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.debug,
    );
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
 //await addFakeEmployees(5);
  //await deleteAllFakeEmployees();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => ProfileCubit()),
        BlocProvider(create: (_) => AuthCubit(AuthService())),
        BlocProvider(create: (_) => LanguageCubit()),
        BlocProvider(create: (_) => HrCompanyCubit()),
        BlocProvider(create: (_) => EmployeesCubit()),
      ],
      child: BlocBuilder<LanguageCubit, Locale>(
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
                themeMode: themeMode,

                // 👇 هنا نتابع حالة المستخدم
                home: StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    // المستخدم مسجّل دخول
                    if (snapshot.hasData && snapshot.data != null) {
                      // إذا ويب، افتح HR Dashboard
                      if (kIsWeb) {
                        return const HRMainPage(); // يمكن تغييره حسب Web dashboard
                      }
                      else {
                        return const HomeScreen();
                      }
                    } else {
                      // المستخدم غير مسجّل دخول
                      return kIsWeb
                          ? const HrLoginScreen()
                          : const LoginScreen();
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
