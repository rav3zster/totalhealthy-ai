import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_settings_model.dart';

class AppSettingsService {
  static const String _settingsKey = 'app_settings';
  SharedPreferences? _prefs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Save settings locally
  Future<void> saveSettings(AppSettingsModel settings) async {
    if (_prefs == null) await init();
    await _prefs!.setString(_settingsKey, jsonEncode(settings.toJson()));
  }

  // Load settings from local storage
  AppSettingsModel loadSettings() {
    if (_prefs == null) {
      return AppSettingsModel(
        language: 'English',
        region: 'India',
        theme: 'Dark',
      );
    }

    final jsonString = _prefs!.getString(_settingsKey);
    if (jsonString == null) {
      return AppSettingsModel(
        language: 'English',
        region: 'India',
        theme: 'Dark',
      );
    }

    try {
      return AppSettingsModel.fromJson(jsonDecode(jsonString));
    } catch (e) {
      print('Error loading settings: $e');
      return AppSettingsModel(
        language: 'English',
        region: 'India',
        theme: 'Dark',
      );
    }
  }

  // Sync settings to Firestore
  Future<void> syncToFirestore(String userId, AppSettingsModel settings) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('settings')
          .doc('app_settings')
          .set(settings.toJson(), SetOptions(merge: true));
    } catch (e) {
      print('Error syncing settings to Firestore: $e');
    }
  }

  // Load settings from Firestore
  Future<AppSettingsModel?> loadFromFirestore(String userId) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('settings')
          .doc('app_settings')
          .get();

      if (doc.exists && doc.data() != null) {
        return AppSettingsModel.fromJson(doc.data()!);
      }
    } catch (e) {
      print('Error loading settings from Firestore: $e');
    }
    return null;
  }

  // Clear local settings
  Future<void> clearSettings() async {
    if (_prefs == null) await init();
    await _prefs!.remove(_settingsKey);
  }
}
