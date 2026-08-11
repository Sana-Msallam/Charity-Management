import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:charity_management/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: const Text(
            'الإعدادات',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: AppTextStyles.fontFamily,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              20,
              16,
              20,
              30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تفضيلات التطبيق',
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppTextStyles.fontFamily,
                  ),
                ),

                const SizedBox(height: 14),

                _buildSettingCard(
                  icon: Icons.language_rounded,
                  title: 'اللغة',
                  subtitle: 'تغيير لغة التطبيق',
                  onTap: () {
                    // لاحقاً نربط اللغة
                  },
                ),

                const SizedBox(height: 14),

                _buildSettingCard(
                  icon: Icons.dark_mode_outlined,
                  title: 'المظهر',
                  subtitle: 'تغيير مظهر التطبيق',
                  onTap: () {
                    // لاحقاً نربط الوضع الفاتح والداكن
                  },
                ),

                const SizedBox(height: 28),

                const Text(
                  'الحساب',
                  style: TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppTextStyles.fontFamily,
                  ),
                ),

                const SizedBox(height: 14),

                _buildLogoutCard(
                  onTap: () {
                    // لاحقاً نربط تسجيل الخروج
                  },
                ),
              ],
            ),
          ),
        ),

        bottomNavigationBar: const CustomBottomNavigation(
          currentIndex: 3,
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.brandGray.withOpacity(0.12),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.025),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 25,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppTextStyles.fontFamily,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.brandGray.withOpacity(0.85),
                        fontSize: 13,
                        fontFamily: AppTextStyles.fontFamily,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.chevron_left_rounded,
                color: AppColors.brandGray,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutCard({
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.05),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.error.withOpacity(0.15),
              width: 1.1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.error,
                  size: 25,
                ),
              ),

              const SizedBox(width: 14),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تسجيل الخروج',
                      style: TextStyle(
                        color: AppColors.error,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppTextStyles.fontFamily,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      'الخروج من الحساب الحالي',
                      style: TextStyle(
                        color: AppColors.brandGray,
                        fontSize: 13,
                        fontFamily: AppTextStyles.fontFamily,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons.chevron_left_rounded,
                color: AppColors.error,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}