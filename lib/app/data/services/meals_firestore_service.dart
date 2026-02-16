import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/meal_model.dart';

class MealsFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'meals';

  /// User-specific meals stream filtered by userId
  Stream<List<MealModel>> getUserMealsStream(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MealModel.fromJson(doc.data(), docId: doc.id))
              .toList()
            ..sort(
              (a, b) => b.createdAt.compareTo(a.createdAt),
            ); // Sort in memory instead of using orderBy
        })
        .handleError((error) {
          print('Error fetching user meals for $userId: $error');
          return <MealModel>[];
        });
  }

  /// Stream of meals filtered by group (existing method enhanced)
  Stream<List<MealModel>> getMealsStream(String groupId) {
    print('getMealsStream called for groupId: $groupId');
    return _firestore
        .collection(_collection)
        .where('groupId', isEqualTo: groupId)
        .snapshots()
        .map((snapshot) {
          print(
            'getMealsStream snapshot received: ${snapshot.docs.length} documents',
          );
          final list = snapshot.docs.map((doc) {
            final data = doc.data();
            print(
              '  - Meal doc ${doc.id}: name=${data['name']}, groupId=${data['groupId']}',
            );
            return MealModel.fromJson(data, docId: doc.id);
          }).toList();
          // Sort in-memory to avoid index requirement during development
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          print('getMealsStream returning ${list.length} meals');
          return list;
        })
        .handleError((error) {
          print('Error fetching group meals for $groupId: $error');
          return <MealModel>[];
        });
  }

  /// Stream of meals filtered by group and category
  Stream<List<MealModel>> getMealsByCategory(String groupId, String category) {
    return _firestore
        .collection(_collection)
        .where('groupId', isEqualTo: groupId)
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs
              .map((doc) => MealModel.fromJson(doc.data(), docId: doc.id))
              .where(
                (meal) => meal.categories.any(
                  (cat) => cat.toLowerCase() == category.toLowerCase(),
                ),
              )
              .toList();
          // Sort in-memory
          list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return list;
        })
        .handleError((error) {
          print(
            'Error fetching group meals for $groupId with category $category: $error',
          );
          return <MealModel>[];
        });
  }

  /// Search meals by name for a specific user
  Stream<List<MealModel>> searchUserMeals(String userId, String searchQuery) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .orderBy('name')
        .startAt([searchQuery])
        .endAt([searchQuery + '\uf8ff'])
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MealModel.fromJson(doc.data(), docId: doc.id))
              .toList();
        })
        .handleError((error) {
          print(
            'Error searching meals for $userId with query "$searchQuery": $error',
          );
          return <MealModel>[];
        });
  }

  /// Fetch all meals once (fallback method)
  Future<List<MealModel>> getMeals() async {
    try {
      final querySnapshot = await _firestore.collection(_collection).get();
      return querySnapshot.docs
          .map((doc) => MealModel.fromJson(doc.data(), docId: doc.id))
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Sort in memory
    } catch (e) {
      print('Error fetching all meals: $e');
      return <MealModel>[];
    }
  }

  /// Add a new meal to Firestore and return the document ID
  Future<String> addMeal(MealModel meal) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final docRef = await _firestore
          .collection(_collection)
          .add(meal.toJson());

      print('addMeal success: docId = ${docRef.id}, groupId = ${meal.groupId}');

      return docRef.id;
    } catch (e) {
      print('Error adding meal: $e');
      rethrow;
    }
  }

  /// Upload multiple meals (for seeding)
  Future<void> uploadBulkMeals(List<MealModel> meals) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final batch = _firestore.batch();
      for (var meal in meals) {
        final docRef = _firestore.collection(_collection).doc();
        batch.set(docRef, meal.toJson());
      }
      await batch.commit();
    } catch (e) {
      print('Error uploading bulk meals: $e');
      rethrow;
    }
  }

  /// Delete a meal by ID
  Future<void> deleteMeal(String mealId) async {
    try {
      await _firestore.collection(_collection).doc(mealId).delete();
    } catch (e) {
      print('Error deleting meal $mealId: $e');
      rethrow;
    }
  }

  /// Update a meal
  Future<void> updateMeal(MealModel meal) async {
    try {
      if (meal.id == null) throw Exception('Meal ID is required for update');

      await _firestore
          .collection(_collection)
          .doc(meal.id)
          .update(meal.toJson());
    } catch (e) {
      print('Error updating meal ${meal.id}: $e');
      rethrow;
    }
  }
}
