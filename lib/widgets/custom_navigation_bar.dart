import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      height: 72, // ارتفاع محكم ومناسب جداً لجميع الشاشات
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        border: Border(
          top: BorderSide(color: AppColors.secondary.withOpacity(0.1)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, l10n.home, isActive: true),
            _buildNavItem(Icons.analytics_outlined, l10n.trackRequest),
            _buildNavItem(Icons.person_outline, l10n.account),
            _buildNavItem(Icons.settings_outlined, l10n.settings),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    final IconData icon,
    final String label, {
    final bool isActive = false,
  }) {
    return InkWell(
      onTap: () {
        // هنا سيتم إضافة التنقل بين الصفحات لاحقاً
      },
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: isActive
            ? BoxDecoration(
                color: AppColors.primaryContainer.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16.0),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize
              .min, // تجعل الـ Column يأخذ المساحة المطلوبة لأيقونته ونصّه فقط
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.brandGray,
              size: 24,
            ),
            const SizedBox(height: 4),
            // تغليف النص بـ Flexible يحميه تماماً من التمدد خارج حدود الشاشة أو الـ Container الأب
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow
                    .ellipsis, // في حال صغرت الشاشة جداً يضع نقاط بدل الـ Overflow
                style: TextStyle(
                  color: isActive ? AppColors.primary : AppColors.brandGray,
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  fontFamily: AppTextStyles.fontFamily,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
