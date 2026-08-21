import 'package:charity_management/features/notifications/cubit/notifications_cubit.dart';
import 'package:charity_management/features/notifications/cubit/notifications_state.dart';
import 'package:charity_management/features/notifications/model/notification_model.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationsCubit()..loadFirstPage(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatefulWidget {
  const _NotificationsView();

  @override
  State<_NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<_NotificationsView> {
  final ScrollController _scrollController = ScrollController();

  bool get _isArabic =>
      Localizations.localeOf(context).languageCode.toLowerCase() == 'ar';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 180) {
      context.read<NotificationsCubit>().loadNextPage();
    }
  }

  void _openNotification(NotificationModel notification) {
    context.read<NotificationsCubit>().markNotificationAsRead(notification);
    // Navigation by targetType/targetId will be connected later.
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationsCubit, NotificationsState>(
      listenWhen: (previous, current) {
        if (current is! NotificationsSuccess) {
          return false;
        }

        final error = current.readActionError;

        if (error == null || error.trim().isEmpty) {
          return false;
        }

        return previous is! NotificationsSuccess ||
            previous.readActionError != error;
      },
      listener: (context, state) {
        if (state is! NotificationsSuccess) {
          return;
        }

        final error = state.readActionError;

        if (error == null || error.trim().isEmpty) {
          return;
        }

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(error),
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.error,
            ),
          );

        context.read<NotificationsCubit>().clearReadActionError();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text(
            _isArabic ? 'الإشعارات' : 'Notifications',
            style: AppTextStyles.sectionTitle.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                final isMarkingAll =
                    state is NotificationsSuccess && state.isMarkingAllAsRead;
                final canMarkAll =
                    state is NotificationsSuccess &&
                    !state.isMarkingAllAsRead &&
                    state.unreadCount > 0;

                return TextButton(
                  onPressed: canMarkAll
                      ? context.read<NotificationsCubit>().markAllAsRead
                      : null,
                  child: isMarkingAll
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        )
                      : Text(_isArabic ? 'قراءة الكل' : 'Read all'),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<NotificationsCubit, NotificationsState>(
                  builder: (context, state) {
                    if (state is NotificationsLoading ||
                        state is NotificationsInitial) {
                      return _buildLoadingState();
                    }

                    if (state is NotificationsError) {
                      return _buildErrorState(state.message);
                    }

                    if (state is NotificationsEmpty) {
                      return RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: context.read<NotificationsCubit>().refresh,
                        child: _buildEmptyState(),
                      );
                    }

                    if (state is NotificationsSuccess) {
                      return RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: context.read<NotificationsCubit>().refresh,
                        child: ListView.separated(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                          itemCount:
                              state.notifications.length +
                              (state.isLoadingMore ||
                                      state.paginationError != null
                                  ? 1
                                  : 0),
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            if (index >= state.notifications.length) {
                              return _buildPaginationState(state);
                            }

                            return _buildNotificationCard(
                              state.notifications[index],
                            );
                          },
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    final style = _styleFor(notification.targetType);

    return Material(
      color: notification.isRead
          ? AppColors.surface
          : AppColors.primaryContainer.withValues(alpha: 0.32),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => _openNotification(notification),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: notification.isRead
                  ? AppColors.primary.withValues(alpha: 0.10)
                  : AppColors.primary.withValues(alpha: 0.28),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: style.color.withValues(alpha: 0.13),
                  shape: BoxShape.circle,
                ),
                child: Icon(style.icon, color: style.color, size: 23),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: AppTextStyles.bodyText.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: notification.isRead
                                  ? FontWeight.w600
                                  : FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                        ),
                        if (!notification.isRead) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 6),
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      notification.message,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyText.copyWith(
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: AppColors.brandGray,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _relativeTime(notification.createdAt),
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 42,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _isArabic
                  ? 'تعذر تحميل الإشعارات'
                  : 'Could not load notifications',
              textAlign: TextAlign.center,
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyText.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: context.read<NotificationsCubit>().loadFirstPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(_isArabic ? 'إعادة المحاولة' : 'Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(32),
      children: [
        SizedBox(height: MediaQuery.sizeOf(context).height * 0.18),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.48),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_off_outlined,
                  size: 42,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _isArabic ? 'لا توجد إشعارات' : 'No notifications',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationState(NotificationsSuccess state) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        state.paginationError ?? '',
        textAlign: TextAlign.center,
        style: AppTextStyles.caption.copyWith(color: AppColors.error),
      ),
    );
  }

  _NotificationStyle _styleFor(String targetType) {
    final normalizedType = targetType.toLowerCase();

    if (normalizedType.contains('sponsor')) {
      return const _NotificationStyle(
        icon: Icons.favorite_outline,
        color: AppColors.error,
      );
    }

    if (normalizedType.contains('report')) {
      return const _NotificationStyle(
        icon: Icons.description_outlined,
        color: AppColors.tertiary,
      );
    }

    if (normalizedType.contains('donation') ||
        normalizedType.contains('wallet') ||
        normalizedType.contains('payment')) {
      return const _NotificationStyle(
        icon: Icons.account_balance_wallet_outlined,
        color: Color(0xFF3A7D5B),
      );
    }

    if (normalizedType.contains('aid') || normalizedType.contains('request')) {
      return const _NotificationStyle(
        icon: Icons.volunteer_activism_outlined,
        color: AppColors.primary,
      );
    }

    return const _NotificationStyle(
      icon: Icons.notifications_none_outlined,
      color: AppColors.primary,
    );
  }

  String _relativeTime(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inMinutes < 1) {
      return _isArabic ? 'الآن' : 'Now';
    }
    if (difference.inHours < 1) {
      return _isArabic
          ? 'منذ ${difference.inMinutes} دقيقة'
          : '${difference.inMinutes} min ago';
    }
    if (difference.inDays < 1) {
      return _isArabic
          ? 'منذ ${difference.inHours} ساعة'
          : '${difference.inHours} hr ago';
    }
    if (difference.inDays == 1) {
      return _isArabic ? 'أمس' : 'Yesterday';
    }
    return _isArabic
        ? 'منذ ${difference.inDays} أيام'
        : '${difference.inDays} days ago';
  }
}

class _NotificationStyle {
  const _NotificationStyle({required this.icon, required this.color});

  final IconData icon;
  final Color color;
}
