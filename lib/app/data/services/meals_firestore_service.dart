import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/meal_model.dart';

class MealsFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'meals';

  /// Stream of meals filtered by group
  Stream<List<MealModel>> getMealsStream(String groupId) {
    print("DEBUG: MealsFirestoreService - getMealsStream for $groupId");
    return _firestore
        .collection(_collection)
        .where('groupId', isEqualTo: groupId)
        // Temporarily comment out orderBy to check if it's an indexing issue
        // .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
          print(
            "DEBUG: MealsFirestoreService - Stream emitted ${snapshot.docs.length} docs",
          );
          return snapshot.docs
              .map((doc) => MealModel.fromJson(doc.data(), docId: doc.id))
              .toList();
        });
  }

  /// Fetch all meals once
  Future<List<MealModel>> getMeals() async {
    final querySnapshot = await _firestore
        .collection(_collection)
        .orderBy('created_at', descending: true)
        .get();
    return querySnapshot.docs
        .map((doc) => MealModel.fromJson(doc.data(), docId: doc.id))
        .toList();
  }

  /// Add a new meal to Firestore
  Future<void> addMeal(MealModel meal) async {
    final user = FirebaseAuth.instance.currentUser;
    print('AUTH USER: ${user?.uid}');
    await _firestore.collection(_collection).add(meal.toJson());
  }

  /// Upload multiple meals (for seeding)
  Future<void> uploadBulkMeals(List<MealModel> meals) async {
    final user = FirebaseAuth.instance.currentUser;
    print('AUTH USER: ${user?.uid}');
    final batch = _firestore.batch();
    for (var meal in meals) {
      final docRef = _firestore.collection(_collection).doc();
      batch.set(docRef, meal.toJson());
    }
    await batch.commit();
  }
}
