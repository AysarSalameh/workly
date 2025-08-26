import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:projects_flutter/Employee/AttendanceHistoryScreen/attendancecard.dart';
import 'package:projects_flutter/Employee/AttendanceHistoryScreen/emptywidget.dart';
import 'package:projects_flutter/Employee/AttendanceHistoryScreen/filterbar.dart';
import 'package:projects_flutter/Employee/AttendanceHistoryScreen/loadingwidget.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  late final List<String> _months;
  String? _selectedMonth;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _months = [
      'الكل',
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];

    _selectedMonth = _months.first;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Format helpers
  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  String _formatDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';

  String _formatDuration(double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).round();
    final loc = AppLocalizations.of(context)!;
    return '$h ${loc.hours} $m ${loc.minutes}';
  }

  String _dayName(int weekday) {
    final loc = AppLocalizations.of(context)!;
    switch (weekday) {
      case 1:
        return loc.monday;
      case 2:
        return loc.tuesday;
      case 3:
        return loc.wednesday;
      case 4:
        return loc.thursday;
      case 5:
        return loc.friday;
      case 6:
        return loc.saturday;
      case 7:
        return loc.sunday;
      default:
        return '';
    }
  }

  Future<String> _getAddress(double lat, double lng) async {
    final loc = AppLocalizations.of(context)!;
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return loc.unknownLocation;
      final p = placemarks.first;
      return '${p.street ?? ''}, ${p.locality ?? ''}, ${p.country ?? ''}';
    } catch (_) {
      return loc.locationError;
    }
  }

  bool _filterByMonth(DateTime date) {
    if (_selectedMonth == null || _selectedMonth == _months[0]) return true;
    final selectedIdx = _months.indexOf(_selectedMonth!);
    return date.month == selectedIdx;
  }

  String locMonthName(String month) {
    final loc = AppLocalizations.of(context)!;
    switch (month) {
      case 'الكل':
        return loc.all;
      case 'يناير':
        return loc.january;
      case 'فبراير':
        return loc.february;
      case 'مارس':
        return loc.march;
      case 'أبريل':
        return loc.april;
      case 'مايو':
        return loc.may;
      case 'يونيو':
        return loc.june;
      case 'يوليو':
        return loc.july;
      case 'أغسطس':
        return loc.august;
      case 'سبتمبر':
        return loc.september;
      case 'أكتوبر':
        return loc.october;
      case 'نوفمبر':
        return loc.november;
      case 'ديسمبر':
        return loc.december;
      default:
        return month;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(loc.attendanceHistory)),
        body: Center(child: Text(loc.pleaseLoginToViewRecords)),
      );
    }

    final uid = user.email ?? user.uid;

    return Scaffold(
      backgroundColor: isDark ? Color(0xFF121212) : const Color(0xF9F8FFFF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          loc.attendanceHistory,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [Color(0xFF3A3A5A), Color(0xFF4C4C7A)]
                  : [Color(0xFF667eea), Color(0xFF764ba2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            FilterBar(
              months: _months.map((m) => locMonthName(m)).toList(),
              selectedMonth: locMonthName(_selectedMonth!),
              onChanged: (m) {
                final idx = _months.indexWhere(
                      (month) => locMonthName(month) == m,
                );
                if (idx != -1) setState(() => _selectedMonth = _months[idx]);
              },
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Employee')
                    .doc(uid)
                    .collection('attendance')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingWidget();
                  } else if (snapshot.hasError) {
                    return ErrorWidget(loc.errorOccurred);
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return EmptyWidget(msg: loc.noData);
                  }

                  final docs = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final checkInTs = data['checkIn'] as Timestamp?;
                    if (checkInTs == null) return false;
                    return _filterByMonth(checkInTs.toDate());
                  }).toList();

                  if (docs.isEmpty) {
                    return EmptyWidget(msg: loc.noRecordsInThisMonth);
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      return AttendanceCard(
                        data: data,
                        index: index,
                        formatDate: _formatDate,
                        formatTime: _formatTime,
                        formatDuration: _formatDuration,
                        dayName: _dayName,
                        getAddress: _getAddress,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
