import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/HR/EmployeeCubit/employeescubit.dart';
import 'package:projects_flutter/HR/Widgets/buildEmployeesContent.dart';
import 'package:projects_flutter/HR/Widgets/buildModernAppBar.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class EmployeesPage extends StatefulWidget {
  final String companyCode;

  const EmployeesPage({super.key, required this.companyCode});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage>
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

  // ✅ دوال البحث والفلترة
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
    // ✅ خذ النصوص المترجمة من loc
    _filterOptions = [
      AppLocalizations.of(context)!.all,
      AppLocalizations.of(context)!.approved,
      AppLocalizations.of(context)!.appending,
    ];

    return BlocProvider(
      create: (_) => EmployeesCubit()..fetchEmployees(widget.companyCode),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Column(
          children: [
            ModernAppBar(
              onSearch: onSearch,
              onFilterChanged: onFilterChanged,
              filterOptions: _filterOptions,
            ),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: buildEmployeesContent(
                  context: context,
                  companyCode: widget.companyCode,
                  searchQuery: _searchQuery,
                  selectedFilter: _selectedFilter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
