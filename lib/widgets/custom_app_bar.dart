import 'package:charity_management/features/notifications/widget/notification_bell_button.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface.withValues(alpha: 0.9),
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 20,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
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
      actions: const [
        NotificationBellButton(
          iconColor: AppColors.brandGray,
          iconSize: 28,
          padding: EdgeInsets.only(left: 12),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
