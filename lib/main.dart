import 'package:charity_management/features/auth/login/cubit/login_cubit.dart';
import 'package:charity_management/features/auth/login/screen/login.dart';
import 'package:charity_management/features/auth/services/auth_service.dart';
import 'package:charity_management/features/language/cubit/language_cubit.dart';
import 'package:charity_management/features/language/cubit/language_state.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_picker/country_picker.dart';

Future<void> main() async {
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
            textTheme: GoogleFonts.notoKufiArabicTextTheme(),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              surface: Color(0xFF1A1C18),
            ),
            textTheme: GoogleFonts.notoKufiArabicTextTheme(
              ThemeData.dark().textTheme,
            ),
          ),
          themeMode: ThemeMode.light,
          home: BlocProvider(
            create: (_) => LoginCubit(authService: AuthService()),
            child: const LoginScreen(),
          ),
        );
      },
    );
  }
}