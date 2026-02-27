# Notification Reminder System - Quick Start Guide

## 🚀 For Users

### Setting Up Water Reminders:
1. Go to Settings → Notifications
2. Toggle "Water Reminder" ON
3. Dialog opens - configure:
   - Start Time: When to start reminding (e.g., 8:00 AM)
   - End Time: When to stop reminding (e.g., 10:00 PM)
   - Interval: How often (30 min / 1 hour / 2 hours)
4. Tap "Save"
5. You'll receive notifications throughout the day!

### Setting Up Meal Reminders:
1. Go to Settings → Notifications
2. Toggle "Meal Reminder" ON
3. Dialog opens - configure:
   - Meal Category: Breakfast, Lunch, Dinner, etc.
   - Time: When to be reminded
4. Tap "Save"
5. You'll receive a daily reminder at that time!

### Setting Up Exercise Reminders:
1. Go to Settings → Notifications
2. Toggle "Exercise Reminder" ON
3. Dialog opens - configure:
   - Days: Select which days (Mon-Sun)
   - Time: When to be reminded
4. Tap "Save"
5. You'll receive reminders on selected days!

### Disabling Reminders:
- Simply toggle the reminder OFF
- All scheduled notifications will be cancelled automatically

---

## 💻 For Developers

### Architecture Overview:
```
UI Layer → Dialog Layer → Service Layer → Storage Layer
```

### Key Components:

#### 1. NotificationService
```dart
// Schedule water reminders
await NotificationService.scheduleWaterReminders(
  startTime: TimeOfDay(hour: 8, minute: 0),
  endTime: TimeOfDay(hour: 22, minute: 0),
  intervalMinutes: 60,
);

// Schedule meal reminder
await NotificationService.scheduleMealReminder(
  mealType: 'Breakfast',
  time: TimeOfDay(hour: 8, minute: 0),
);

// Schedule exercise reminder
await NotificationService.scheduleExerciseReminder(
  time: TimeOfDay(hour: 18, minute: 0),
  weekdays: [1, 3, 5], // Mon, Wed, Fri
);

// Cancel reminders
await NotificationService.cancelWaterReminders();
await NotificationService.cancelMealReminders();
await NotificationService.cancelExerciseReminders();
```

#### 2. ReminderStorageService
```dart
// Save water reminder
await ReminderStorageService.saveWaterReminder(
  true, // enabled
  WaterReminderSettings(
    startTime: TimeOfDay(hour: 8, minute: 0),
    endTime: TimeOfDay(hour: 22, minute: 0),
    intervalMinutes: 60,
  ),
);

// Load water reminder
final data = await ReminderStorageService.loadWaterReminder();
if (data != null) {
  final enabled = data['enabled'] as bool;
  final settings = data['settings'];
}

// Sync from Firestore
await ReminderStorageService.loadFromFirestore();
```

#### 3. Reminder Dialogs
```dart
// Show water reminder dialog
await WaterReminderDialog.show(context);

// Show meal reminder dialog
await MealReminderDialog.show(context);

// Show exercise reminder dialog
await ExerciseReminderDialog.show(context);
```

### Adding New Reminder Types:

1. **Create Model** in `reminder_model.dart`:
```dart
class CustomReminderSettings {
  final String customField;
  final TimeOfDay time;
  
  CustomReminderSettings({required this.customField, required this.time});
  
  Map<String, dynamic> toJson() => {
    'customField': customField,
    'time': '${time.hour}:${time.minute}',
  };
  
  factory CustomReminderSettings.fromJson(Map<String, dynamic> json) {
    final timeParts = (json['time'] as String).split(':');
    return CustomReminderSettings(
      customField: json['customField'] as String,
      time: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
    );
  }
}
```

2. **Add Storage Methods** in `reminder_storage_service.dart`:
```dart
static Future<void> saveCustomReminder(
  bool enabled,
  CustomReminderSettings? settings,
) async {
  final data = {
    'enabled': enabled,
    'settings': settings?.toJson(),
  };
  await _storage.write('custom_reminder', jsonEncode(data));
  await _syncToFirestore('custom', data);
}
```

3. **Add Scheduling Method** in `notification_service.dart`:
```dart
static Future<void> scheduleCustomReminder({
  required String customField,
  required TimeOfDay time,
}) async {
  await scheduleNotification(
    id: customReminderId,
    title: 'Custom Reminder',
    body: customField,
    time: time,
    payload: 'custom_reminder',
  );
}
```

4. **Create Dialog** in `reminder_dialogs.dart`:
```dart
class CustomReminderDialog {
  static Future<void> show(BuildContext context) async {
    // Dialog implementation
  }
}
```

