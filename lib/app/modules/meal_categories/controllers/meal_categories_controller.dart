import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/meal_category_model.dart';
import '../../../data/models/group_model.dart';
import '../../../data/services/meal_categories_firestore_service.dart';
class MealCategoriesController extends GetxController {
  final _categoriesService = MealCategoriesFirestoreService();

  final categories = <MealCategoryModel>[].obs;
  final isLoading = false.obs;
  final selectedGroupId = Rxn<String>();
  final selectedGroup = Rxn<GroupModel>();
  final isAdmin = false.obs;

  StreamSubscription? _categoriesSubscription;

  @override
  void onClose() {
    _categoriesSubscription?.cancel();
    super.onClose();
  }

  void initForGroup(GroupModel group) {
    selectedGroup.value = group;
    selectedGroupId.value = group.id;

    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    isAdmin.value = group.createdBy == currentUserId;

    _loadCategories();
  }

  void _loadCategories() {
    if (selectedGroupId.value == null) return;

    isLoading.value = true;

    _categoriesSubscription?.cancel();
    _categoriesSubscription = _categoriesService
        .getCategoriesStream(selectedGroupId.value!)
        .listen(
          (cats) {
            categories.value = cats;
            isLoading.value = false;
          },
          onError: (error) {
            debugPrint('Error loading categories: $error');
            isLoading.value = false;
            Get.snackbar('Error', 'Failed to load categories');
          },
        );
  }

  Future<void> createCategory(String name) async {
    if (!isAdmin.value) {
      Get.snackbar('Permission Denied', 'Only admins can create categories');
      return;
    }

    if (name.trim().isEmpty) {
      Get.snackbar('Invalid Name', 'Category name cannot be empty');
      return;
    }

    if (name.length > 30) {
      Get.snackbar(
        'Invalid Name',
        'Category name must be 30 characters or less',
      );
      return;
    }

    try {
      isLoading.value = true;

      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      await _categoriesService.createCategory(
        selectedGroupId.value!,
        name.trim(),
        userId,
      );

      Get.back();
      Get.snackbar('Success', 'Category created successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
