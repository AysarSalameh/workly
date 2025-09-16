import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/HR/SalaryCubit/SalaryCubit.dart';
import 'package:projects_flutter/HR/company/hrcompanycubit.dart';
import 'package:projects_flutter/HR/company/hrcompanystate.dart';
import 'package:projects_flutter/HR/screen/AttendancePage.dart';
import 'package:projects_flutter/HR/screen/EmployeeRatePerHour.dart';
import 'package:projects_flutter/HR/screen/SalaryReleasePage.dart';
import 'package:projects_flutter/HR/screen/SettingsPage.dart';
import 'package:projects_flutter/HR/screen/employeespage.dart';
import '/l10n/app_localizations.dart'; // 👈 إضافة Localization

class BuildModernSidebar extends StatefulWidget {
  const BuildModernSidebar({super.key});

  @override
  State<BuildModernSidebar> createState() => _BuildModernSidebarState();
}

class _BuildModernSidebarState extends State<BuildModernSidebar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!; // 👈 اختصار للوصول للنصوص

    final List<MenuItem> _menuItems = [
      MenuItem(loc.myEmployees, Icons.people_rounded),
      MenuItem(loc.attendance, Icons.access_time_rounded),
      MenuItem(loc.ratePerHour, Icons.money_rounded),
      MenuItem(loc.salaryRelease, Icons.account_balance_wallet_rounded),
      MenuItem(loc.settings, Icons.settings_rounded),
    ];

    return BlocBuilder<HrCompanyCubit, HrCompanyState>(
      builder: (context, state) {
        String companyCode = '';
        if (state is CompanyLoaded) companyCode = state.code;

        return Container(
          width: 290,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.indigo.shade900,
                Colors.indigo.shade700,
                Colors.blue.shade800
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(2, 0))
            ],
          ),
          child: Column(
            children: [
              // ---- Header ----
              Container(
                padding: const EdgeInsets.all(32),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.business_rounded,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.hrPortal,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            loc.managementSystem,
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ---- Menu ----
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _menuItems.length,
                  itemBuilder: (context, index) {
                    final item = _menuItems[index];
                    final isSelected = _selectedIndex == index;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            setState(() => _selectedIndex = index);

                            if (index == 0 && companyCode.isNotEmpty) {
                              // MyEmployees
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EmployeesPage(companyCode: companyCode),
                                ),
                              );
                            }
                            else if (index == 1) {
                              // Settings
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AttendancePage(companyCode: companyCode,), // استبدل بـصفحتك الحقيقية
                                ),
                              );
                            }
                            else if (index == 2) {
                              // Settings
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EmployeeRatePerHour(companyCode: companyCode,), // استبدل بـصفحتك الحقيقية
                                ),
                              );
                            }
                            else if (index == 3) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                    create: (_) => SalaryCubit(),
                                    child: const SalaryPage(),
                                  ),
                                ),
                              );

                            }
                            else if (index == 4) {
                              // Settings
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SettingsPage(), // استبدل بـصفحتك الحقيقية
                                ),
                              );
                            }
                          },

                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              border: isSelected
                                  ? Border.all(
                                  color: Colors.white.withOpacity(0.3))
                                  : null,
                            ),
                            child: Row(
                              children: [
                                Icon(item.icon,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white70,
                                    size: 24),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.white70,
                                      fontSize: 16,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ---- User Info ----
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: BlocBuilder<HrCompanyCubit, HrCompanyState>(
                  builder: (context, state) {
                    if (state is CompanyLoaded) {
                      return Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            backgroundImage: state.hrImageUrl.isNotEmpty
                                ? NetworkImage(state.hrImageUrl)
                                : null,
                            child: state.hrImageUrl.isEmpty
                                ? const Icon(Icons.person, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.hrName,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  loc.hrManager,
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class MenuItem {
  final String title;
  final IconData icon;

  MenuItem(this.title, this.icon);
}