5. **Add Toggle** in `notification_settings_view.dart`:
```dart
_buildNotificationToggle(
  'custom_reminder'.tr,
  customReminderEnabled,
  (value) async {
    if (value) {
      await CustomReminderDialog.show(context);
      await _loadSettings();
    } else {
      await _disableCustomReminder();
    }
  },
),
```

### Testing Notifications:

#### Test Immediate Notification:
```dart
await NotificationService.showImmediateNotification(
  title: 'Test Notification',
  body: 'This is a test',
);
```

#### Check Pending Notifications:
```dart
final pending = await NotificationService.getPendingNotifications();
print('Pending: ${pending.length}');
for (final notification in pending) {
  print('ID: ${notification.id}, Title: ${notification.title}');
}
```

### Debugging:

All operations include debug logs:
```
📱 Initializing NotificationService...
✅ NotificationService initialized successfully
📅 Scheduling notification: Drink Water 💧 at 08:00
✅ Notification scheduled: ID=2000, Time=08:00
💾 Saving water reminder: enabled=true
☁️ Synced water reminder to Firestore
```

Look for these emojis in logs:
- 📱 Initialization
- 📅 Scheduling
- ✅ Success
- 💾 Storage
- ☁️ Firestore sync
- 🗑️ Cancellation
- ❌ Error
- ⚠️ Warning

### Common Issues:

#### Notifications Not Appearing:
1. Check permissions are granted
2. Verify `AndroidScheduleMode.exactAllowWhileIdle` is used
3. Check pending notifications with `getPendingNotifications()`
4. Look for error logs

#### Settings Not Persisting:
1. Verify GetStorage is initialized in main.dart
2. Check Firestore rules allow read/write
3. Look for storage error logs

#### Theme Issues:
1. Always use `context.cardColor`, `context.textPrimary`, `context.accent`
2. Never hardcode colors
3. Wrap with `Builder` if context not available

---

## 🎯 Best Practices

### 1. Always Save Before Scheduling:
```dart
// ✅ Good
await ReminderStorageService.saveWaterReminder(true, settings);
await NotificationService.scheduleWaterReminders(...);

// ❌ Bad
await NotificationService.scheduleWaterReminders(...);
// Settings not saved - will be lost on app restart
```

### 2. Always Cancel Before Disabling:
```dart
// ✅ Good
await NotificationService.cancelWaterReminders();
await ReminderStorageService.saveWaterReminder(false, null);

// ❌ Bad
await ReminderStorageService.saveWaterReminder(false, null);
// Notifications still scheduled - will keep firing
```

### 3. Always Reload After Dialog:
```dart
// ✅ Good
await WaterReminderDialog.show(context);
await _loadSettings(); // Reload to get updated state

// ❌ Bad
await WaterReminderDialog.show(context);
// UI shows old state
```

### 4. Always Use Theme Extensions:
```dart
// ✅ Good
backgroundColor: context.cardColor,
textColor: context.textPrimary,

// ❌ Bad
backgroundColor: Colors.white,
textColor: Colors.black,
```

---

## 📱 Notification IDs

Reserved ID ranges:
- 1000-1999: Meal reminders
- 2000-2999: Water reminders (2000-2049 used)
- 3000-3999: Exercise reminders
- 4000-4999: Update notifications

When adding new reminder types, use IDs outside these ranges.

---

## 🔐 Permissions

### Android:
- `POST_NOTIFICATIONS` - Automatically requested
- `SCHEDULE_EXACT_ALARM` - Automatically requested
- `USE_EXACT_ALARM` - Automatically granted

### iOS:
- Notification permissions - Automatically requested on first use

No manual permission handling needed - all handled by NotificationService.init()

---

## 🌍 Translations

All reminder-related strings are translated in 4 languages:
- English (en)
- Hindi (hi)
- Spanish (es)
- French (fr)

To add new strings:
1. Add key to all 4 language sections in `app_translations.dart`
2. Use `.tr` extension: `'your_key'.tr`

---

## 📊 Firestore Structure

```
users/{userId}/settings/reminders
  ├── water: {
  │     enabled: true,
  │     settings: {
  │       startTime: "8:0",
  │       endTime: "22:0",
  │       intervalMinutes: 60
  │     }
  │   }
  ├── meal: {
  │     enabled: true,
  │     settings: [{
  │       mealCategory: "Breakfast",
  │       time: "8:0",
  │       repeatDaily: true
  │     }]
  │   }
  ├── exercise: {
  │     enabled: true,
  │     settings: {
  │       weekdays: [1, 3, 5],
  │       time: "18:0"
  │     }
  │   }
  └── update: {
        enabled: true
      }
```

---

## 🎉 That's It!

The notification reminder system is production-ready and fully functional. Happy coding! 🚀

