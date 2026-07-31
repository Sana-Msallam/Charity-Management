import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../login/cubit/login_cubit.dart';
import '../login/screen/login.dart';
import '../services/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../widgets/language_toggle_button.dart';

class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: LanguageToggleButton(),
              ),
              Container(
                width: 105,
                height: 105,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD85A),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.hourglass_top_rounded,
                  size: 54,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                localizations.accountCreated,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                localizations.pendingApprovalMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF5E574A),
                  fontSize: 15,
                  height: 1.8,
                ),
              ),
              const SizedBox(height: 34),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => LoginCubit(authService: AuthService()),
                          child: const LoginScreen(),
                        ),
                      ),
                      (route) => false,
                    );
                  },
                  child: Text(localizations.backToLogin),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
