import 'package:charity_management/features/notifications/cubit/notifications_badge_cubit.dart';
import 'package:charity_management/features/notifications/cubit/notifications_badge_state.dart';
import 'package:charity_management/features/notifications/screen/notifications_screen.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBellButton extends StatelessWidget {
  const NotificationBellButton({
    super.key,
    required this.iconColor,
    required this.iconSize,
    this.padding = EdgeInsets.zero,
  });

  final Color iconColor;
  final double iconSize;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsBadgeCubit()..loadUnreadCount(),
      child: _NotificationBellButtonContent(
        iconColor: iconColor,
        iconSize: iconSize,
        padding: padding,
      ),
    );
  }
}

class _NotificationBellButtonContent extends StatelessWidget {
  const _NotificationBellButtonContent({
    required this.iconColor,
    required this.iconSize,
    required this.padding,
  });

  final Color iconColor;
  final double iconSize;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: IconButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
          );

          if (context.mounted) {
            context.read<NotificationsBadgeCubit>().loadUnreadCount();
          }
        },
        icon: BlocBuilder<NotificationsBadgeCubit, NotificationsBadgeState>(
          builder: (context, state) {
            final unreadCount = state is NotificationsBadgeLoaded
                ? state.unreadCount
                : 0;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.notifications_none_outlined,
                  color: iconColor,
                  size: iconSize,
                ),
                if (unreadCount > 0)
                  PositionedDirectional(
                    top: -5,
                    end: -7,
                    child: _UnreadBadge(unreadCount: unreadCount),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  const _UnreadBadge({required this.unreadCount});

  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    final label = unreadCount > 99 ? '99+' : unreadCount.toString();

    return Container(
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.surface, width: 1),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          height: 1,
        ),
      ),
    );
  }
}
