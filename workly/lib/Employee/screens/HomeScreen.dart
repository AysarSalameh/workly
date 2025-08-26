import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projects_flutter/Employee/attendance/attendance_cubit.dart';
import 'package:projects_flutter/Employee/attendance/attendance_state.dart';
import 'package:projects_flutter/Employee/data_profile/profile_cubit.dart';
import 'package:projects_flutter/Employee/drawer/buildbody.dart';
import 'package:projects_flutter/Employee/drawer/builddrawer.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final String uid;
  late final AppLocalizations loc;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser?.email ?? 'unknown_user';
    // لاحقًا نستخدم context بعد build
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // متغير محلي

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AttendanceCubit()..loadToday(uid: uid),
        ),
        BlocProvider(
          create: (_) => ProfileCubit()..loadUser(uid),
        ),
      ],
      child: Builder(
        builder: (context) {
          return BlocListener<AttendanceCubit, AttendanceState>(
            listener: (context, state) {
              if (state is AttendanceError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.redAccent,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                });
              }
            },
            child: BlocListener<ProfileCubit, ProfileState>(
              listener: (context, state) {
                if (state is ProfileEdited) {
                  // لإعادة بناء الصفحة بعد تعديل البيانات
                  setState(() {});
                }
              },
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, profileState) {
                  Map<String, dynamic>? employeeData;

                  if (profileState is ProfileLoaded) {
                    employeeData = profileState.userData;
                  } else if (profileState is ProfileEdited) {
                    employeeData = profileState.userData;
                  }


                  return Scaffold(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor, // ديناميكي حسب Theme
                    appBar: AppBar(
                      title: Text(
                        loc.home,
                        style: GoogleFonts.alata(
                          fontWeight: FontWeight.bold,
                          fontSize: 29,
                          color: Colors.white, // ديناميكي
                        ),
                      ),
                      centerTitle: true,
                      elevation: 0,
                      flexibleSpace: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: Theme.of(context).brightness == Brightness.light
                                ? [Color(0xFF667eea), Color(0xFF764ba2)]
                                : [Colors.grey[850]!, Colors.grey[900]!], // ألوان داكنة
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      iconTheme: IconThemeData(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Colors.grey[300],
                      ),
                    ),
                    drawer: employeeData != null
                        ? buildDrawer(context, loc, employeeData)
                        : const Drawer(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    body: buildBody(context, loc, uid),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
