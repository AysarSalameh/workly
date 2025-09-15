import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/languge/cubit/language_cubit.dart';
import '/l10n/app_localizations.dart';

Widget buildModernAppBar(BuildContext context) {
  final loc = AppLocalizations.of(context)!;

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          loc.dashboard,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        IconButton(
          icon: const Icon(Icons.language, color: Colors.black87),
          onPressed: () {
            final currentLocale = context.read<LanguageCubit>().state;
            if (currentLocale.languageCode == 'en') {
              context.read<LanguageCubit>().switchToArabic();
            } else {
              context.read<LanguageCubit>().switchToEnglish();
            }
          },
        ),
      ],
    ),
  );
}
