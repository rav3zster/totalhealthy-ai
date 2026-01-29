import 'dart:core';

import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  // static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Temporarily disabled for compatibility
    print("Notification Service Initialized (disabled for compatibility)");
  }

  showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    // Temporarily disabled
    print("Show notification called: $title - $body");
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    // Temporarily disabled
    print("Schedule notification called: $title at $hour:$minute");
  }

  Future<void> cancelNotification(int id) async {
    // Temporarily disabled
    print("Cancel notification called for id: $id");
  }
}
