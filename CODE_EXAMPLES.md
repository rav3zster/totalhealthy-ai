# Group Categories System - Code Examples

This document provides concrete code examples for the most critical components of the Group Categories system.

## 1. MealCategoryModel

```dart
// lib/app/data/models/meal_category_model.dart

class MealCategoryModel {
  final String? id;
  final String groupId;
  final String name;
  final int order;
  final bool isDefault;
  final DateTime createdAt;
  final String createdBy;

  // Default categories that cannot be deleted
  static const List<String> defaultCategories = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
  ];

  MealCategoryModel({
    this.id,
    required this.groupId,
    required this.name,
    required this.order,
    required this.isDefault,
    required this.createdAt,
    required this.createdBy,
  });

  factory MealCategoryModel.fromJson(
    Map<String, dynamic> json, {
    String? docId,
  }) {
    return MealCategoryModel(
      id: docId ?? json['id'],
      groupId: json['groupId'] ?? '',
      name: json['name'] ?? '',
      order: json['order'] ?? 0,
      isDefault: json['isDefault'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      createdBy: json['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'name': name,
      'order': order,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
    };
  }

  MealCategoryModel copyWith({
    String? id,
    String? groupId,
    String? name,
    int? order,
    bool? isDefault,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return MealCategoryModel(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      order: order ?? this.order,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
```

## 2. MealCategoriesFirestoreService

```dart
// lib/app/data/services/meal_categories_firestore_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meal_category_model.dart';

class MealCategoriesFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get categories stream for a group (ordered)
  Stream<List<MealCategoryModel>> getCategoriesStream(String groupId) {
    return _firestore
        .collection('groups')
        .doc(groupId)
        .collection('categories')
        .orderBy('order')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => MealCategoryModel.fromJson(
                doc.data(),
                docId: doc.id,
              ))
          .toList();
    });
  }

  /// Get categories once (for validation)
  Future<List<MealCategoryModel>> getCategories(String groupId) async {
    final snapshot = await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('categories')
        .orderBy('order')
        .get();

    return snapshot.docs
        .map((doc) => MealCategoryModel.fromJson(
              doc.data(),
              docId: doc.id,
            ))
        .toList();
  }

  /// Create a new category
  Future<String> createCategory(
    String groupId,
    String name,
    String userId,
  ) async {
    // Validate unique name
    final isUnique = await isCategoryNameUnique(groupId, name);
    if (!isUnique) {
      throw Exception('A category with this name already exists');
    }

    // Get next order number
    final categories = await getCategories(groupId);
    final nextOrder = categories.isEmpty
        ? 0
        : categories.map((c) => c.order).reduce((a, b) => a > b ? a : b) + 1;

    // Create category
    final category = MealCategoryModel(
      groupId: groupId,
      name: name,
      order: nextOrder,
      isDefault: false,
      createdAt: DateTime.now(),
      createdBy: userId,
    );

    final docRef = await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('categories')
        .add(category.toJson());

    return docRef.id;
  }

  /// Rename a category
  Future<void> renameCategory(
    String groupId,
    String categoryId,
    String newName,
  ) async {
    // Validate unique name (excluding current category)
    final isUnique = await isCategoryNameUnique(
      groupId,
      newName,
      excludeId: categoryId,
    );

    if (!isUnique) {
      throw Exception('A category with this name already exists');
    }

    await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('categories')
        .doc(categoryId)
        .update({'name': newName});
  }

  /// Reorder categories
  Future<void> reorderCategories(
    String groupId,
    List<String> categoryIds,
  ) async {
    final batch = _firestore.batch();

    for (int i = 0; i < categoryIds.length; i++) {
      final docRef = _firestore
          .collection('groups')
          .doc(groupId)
          .collection('categories')
          .doc(categoryIds[i]);

      batch.update(docRef, {'order': i});
    }

    await batch.commit();
  }

  /// Delete a category (with validation)
  Future<void> deleteCategory(String groupId, String categoryId) async {
    // Validate deletion is allowed
    final canDelete = await canDeleteCategory(groupId, categoryId);

    if (!canDelete) {
      throw Exception('Cannot delete this category');
    }

    await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('categories')
        .doc(categoryId)
        .delete();
  }

  /// Check if category can be deleted
  Future<bool> canDeleteCategory(String groupId, String categoryId) async {
    // 1. Get category
    final categoryDoc = await _firestore
        .collection('groups')
        .doc(groupId)
        .collection('categories')
        .doc(categoryId)
        .get();

    if (!categoryDoc.exists) return false;

    final category = MealCategoryModel.fromJson(
      categoryDoc.data()!,
      docId: categoryDoc.id,
    );

    // 2. Check if default
    if (category.isDefault) {
      return false;
    }

    // 3. Check if meals reference it
    final mealsQuery = await _firestore
        .collection('meals')
        .where('groupId', isEqualTo: groupId)
        .where('categoryIds', arrayContains: categoryId)
        .limit(1)
        .get();

    if (mealsQuery.docs.isNotEmpty) {
      return false;
    }

    // 4. Check if planner references it
    final plansQuery = await _firestore
        .collection('group_meal_plans')
        .where('groupId', isEqualTo: groupId)
        .get();

    for (var planDoc in plansQuery.docs) {
      final mealSlots = planDoc.data()['mealSlots'] as Map<String, dynamic>?;
      if (mealSlots != null && mealSlots.containsKey(categoryId)) {
        return false;
      }
    }

    // 5. Check if last category
    final allCategories = await getCategories(groupId);
    if (allCategories.length <= 1) {
      return false;
    }

    return true;
  }

  /// Check if category name is unique
  Future<bool> isCategoryNameUnique(
    String groupId,
    String name, {
    String? excludeId,
  }) async {
    final categories = await getCategories(groupId);

    return !categories.any((cat) =>
        cat.name.toLowerCase() == name.toLowerCase() && cat.id != excludeId);
  }

  /// Initialize default categories for a new group
  Future<void> initializeDefaultCategories(
    String groupId,
    String userId,
  ) async {
    final batch = _firestore.batch();

    for (int i = 0; i < MealCategoryModel.defaultCategories.length; i++) {
      final category = MealCategoryModel(
        groupId: groupId,
        name: MealCategoryModel.defaultCategories[i],
        order: i,
        isDefault: true,
        createdAt: DateTime.now(),
        createdBy: userId,
      );

      final docRef = _firestore
          .collection('groups')
          .doc(groupId)
          .collection('categories')
          .doc();

      batch.set(docRef, category.toJson());
    }

    await batch.commit();
  }
}
```

