import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';
import 'package:dio/dio.dart';

import '../model/notifications_response_model.dart';
import '../model/notification_read_result_model.dart';

class NotificationsService {
  NotificationsService({Dio? dio}) : _dio = dio ?? DioClient.dio;

  final Dio _dio;

  Future<NotificationsResponseModel> fetchNotifications({
    required int page,
    required int limit,
  }) async {
    final response = await _dio.get<dynamic>(
      ApiConstants.notifications,
      queryParameters: {'page': page, 'limit': limit},
    );

    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid notifications response');
    }

    return NotificationsResponseModel.fromJson(data);
  }

  Future<int> fetchUnreadCount() async {
    final response = await _dio.get<dynamic>(
      ApiConstants.unreadNotificationsCount,
    );

    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid unread notifications response');
    }

    return _parseInt(data['unreadCount']) ?? 0;
  }

  Future<NotificationsReadAllResultModel> markAllAsRead() async {
    final response = await _dio.patch<dynamic>(
      ApiConstants.readAllNotifications,
    );

    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid read all notifications response');
    }

    return NotificationsReadAllResultModel.fromJson(data);
  }

  Future<NotificationReadResultModel> markNotificationAsRead(int id) async {
    final response = await _dio.patch<dynamic>(
      ApiConstants.readNotification(id),
    );

    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid read notification response');
    }

    return NotificationReadResultModel.fromJson(data);
  }

  int? _parseInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value.toString());
  }
}
