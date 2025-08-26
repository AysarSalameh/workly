import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projects_flutter/attendance/attendance_cubit.dart';
import 'package:projects_flutter/attendance/attendance_state.dart';
import 'package:projects_flutter/drawer/buildbody.dart';
import 'package:projects_flutter/drawer/builddrawer.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<Map<String, dynamic>?> _loadEmployee(String uid) async {
    final doc = await FirebaseFirestore.instance
        .collection('Employee')
        .doc(uid)
        .get();
    return doc.data();
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.email ?? 'unknown_user';
    final loc = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => AttendanceCubit()..loadToday(uid: uid),
      child: BlocListener<AttendanceCubit, AttendanceState>(
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
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _loadEmployee(uid),
          builder: (ctx, snap) {
            final employeeData = snap.data;

            return Scaffold(
              backgroundColor: const Color(0xFFE8F4FD),
              appBar: AppBar(
                title: Text(
                  loc.home,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
                centerTitle: true,
                elevation: 0,
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                iconTheme: const IconThemeData(color: Colors.white),
              ),
              drawer: buildDrawer(context, loc, employeeData),
              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFF8FAFF), Color(0xFFE8F4FD)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: buildBody(context, loc, uid, snap),
              ),
            );
          },
        ),
      ),
    );
  }






}
