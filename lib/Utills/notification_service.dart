import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nammadaiva_dashboard/Utills/provider.dart';
import 'package:nammadaiva_dashboard/Utills/string_routes.dart';

class FcmNotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // 🍏 REQUIRED for iOS foreground notifications
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 🔔 Android notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Important notifications',
      importance: Importance.max,
    );

    final androidPlugin =
        _localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(channel);

    // 🔔 Init local notifications
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        handleNotificationTap(
          RemoteMessage(data: {'event_name': response.payload ?? ''}),
        );
      },
    );

    // 🔔 FOREGROUND notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification == null) return;

      // 🍏 iOS → system already shows notification
      if (Platform.isIOS) return;

      // 🤖 Android → show local notification
      showNotification(
        title: notification.title ?? 'Notification',
        body: notification.body ?? '',
      );
    });

    // 🔔 Notification tap (background)
    FirebaseMessaging.onMessageOpenedApp.listen(handleNotificationTap);
  }

  /// 🔐 Request notification permission (call once)
  static Future<void> requestPermission() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
    );
  }

  static void handleNotificationTap(RemoteMessage message) {
    final screen = message.data['event_name'];

    if (screen == null) return;

    switch (screen) {
      case 'event':
        navigatorKey.currentState?.pushNamed(StringsRoute.bookings);
        break;
      case 'profile':
        navigatorKey.currentState?.pushNamed('/profile');
        break;
      default:
        navigatorKey.currentState?.pushNamed(StringsRoute.bookings);
    }
  }
}
