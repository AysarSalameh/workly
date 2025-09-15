import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/HR/EmployeeCubit/employeescubit.dart';
import 'package:projects_flutter/HR/EmployeeCubit/employeesstate.dart';
import 'package:projects_flutter/HR/WidgetsEmployee/buildEmptyState.dart';
import 'package:projects_flutter/HR/WidgetsEmployee/buildErrorState.dart';
import 'package:projects_flutter/HR/WidgetsEmployee/buildListView.dart';
import 'package:projects_flutter/HR/WidgetsEmployee/buildLoadingState.dart';
import 'package:projects_flutter/HR/WidgetsEmployee/buildStatsHeader.dart';
import 'package:projects_flutter/l10n/app_localizations.dart'; // للترجمة

Widget buildEmployeesContent({
  required BuildContext context,
  required String companyCode,
  required String searchQuery,
  required String selectedFilter,
}) {
  final loc = AppLocalizations.of(context)!; // اختصار للترجمة
  return BlocBuilder<EmployeesCubit, EmployeesState>(
    builder: (context, state) {
      if (state is EmployeesLoading) {
        return buildLoadingState(context);
      } else if (state is EmployeesError) {
        return buildErrorState(context, companyCode, state.message, loc);
      } else if (state is EmployeesLoaded) {
        final filteredEmployees = _filterEmployees(
          state.employees,
          searchQuery,
          selectedFilter,
          loc,
        );
        if (filteredEmployees.isEmpty) return buildEmptyState(loc);

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              buildStatsHeader(state.employees, loc),
              const SizedBox(height: 24),
              Expanded(child: buildListView(filteredEmployees)),
            ],
          ),
        );
      }
      return const SizedBox();
    },
  );
}

// دالة الفلترة مع دعم اللغات المختلفة
List<dynamic> _filterEmployees(
    List<dynamic> employees,
    String searchQuery,
    String selectedFilter,
    AppLocalizations loc,
    ) {
  // خريطة تربط كل نص مترجم بالحالة الفعلية المخزنة
  final statusMap = {
    loc.all: null,           // "الكل"
    loc.approved: 'approved',
    loc.appending: 'pending',
  };

  return employees.where((emp) {
    final matchesSearch = emp.name.toLowerCase().contains(
      searchQuery.toLowerCase(),
    );

    final filterStatus = statusMap[selectedFilter]; // نجيب الحالة المخزنة
    final matchesFilter = filterStatus == null || emp.hrStatus == filterStatus;

    return matchesSearch && matchesFilter;
  }).toList();
}
