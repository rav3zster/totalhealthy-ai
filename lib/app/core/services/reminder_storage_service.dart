import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/reminder_model.dart';
/// Service for persisting reminder settings locally and to Firestore
class ReminderStorageService {
  static final GetStorage _storage = GetStorage();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Storage keys
  static const String _waterReminderKey = 'water_reminder';
  static const String _mealReminderKey = 'meal_reminder';
  static const String _exerciseReminderKey = 'exercise_reminder';
  static const String _updateNotificationKey = 'update_notification';

  /// Save water reminder settings locally
  static Future<void> saveWaterReminder(
    bool enabled,
    WaterReminderSettings? settings,
  ) async {
    debugPrint('💾 Saving water reminder: enabled=$enabled');

    final data = {'enabled': enabled, 'settings': settings?.toJson()};

    await _storage.write(_waterReminderKey, jsonEncode(data));

    // Sync to Firestore
    await _syncToFirestore('water', data);

    debugPrint('✅ Water reminder saved');
  }

  /// Load water reminder settings
  static Future<Map<String, dynamic>?> loadWaterReminder() async {
    final jsonString = _storage.read(_waterReminderKey);
    if (jsonString == null) return null;

    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('❌ Error loading water reminder: $e');
      return null;
    }
  }

  /// Save meal reminder settings locally
  static Future<void> saveMealReminder(
    bool enabled,
    List<MealReminderSettings>? settings,
  ) async {
    debugPrint('💾 Saving meal reminder: enabled=$enabled');

    final data = {
      'enabled': enabled,
      'settings': settings?.map((s) => s.toJson()).toList(),
    };

    await _storage.write(_mealReminderKey, jsonEncode(data));

    // Sync to Firestore
    await _syncToFirestore('meal', data);

    debugPrint('✅ Meal reminder saved');
  }

  /// Load meal reminder settings
  static Future<Map<String, dynamic>?> loadMealReminder() async {
    final jsonString = _storage.read(_mealReminderKey);
    if (jsonString == null) return null;

    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('❌ Error loading meal reminder: $e');
      return null;
    }
  }

  /// Save exercise reminder settings locally
  static Future<void> saveExerciseReminder(
    bool enabled,
    ExerciseReminderSettings? settings,
  ) async {
    debugPrint('💾 Saving exercise reminder: enabled=$enabled');

    final data = {'enabled': enabled, 'settings': settings?.toJson()};

    await _storage.write(_exerciseReminderKey, jsonEncode(data));

    // Sync to Firestore
    await _syncToFirestore('exercise', data);

    debugPrint('✅ Exercise reminder saved');
  }

  /// Load exercise reminder settings
  static Future<Map<String, dynamic>?> loadExerciseReminder() async {
    final jsonString = _storage.read(_exerciseReminderKey);
    if (jsonString == null) return null;

    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('❌ Error loading exercise reminder: $e');
      return null;
    }
  }

  /// Save update notification settings locally
  static Future<void> saveUpdateNotification(bool enabled) async {
    debugPrint('💾 Saving update notification: enabled=$enabled');

    final data = {'enabled': enabled};

    await _storage.write(_updateNotificationKey, jsonEncode(data));

    // Sync to Firestore
    await _syncToFirestore('update', data);

    debugPrint('✅ Update notification saved');
  }

  /// Load update notification settings
  static Future<Map<String, dynamic>?> loadUpdateNotification() async {
    final jsonString = _storage.read(_updateNotificationKey);
    if (jsonString == null) return null;

    try {
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('❌ Error loading update notification: $e');
      return null;
    }
  }

  /// Sync reminder settings to Firestore (optional cloud backup)
  static Future<void> _syncToFirestore(
    String type,
    Map<String, dynamic> data,
  ) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        debugPrint('⚠️ No user logged in, skipping Firestore sync');
        return;
      }

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('settings')
          .doc('reminders')
          .set({type: data}, SetOptions(merge: true));

      debugPrint('☁️ Synced $type reminder to Firestore');
    } catch (e) {
      debugPrint('⚠️ Failed to sync to Firestore: $e');
      // Don't throw - local storage is primary
    }
  }

  /// Load all reminder settings from Firestore (for sync across devices)
  static Future<void> loadFromFirestore() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('settings')
          .doc('reminders')
          .get();

      if (!doc.exists) return;

      final data = doc.data();
      if (data == null) return;

      // Update local storage with Firestore data
      if (data.containsKey('water')) {
        await _storage.write(_waterReminderKey, jsonEncode(data['water']));
      }
      if (data.containsKey('meal')) {
        await _storage.write(_mealReminderKey, jsonEncode(data['meal']));
      }
      if (data.containsKey('exercise')) {
        await _storage.write(
          _exerciseReminderKey,
          jsonEncode(data['exercise']),
        );
      }
      if (data.containsKey('update')) {
        await _storage.write(
          _updateNotificationKey,
          jsonEncode(data['update']),
        );
      }

      debugPrint('☁️ Loaded reminder settings from Firestore');
    } catch (e) {
      debugPrint('⚠️ Failed to load from Firestore: $e');
    }
  }

  /// Clear all reminder settings
  static Future<void> clearAll() async {
    await _storage.remove(_waterReminderKey);
    await _storage.remove(_mealReminderKey);
    await _storage.remove(_exerciseReminderKey);
    await _storage.remove(_updateNotificationKey);
    debugPrint('🗑️ All reminder settings cleared');
  }
}
