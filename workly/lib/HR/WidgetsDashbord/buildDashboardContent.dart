import 'package:flutter/cupertino.dart';
import 'package:projects_flutter/HR/WidgetsDashbord/buildRecentActivityTable.dart';
import 'package:projects_flutter/HR/WidgetsDashbord/buildStatisticsSection.dart';

Widget buildDashboardContent(BuildContext context) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildStatisticsSection(context),
        const SizedBox(height: 24),
        RecentActivityTable(),
      ],
    ),
  );
}