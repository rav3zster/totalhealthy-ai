// import 'local_notification.dart';

// void scheduleMealReminders() {
//   DateTime now = DateTime.now();

//   // Breakfast Reminder at 9:00 AM
//   DateTime breakfastTime = DateTime(now.year, now.month, now.day, 9, 0);
//   if (now.isBefore(breakfastTime)) {
//     NotificationService.scheduleNotification(
//         1, "Breakfast Reminder", "Did you eat your breakfast today?", breakfastTime);
//   }

//   // Lunch Reminder at 1:00 PM
//   DateTime lunchTime = DateTime(now.year, now.month, now.day, 13, 0);
//   if (now.isBefore(lunchTime)) {
//     NotificationService.scheduleNotification(
//         2, "Lunch Reminder", "Did you have lunch today?", lunchTime);
//   }

//   // Dinner Reminder at 8:00 PM
//   DateTime dinnerTime = DateTime(now.year, now.month, now.day, 20, 0);
//   if (now.isBefore(dinnerTime)) {
//     NotificationService.scheduleNotification(
//         3, "Dinner Reminder", "Did you eat your dinner today?", dinnerTime);
//   }
// }
