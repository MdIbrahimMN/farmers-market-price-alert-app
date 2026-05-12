import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // 🔥 INIT (NO PERMISSION CODE)
  static Future init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _notifications.initialize(settings);
  }

  // 🔔 SHOW NOTIFICATION
  static Future showNotification(
      String title, String body, int id) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'price_channel',
      'Price Alerts',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _notifications.show(id, title, body, details);
  }

  // 🧹 CLEAR ALL
  static Future clearAll() async {
    await _notifications.cancelAll();
  }
}