import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LNotificationHelper {
  LNotificationHelper._();
  static LNotificationHelper lNotificationHelper = LNotificationHelper._();

  FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initializeNotification() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('mipmap/ic_launcher');

    const DarwinInitializationSettings iOSSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );

    await notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showLocalNotification(
      {required String title, required String body}) async {
    initializeNotification();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'Id',
      'Channel Name',
      channelDescription: 'Channel Description',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await notificationsPlugin.show(
      1,
      title,
      body,
      notificationDetails,
    );
  }
}
