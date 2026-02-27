import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

/// Production-level Notification Service
/// Handles scheduling, canceling, and managing local notifications
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  // Notification IDs for different reminder types
  static const int mealReminderId = 1000;
  static const int waterReminderBaseId = 2000;
  static const int exerciseReminderId = 3000;
  static const int updateNotificationId = 4000;

  /// Initialize notification service
  static Future<void> init() async {
    try {
      print('📱 Initializing NotificationService...');

      // Initialize timezone data
      try {
        tz.initializeTimeZones();
        print('✅ Timezone initialized');
      } catch (e) {
        print('⚠️ Timezone initialization failed: $e');
        // Continue anyway - notifications will still work without timezone
      }

      // Android initialization settings
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization settings
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
          );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      print('✅ Notification plugin initialized');

      // Request permissions (non-blocking)
      try {
        await requestPermissions();
      } catch (e) {
        print('⚠️ Permission request failed: $e');
        // Continue anyway
      }

      print('✅ NotificationService initialized successfully');
    } catch (e) {
      print('❌ NotificationService initialization error: $e');
      rethrow; // Let main.dart handle it
    }
  }

  /// Request notification permissions
  static Future<bool> requestPermissions() async {
    print('📱 Requesting notification permissions...');

    // Request Android 13+ notification permission
    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      if (status.isGranted) {
        print('✅ Notification permission granted');
        return true;
      } else {
        print('❌ Notification permission denied');
        return false;
      }
    }

    // Request exact alarm permission for Android 12+
    if (await Permission.scheduleExactAlarm.isDenied) {
      final status = await Permission.scheduleExactAlarm.request();
      if (status.isGranted) {
        print('✅ Exact alarm permission granted');
      } else {
        print(
          '⚠️ Exact alarm permission denied - notifications may be delayed',
        );
      }
    }

    return true;
  }

  /// Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    print('📱 Notification tapped: ${response.payload}');
    // Handle navigation based on payload
    // Can be extended to navigate to specific screens
  }

  /// Schedule a single notification
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    String? payload,
  }) async {
    print('📅 Scheduling notification: $title at ${time.format}');

    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // If the time has already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tzScheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          channelDescription: 'Daily reminders for health and fitness',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );

    print('✅ Notification scheduled: ID=$id, Time=${time.format}');
  }

  /// Schedule multiple water reminders with interval
  static Future<void> scheduleWaterReminders({
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required int intervalMinutes,
  }) async {
    print(
      '💧 Scheduling water reminders: ${startTime.format} to ${endTime.format}, every $intervalMinutes min',
    );

    // Cancel existing water reminders
    await cancelWaterReminders();

    // Calculate number of reminders
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;
    final totalMinutes = endMinutes - startMinutes;
    final reminderCount = (totalMinutes / intervalMinutes).floor() + 1;

    print('💧 Scheduling $reminderCount water reminders');

    // Schedule each reminder
    for (int i = 0; i < reminderCount; i++) {
      final reminderMinutes = startMinutes + (i * intervalMinutes);
      final hour = reminderMinutes ~/ 60;
      final minute = reminderMinutes % 60;

      // Stop if we've passed the end time
      if (hour > endTime.hour ||
          (hour == endTime.hour && minute > endTime.minute)) {
        break;
      }

      final reminderTime = TimeOfDay(hour: hour, minute: minute);

      await scheduleNotification(
        id: waterReminderBaseId + i,
        title: 'Drink Water 💧',
        body: 'Stay hydrated! Time to drink some water.',
        time: reminderTime,
        payload: 'water_reminder',
      );
    }

    print('✅ Water reminders scheduled successfully');
  }

  /// Schedule meal reminder
  static Future<void> scheduleMealReminder({
    required String mealType,
    required TimeOfDay time,
  }) async {
    print('🍽️ Scheduling meal reminder: $mealType at ${time.format}');

    await scheduleNotification(
      id: mealReminderId + mealType.hashCode,
      title: '$mealType Time 🍳',
      body: 'Time for your $mealType!',
      time: time,
      payload: 'meal_reminder_$mealType',
    );

    print('✅ Meal reminder scheduled: $mealType');
  }

  /// Schedule exercise reminder
  static Future<void> scheduleExerciseReminder({
    required TimeOfDay time,
    List<int>? weekdays, // 1=Monday, 7=Sunday
  }) async {
    print('💪 Scheduling exercise reminder at ${time.format}');

    await scheduleNotification(
      id: exerciseReminderId,
      title: 'Workout Time 💪',
      body: 'Time to exercise! Let\'s get moving.',
      time: time,
      payload: 'exercise_reminder',
    );

    print('✅ Exercise reminder scheduled');
  }

  /// Cancel a specific notification
  static Future<void> cancel(int id) async {
    print('🗑️ Cancelling notification: ID=$id');
    await _notifications.cancel(id: id);
    print('✅ Notification cancelled: ID=$id');
  }

  /// Cancel all water reminders
  static Future<void> cancelWaterReminders() async {
    print('🗑️ Cancelling all water reminders...');
    // Cancel up to 50 water reminder slots
    for (int i = 0; i < 50; i++) {
      await _notifications.cancel(id: waterReminderBaseId + i);
    }
    print('✅ Water reminders cancelled');
  }

  /// Cancel meal reminders
  static Future<void> cancelMealReminders() async {
    print('🗑️ Cancelling meal reminders...');
    // Cancel common meal types
    final mealTypes = [
      'Breakfast',
      'Lunch',
      'Dinner',
      'Morning Snack',
      'Evening Snack',
    ];
    for (final meal in mealTypes) {
      await _notifications.cancel(id: mealReminderId + meal.hashCode);
    }
    print('✅ Meal reminders cancelled');
  }

  /// Cancel exercise reminders
  static Future<void> cancelExerciseReminders() async {
    print('🗑️ Cancelling exercise reminders...');
    await _notifications.cancel(id: exerciseReminderId);
    print('✅ Exercise reminders cancelled');
  }

  /// Cancel all notifications
  static Future<void> cancelAll() async {
    print('🗑️ Cancelling ALL notifications...');
    await _notifications.cancelAll();
    print('✅ All notifications cancelled');
  }

  /// Get pending notifications (for debugging)
  static Future<List<PendingNotificationRequest>>
  getPendingNotifications() async {
    final pending = await _notifications.pendingNotificationRequests();
    print('📋 Pending notifications: ${pending.length}');
    for (final notification in pending) {
      print('  - ID: ${notification.id}, Title: ${notification.title}');
    }
    return pending;
  }

  /// Show immediate notification (for testing)
  static Future<void> showImmediateNotification({
    required String title,
    required String body,
  }) async {
    print('📱 Showing immediate notification: $title');

    await _notifications.show(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );

    print('✅ Immediate notification shown');
  }
}
