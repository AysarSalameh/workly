import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(const Locale('en')); // اللغة الافتراضية

  void switchToEnglish() => emit(const Locale('en'));
  void switchToArabic() => emit(const Locale('ar'));

  void toggle() {
    if (state.languageCode == 'en') {
      emit(const Locale('ar'));
    } else {
      emit(const Locale('en'));
    }
  }
}
