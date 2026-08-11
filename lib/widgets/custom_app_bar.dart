import 'package:charity_management/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          AppColors.surface.withOpacity(0.9),
      elevation: 0,
      scrolledUnderElevation: 0,

      // ==========================================
      // اليمين: لوغو الجمعية + اسم الجمعية
      // ==========================================
      titleSpacing: 20,

      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // لوغو الجمعية
          Container(
            width: 44,
            height: 44,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    AppColors.primary.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/img/logo_isolated.svg.png',
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(width: 10),

          // اسم الجمعية
          const Text(
            'جمعية الأثر',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

      // ==========================================
      // اليسار: الإشعارات
      // ==========================================
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            left: 12,
          ),
          child: IconButton(
            onPressed: () {
              // لاحقاً نربط صفحة الإشعارات
            },
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.notifications_none_outlined,
                  color: AppColors.brandGray,
                  size: 28,
                ),

                // النقطة الحمراء
                Positioned(
                  top: 1,
                  right: 1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.surface,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);
}