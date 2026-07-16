import 'package:charity_management/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static const String fontFamily = 'IBM Plex Sans Arabic';

  static const TextStyle mainTitle = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.onSurface,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.primary,
    fontSize: 20,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle bodyText = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.brandGray,
    fontSize: 16,
    height: 1.6,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    color: AppColors.brandGray,
    fontSize: 12,
  );
}