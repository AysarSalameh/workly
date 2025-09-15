import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/HR/WidgetsEmployeeRatePerHour/ModernAppBarEmpRate.dart';
import 'package:projects_flutter/HR/WidgetsEmployeeRatePerHour/buildEmployeeRatePerHourContent.dart';

import 'package:projects_flutter/l10n/app_localizations.dart';

class EmployeeRatePerHour extends StatefulWidget {
  final String companyCode;

  const EmployeeRatePerHour({super.key, required this.companyCode});

  @override
  State<EmployeeRatePerHour> createState() => _EmployeeRatePerHourState();
}

class _EmployeeRatePerHourState extends State<EmployeeRatePerHour>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String _searchQuery = '';
  String _selectedFilter = 'All';
  List<String> _filterOptions = [];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void onSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    _filterOptions = [
      AppLocalizations.of(context)!.all,
      AppLocalizations.of(context)!.approved,
      AppLocalizations.of(context)!.appending,
    ];

    // ✅ هنا دمجنا BlocProvider مباشرة
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          ModernAppBarEmpRate(onSearch: onSearch),
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: buildEmployeeRatePerHourContent(
                context: context,
                companyCode: widget.companyCode,
                searchQuery: _searchQuery,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
