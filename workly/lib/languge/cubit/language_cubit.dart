import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../storage/language_storage_stub.dart'
if (dart.library.html) '../storage/language_storage_web.dart'
if (dart.library.io) '../storage/language_storage_mobile.dart';

class LanguageCubit extends Cubit<Locale> {
  LanguageCubit() : super(const Locale('en')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final code = await LanguageStorage.getLanguageCode(); // static method
    if (code != null && code.isNotEmpty) {
      emit(Locale(code));
    }
  }

  Future<void> switchToEnglish() async {
    emit(const Locale('en'));
    await LanguageStorage.setLanguageCode('en'); // static method
  }

  Future<void> switchToArabic() async {
    emit(const Locale('ar'));
    await LanguageStorage.setLanguageCode('ar'); // static method
  }

  Future<void> toggleLanguage() async {
    if (state.languageCode == 'en') {
      await switchToArabic();
    } else {
      await switchToEnglish();
    }
  }
}
