import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/group_category_model.dart';
import '../../../data/models/group_model.dart';
import '../../../data/services/group_categories_firestore_service.dart';
import '../../../data/services/groups_firestore_service.dart';

class CreateGroupController extends GetxController {
  final GroupCategoriesFirestoreService _groupCategoriesService =
      GroupCategoriesFirestoreService();
  final GroupsFirestoreService _groupsService = GroupsFirestoreService();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  final groupCategories = <GroupCategoryModel>[].obs;
  final selectedGroupCategory = Rxn<GroupCategoryModel>();
  final isLoading = false.obs;
  final isLoadingCategories = false.obs;

  String? get userId => FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    _loadGroupCategories();
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void _loadGroupCategories() {
    if (userId == null) {
      Get.snackbar('Error', 'User not authenticated');
      return;
    }

    isLoadingCategories.value = true;

    _groupCategoriesService
        .getGroupCategoriesStream(userId!)
        .listen(
          (categories) {
            groupCategories.value = categories;

            // Auto-select first category if available
            if (categories.isNotEmpty && selectedGroupCategory.value == null) {
              selectedGroupCategory.value = categories.first;
            }

            isLoadingCategories.value = false;
          },
          onError: (e) {
            print('Error loading group categories: $e');
            isLoadingCategories.value = false;
            Get.snackbar(
              'Error',
              'Failed to load categories. Please try again.',
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          },
        );
  }

  void selectGroupCategory(GroupCategoryModel? category) {
    selectedGroupCategory.value = category;
  }

  Future<void> createGroup() async {
    // Validation
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a group name',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedGroupCategory.value == null) {
      Get.snackbar(
        'Error',
        'Please select a group category',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (userId == null) {
      Get.snackbar(
        'Error',
        'User not authenticated',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final group = GroupModel(
        name: nameController.text.trim(),
        description: descriptionController.text.trim().isEmpty
            ? 'No description'
            : descriptionController.text.trim(),
        groupCategoryId: selectedGroupCategory.value!.id,
        createdBy: userId!,
        membersList: [userId!],
        createdAt: DateTime.now(),
        memberCount: 1,
        categories: [],
        isPrivate: false,
      );

      await _groupsService.addGroup(group);

      Get.back();
      Get.snackbar(
        'Success',
        'Group "${nameController.text}" created successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create group: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
