// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//   FlutterLocalNotificationsPlugin();

//   static Future<void> init() async {
//     final AndroidInitializationSettings androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');

//     final DarwinInitializationSettings iosSettings =
//     DarwinInitializationSettings();

//     final InitializationSettings settings =
//     InitializationSettings(android: androidSettings, iOS: iosSettings);

//     await _notificationsPlugin.initialize(settings);
//   }

//   static Future<void> showNotification(
//       int id, String title, String body) async {
//     const AndroidNotificationDetails androidDetails =
//     AndroidNotificationDetails(
//       'meal_reminder', // Channel ID
//       'Meal Reminder', // Channel Name
//       channelDescription: 'Reminds you to eat your meals',
//       importance: Importance.high,
//       priority: Priority.high,
//     );

//     const NotificationDetails details =
//     NotificationDetails(android: androidDetails);

//     await _notificationsPlugin.show(id, title, body, details);
//   }

//   static Future<void> scheduleNotification(
//       {int id=0, String? title, String? body,required DateTime scheduledTime}) async {
//     await _notificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.from(scheduledTime, tz.local),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'meal_reminder',
//           'Meal Reminder',
//           channelDescription: 'Reminds you to eat your meals',
//           importance: Importance.high,
//           priority: Priority.high,
//         ),
//       ),
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       uiLocalNotificationDateInterpretation:
//       UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
//   static Future<void> cancelNotification(int id) async {
//     await _notificationsPlugin.cancel(id);
//   }
// }
