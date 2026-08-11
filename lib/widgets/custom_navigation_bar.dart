import 'package:charity_management/features/Beneficiary/profile/cubit/profile_cubit.dart';
import 'package:charity_management/features/Beneficiary/profile/screen/profile_screen.dart';
import 'package:charity_management/features/Beneficiary/profile/service/profile_service.dart';
import 'package:charity_management/features/screen/settings_page.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({
    super.key,
    this.currentIndex = 0,
  });

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(
            color: AppColors.secondary.withOpacity(0.1),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              index: 0,
              icon: Icons.home,
              label: l10n.home,
            ),
            _buildNavItem(
              context: context,
              index: 1,
              icon: Icons.analytics_outlined,
              label: l10n.trackRequest,
            ),
            _buildNavItem(
              context: context,
              index: 2,
              icon: Icons.person_outline,
              label: l10n.account,
            ),
            _buildNavItem(
              context: context,
              index: 3,
              icon: Icons.settings_outlined,
              label: l10n.settings,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isActive = currentIndex == index;

    return InkWell(
      onTap: () {
        _handleNavigation(
          context,
          index,
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: isActive
            ? BoxDecoration(
                color: AppColors.primaryContainer.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive
                  ? AppColors.primary
                  : AppColors.brandGray,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isActive
                    ? AppColors.primary
                    : AppColors.brandGray,
                fontSize: 11,
                fontWeight: isActive
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontFamily: AppTextStyles.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }

void _handleNavigation(
  BuildContext context,
  int index,
) {
  if (index == currentIndex) {
    return;
  }

  switch (index) {
    case 0:
      Navigator.of(context).popUntil(
        (route) => route.isFirst,
      );
      break;

    case 1:
      debugPrint(
        'Track requests clicked',
      );
      break;

    case 2:
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return BlocProvider(
              create: (_) => ProfileCubit(
                ProfileService(),
              ),
              child: const ProfilePage(),
            );
          },
        ),
      );
      break;

    case 3:
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return const SettingsPage();
          },
        ),
      );
      break;
  }
}
}