## 3. MealCategoriesController

```dart
// lib/app/modules/meal_categories/controllers/meal_categories_controller.dart

import 'dart:async';
import 'package:get/get.dart';
import '../../../data/models/meal_category_model.dart';
import '../../../data/services/meal_categories_firestore_service.dart';
import '../../../data/services/role_permissions_service.dart';

class MealCategoriesController extends GetxController {
  final _categoriesService = MealCategoriesFirestoreService();
  final _permissionsService = RolePermissionsService();

  final categories = <MealCategoryModel>[].obs;
  final isLoading = false.obs;
  final selectedGroupId = Rxn<String>();
  final isAdmin = false.obs;

  StreamSubscription? _categoriesSubscription;

  @override
  void onClose() {
    _categoriesSubscription?.cancel();
    super.onClose();
  }

  /// Initialize for a specific group
  void initForGroup(String groupId, bool isUserAdmin) {
    selectedGroupId.value = groupId;
    isAdmin.value = isUserAdmin;
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
            print('Error loading categories: $error');
            isLoading.value = false;
            Get.snackbar('Error', 'Failed to load categories');
          },
        );
  }

  /// Create a new category
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
      Get.snackbar('Invalid Name', 'Category name must be 30 characters or less');
      return;
    }

    try {
      isLoading.value = true;

      await _categoriesService.createCategory(
        selectedGroupId.value!,
        name.trim(),
        _permissionsService.getCurrentUserId(),
      );

      Get.back(); // Close dialog
      Get.snackbar('Success', 'Category created successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Rename a category
  Future<void> renameCategory(String categoryId, String newName) async {
    if (!isAdmin.value) {
      Get.snackbar('Permission Denied', 'Only admins can rename categories');
      return;
    }

    if (newName.trim().isEmpty) {
      Get.snackbar('Invalid Name', 'Category name cannot be empty');
      return;
    }

    try {
      isLoading.value = true;

      await _categoriesService.renameCategory(
        selectedGroupId.value!,
        categoryId,
        newName.trim(),
      );

      Get.back(); // Close dialog
      Get.snackbar('Success', 'Category renamed successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Reorder categories
  Future<void> reorderCategories(List<MealCategoryModel> reordered) async {
    if (!isAdmin.value) {
      Get.snackbar('Permission Denied', 'Only admins can reorder categories');
      return;
    }

    try {
      // Optimistic update
      categories.value = reordered;

      final categoryIds = reordered.map((c) => c.id!).toList();

      await _categoriesService.reorderCategories(
        selectedGroupId.value!,
        categoryIds,
      );
    } catch (e) {
      // Revert on error
      _loadCategories();
      Get.snackbar('Error', 'Failed to reorder categories');
    }
  }

  /// Delete a category
  Future<void> deleteCategory(String categoryId) async {
    if (!isAdmin.value) {
      Get.snackbar('Permission Denied', 'Only admins can delete categories');
      return;
    }

    try {
      isLoading.value = true;

      // Check if deletion is allowed
      final canDelete = await _categoriesService.canDeleteCategory(
        selectedGroupId.value!,
        categoryId,
      );

      if (!canDelete) {
        Get.snackbar(
          'Cannot Delete',
          'This category cannot be deleted. It may be a default category, have meals assigned, or be referenced in meal plans.',
        );
        return;
      }

      // Confirm deletion
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: Text('Delete Category'),
          content: Text('Are you sure you want to delete this category?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: Text('Delete'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      await _categoriesService.deleteCategory(
        selectedGroupId.value!,
        categoryId,
      );

      Get.snackbar('Success', 'Category deleted successfully');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
```

