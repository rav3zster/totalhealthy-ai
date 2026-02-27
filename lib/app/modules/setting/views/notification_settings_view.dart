import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_helper.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/reminder_storage_service.dart';
import '../../../widgets/reminder_dialogs.dart';

class NotificationSettingsView extends StatefulWidget {
  const NotificationSettingsView({super.key});

  @override
  State<NotificationSettingsView> createState() =>
      _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<NotificationSettingsView> {
  bool mealReminderEnabled = false;
  bool waterReminderEnabled = false;
  bool exerciseReminderEnabled = false;
  bool updateNotificationEnabled = true;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  /// Load saved reminder settings
  Future<void> _loadSettings() async {
    setState(() => isLoading = true);

    try {
      // Load from Firestore first (for cross-device sync)
      await ReminderStorageService.loadFromFirestore();

      // Load water reminder
      final waterData = await ReminderStorageService.loadWaterReminder();
      if (waterData != null) {
        waterReminderEnabled = waterData['enabled'] as bool? ?? false;
      }

      // Load meal reminder
      final mealData = await ReminderStorageService.loadMealReminder();
      if (mealData != null) {
        mealReminderEnabled = mealData['enabled'] as bool? ?? false;
      }

      // Load exercise reminder
      final exerciseData = await ReminderStorageService.loadExerciseReminder();
      if (exerciseData != null) {
        exerciseReminderEnabled = exerciseData['enabled'] as bool? ?? false;
      }

      // Load update notification
      final updateData = await ReminderStorageService.loadUpdateNotification();
      if (updateData != null) {
        updateNotificationEnabled = updateData['enabled'] as bool? ?? true;
      }

      print('✅ Loaded reminder settings');
    } catch (e) {
      print('❌ Error loading settings: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: context.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  gradient: context.headerGradient,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  boxShadow: context.cardShadow,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              context.accent.withValues(alpha: 0.2),
                              context.accent.withValues(alpha: 0.1),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: context.textPrimary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'notifications'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: context.textPrimary,
                            fontFamily: 'inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),

              // Content
              Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(color: context.accent),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Meal reminder
                            _buildNotificationToggle(
                              'meal_reminder'.tr,
                              mealReminderEnabled,
                              (value) async {
                                if (value) {
                                  // Show confirmation to enable
                                  await _showMealReminderEnableConfirmation();
                                } else {
                                  // Show confirmation to disable
                                  await _showMealReminderDisableConfirmation();
                                }
                              },
                            ),

                            const SizedBox(height: 20),

                            // Water reminder
                            _buildNotificationToggle(
                              'water_reminder'.tr,
                              waterReminderEnabled,
                              (value) async {
                                if (value) {
                                  // Show dialog to configure
                                  await WaterReminderDialog.show(context);
                                  // Reload to get updated status
                                  await _loadSettings();
                                } else {
                                  // Disable and cancel notifications
                                  await _disableWaterReminder();
                                }
                              },
                            ),

                            const SizedBox(height: 20),

                            // Exercise reminder
                            _buildNotificationToggle(
                              'exercise_reminder'.tr,
                              exerciseReminderEnabled,
                              (value) async {
                                if (value) {
                                  // Show dialog to configure
                                  await ExerciseReminderDialog.show(context);
                                  // Reload to get updated status
                                  await _loadSettings();
                                } else {
                                  // Disable and cancel notifications
                                  await _disableExerciseReminder();
                                }
                              },
                            ),

                            const SizedBox(height: 20),

                            // Update Notification
                            _buildNotificationToggle(
                              'update_notification'.tr,
                              updateNotificationEnabled,
                              (value) async {
                                setState(
                                  () => updateNotificationEnabled = value,
                                );
                                await ReminderStorageService.saveUpdateNotification(
                                  value,
                                );

                                Get.snackbar(
                                  'success'.tr,
                                  value
                                      ? 'update_notification_enabled'.tr
                                      : 'update_notification_disabled'.tr,
                                  backgroundColor: context.accent,
                                  colorText: Colors.black,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationToggle(
    String title,
    bool currentValue,
    Future<void> Function(bool) onChanged,
  ) {
    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: context.cardGradient,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: context.accent.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: context.cardShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: context.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Switch(
              value: currentValue,
              onChanged: (value) => onChanged(value),
              activeColor: context.accent,
              activeTrackColor: context.accent.withValues(alpha: 0.5),
              inactiveThumbColor: context.textSecondary,
              inactiveTrackColor: context.textSecondary.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }

  /// Disable water reminder
  Future<void> _disableWaterReminder() async {
    await ReminderStorageService.saveWaterReminder(false, null);
    await NotificationService.cancelWaterReminders();
    setState(() => waterReminderEnabled = false);

    print('Reminder cancelled: Water');

    Get.snackbar(
      'success'.tr,
      'water_reminder_disabled'.tr,
      backgroundColor: context.accent,
      colorText: Colors.black,
    );
  }

  /// Show confirmation dialog to enable meal reminders
  Future<void> _showMealReminderEnableConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: context.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'enable_meal_reminders'.tr,
          style: TextStyle(
            color: context.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'meal_reminder_enable_message'.tr,
          style: TextStyle(color: context.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              'cancel'.tr,
              style: TextStyle(color: context.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.accent,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('enable'.tr),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _enableMealReminder();
    }
  }

  /// Show confirmation dialog to disable meal reminders
  Future<void> _showMealReminderDisableConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: context.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'disable_meal_reminders'.tr,
          style: TextStyle(
            color: context.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'meal_reminder_disable_message'.tr,
          style: TextStyle(color: context.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              'cancel'.tr,
              style: TextStyle(color: context.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('disable'.tr),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _disableMealReminder();
    }
  }

  /// Enable meal reminders (sync with meal categories)
  Future<void> _enableMealReminder() async {
    try {
      // Enable meal reminder
      await ReminderStorageService.saveMealReminder(true, []);
      setState(() => mealReminderEnabled = true);

      print('✅ Meal reminders enabled - User can configure in Meal Categories');

      Get.snackbar(
        'success'.tr,
        'meal_reminder_enabled_message'.tr,
        backgroundColor: context.accent,
        colorText: Colors.black,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      print('❌ Error enabling meal reminders: $e');
      Get.snackbar(
        'error'.tr,
        'failed_to_enable_meal_reminder'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Disable meal reminders (sync with meal categories)
  Future<void> _disableMealReminder() async {
    try {
      // Disable meal reminder
      await ReminderStorageService.saveMealReminder(false, null);

      // Cancel all meal notifications
      await NotificationService.cancelMealReminders();

      setState(() => mealReminderEnabled = false);

      print('🗑️ All meal reminders disabled and cancelled');

      Get.snackbar(
        'success'.tr,
        'meal_reminder_disabled'.tr,
        backgroundColor: context.accent,
        colorText: Colors.black,
      );
    } catch (e) {
      print('❌ Error disabling meal reminders: $e');
      Get.snackbar(
        'error'.tr,
        'failed_to_disable_meal_reminder'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Disable exercise reminder
  Future<void> _disableExerciseReminder() async {
    await ReminderStorageService.saveExerciseReminder(false, null);
    await NotificationService.cancelExerciseReminders();
    setState(() => exerciseReminderEnabled = false);

    print('Reminder cancelled: Exercise');

    Get.snackbar(
      'success'.tr,
      'exercise_reminder_disabled'.tr,
      backgroundColor: context.accent,
      colorText: Colors.black,
    );
  }
}
