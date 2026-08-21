import 'dart:async';

import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';
import 'package:charity_management/features/auth/storage/auth_local_storage.dart';
import 'package:charity_management/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  debugPrint('Background notification: ${message.messageId}');
}

class FirebaseNotificationService {
  FirebaseNotificationService._();

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        'high_importance_notifications',
        'High Importance Notifications',
        description: 'Used for foreground Firebase notifications.',
        importance: Importance.max,
      );

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final AuthLocalStorage _authLocalStorage = AuthLocalStorage();
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  static StreamSubscription<String>? _tokenRefreshSubscription;
  static StreamSubscription<RemoteMessage>? _foregroundSubscription;
  static bool _localNotificationsInitialized = false;

  static Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint('Notification permission: ${settings.authorizationStatus}');

    await _initializeLocalNotifications();
    await getRegistrationToken();
    _listenForTokenRefresh();
    _listenForForegroundMessages();
  }

  static Future<void> _initializeLocalNotifications() async {
    if (_localNotificationsInitialized) {
      return;
    }

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await _localNotifications.initialize(settings: initializationSettings);

    final androidNotifications = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidNotifications?.requestNotificationsPermission();
    await androidNotifications?.createNotificationChannel(_androidChannel);

    _localNotificationsInitialized = true;
  }

  static Future<String?> getRegistrationToken() async {
    try {
      final token = await _messaging.getToken();
      final trimmedToken = token?.trim();

      if (trimmedToken == null || trimmedToken.isEmpty) {
        return null;
      }

      if (kDebugMode) {
        debugPrint('FCM registration token is available.');
      }

      return trimmedToken;
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Failed to get FCM registration token: $error');
      }

      return null;
    }
  }

  static Future<void> registerCurrentTokenIfAuthenticated() async {
    final jwt = await _authLocalStorage.getToken();

    if (jwt == null) {
      return;
    }

    final registrationId = await getRegistrationToken();

    if (registrationId == null) {
      return;
    }

    await _registerToken(registrationId);
  }

  static void _listenForTokenRefresh() {
    _tokenRefreshSubscription ??= _messaging.onTokenRefresh.listen((newToken) {
      unawaited(_registerRefreshedTokenIfAuthenticated(newToken));
    });
  }

  static void _listenForForegroundMessages() {
    _foregroundSubscription ??= FirebaseMessaging.onMessage.listen((message) {
      debugPrint('Foreground notification: ${message.notification?.title}');

      debugPrint('Notification data: ${message.data}');

      unawaited(_showForegroundNotification(message));
    });
  }

  static Future<void> _showForegroundNotification(RemoteMessage message) async {
    final title = _firstNonEmpty([
      message.notification?.title,
      message.data['title']?.toString(),
    ]);
    final body = _firstNonEmpty([
      message.notification?.body,
      message.data['body']?.toString(),
    ]);

    if (title == null && body == null) {
      return;
    }

    final notificationId =
        (message.messageId ?? DateTime.now().microsecondsSinceEpoch.toString())
            .hashCode &
        0x7fffffff;

    await _localNotifications.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
      payload: message.data.isEmpty ? null : message.data.toString(),
    );
  }

  static String? _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      final trimmedValue = value?.trim();

      if (trimmedValue != null && trimmedValue.isNotEmpty) {
        return trimmedValue;
      }
    }

    return null;
  }

  static Future<void> _registerRefreshedTokenIfAuthenticated(
    String newToken,
  ) async {
    try {
      final jwt = await _authLocalStorage.getToken();
      final registrationId = newToken.trim();

      if (jwt == null || registrationId.isEmpty) {
        return;
      }

      await _registerToken(registrationId);
    } catch (error) {
      if (kDebugMode) {
        debugPrint('Failed to register refreshed FCM token: $error');
      }
    }
  }

  static Future<void> _registerToken(String registrationId) async {
    await DioClient.dio.put<dynamic>(
      ApiConstants.notificationRegistration,
      data: {'registrationId': registrationId},
    );
  }
}
