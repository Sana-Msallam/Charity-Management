import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class CustomStepIndicator extends StatelessWidget {
  final int currentStep; // الخطوة الحالية (مثلاً: 1 أو 2)
  final int totalSteps; // إجمالي الخطوات (مثلاً: 2 أو 3)

  const CustomStepIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // حساب النسبة المئوية لتقدم المؤشر برمجياً
    double progress = currentStep / totalSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentStep == totalSteps ? l10n.lastStep : l10n.currentStep,
              style: const TextStyle(color: AppColors.brandGray, fontSize: 14),
            ),
            Text(
              l10n.stepOfTotal(currentStep, totalSteps),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // شريط التقدم (Progress Bar)
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.brandGray.withOpacity(
              0.15,
            ), // الخلفية الفاتحة للشريط
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppColors.primaryContainer,
            ), // لون التقدم الذهبي/الأصفر
          ),
        ),
      ],
    );
  }
}
