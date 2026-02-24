import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/group_category_model.dart';

class GroupCategoriesFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection path: group_categories (user-level)
  String _getUserCategoriesPath(String userId) =>
      'users/$userId/group_categories';

  Stream<List<GroupCategoryModel>> getGroupCategoriesStream(String userId) {
    return _firestore
        .collection(_getUserCategoriesPath(userId))
        .orderBy('order')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => GroupCategoryModel.fromJson(doc.data(), docId: doc.id),
              )
              .toList();
        });
  }

  Future<List<GroupCategoryModel>> getGroupCategories(String userId) async {
    final snapshot = await _firestore
        .collection(_getUserCategoriesPath(userId))
        .orderBy('order')
        .get();

    return snapshot.docs
        .map((doc) => GroupCategoryModel.fromJson(doc.data(), docId: doc.id))
        .toList();
  }

  Future<String> createGroupCategory(
    String userId,
    String name,
    String icon,
    String? description,
  ) async {
    final isUnique = await isGroupCategoryNameUnique(userId, name);
    if (!isUnique) {
      throw Exception('A group category with this name already exists');
    }

    final categories = await getGroupCategories(userId);
    final nextOrder = categories.isEmpty
        ? 0
        : categories.map((c) => c.order).reduce((a, b) => a > b ? a : b) + 1;

    final category = GroupCategoryModel(
      name: name,
      description: description,
      icon: icon,
      order: nextOrder,
      isDefault: false,
      createdAt: DateTime.now(),
      createdBy: userId,
    );

    final docRef = await _firestore
        .collection(_getUserCategoriesPath(userId))
        .add(category.toJson());

    return docRef.id;
  }

  Future<bool> isGroupCategoryNameUnique(
    String userId,
    String name, {
    String? excludeId,
  }) async {
    final categories = await getGroupCategories(userId);

    return !categories.any(
      (cat) =>
          cat.name.toLowerCase() == name.toLowerCase() && cat.id != excludeId,
    );
  }

  Future<void> updateGroupCategory(
    String userId,
    String categoryId,
    Map<String, dynamic> updates,
  ) async {
    await _firestore
        .collection(_getUserCategoriesPath(userId))
        .doc(categoryId)
        .update(updates);
  }

  Future<void> deleteGroupCategory(String userId, String categoryId) async {
    await _firestore
        .collection(_getUserCategoriesPath(userId))
        .doc(categoryId)
        .delete();
  }

  /// Initialize default group categories for a new user
  Future<void> initializeDefaultGroupCategories(String userId) async {
    final batch = _firestore.batch();

    for (int i = 0; i < GroupCategoryModel.defaultGroupCategories.length; i++) {
      final defaultCat = GroupCategoryModel.defaultGroupCategories[i];

      final category = GroupCategoryModel(
        name: defaultCat['name'],
        description: defaultCat['description'],
        icon: defaultCat['icon'],
        order: i,
        isDefault: true,
        createdAt: DateTime.now(),
        createdBy: userId,
      );

      final docRef = _firestore
          .collection(_getUserCategoriesPath(userId))
          .doc();

      batch.set(docRef, category.toJson());
    }

    await batch.commit();
  }
}
