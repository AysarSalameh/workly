import 'package:flutter/cupertino.dart';
import 'package:projects_flutter/HR/Widgets/buildEmployeeCard.dart';

Widget buildListView(List<dynamic> employees) {
  return ListView.separated(
    itemCount: employees.length,
    separatorBuilder: (_, __) => const SizedBox(height: 16),
    itemBuilder: (context, index) {
      final emp = employees[index];
      return buildEmployeeCard(context,emp, index);
    },
  );
}