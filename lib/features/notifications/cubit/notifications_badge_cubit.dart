import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../service/notifications_service.dart';
import 'notifications_badge_state.dart';

class NotificationsBadgeCubit extends Cubit<NotificationsBadgeState> {
  NotificationsBadgeCubit({NotificationsService? service})
    : _service = service ?? NotificationsService(),
      super(const NotificationsBadgeInitial());

  final NotificationsService _service;

  bool _isLoading = false;

  Future<void> loadUnreadCount() async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;

    try {
      final unreadCount = await _service.fetchUnreadCount();

      if (unreadCount <= 0) {
        emit(const NotificationsBadgeHidden());
        return;
      }

      emit(NotificationsBadgeLoaded(unreadCount));
    } on DioException catch (error, stackTrace) {
      debugPrint('NotificationsBadgeCubit DioException: ${error.message}');
      debugPrint('Response: ${error.response?.data}');
      debugPrint('Stack trace: $stackTrace');

      emit(const NotificationsBadgeHidden());
    } catch (error, stackTrace) {
      debugPrint('NotificationsBadgeCubit unexpected error: $error');
      debugPrint('Stack trace: $stackTrace');

      emit(const NotificationsBadgeHidden());
    } finally {
      _isLoading = false;
    }
  }
}
