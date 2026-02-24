import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meal_category_model.dart';

class MealCategoriesFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection path: users/{userId}/group_categories/{groupCategoryId}/meal_categories
  String _getMealCategoriesPath(String userId, String groupCategoryId) =>
      'users/$userId/group_categories/$groupCategoryId/meal_categories';

  Stream<List<MealCategoryModel>> getMealCategoriesStream(
    String userId,
    String groupCategoryId,
  ) {
    return _firestore
        .collection(_getMealCategoriesPath(userId, groupCategoryId))
        .orderBy('order')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => MealCategoryModel.fromJson(doc.data(), docId: doc.id),
              )
              .toList();
        });
  }

  Future<List<MealCategoryModel>> getMealCategories(
    String userId,
    String groupCategoryId,
  ) async {
    final snapshot = await _firestore
        .collection(_getMealCategoriesPath(userId, groupCategoryId))
        .orderBy('order')
        .get();

    return snapshot.docs
        .map((doc) => MealCategoryModel.fromJson(doc.data(), docId: doc.id))
        .toList();
  }

  Future<String> createMealCategory(
    String userId,
    String groupCategoryId,
    String name,
    String? time,
  ) async {
    final isUnique = await isMealCategoryNameUnique(
      userId,
      groupCategoryId,
      name,
    );
    if (!isUnique) {
      throw Exception('A meal category with this name already exists');
    }

    final categories = await getMealCategories(userId, groupCategoryId);
    final nextOrder = categories.isEmpty
        ? 0
        : categories.map((c) => c.order).reduce((a, b) => a > b ? a : b) + 1;

    final category = MealCategoryModel(
      groupCategoryId: groupCategoryId,
      name: name,
      time: time,
      order: nextOrder,
      isDefault: false,
      createdAt: DateTime.now(),
      createdBy: userId,
    );

    final docRef = await _firestore
        .collection(_getMealCategoriesPath(userId, groupCategoryId))
        .add(category.toJson());

    return docRef.id;
  }

  Future<bool> isMealCategoryNameUnique(
    String userId,
    String groupCategoryId,
    String name, {
    String? excludeId,
  }) async {
    final categories = await getMealCategories(userId, groupCategoryId);

    return !categories.any(
      (cat) =>
          cat.name.toLowerCase() == name.toLowerCase() && cat.id != excludeId,
    );
  }

  Future<void> updateMealCategory(
    String userId,
    String groupCategoryId,
    String categoryId,
    Map<String, dynamic> updates,
  ) async {
    await _firestore
        .collection(_getMealCategoriesPath(userId, groupCategoryId))
        .doc(categoryId)
        .update(updates);
  }

  Future<void> deleteMealCategory(
    String userId,
    String groupCategoryId,
    String categoryId,
  ) async {
    await _firestore
        .collection(_getMealCategoriesPath(userId, groupCategoryId))
        .doc(categoryId)
        .delete();
  }

  /// Initialize default meal categories for a new group category
  Future<void> initializeDefaultMealCategories(
    String userId,
    String groupCategoryId,
  ) async {
    final batch = _firestore.batch();

    for (int i = 0; i < MealCategoryModel.defaultMealCategories.length; i++) {
      final defaultCat = MealCategoryModel.defaultMealCategories[i];

      final category = MealCategoryModel(
        groupCategoryId: groupCategoryId,
        name: defaultCat['name'],
        time: defaultCat['time'],
        order: i,
        isDefault: true,
        createdAt: DateTime.now(),
        createdBy: userId,
      );

      final docRef = _firestore
          .collection(_getMealCategoriesPath(userId, groupCategoryId))
          .doc();

      batch.set(docRef, category.toJson());
    }

    await batch.commit();
  }

  // Legacy methods for backward compatibility (will be deprecated)
  @Deprecated('Use getMealCategoriesStream with userId and groupCategoryId')
  Stream<List<MealCategoryModel>> getCategoriesStream(String groupId) {
    // This is a placeholder for backward compatibility
    // In production, you'd need to migrate existing data
    return Stream.value([]);
  }

  @Deprecated('Use getMealCategories with userId and groupCategoryId')
  Future<List<MealCategoryModel>> getCategories(String groupId) async {
    return [];
  }

  @Deprecated('Use createMealCategory with userId and groupCategoryId')
  Future<String> createCategory(
    String groupId,
    String name,
    String userId,
  ) async {
    // For backward compatibility, create in a default group category
    // This assumes the user has a "General" group category
    // In production, you'd need proper migration
    throw UnimplementedError(
      'This method is deprecated. Please use the new hierarchical system.',
    );
  }

  @Deprecated(
    'Use initializeDefaultMealCategories with userId and groupCategoryId',
  )
  Future<void> initializeDefaultCategories(
    String groupId,
    String userId,
  ) async {
    // For backward compatibility
    // In production, you'd need proper migration
    throw UnimplementedError(
      'This method is deprecated. Please use the new hierarchical system.',
    );
  }
}
