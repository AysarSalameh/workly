import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:projects_flutter/HR/WidgetsEmployee/buildEmployeeCard.dart';
import 'package:projects_flutter/HR/screen/EmployeeDetailsPage.dart';

Widget buildListView(List<dynamic> employees) {
  return ListView.separated(
    itemCount: employees.length,
    separatorBuilder: (_, __) => const SizedBox(height: 16),
    itemBuilder: (context, index) {
      final emp = employees[index];
      return buildEmployeeCard(
        emp: emp,
        index: index,
        onTap: (employee) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EmployeeDetailsPage(
                employee: employee,
              ),
            ),
          );
        },
      );

    },
  );
}