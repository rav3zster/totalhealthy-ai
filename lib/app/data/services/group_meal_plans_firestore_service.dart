import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/group_meal_plan_model.dart';

class GroupMealPlansFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'group_meal_plans';

  /// Get meal plans for a specific group and date range
  Stream<List<GroupMealPlanModel>> getGroupMealPlansStream(
    String groupId,
    DateTime startDate,
    DateTime endDate,
  ) {
    final startDateStr = _formatDateOnly(startDate);
    final endDateStr = _formatDateOnly(endDate);

    return _firestore
        .collection(_collection)
        .where('groupId', isEqualTo: groupId)
        .where('date', isGreaterThanOrEqualTo: startDateStr)
        .where('date', isLessThanOrEqualTo: endDateStr)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(
                (doc) => GroupMealPlanModel.fromJson(doc.data(), docId: doc.id),
              )
              .toList()
            ..sort((a, b) => a.date.compareTo(b.date));
        })
        .handleError((error) {
          print('Error fetching group meal plans: $error');
          return <GroupMealPlanModel>[];
        });
  }

  /// Get meal plan for a specific date
  Future<GroupMealPlanModel?> getMealPlanForDate(
    String groupId,
    DateTime date,
  ) async {
    try {
      final dateStr = _formatDateOnly(date);
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('groupId', isEqualTo: groupId)
          .where('date', isEqualTo: dateStr)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      return GroupMealPlanModel.fromJson(
        querySnapshot.docs.first.data(),
        docId: querySnapshot.docs.first.id,
      );
    } catch (e) {
      print('Error getting meal plan for date: $e');
      return null;
    }
  }

  /// Create or update meal plan for a specific date
  Future<void> setMealPlan(GroupMealPlanModel mealPlan) async {
    try {
      // Check if plan exists for this date
      final existingPlan = await getMealPlanForDate(
        mealPlan.groupId,
        mealPlan.date,
      );

      if (existingPlan != null && existingPlan.id != null) {
        // Update existing plan
        await _firestore.collection(_collection).doc(existingPlan.id).update({
          'breakfastMealId': mealPlan.breakfastMealId,
          'lunchMealId': mealPlan.lunchMealId,
          'dinnerMealId': mealPlan.dinnerMealId,
          'updatedAt': DateTime.now().toIso8601String(),
        });
      } else {
        // Create new plan
        await _firestore.collection(_collection).add(mealPlan.toJson());
      }
    } catch (e) {
      print('Error setting meal plan: $e');
      rethrow;
    }
  }

  /// Update specific meal slot
  Future<void> updateMealSlot(
    String groupId,
    DateTime date,
    String mealType, // 'breakfast', 'lunch', or 'dinner'
    String? mealId,
    String adminId,
    String adminName,
  ) async {
    try {
      final existingPlan = await getMealPlanForDate(groupId, date);

      if (existingPlan != null && existingPlan.id != null) {
        // Update existing plan
        final updates = <String, dynamic>{
          '${mealType}MealId': mealId,
          'updatedAt': DateTime.now().toIso8601String(),
        };
        await _firestore
            .collection(_collection)
            .doc(existingPlan.id)
            .update(updates);
      } else {
        // Create new plan with this meal
        final newPlan = GroupMealPlanModel(
          groupId: groupId,
          date: date,
          breakfastMealId: mealType == 'breakfast' ? mealId : null,
          lunchMealId: mealType == 'lunch' ? mealId : null,
          dinnerMealId: mealType == 'dinner' ? mealId : null,
          createdBy: adminId,
          createdByName: adminName,
          createdAt: DateTime.now(),
        );
        await _firestore.collection(_collection).add(newPlan.toJson());
      }
    } catch (e) {
      print('Error updating meal slot: $e');
      rethrow;
    }
  }

  /// Duplicate a day's meals to another date
  Future<void> duplicateDayMeals(
    String groupId,
    DateTime sourceDate,
    DateTime targetDate,
    String adminId,
    String adminName,
  ) async {
    try {
      final sourcePlan = await getMealPlanForDate(groupId, sourceDate);

      if (sourcePlan == null) {
        throw Exception('No meal plan found for source date');
      }

      final newPlan = GroupMealPlanModel(
        groupId: groupId,
        date: targetDate,
        breakfastMealId: sourcePlan.breakfastMealId,
        lunchMealId: sourcePlan.lunchMealId,
        dinnerMealId: sourcePlan.dinnerMealId,
        createdBy: adminId,
        createdByName: adminName,
        createdAt: DateTime.now(),
      );

      await setMealPlan(newPlan);
    } catch (e) {
      print('Error duplicating day meals: $e');
      rethrow;
    }
  }

  /// Apply meal template to entire week
  Future<void> applyWeekTemplate(
    String groupId,
    DateTime weekStart,
    String? breakfastMealId,
    String? lunchMealId,
    String? dinnerMealId,
    String adminId,
    String adminName,
  ) async {
    try {
      // Apply to 7 days starting from weekStart
      for (int i = 0; i < 7; i++) {
        final date = weekStart.add(Duration(days: i));
        final plan = GroupMealPlanModel(
          groupId: groupId,
          date: date,
          breakfastMealId: breakfastMealId,
          lunchMealId: lunchMealId,
          dinnerMealId: dinnerMealId,
          createdBy: adminId,
          createdByName: adminName,
          createdAt: DateTime.now(),
        );
        await setMealPlan(plan);
      }
    } catch (e) {
      print('Error applying week template: $e');
      rethrow;
    }
  }

  /// Delete meal plan for a specific date
  Future<void> deleteMealPlan(String groupId, DateTime date) async {
    try {
      final plan = await getMealPlanForDate(groupId, date);
      if (plan != null && plan.id != null) {
        await _firestore.collection(_collection).doc(plan.id).delete();
      }
    } catch (e) {
      print('Error deleting meal plan: $e');
      rethrow;
    }
  }

  String _formatDateOnly(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
