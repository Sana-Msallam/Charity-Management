import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/notification_model.dart';
import '../service/notifications_service.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({NotificationsService? service})
    : _service = service ?? NotificationsService(),
      super(const NotificationsInitial());

  static const int firstPage = 1;
  static const int pageLimit = 20;

  final NotificationsService _service;

  bool _isRequestInProgress = false;

  Future<void> loadFirstPage() async {
    if (_isRequestInProgress) {
      return;
    }

    _isRequestInProgress = true;
    emit(const NotificationsLoading());

    try {
      final response = await _service.fetchNotifications(
        page: firstPage,
        limit: pageLimit,
      );

      if (response.data.isEmpty) {
        emit(const NotificationsEmpty());
        return;
      }

      emit(
        NotificationsSuccess(
          notifications: _deduplicateById(response.data),
          meta: response.meta,
          unreadCount: response.unreadCount,
          markingNotificationIds: const <int>{},
        ),
      );
    } on FormatException catch (error, stackTrace) {
      debugPrint('NotificationsCubit FormatException: ${error.message}');
      debugPrint('Stack trace: $stackTrace');

      emit(NotificationsError(error.message));
    } on DioException catch (error, stackTrace) {
      debugPrint('NotificationsCubit DioException: ${error.message}');
      debugPrint('Response: ${error.response?.data}');
      debugPrint('Stack trace: $stackTrace');

      emit(NotificationsError(_extractDioMessage(error)));
    } catch (error, stackTrace) {
      debugPrint('NotificationsCubit unexpected error: $error');
      debugPrint('Stack trace: $stackTrace');

      emit(const NotificationsError('تعذر تحميل الإشعارات'));
    } finally {
      _isRequestInProgress = false;
    }
  }

  Future<void> refresh() async {
    final currentState = state;

    if (currentState is! NotificationsSuccess) {
      await loadFirstPage();
      return;
    }

    if (_isRequestInProgress) {
      return;
    }

    _isRequestInProgress = true;

    try {
      final response = await _service.fetchNotifications(
        page: firstPage,
        limit: pageLimit,
      );

      if (response.data.isEmpty) {
        emit(const NotificationsEmpty());
        return;
      }

      emit(
        NotificationsSuccess(
          notifications: _deduplicateById(response.data),
          meta: response.meta,
          unreadCount: response.unreadCount,
          markingNotificationIds: const <int>{},
        ),
      );
    } on FormatException catch (error, stackTrace) {
      debugPrint(
        'NotificationsCubit refresh FormatException: '
        '${error.message}',
      );
      debugPrint('Stack trace: $stackTrace');

      emit(currentState.copyWith(paginationError: error.message));
    } on DioException catch (error, stackTrace) {
      debugPrint('NotificationsCubit refresh DioException: ${error.message}');
      debugPrint('Response: ${error.response?.data}');
      debugPrint('Stack trace: $stackTrace');

      emit(currentState.copyWith(paginationError: _extractDioMessage(error)));
    } catch (error, stackTrace) {
      debugPrint('NotificationsCubit refresh unexpected error: $error');
      debugPrint('Stack trace: $stackTrace');

      emit(currentState.copyWith(paginationError: 'تعذر تحديث الإشعارات'));
    } finally {
      _isRequestInProgress = false;
    }
  }

  Future<void> loadNextPage() async {
    final currentState = state;

    if (_isRequestInProgress ||
        currentState is! NotificationsSuccess ||
        !currentState.meta.hasNextPage) {
      return;
    }

    _isRequestInProgress = true;
    emit(
      currentState.copyWith(isLoadingMore: true, clearPaginationError: true),
    );

    try {
      final response = await _service.fetchNotifications(
        page: currentState.meta.page + 1,
        limit: pageLimit,
      );

      emit(
        NotificationsSuccess(
          notifications: _deduplicateById([
            ...currentState.notifications,
            ...response.data,
          ]),
          meta: response.meta,
          unreadCount: response.unreadCount,
          markingNotificationIds: currentState.markingNotificationIds,
        ),
      );
    } on FormatException catch (error, stackTrace) {
      debugPrint(
        'NotificationsCubit pagination FormatException: '
        '${error.message}',
      );
      debugPrint('Stack trace: $stackTrace');

      emit(
        currentState.copyWith(
          isLoadingMore: false,
          paginationError: error.message,
        ),
      );
    } on DioException catch (error, stackTrace) {
      debugPrint(
        'NotificationsCubit pagination DioException: '
        '${error.message}',
      );
      debugPrint('Response: ${error.response?.data}');
      debugPrint('Stack trace: $stackTrace');

      emit(
        currentState.copyWith(
          isLoadingMore: false,
          paginationError: _extractDioMessage(error),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('NotificationsCubit pagination unexpected error: $error');
      debugPrint('Stack trace: $stackTrace');

      emit(
        currentState.copyWith(
          isLoadingMore: false,
          paginationError: 'تعذر تحميل المزيد من الإشعارات',
        ),
      );
    } finally {
      _isRequestInProgress = false;
    }
  }

  Future<void> markNotificationAsRead(NotificationModel notification) async {
    final currentState = state;

    if (currentState is! NotificationsSuccess ||
        currentState.isMarkingAllAsRead ||
        notification.isRead ||
        currentState.markingNotificationIds.contains(notification.id)) {
      return;
    }

    emit(
      currentState.copyWith(
        markingNotificationIds: {
          ...currentState.markingNotificationIds,
          notification.id,
        },
        clearReadActionError: true,
      ),
    );

    try {
      final result = await _service.markNotificationAsRead(notification.id);
      final latestState = state;

      if (latestState is! NotificationsSuccess) {
        return;
      }

      final updatedNotifications = latestState.notifications.map((
        currentNotification,
      ) {
        if (currentNotification.id != notification.id) {
          return currentNotification;
        }

        return currentNotification.copyWith(isRead: result.isRead);
      }).toList();

      final updatedMarkingIds = {...latestState.markingNotificationIds}
        ..remove(notification.id);

      emit(
        latestState.copyWith(
          notifications: updatedNotifications,
          unreadCount: result.isRead
              ? _decrementUnreadCount(latestState.unreadCount)
              : latestState.unreadCount,
          markingNotificationIds: updatedMarkingIds,
          clearReadActionError: true,
        ),
      );
    } on FormatException catch (error, stackTrace) {
      debugPrint(
        'NotificationsCubit mark read FormatException: ${error.message}',
      );
      debugPrint('Stack trace: $stackTrace');

      _emitReadActionFailure(notification.id, error.message);
    } on DioException catch (error, stackTrace) {
      debugPrint('NotificationsCubit mark read DioException: ${error.message}');
      debugPrint('Response: ${error.response?.data}');
      debugPrint('Stack trace: $stackTrace');

      _emitReadActionFailure(notification.id, _extractDioMessage(error));
    } catch (error, stackTrace) {
      debugPrint('NotificationsCubit mark read unexpected error: $error');
      debugPrint('Stack trace: $stackTrace');

      _emitReadActionFailure(notification.id, 'تعذر تحديث الإشعار');
    }
  }

  Future<void> markAllAsRead() async {
    final currentState = state;

    if (currentState is! NotificationsSuccess ||
        currentState.isMarkingAllAsRead ||
        currentState.markingNotificationIds.isNotEmpty ||
        currentState.unreadCount <= 0) {
      return;
    }

    emit(
      currentState.copyWith(
        isMarkingAllAsRead: true,
        clearReadActionError: true,
      ),
    );

    try {
      final result = await _service.markAllAsRead();
      final latestState = state;

      if (latestState is! NotificationsSuccess) {
        return;
      }

      if (!result.success) {
        emit(
          latestState.copyWith(
            isMarkingAllAsRead: false,
            readActionError: 'تعذر تحديث الإشعارات',
          ),
        );
        return;
      }

      emit(
        latestState.copyWith(
          notifications: latestState.notifications
              .map((notification) => notification.copyWith(isRead: true))
              .toList(),
          unreadCount: 0,
          isMarkingAllAsRead: false,
          markingNotificationIds: const <int>{},
          clearReadActionError: true,
        ),
      );
    } on FormatException catch (error, stackTrace) {
      debugPrint(
        'NotificationsCubit mark all FormatException: ${error.message}',
      );
      debugPrint('Stack trace: $stackTrace');

      _emitMarkAllFailure(error.message);
    } on DioException catch (error, stackTrace) {
      debugPrint('NotificationsCubit mark all DioException: ${error.message}');
      debugPrint('Response: ${error.response?.data}');
      debugPrint('Stack trace: $stackTrace');

      _emitMarkAllFailure(_extractDioMessage(error));
    } catch (error, stackTrace) {
      debugPrint('NotificationsCubit mark all unexpected error: $error');
      debugPrint('Stack trace: $stackTrace');

      _emitMarkAllFailure('تعذر تحديث الإشعارات');
    }
  }

  void clearReadActionError() {
    final currentState = state;

    if (currentState is NotificationsSuccess &&
        currentState.readActionError != null) {
      emit(currentState.copyWith(clearReadActionError: true));
    }
  }

  List<NotificationModel> _deduplicateById(
    List<NotificationModel> notifications,
  ) {
    final seenIds = <int>{};
    final uniqueNotifications = <NotificationModel>[];

    for (final notification in notifications) {
      if (seenIds.add(notification.id)) {
        uniqueNotifications.add(notification);
      }
    }

    return uniqueNotifications;
  }

  int _decrementUnreadCount(int unreadCount) {
    if (unreadCount <= 0) {
      return 0;
    }

    return unreadCount - 1;
  }

  void _emitReadActionFailure(int notificationId, String message) {
    final latestState = state;

    if (latestState is! NotificationsSuccess) {
      return;
    }

    final updatedMarkingIds = {...latestState.markingNotificationIds}
      ..remove(notificationId);

    emit(
      latestState.copyWith(
        markingNotificationIds: updatedMarkingIds,
        readActionError: message,
      ),
    );
  }

  void _emitMarkAllFailure(String message) {
    final latestState = state;

    if (latestState is! NotificationsSuccess) {
      return;
    }

    emit(
      latestState.copyWith(isMarkingAllAsRead: false, readActionError: message),
    );
  }

  String _extractDioMessage(DioException error) {
    final data = error.response?.data;

    if (data is Map) {
      final message = data['message'];

      if (message is String && message.trim().isNotEmpty) {
        return message;
      }

      if (message is List) {
        final messages = message
            .whereType<String>()
            .map((value) => value.trim())
            .where((value) => value.isNotEmpty)
            .toSet()
            .toList();

        if (messages.isNotEmpty) {
          return messages.join('\n');
        }
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاتصال بالخادم';
      case DioExceptionType.connectionError:
        return 'تعذر الاتصال بالخادم';
      default:
        return 'تعذر تحميل الإشعارات';
    }
  }
}
