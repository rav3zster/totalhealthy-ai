import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/meal_category_model.dart';
import '../../../data/services/meal_categories_firestore_service.dart';

class MealCategoriesManagementController extends GetxController {
  final MealCategoriesFirestoreService _categoriesService =
      MealCategoriesFirestoreService();

  final mealCategories = <MealCategoryModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  String? userId;
  String? groupCategoryId;
  String? groupCategoryName;

  @override
  void onInit() {
    super.onInit();

    // Get arguments from navigation
    final args = Get.arguments as Map<String, dynamic>?;
    groupCategoryId = args?['groupCategoryId'];
    groupCategoryName = args?['groupCategoryName'];
    userId = FirebaseAuth.instance.currentUser?.uid;

    if (groupCategoryId != null && userId != null) {
      _loadMealCategories();
    } else {
      error.value = 'Missing required parameters';
    }
  }

  void _loadMealCategories() {
    if (userId == null || groupCategoryId == null) return;

    isLoading.value = true;

    _categoriesService
        .getMealCategoriesStream(userId!, groupCategoryId!)
        .listen(
          (categories) {
            mealCategories.value = categories;
            isLoading.value = false;
            error.value = '';
          },
          onError: (e) {
            error.value = 'Failed to load categories: $e';
            isLoading.value = false;
          },
        );
  }

  Future<void> createMealCategory(String name, TimeOfDay? time) async {
    if (userId == null || groupCategoryId == null) {
      Get.snackbar('Error', 'Missing required parameters');
      return;
    }

    try {
      isLoading.value = true;

      final timeStr = time != null
          ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
          : null;

      await _categoriesService.createMealCategory(
        userId!,
        groupCategoryId!,
        name,
        timeStr,
      );

      Get.back();
      Get.snackbar(
        'Success',
        'Meal category "$name" created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateMealCategoryTime(
    MealCategoryModel category,
    TimeOfDay? time,
  ) async {
    if (userId == null || groupCategoryId == null) return;

    try {
      final timeStr = time != null
          ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
          : null;

      await _categoriesService.updateMealCategory(
        userId!,
        groupCategoryId!,
        category.id!,
        {'time': timeStr},
      );

      Get.snackbar(
        'Success',
        'Time updated for ${category.name}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update time: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> toggleAlarm(MealCategoryModel category, bool enabled) async {
    if (userId == null || groupCategoryId == null) return;

    try {
      await _categoriesService.updateMealCategory(
        userId!,
        groupCategoryId!,
        category.id!,
        {'isAlarmEnabled': enabled},
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update alarm: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteMealCategory(MealCategoryModel category) async {
    if (userId == null || groupCategoryId == null) return;

    if (category.isDefault) {
      Get.snackbar(
        'Error',
        'Cannot delete default categories',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      await _categoriesService.deleteMealCategory(
        userId!,
        groupCategoryId!,
        category.id!,
      );

      Get.snackbar(
        'Success',
        'Category deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete category: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  TimeOfDay? parseTimeString(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return null;

    try {
      final parts = timeStr.split(':');
      if (parts.length == 2) {
        return TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    } catch (e) {
      // Silently handle parsing errors
    }

    return null;
  }
}
