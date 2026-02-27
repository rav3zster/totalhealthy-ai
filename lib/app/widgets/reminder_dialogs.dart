import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/theme/theme_helper.dart';
import '../core/models/reminder_model.dart';
import '../core/services/notification_service.dart';
import '../core/services/reminder_storage_service.dart';

/// Water Reminder Setup Dialog
class WaterReminderDialog {
  static Future<void> show(BuildContext context) async {
    TimeOfDay startTime = const TimeOfDay(hour: 8, minute: 0);
    TimeOfDay endTime = const TimeOfDay(hour: 22, minute: 0);
    int intervalMinutes = 60;

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: context.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'water_reminder'.tr,
            style: TextStyle(
              color: context.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Start Time
                Text(
                  'start_time'.tr,
                  style: TextStyle(
                    color: context.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: startTime,
                      builder: (context, child) => Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: context.accent,
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) {
                      setState(() => startTime = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: context.cardGradient,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: context.accent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          startTime.format(context),
                          style: TextStyle(
                            color: context.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                        Icon(Icons.access_time, color: context.accent),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // End Time
                Text(
                  'end_time'.tr,
                  style: TextStyle(
                    color: context.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: endTime,
                      builder: (context, child) => Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: context.accent,
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) {
                      setState(() => endTime = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: context.cardGradient,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: context.accent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          endTime.format(context),
                          style: TextStyle(
                            color: context.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                        Icon(Icons.access_time, color: context.accent),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Interval
                Text(
                  'interval'.tr,
                  style: TextStyle(
                    color: context.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    gradient: context.cardGradient,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: context.accent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: intervalMinutes,
                      isExpanded: true,
                      dropdownColor: context.cardColor,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: context.textPrimary,
                      ),
                      style: TextStyle(
                        color: context.textPrimary,
                        fontSize: 16,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 30,
                          child: Text('every_30_min'.tr),
                        ),
                        DropdownMenuItem(
                          value: 60,
                          child: Text('every_1_hour'.tr),
                        ),
                        DropdownMenuItem(
                          value: 120,
                          child: Text('every_2_hours'.tr),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => intervalMinutes = value);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'cancel'.tr,
                style: TextStyle(color: context.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Save settings
                final settings = WaterReminderSettings(
                  startTime: startTime,
                  endTime: endTime,
                  intervalMinutes: intervalMinutes,
                );

                await ReminderStorageService.saveWaterReminder(true, settings);

                // Schedule notifications
                await NotificationService.scheduleWaterReminders(
                  startTime: startTime,
                  endTime: endTime,
                  intervalMinutes: intervalMinutes,
                );

                print(
                  'Reminder scheduled: ${startTime.format(context)} to ${endTime.format(context)}, every $intervalMinutes min',
                );

                Navigator.pop(context);

                Get.snackbar(
                  'success'.tr,
                  'water_reminder_set'.tr,
                  backgroundColor: context.accent,
                  colorText: Colors.black,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.accent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('save'.tr),
            ),
          ],
        ),
      ),
    );
  }
}

/// Meal Reminder Setup Dialog
class MealReminderDialog {
  static Future<void> show(BuildContext context) async {
    String selectedMeal = 'Breakfast';
    TimeOfDay selectedTime = const TimeOfDay(hour: 8, minute: 0);

    final mealOptions = [
      'Breakfast',
      'Morning Snack',
      'Lunch',
      'Evening Snack',
      'Dinner',
    ];

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: context.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'meal_reminder'.tr,
            style: TextStyle(
              color: context.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Meal Category
                Text(
                  'meal_category'.tr,
                  style: TextStyle(
                    color: context.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    gradient: context.cardGradient,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: context.accent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedMeal,
                      isExpanded: true,
                      dropdownColor: context.cardColor,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: context.textPrimary,
                      ),
                      style: TextStyle(
                        color: context.textPrimary,
                        fontSize: 16,
                      ),
                      items: mealOptions.map((meal) {
                        return DropdownMenuItem(
                          value: meal,
                          child: Text(
                            meal.toLowerCase().replaceAll(' ', '_').tr,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedMeal = value);
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Time
                Text(
                  'time'.tr,
                  style: TextStyle(
                    color: context.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                      builder: (context, child) => Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: context.accent,
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) {
                      setState(() => selectedTime = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: context.cardGradient,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: context.accent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedTime.format(context),
                          style: TextStyle(
                            color: context.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                        Icon(Icons.access_time, color: context.accent),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'cancel'.tr,
                style: TextStyle(color: context.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Save settings
                final settings = MealReminderSettings(
                  mealCategory: selectedMeal,
                  time: selectedTime,
                  repeatDaily: true,
                );

                await ReminderStorageService.saveMealReminder(true, [settings]);

                // Schedule notification
                await NotificationService.scheduleMealReminder(
                  mealType: selectedMeal,
                  time: selectedTime,
                );

                print(
                  'Reminder scheduled: $selectedMeal at ${selectedTime.format(context)}',
                );

                Navigator.pop(context);

                Get.snackbar(
                  'success'.tr,
                  'meal_reminder_set'.tr,
                  backgroundColor: context.accent,
                  colorText: Colors.black,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.accent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('save'.tr),
            ),
          ],
        ),
      ),
    );
  }
}

/// Exercise Reminder Setup Dialog
class ExerciseReminderDialog {
  static Future<void> show(BuildContext context) async {
    TimeOfDay selectedTime = const TimeOfDay(hour: 18, minute: 0);
    final selectedDays = <int>{1, 2, 3, 4, 5}; // Mon-Fri by default

    final weekDays = [
      {'value': 1, 'label': 'monday'.tr},
      {'value': 2, 'label': 'tuesday'.tr},
      {'value': 3, 'label': 'wednesday'.tr},
      {'value': 4, 'label': 'thursday'.tr},
      {'value': 5, 'label': 'friday'.tr},
      {'value': 6, 'label': 'saturday'.tr},
      {'value': 7, 'label': 'sunday'.tr},
    ];

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: context.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'exercise_reminder'.tr,
            style: TextStyle(
              color: context.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Days of Week
                Text(
                  'select_days'.tr,
                  style: TextStyle(
                    color: context.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: weekDays.map((day) {
                    final isSelected = selectedDays.contains(day['value']);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedDays.remove(day['value']);
                          } else {
                            selectedDays.add(day['value'] as int);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? context.accentGradient
                              : context.cardGradient,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? context.accent
                                : context.accent.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          (day['label'] as String).substring(0, 3),
                          style: TextStyle(
                            color: isSelected
                                ? Colors.black
                                : context.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Time
                Text(
                  'time'.tr,
                  style: TextStyle(
                    color: context.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                      builder: (context, child) => Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: context.accent,
                          ),
                        ),
                        child: child!,
                      ),
                    );
                    if (picked != null) {
                      setState(() => selectedTime = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: context.cardGradient,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: context.accent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedTime.format(context),
                          style: TextStyle(
                            color: context.textPrimary,
                            fontSize: 16,
                          ),
                        ),
                        Icon(Icons.access_time, color: context.accent),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'cancel'.tr,
                style: TextStyle(color: context.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedDays.isEmpty) {
                  Get.snackbar(
                    'error'.tr,
                    'select_at_least_one_day'.tr,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  return;
                }

                // Save settings
                final settings = ExerciseReminderSettings(
                  weekdays: selectedDays.toList(),
                  time: selectedTime,
                );

                await ReminderStorageService.saveExerciseReminder(
                  true,
                  settings,
                );

                // Schedule notification
                await NotificationService.scheduleExerciseReminder(
                  time: selectedTime,
                  weekdays: selectedDays.toList(),
                );

                print(
                  'Reminder scheduled: Exercise at ${selectedTime.format(context)} on days ${selectedDays.toList()}',
                );

                Navigator.pop(context);

                Get.snackbar(
                  'success'.tr,
                  'exercise_reminder_set'.tr,
                  backgroundColor: context.accent,
                  colorText: Colors.black,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.accent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('save'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
