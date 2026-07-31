import 'package:charity_management/features/language/cubit/language_cubit.dart';
import 'package:charity_management/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('uses Arabic for an Arabic device and toggles to English', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    final languageCubit = await LanguageCubit.create(
      deviceLocale: const Locale('ar'),
    );
    addTearDown(languageCubit.close);

    await tester.pumpWidget(
      BlocProvider.value(value: languageCubit, child: const MyApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('تسجيل الدخول'), findsWidgets);

    await languageCubit.toggleLanguage();
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsWidgets);
    expect(
      (await SharedPreferences.getInstance()).getString('selected_language'),
      'en',
    );
  });

  testWidgets('falls back to English for an unsupported device language', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    final languageCubit = await LanguageCubit.create(
      deviceLocale: const Locale('fr'),
    );
    addTearDown(languageCubit.close);

    await tester.pumpWidget(
      BlocProvider.value(value: languageCubit, child: const MyApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsWidgets);
  });
}
