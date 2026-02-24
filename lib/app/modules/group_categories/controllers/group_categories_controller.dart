import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/models/group_category_model.dart';
import '../../../data/services/group_categories_firestore_service.dart';
import '../../../data/services/meal_categories_firestore_service.dart';
import '../../../data/services/user_initialization_service.dart';

class GroupCategoriesController extends GetxController {
  final GroupCategoriesFirestoreService _groupCategoriesService =
      GroupCategoriesFirestoreService();
  final MealCategoriesFirestoreService _mealCategoriesService =
      MealCategoriesFirestoreService();
  final UserInitializationService _initService = UserInitializationService();

  final groupCategories = <GroupCategoryModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  String? get userId => FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    _initializeAndLoadCategories();
  }

  Future<void> _initializeAndLoadCategories() async {
    if (userId == null) {
      error.value = 'User not authenticated';
      return;
    }

    try {
      // Check if user needs initialization
      final needsInit = await _initService.needsInitialization();
      if (needsInit) {
        isLoading.value = true;
        await _initService.initializeUserDefaults();
      }

      // Load categories
      _loadGroupCategories();
    } catch (e) {
      error.value = 'Failed to initialize: $e';
      isLoading.value = false;
    }
  }

  void _loadGroupCategories() {
    if (userId == null) {
      error.value = 'User not authenticated';
      return;
    }

    isLoading.value = true;

    _groupCategoriesService
        .getGroupCategoriesStream(userId!)
        .listen(
          (categories) {
            groupCategories.value = categories;
            isLoading.value = false;
            error.value = '';
          },
          onError: (e) {
            error.value = 'Failed to load categories: $e';
            isLoading.value = false;
          },
        );
  }

  Future<void> createGroupCategory(
    String name,
    String icon,
    String? description,
  ) async {
    if (userId == null) {
      Get.snackbar('Error', 'User not authenticated');
      return;
    }

    try {
      isLoading.value = true;

      final categoryId = await _groupCategoriesService.createGroupCategory(
        userId!,
        name,
        icon,
        description,
      );

      // Initialize default meal categories for this group category
      await _mealCategoriesService.initializeDefaultMealCategories(
        userId!,
        categoryId,
      );

      Get.back();
      Get.snackbar(
        'Success',
        'Group category "$name" created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteGroupCategory(GroupCategoryModel category) async {
    if (userId == null) return;

    if (category.isDefault) {
      Get.snackbar(
        'Error',
        'Cannot delete default categories',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      await _groupCategoriesService.deleteGroupCategory(userId!, category.id!);
      Get.snackbar(
        'Success',
        'Category deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete category: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void navigateToMealCategories(GroupCategoryModel groupCategory) {
    Get.toNamed(
      '/meal-categories-management',
      arguments: {
        'groupCategoryId': groupCategory.id,
        'groupCategoryName': groupCategory.name,
      },
    );
  }
}
