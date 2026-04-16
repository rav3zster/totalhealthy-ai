import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'group_categories_firestore_service.dart';
class UserInitializationService {
  final GroupCategoriesFirestoreService _groupCategoriesService =
      GroupCategoriesFirestoreService();

  /// Initialize default group categories for a new user
  /// Call this after user signup or on first app launch
  Future<void> initializeUserDefaults() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Check if user already has group categories
      final existingCategories = await _groupCategoriesService
          .getGroupCategories(userId);

      if (existingCategories.isEmpty) {
        // Initialize default group categories
        await _groupCategoriesService.initializeDefaultGroupCategories(userId);
        debugPrint('✓ Default group categories initialized for user: $userId');
      } else {
        debugPrint('✓ User already has group categories');
      }
    } catch (e) {
      debugPrint('⚠️ Failed to initialize user defaults: $e');
      rethrow;
    }
  }

  /// Check if user needs initialization
  Future<bool> needsInitialization() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return false;

    try {
      final categories = await _groupCategoriesService.getGroupCategories(
        userId,
      );
      return categories.isEmpty;
    } catch (e) {
      return false;
    }
  }
}
