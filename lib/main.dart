import 'package:charity_management/features/language/cubit/language_cubit.dart';
import 'package:charity_management/features/language/cubit/language_state.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/routes/app_router.dart';
import 'package:charity_management/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:country_picker/country_picker.dart';

/*Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final languageCubit = await LanguageCubit.create();

  runApp(BlocProvider.value(value: languageCubit, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF735C00);
    const backgroundColor = Color(0xFFFFF8F1);

    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, languageState) {
        return MaterialApp(
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          debugShowCheckedModeBanner: false,
          locale: languageState.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            ...AppLocalizations.localizationsDelegates,
            CountryLocalizations.delegate,
          ],
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: primaryColor,
            scaffoldBackgroundColor: backgroundColor,
            colorScheme: ColorScheme.fromSeed(
              seedColor: primaryColor,
              primary: primaryColor,
              brightness: Brightness.light,
            ),
textTheme: ThemeData.light().textTheme,          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              surface: Color(0xFF1A1C18),
            ),
            textTheme: ThemeData.dark().textTheme,
          ),
          themeMode: ThemeMode.light,
          initialRoute: AppRoutes.authGate,
          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      },
    );
  }
}
*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint('========== MAIN START ==========');

  final LanguageCubit languageCubit =
      await LanguageCubit.create();

  debugPrint('LanguageCubit created successfully');

  runApp(
    BlocProvider.value(
      value: languageCubit,
      child: const MyApp(),
    ),
  );

  debugPrint('runApp called');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('MyApp build called');

    const Color primaryColor = Color(0xFF735C00);
    const Color backgroundColor = Color(0xFFFFF8F1);

    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, languageState) {
        debugPrint(
          'MaterialApp building with locale: '
          '${languageState.locale}',
        );

        return MaterialApp(
          onGenerateTitle: (context) {
            return AppLocalizations.of(context).appTitle;
          },
          debugShowCheckedModeBanner: false,

          locale: languageState.locale,

          supportedLocales:
              AppLocalizations.supportedLocales,

          localizationsDelegates: const [
            ...AppLocalizations.localizationsDelegates,
            CountryLocalizations.delegate,
          ],

          theme: ThemeData(
            useMaterial3: true,
            primaryColor: primaryColor,
            scaffoldBackgroundColor: backgroundColor,
            colorScheme: ColorScheme.fromSeed(
              seedColor: primaryColor,
              primary: primaryColor,
              brightness: Brightness.light,
            ),
            textTheme: ThemeData.light().textTheme,
          ),

          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              surface: Color(0xFF1A1C18),
            ),
            textTheme: ThemeData.dark().textTheme,
          ),

          themeMode: ThemeMode.light,

          // مؤقتاً لنعرف هل المشكلة من AuthGate
          initialRoute: AppRoutes.login,

          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      },
    );
  }
}