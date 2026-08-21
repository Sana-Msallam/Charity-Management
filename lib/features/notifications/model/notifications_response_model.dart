import 'notification_model.dart';

class NotificationsResponseModel {
  const NotificationsResponseModel({
    required this.data,
    required this.meta,
    required this.unreadCount,
  });

  final List<NotificationModel> data;
  final NotificationsMetaModel meta;
  final int unreadCount;

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final rawMeta = json['meta'];

    return NotificationsResponseModel(
      data: rawData is List
          ? rawData
                .whereType<Map>()
                .map(
                  (item) => NotificationModel.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : const [],
      meta: rawMeta is Map
          ? NotificationsMetaModel.fromJson(Map<String, dynamic>.from(rawMeta))
          : const NotificationsMetaModel.empty(),
      unreadCount: _parseInt(json['unreadCount']) ?? 0,
    );
  }

  static int? _parseInt(dynamic value) {
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

class NotificationsMetaModel {
  const NotificationsMetaModel({
    required this.totalCount,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });

  const NotificationsMetaModel.empty()
    : totalCount = 0,
      page = 1,
      limit = 20,
      totalPages = 0,
      hasNextPage = false,
      hasPreviousPage = false;

  final int totalCount;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  factory NotificationsMetaModel.fromJson(Map<String, dynamic> json) {
    return NotificationsMetaModel(
      totalCount: _parseInt(json['totalCount']) ?? 0,
      page: _parseInt(json['page']) ?? 1,
      limit: _parseInt(json['limit']) ?? 20,
      totalPages: _parseInt(json['totalPages']) ?? 0,
      hasNextPage: json['hasNextPage'] == true,
      hasPreviousPage: json['hasPreviousPage'] == true,
    );
  }

  static int? _parseInt(dynamic value) {
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
