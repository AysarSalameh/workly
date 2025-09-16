import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:projects_flutter/HR/screen/SalaryReleasePreview.dart';
import '../ModelsHR/Employee.dart';
import '../SalaryCubit/SalaryCubit.dart';
import '../SalaryCubit/SalaryState.dart';
import '../EmployeeCubit/employeescubit.dart';
import '../EmployeeCubit/employeesstate.dart';
import '../WidgetsEmployee/buildEmptyState.dart';
import '../WidgetsEmployee/buildLoadingState.dart';
import '../WidgetsMonthlyAttendance/ErrorStateWidget.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class SalaryPage extends StatefulWidget {
  const SalaryPage({super.key});

  @override
  State<SalaryPage> createState() => _SalaryPageState();
}

class _SalaryPageState extends State<SalaryPage> with TickerProviderStateMixin {
  DateTime selectedMonth = DateTime.now();
  Map<String, bool> selectedEmployees = {};
  bool selectAll = false;
  String searchQuery = '';

  late AnimationController _animationController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward();

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // تحميل الرواتب الافتراضية عند فتح الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSalaries();
    });
  }

  void _loadSalaries() {
    final employeesState = context.read<EmployeesCubit>().state;
    List<Employee> approvedEmployees = [];
    if (employeesState is EmployeesLoaded) {
      approvedEmployees = employeesState.employees
          .where((e) => e.hrStatus == 'approved')
          .toList();
    }
    final monthDocId = DateFormat('yyyy-MM').format(selectedMonth);
    context.read<SalaryCubit>().loadSalaries(monthDocId, approvedEmployees);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _updateFabVisibility() {
    final hasSelected = selectedEmployees.values.any((v) => v);
    if (hasSelected) {
      _fabAnimationController.forward();
    } else {
      _fabAnimationController.reverse();
    }
  }

  void _onMonthPicked(DateTime picked) {
    setState(() {
      selectedMonth = picked;
      selectedEmployees.clear();
      selectAll = false;
      _animationController.reset();
      _animationController.forward();
    });
    _loadSalaries();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final employeesState = context.watch<EmployeesCubit>().state;

    List<Employee> approvedEmployees = [];
    if (employeesState is EmployeesLoaded) {
      approvedEmployees = employeesState.employees
          .where((e) => e.hrStatus == 'approved')
          .toList();
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 180,
            floating: false,
            pinned: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.indigo.shade600,
                      Colors.blue.shade600,
                      Colors.indigo.shade700,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                                    loc.salaryPageTitle,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    DateFormat(
                                      'MMMM yyyy',
                                    ).format(selectedMonth),
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () async {
                              final picked = await showMonthPicker(
                                context: context,
                                initialDate: selectedMonth,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                _onMonthPicked(picked);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    loc.chooseMonth,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.calendar_month_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            onChanged: (val) =>
                                setState(() => searchQuery = val),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search_rounded,
                                color: Colors.grey[400],
                              ),
                              hintText: loc.searchEmployees,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: BlocBuilder<SalaryCubit, SalaryState>(
              builder: (context, state) {
                if (state is SalaryLoading) return buildLoadingState(context);
                if (state is SalaryError) {
                  return ErrorStateWidget(error: state.message);
                }
                if (state is SalaryLoaded) {
                  if (state.salaries.isEmpty) return buildEmptyState(loc);
                  return _buildSalariesList(state, approvedEmployees, loc);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _fabAnimationController,
            curve: Curves.elasticOut,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.indigo.shade600,
                Colors.blue.shade600,
                Colors.indigo.shade700,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
              onPressed: () {
                final currentState = context.read<SalaryCubit>().state;
                if (currentState is SalaryLoaded) {
                  final selected = currentState.salaries
                      .where((e) => selectedEmployees[e.email] ?? false)
                      .toList();
                  if (selected.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SalaryReleasePreview(
                          salaries: selected,
                          approvedEmployees: approvedEmployees,
                          month: selectedMonth,
                        ),
                      ),
                    ).then((_) {
                      // بعد رجوع المستخدم من SalaryReleasePreview
                      Navigator.pop(context); // يعمل Pop للـ SalaryPage نفسها
                    });
                    return;
                  }
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(loc.selectAtLeastOneEmployee),
                    backgroundColor: Colors.red[400],
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },

            label: Text(
              loc.release,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            icon: const Icon(Icons.send_rounded),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  // تابع لبناء قائمة الرواتب
  Widget _buildSalariesList(
    SalaryLoaded state,
    List<Employee> approvedEmployees,
    AppLocalizations loc,
  ) {
    final filteredSalaries = state.salaries.where((empSalary) {
      final employee = approvedEmployees.firstWhere(
        (e) => e.email == empSalary.email,
        orElse: () => Employee(
          id: empSalary.email,
          name: empSalary.email,
          email: empSalary.email,
          phoneNumber: '',
          iban: '',
          address: '',
          birthDate: '',
          hrStatus: '',
          profileImage: '',
          companyCode: '',
          companyLat: 0,
          companyLng: 0,
          createdAt: Timestamp.now(),
          idImage: '',
          ratePerHour: 0,
        ),
      );
      return employee.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          employee.email.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Select All Card
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CheckboxListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                value: selectAll,
                onChanged: (val) {
                  setState(() {
                    selectAll = val ?? false;
                    for (var emp in filteredSalaries) {
                      if (!(emp.salaryReleased ?? false)) {
                        selectedEmployees[emp.email] = selectAll;
                      }
                    }
                    _updateFabVisibility();
                  });
                },
                title: Text(
                  loc.selectAll,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                activeColor: Colors.indigo.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            // Employees List
            ...filteredSalaries.asMap().entries.map((entry) {
              final index = entry.key;
              final empSalary = entry.value;
              final employee = approvedEmployees.firstWhere(
                (e) => e.email == empSalary.email,
                orElse: () => Employee(
                  id: '',
                  name: empSalary.email,
                  email: empSalary.email,
                  phoneNumber: '',
                  iban: '',
                  address: '',
                  birthDate: '',
                  hrStatus: '',
                  profileImage: '',
                  companyCode: '',
                  companyLat: 0,
                  companyLng: 0,
                  createdAt: Timestamp.now(),
                  idImage: '',
                  ratePerHour: 0,
                ),
              );

              final isChecked = selectedEmployees[empSalary.email] ?? false;
              final isPaid = empSalary.salaryReleased ;

              return TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 300 + (index * 100)),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 50 * (1 - value)),
                    child: Opacity(
                      opacity: value,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: isPaid
                              ? Border.all(
                                  color: Colors.green.shade200,
                                  width: 2,
                                )
                              : isChecked
                              ? Border.all(
                                  color: Colors.indigo.shade200,
                                  width: 2,
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  // Status Icon/Checkbox
                                  if (isPaid)
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.green[100],
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check_circle_rounded,
                                        color: Colors.green[600],
                                        size: 24,
                                      ),
                                    )
                                  else
                                    Transform.scale(
                                      scale: 1.2,
                                      child: Checkbox(
                                        value: isChecked,
                                        onChanged: (val) {
                                          setState(() {
                                            selectedEmployees[empSalary.email] =
                                                val ?? false;
                                            selectAll = filteredSalaries.every(
                                              (emp) =>
                                                  emp.salaryReleased == true ||
                                                  (selectedEmployees[emp
                                                          .email] ??
                                                      false),
                                            );
                                            _updateFabVisibility();
                                          });
                                        },
                                        activeColor: Colors.indigo.shade600,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                      ),
                                    ),

                                  const SizedBox(width: 16),

                                  // Employee Avatar
                                  CircleAvatar(
                                    radius: 24,
                                    backgroundColor: isPaid
                                        ? Colors.green.shade100
                                        : Colors.indigo.shade100,
                                    backgroundImage:
                                        employee.profileImage.isNotEmpty
                                        ? NetworkImage(employee.profileImage)
                                        : null,
                                    child: employee.profileImage.isEmpty
                                        ? Text(
                                            employee.name.isNotEmpty
                                                ? employee.name
                                                      .substring(0, 1)
                                                      .toUpperCase()
                                                : 'W',
                                            style: TextStyle(
                                              color: isPaid
                                                  ? Colors.green.shade600
                                                  : Colors.indigo.shade600,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        : null,
                                  ),

                                  const SizedBox(width: 16),

                                  // Employee Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          employee.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2D3748),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          employee.email,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Salary Amount
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isPaid
                                          ? Colors.green[50]
                                          : Colors.indigo[50],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${empSalary.salary.toStringAsFixed(2)}\$',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isPaid
                                            ? Colors.green[700]
                                            : Colors.indigo[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Details Row
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                loc.hours,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                empSalary?.totalMonthHours !=
                                                        null
                                                    ? '${empSalary.totalMonthHours!.floor()} ${loc.hours} ${((empSalary.totalMonthHours - empSalary.totalMonthHours.floor()) * 60).round()} ${loc.minutes}'
                                                    : '--',

                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF2D3748),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: 1,
                                          height: 40,
                                          color: Colors.grey[300],
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                loc.hourRate,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${empSalary.ratePerHour.toStringAsFixed(2)}\$',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF2D3748),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (isPaid) ...[
                                      const SizedBox(height: 12),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.green[100],
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.payment_rounded,
                                              color: Colors.green[600],
                                              size: 18,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                '${loc.paid}: ${_formatReleaseDate(empSalary.releaseDate)}',
                                                style: TextStyle(
                                                  color: Colors.green[700],
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

String _formatReleaseDate(dynamic releaseDate) {
  try {
    DateTime date;
    if (releaseDate is Timestamp) {
      date = releaseDate.toDate();
    } else if (releaseDate is DateTime) {
      date = releaseDate;
    } else {
      return 'تاريخ غير محدد';
    }
    return DateFormat('yyyy-MM-dd').format(date);
  } catch (e) {
    return 'تاريخ غير صالح';
  }
}
