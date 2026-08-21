import '../model/notification_model.dart';
import '../model/notifications_response_model.dart';

sealed class NotificationsState {
  const NotificationsState();
}

class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

class NotificationsEmpty extends NotificationsState {
  const NotificationsEmpty();
}

class NotificationsSuccess extends NotificationsState {
  const NotificationsSuccess({
    required this.notifications,
    required this.meta,
    required this.unreadCount,
    this.isLoadingMore = false,
    this.isMarkingAllAsRead = false,
    this.markingNotificationIds = const <int>{},
    this.paginationError,
    this.readActionError,
  });

  final List<NotificationModel> notifications;
  final NotificationsMetaModel meta;
  final int unreadCount;
  final bool isLoadingMore;
  final bool isMarkingAllAsRead;
  final Set<int> markingNotificationIds;
  final String? paginationError;
  final String? readActionError;

  NotificationsSuccess copyWith({
    List<NotificationModel>? notifications,
    NotificationsMetaModel? meta,
    int? unreadCount,
    bool? isLoadingMore,
    bool? isMarkingAllAsRead,
    Set<int>? markingNotificationIds,
    String? paginationError,
    String? readActionError,
    bool clearPaginationError = false,
    bool clearReadActionError = false,
  }) {
    return NotificationsSuccess(
      notifications: notifications ?? this.notifications,
      meta: meta ?? this.meta,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isMarkingAllAsRead: isMarkingAllAsRead ?? this.isMarkingAllAsRead,
      markingNotificationIds:
          markingNotificationIds ?? this.markingNotificationIds,
      paginationError: clearPaginationError
          ? null
          : paginationError ?? this.paginationError,
      readActionError: clearReadActionError
          ? null
          : readActionError ?? this.readActionError,
    );
  }
}

class NotificationsError extends NotificationsState {
  const NotificationsError(this.message);

  final String message;
}
