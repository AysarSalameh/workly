import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/HR/EmployeeCubit/employeescubit.dart';
import 'package:projects_flutter/HR/WidgetsDashbord/buildDashboardContent.dart';
import 'package:projects_flutter/HR/WidgetsDashbord/buildModernAppBar.dart';
import 'package:projects_flutter/HR/WidgetsDashbord/buildModernSidebar.dart';
import 'package:projects_flutter/HR/company/hrcompanycubit.dart';
import 'package:projects_flutter/HR/company/hrcompanystate.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';
import 'package:projects_flutter/languge/cubit/language_cubit.dart';

class HrDashboardScreen extends StatefulWidget {
  const HrDashboardScreen({super.key});

  @override
  State<HrDashboardScreen> createState() => _HrDashboardScreenState();
}

class _HrDashboardScreenState extends State<HrDashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
    _cardAnimationController.forward();

    final String companyEmailid =
        FirebaseAuth.instance.currentUser?.email ?? '';
    context.read<HrCompanyCubit>().fetchCompanyData(companyEmailid);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocBuilder<HrCompanyCubit, HrCompanyState>(
      builder: (context, state) {
        if (state is CompanyLoaded) {
          final screenWidth = MediaQuery.of(context).size.width;
          final isMobile = screenWidth <950;

          return Scaffold(
            backgroundColor: const Color(0xFFFFFFFF),
            drawer: isMobile ? const BuildModernSidebar(isDrawer: true) : null,
            appBar: isMobile
                ? AppBar(
                    leading: Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                    title: Text(loc.dashboard,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    actions: [
                      IconButton(
                        icon: const Icon(
                          Icons.language,
                        ), // 🌐 أيقونة الكرة الأرضية
                        onPressed: () {
                          final currentLocale = context
                              .read<LanguageCubit>()
                              .state;
                          if (currentLocale.languageCode == 'en') {
                            context.read<LanguageCubit>().switchToArabic();
                          } else {
                            context.read<LanguageCubit>().switchToEnglish();
                          }
                        },
                      ),
                    ],
                  )
                : null,
            body: Row(
              children: [
                if (!isMobile)
                  const BuildModernSidebar(), // sidebar على الشاشات الكبيرة
                Expanded(
                  child: Column(
                    children: [
                      if (!isMobile) buildModernAppBar(context),
                      Expanded(
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: buildDashboardContent(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (state is HrCompanyLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
