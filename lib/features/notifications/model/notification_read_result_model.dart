class NotificationReadResultModel {
  const NotificationReadResultModel({required this.id, required this.isRead});

  final int id;
  final bool isRead;

  factory NotificationReadResultModel.fromJson(Map<String, dynamic> json) {
    return NotificationReadResultModel(
      id: _parseInt(json['id']) ?? 0,
      isRead: json['isRead'] == true,
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

class NotificationsReadAllResultModel {
  const NotificationsReadAllResultModel({
    required this.success,
    required this.updatedCount,
  });

  final bool success;
  final int updatedCount;

  factory NotificationsReadAllResultModel.fromJson(Map<String, dynamic> json) {
    return NotificationsReadAllResultModel(
      success: json['success'] == true,
      updatedCount: _parseInt(json['updatedCount']) ?? 0,
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