## 4. Updated MealModel

```dart
// lib/app/data/models/meal_model.dart (UPDATED)

class MealModel {
  final String? id;
  final String name;
  final String description;
  final String kcal;
  final String protein;
  final String carbs;
  final String fat;
  
  // NEW: Store category IDs instead of names
  final List<String> categoryIds;
  
  // DEPRECATED: Keep for backward compatibility
  final List<String> categories;
  
  final String imageUrl;
  final List<IngredientModel> ingredients;
  final String instructions;
  final DateTime createdAt;
  final String prepTime;
  final String difficulty;
  final String userId;
  final String groupId;

  MealModel({
    this.id,
    required this.userId,
    required this.groupId,
    required this.name,
    required this.description,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.categoryIds = const [],
    this.categories = const [], // Deprecated
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    required this.createdAt,
    required this.prepTime,
    required this.difficulty,
  });

  factory MealModel.fromJson(Map<String, dynamic> json, {String? docId}) {
    // Try new format first
    List<String> categoryIds = [];
    if (json['categoryIds'] != null) {
      categoryIds = List<String>.from(json['categoryIds']);
    }

    // Keep old format for backward compatibility
    List<String> categories = [];
    if (json['categorys'] != null || json['categories'] != null) {
      categories = List<String>.from(
        json['categorys'] ?? json['categories'] ?? [],
      );
    }

    return MealModel(
      id: docId ?? json['_id'] ?? json['id'],
      userId: json['userId'] ?? json['user_id'] ?? '',
      groupId: json['groupId'] ?? json['group_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      kcal: json['kcal']?.toString() ?? '0',
      protein: json['protein']?.toString() ?? '0',
      carbs: json['carbs']?.toString() ?? '0',
      fat: json['fat']?.toString() ?? '0',
      categoryIds: categoryIds,
      categories: categories,
      imageUrl: json['imageUrl'] ?? '',
      ingredients: (json['ingredients'] as List? ?? [])
          .map((i) => IngredientModel.fromJson(i))
          .toList(),
      instructions: json['instructions'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      prepTime: json['prep_time'] ?? '',
      difficulty: json['difficulty'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'groupId': groupId,
      'name': name,
      'description': description,
      'kcal': kcal,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'categoryIds': categoryIds, // NEW
      'categorys': categories, // Keep for backward compatibility
      'imageUrl': imageUrl,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'instructions': instructions,
      'created_at': createdAt.toIso8601String(),
      'prep_time': prepTime,
      'difficulty': difficulty,
    };
  }
}
```

## 5. Updated ClientDashboardController (Key Changes)

