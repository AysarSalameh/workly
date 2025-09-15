
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projects_flutter/HR/Reports/ExportPdfAttendance.dart';
import 'package:projects_flutter/HR/WidgetsMonthlyAttendance/AttendanceList.dart';
import 'package:projects_flutter/HR/WidgetsMonthlyAttendance/CustomAppBarWidget.dart';
import 'package:projects_flutter/HR/WidgetsMonthlyAttendance/EmptyStateWidget.dart';
import 'package:projects_flutter/HR/WidgetsMonthlyAttendance/ErrorStateWidget.dart';
import 'package:projects_flutter/HR/WidgetsMonthlyAttendance/LoadingWidget.dart';
import 'package:projects_flutter/HR/WidgetsMonthlyAttendance/StatisticsCards.dart';
import 'package:projects_flutter/HR/company/hrcompanycubit.dart';
import 'package:projects_flutter/HR/company/hrcompanystate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';


class MonthlyAttendanceScreen extends StatefulWidget {
  final String empEmail;
  final String empName;

  const MonthlyAttendanceScreen({
    super.key,
    required this.empEmail,
    required this.empName,
  });

  @override
  State<MonthlyAttendanceScreen> createState() =>
      _MonthlyAttendanceScreenState();
}

class _MonthlyAttendanceScreenState extends State<MonthlyAttendanceScreen> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  late Future<List<Map<String, dynamic>>> attendanceFuture;

  @override
  void initState() {
    super.initState();
    attendanceFuture = getMonthlyAttendance(
      widget.empEmail,
      selectedMonth,
      selectedYear,
    );
  }

  void refreshAttendance() {
    setState(() {
      attendanceFuture = getMonthlyAttendance(
        widget.empEmail,
        selectedMonth,
        selectedYear,
      );
    });
  }

  Future<void> openMap(double lat, double lng) async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      final loc = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loc.couldNotOpenMap),
          backgroundColor: const Color(0xFFE74C3C),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          CustomAppBarWidget(
            empName: widget.empName,
            selectedMonth: selectedMonth,
            selectedYear: selectedYear,
            onMonthChanged: (month) {
              selectedMonth = month;
              refreshAttendance();
            },
            onYearChanged: (year) {
              selectedYear = year;
              refreshAttendance();
            },
            onRefresh: refreshAttendance,
          ),

          SliverToBoxAdapter(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: attendanceFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingWidget();
                }

                if (snapshot.hasError) {
                  return ErrorStateWidget(error: snapshot.error.toString());
                }

                final days = snapshot.data ?? [];

                if (days.isEmpty) {
                  return EmptyStateWidget();
                }

                // حساب الإحصائيات
                final statistics = _calculateStatistics(days);

                return Column(
                  children: [
                    StatisticsCards(
                      presentDays: statistics['presentDays'],
                      absentDays: statistics['absentDays'],
                      totalHours: statistics['totalHours'],
                    ),

                    // Export Button
                    BlocBuilder<HrCompanyCubit, HrCompanyState>(
                      builder: (context, state) {
                        if (state is CompanyLoaded) {
                          return Container(
                            margin: const EdgeInsets.all(20),
                            child: ExportPdfAttendance(
                              empName: widget.empName,
                              empEmail: widget.empEmail,
                              hrName: state.hrName,
                              companyName: state.name,
                              companyLogoUrl: state.hrImageUrl,
                              attendance: days,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    AttendanceList(days: days, onLocationTap: openMap),

                    const SizedBox(height: 40),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _calculateStatistics(List<Map<String, dynamic>> days) {
    int presentDays = 0;
    int absentDays = 0;
    double totalHours = 0;

    for (var day in days) {
      if (day['checkIn'] != null) {
        presentDays++;
        if (day['totalHours'] != null) {
          totalHours += (day['totalHours'] as num).toDouble();
        }
      } else {
        absentDays++;
      }
    }

    return {
      'presentDays': presentDays,
      'absentDays': absentDays,
      'totalHours': totalHours,
    };
  }
}

Future<List<Map<String, dynamic>>> getMonthlyAttendance(
  String empEmail,
  int month,
  int year,
) async {
  final firestore = FirebaseFirestore.instance;

  final snapshot = await firestore
      .collection('Employee')
      .doc(empEmail)
      .collection('attendance')
      .where('date', isGreaterThanOrEqualTo: DateTime(year, month, 1))
      .where('date', isLessThanOrEqualTo: DateTime(year, month + 1, 0))
      .orderBy('date', descending: false)
      .get();

  return snapshot.docs.map((doc) => doc.data()).toList();
}
