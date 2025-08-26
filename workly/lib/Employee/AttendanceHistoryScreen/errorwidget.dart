import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class ErrorWidgetLocalized extends StatelessWidget {
  final String error;
  const ErrorWidgetLocalized({required this.error, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.error_outline, color: Colors.red[400], size: 64),
          const SizedBox(height: 12),
          Text(
            loc.errorOccurred, // بدل 'حدث خطأ'
            style: TextStyle(fontSize: 18, color: Colors.red[700], fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(error, textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}
