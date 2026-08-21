import 'package:charity_management/features/notifications/model/notification_model.dart';
import 'package:charity_management/features/notifications/model/notifications_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses notification with nullable targetId', () {
    final model = NotificationModel.fromJson(const {
      'id': 1,
      'title': 'Title',
      'message': 'Message',
      'targetType': 'aid_request',
      'targetId': null,
      'isRead': false,
      'createdAt': '2026-08-18T07:00:00.000Z',
    });

    expect(model.id, 1);
    expect(model.targetId, isNull);
    expect(model.title, 'Title');
    expect(model.isRead, isFalse);
  });

  test('parses targetId from string', () {
    final model = NotificationModel.fromJson(const {
      'id': '2',
      'title': 'Title',
      'message': 'Message',
      'targetType': 'report',
      'targetId': '15',
      'isRead': true,
      'createdAt': '2026-08-18T07:00:00.000Z',
    });

    expect(model.id, 2);
    expect(model.targetId, 15);
    expect(model.isRead, isTrue);
  });

  test('parses notifications response meta and unread count', () {
    final response = NotificationsResponseModel.fromJson(const {
      'data': [
        {
          'id': 1,
          'title': 'Title',
          'message': 'Message',
          'targetType': 'aid_request',
          'targetId': null,
          'isRead': false,
          'createdAt': '2026-08-18T07:00:00.000Z',
        },
      ],
      'meta': {
        'totalCount': 21,
        'page': 1,
        'limit': 20,
        'totalPages': 2,
        'hasNextPage': true,
        'hasPreviousPage': false,
      },
      'unreadCount': 7,
    });

    expect(response.data, hasLength(1));
    expect(response.meta.totalCount, 21);
    expect(response.meta.page, 1);
    expect(response.meta.hasNextPage, isTrue);
    expect(response.meta.hasPreviousPage, isFalse);
    expect(response.unreadCount, 7);
  });
}
