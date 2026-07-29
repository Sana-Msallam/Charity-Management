import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/dio_client.dart';
import 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit._({
    required SharedPreferences preferences,
    required String initialLanguageCode,
  }) : _preferences = preferences,
       super(LanguageState(Locale(initialLanguageCode))) {
    DioClient.setLanguage(initialLanguageCode);
  }

  static const String _languageKey = 'selected_language';
  final SharedPreferences _preferences;

  static Future<LanguageCubit> create({Locale? deviceLocale}) async {
    final preferences = await SharedPreferences.getInstance();
    final savedLanguageCode = preferences.getString(_languageKey);
    final deviceLanguageCode =
        (deviceLocale ?? PlatformDispatcher.instance.locale).languageCode;

    final initialLanguageCode =
        savedLanguageCode ?? (deviceLanguageCode == 'ar' ? 'ar' : 'en');

    return LanguageCubit._(
      preferences: preferences,
      initialLanguageCode: initialLanguageCode,
    );
  }

  Future<void> changeLanguage(String languageCode) async {
    final normalizedLanguageCode = languageCode == 'ar' ? 'ar' : 'en';

    if (state.locale.languageCode == normalizedLanguageCode) {
      return;
    }

    await _preferences.setString(_languageKey, normalizedLanguageCode);
    DioClient.setLanguage(normalizedLanguageCode);
    emit(LanguageState(Locale(normalizedLanguageCode)));
  }

  Future<void> toggleLanguage() async {
    final newLanguageCode = state.locale.languageCode == 'ar' ? 'en' : 'ar';
    await changeLanguage(newLanguageCode);
  }
}
