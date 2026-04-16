import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/models/app_settings_model.dart';
import '../../data/services/app_settings_service.dart';

class GlobalSettingsController extends GetxController {
  static GlobalSettingsController get to => Get.find();

  final AppSettingsService _settingsService = AppSettingsService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Reactive observables
  final Rx<ThemeMode> themeMode = ThemeMode.dark.obs;
  final Rx<Locale> locale = const Locale('en').obs;
  final RxString language = 'English'.obs;
  final RxString region = 'India'.obs;
  final RxString themeString = 'Dark'.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _settingsService.init();
    await loadSettings();
  }

  // Load settings from local storage and optionally from Firestore
  Future<void> loadSettings() async {
    try {
      // Try to load from Firestore first if user is logged in
      final user = _auth.currentUser;
      if (user != null) {
        final firestoreSettings = await _settingsService.loadFromFirestore(
          user.uid,
        );
        if (firestoreSettings != null) {
          language.value = firestoreSettings.language;
          region.value = firestoreSettings.region;
          themeString.value = firestoreSettings.theme;
          _applyThemeMode(firestoreSettings.theme);
          _applyLocale(firestoreSettings.language);

          // Save to local storage for offline access
          await _settingsService.saveSettings(firestoreSettings);
          return;
        }
      }

      // Load from local storage if Firestore fails or user not logged in
      final settings = _settingsService.loadSettings();
      language.value = settings.language;
      region.value = settings.region;
      themeString.value = settings.theme;
      _applyThemeMode(settings.theme);
      _applyLocale(settings.language);
    } catch (e) {
      debugPrint('Error loading settings: $e');
      // Use defaults on error
      language.value = 'English';
      region.value = 'India';
      themeString.value = 'Dark';
      themeMode.value = ThemeMode.dark;
      locale.value = const Locale('en');
    }
  }

  // Apply theme mode based on string value
  void _applyThemeMode(String theme) {
    switch (theme) {
      case 'Light':
        themeMode.value = ThemeMode.light;
        break;
      case 'Dark':
        themeMode.value = ThemeMode.dark;
        break;
      case 'System':
        themeMode.value = ThemeMode.system;
        break;
      default:
        themeMode.value = ThemeMode.dark;
    }
  }

  // Apply locale based on language
  void _applyLocale(String language) {
    String code;
    switch (language) {
      case 'Hindi':
        code = 'hi';
        break;
      case 'Spanish':
        code = 'es';
        break;
      case 'French':
        code = 'fr';
        break;
      default:
        code = 'en';
    }
    locale.value = Locale(code);
    Get.updateLocale(Locale(code));
  }

  // Change theme
  void changeTheme(String theme) {
    themeString.value = theme;
    _applyThemeMode(theme);
    _save();

    Get.snackbar(
      'Theme Updated',
      'Theme changed to $theme',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFC2D86A).withValues(alpha: 0.9),
      colorText: Colors.black,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
    );
  }

  // Change language
  void changeLanguage(String lang) {
    language.value = lang;
    _applyLocale(lang);
    _save();

    Get.snackbar(
      'Language Updated',
      'Language changed to $lang',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFC2D86A).withValues(alpha: 0.9),
      colorText: Colors.black,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
    );
  }

  // Change region
  void changeRegion(String reg) {
    region.value = reg;
    _save();

    Get.snackbar(
      'Region Updated',
      'Region changed to $reg',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFC2D86A).withValues(alpha: 0.9),
      colorText: Colors.black,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
    );
  }

  // Save settings to local storage and Firestore
  Future<void> _save() async {
    try {
      final settings = AppSettingsModel(
        language: language.value,
        region: region.value,
        theme: themeString.value,
      );

      // Save locally
      await _settingsService.saveSettings(settings);

      // Sync to Firestore if user is logged in
      final user = _auth.currentUser;
      if (user != null) {
        await _settingsService.syncToFirestore(user.uid, settings);
      }
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  // Clear all settings
  Future<void> clearSettings() async {
    await _settingsService.clearSettings();
    language.value = 'English';
    region.value = 'India';
    themeString.value = 'Dark';
    themeMode.value = ThemeMode.dark;
    locale.value = const Locale('en');
  }
}
