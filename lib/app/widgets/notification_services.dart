import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    tz.setLocalLocation(tz.getLocation("Asia/Kolkata"));
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(settings);

    print("Notification Service Initialized");
  }

  NotificationDetails notificationDetails() {
    return NotificationDetails(
        android: AndroidNotificationDetails(
      'category_channel',
      'Category Notifications',
      importance: Importance.max,
      priority: Priority.high,
    ));
  }

  showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    return _notificationsPlugin.show(id, title, body, notificationDetails());
  }

  //Use for show notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    try {
      var now = tz.TZDateTime.now(tz.local);

      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(Duration(days: 1));
      }
      print("Scheduled Date: $scheduledDate");

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      print("Notification Service Started");
    } catch (e) {
      print(e);
    }
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancelAll();
  }
}
