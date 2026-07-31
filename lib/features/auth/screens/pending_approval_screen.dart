import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import 'package:charity_management/routes/app_routes.dart';
import '../../../l10n/generated/app_localizations.dart';

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
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
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