```dart
// lib/app/modules/client_dashboard/controllers/client_dashboard_controllers.dart (PARTIAL UPDATE)

class ClientDashboardControllers extends GetxController {
  // ... existing properties ...

  // NEW: Add categories
  final mealCategories = <MealCategoryModel>[].obs;
  StreamSubscription? _categoriesSubscription;

  // UPDATED: selectedCategory now stores categoryId instead of name
  final selectedCategory = ''.obs;

  @override
  void onClose() {
    _mealsSubscription?.cancel();
    _authSubscription?.cancel();
    _categoriesSubscription?.cancel(); // NEW
    super.onClose();
  }

  // NEW: Load categories for selected group
  void _loadCategoriesForGroup(String groupId) {
    _categoriesSubscription?.cancel();
    
    _categoriesSubscription = MealCategoriesFirestoreService()
        .getCategoriesStream(groupId)
        .listen((cats) {
          mealCategories.value = cats;
          
          // Set first category as selected if none selected
          if (selectedCategory.value.isEmpty && cats.isNotEmpty) {
            selectedCategory.value = cats.first.id ?? '';
          }
          
          // Update selected category if current one was deleted
          if (!cats.any((c) => c.id == selectedCategory.value)) {
            selectedCategory.value = cats.isNotEmpty ? cats.first.id! : '';
          }
        });
  }

  // UPDATED: Select category by ID
  void selectCategory(String categoryId) {
    selectedCategory.value = categoryId;
    update();
  }

  // UPDATED: Filter meals by categoryId
  List<MealModel> get filteredMeals {
    var result = isGroupMode.value ? groupMeals : meals;

    // Filter by categoryId instead of name
    if (selectedCategory.value.isNotEmpty) {
      result = result.where((meal) {
        return meal.categoryIds.contains(selectedCategory.value);
      }).toList();
    }

    // Search filter
    if (searchQuery.value.isNotEmpty) {
      result = result.where((meal) {
        return meal.name
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase());
      }).toList();
    }

    return result;
  }

  // UPDATED: Switch to group mode
  void switchToGroupMode(String groupId, String groupName) {
    isGroupMode.value = true;
    selectedGroupId.value = groupId;
    selectedGroupName.value = groupName;
    
    // Load categories for this group
    _loadCategoriesForGroup(groupId);
    
    // ... rest of existing logic ...
  }
}
```

## 6. Updated ClientDashboardView (Category Tabs)

```dart
// lib/app/modules/client_dashboard/views/client_dashboard_views.dart (PARTIAL UPDATE)

// BEFORE (Hardcoded):
final categories = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];

TabBar(
  tabs: categories.map((cat) => Tab(text: cat)).toList(),
)

// AFTER (Dynamic):
Obx(() {
  final categories = controller.mealCategories;
  
  if (categories.isEmpty) {
    return Center(
      child: Text('No categories available'),
    );
  }
  
  return TabBar(
    isScrollable: true,
    tabs: categories.map((cat) {
      return Tab(text: cat.name);
    }).toList(),
    onTap: (index) {
      final categoryId = categories[index].id;
      if (categoryId != null) {
        controller.selectCategory(categoryId);
      }
    },
  );
})
```

## 7. MealCategoriesView (New)

```dart
// lib/app/modules/meal_categories/views/meal_categories_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/meal_categories_controller.dart';

class MealCategoriesView extends GetView<MealCategoriesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Categories'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.categories.isEmpty) {
          return Center(
            child: Text('No categories available'),
          );
        }

        return ListView.builder(
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final category = controller.categories[index];
            
            return ListTile(
              leading: controller.isAdmin.value
                  ? Icon(Icons.drag_handle) // Drag handle for reordering
                  : Icon(Icons.circle, size: 8),
              title: Text(category.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (category.isDefault)
                    Chip(
                      label: Text('Default'),
                      backgroundColor: Colors.grey[300],
                    ),
                  if (controller.isAdmin.value && !category.isDefault) ...[
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showRenameDialog(category),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.deleteCategory(category.id!),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: Obx(() {
        if (!controller.isAdmin.value) return SizedBox.shrink();
        
        return FloatingActionButton(
          onPressed: _showAddCategoryDialog,
          child: Icon(Icons.add),
        );
      }),
    );
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: Text('Add Category'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Category Name',
            hintText: 'e.g., Pre-Workout',
          ),
          maxLength: 30,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.createCategory(nameController.text);
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(MealCategoryModel category) {
    final nameController = TextEditingController(text: category.name);
    
    Get.dialog(
      AlertDialog(
        title: Text('Rename Category'),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Category Name',
          ),
          maxLength: 30,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.renameCategory(category.id!, nameController.text);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
```

These code examples provide a solid foundation for implementing the Group Categories system. Each component is designed to work together while maintaining backward compatibility with existing data.
