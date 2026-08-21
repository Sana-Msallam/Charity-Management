class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.targetType,
    required this.targetId,
    required this.isRead,
    required this.createdAt,
  });

  final int id;
  final String title;
  final String message;
  final String targetType;
  final int? targetId;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel copyWith({
    int? id,
    String? title,
    String? message,
    String? targetType,
    int? targetId,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      targetType: targetType ?? this.targetType,
      targetId: targetId ?? this.targetId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: _parseInt(json['id']) ?? 0,
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      targetType: json['targetType']?.toString() ?? '',
      targetId: _parseInt(json['targetId']),
      isRead: json['isRead'] == true,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
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
