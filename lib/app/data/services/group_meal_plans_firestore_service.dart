import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/group_meal_plan_model.dart';
class GroupMealPlansFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'group_meal_plans';

  /// Generate deterministic document ID from groupId and date
  /// Format: {groupId}_{yyyy-MM-dd}
  /// Example: "group123_2026-02-20"
  String _generateDocId(String groupId, DateTime date) {
    final dateStr = _formatDateOnly(date);
    return '${groupId}_$dateStr';
  }

  /// Get meal plans for a specific group and date range
  /// Uses deterministic document IDs for direct access
  Stream<List<GroupMealPlanModel>> getGroupMealPlansStream(
    String groupId,
    DateTime startDate,
    DateTime endDate,
  ) {
    debugPrint('=== FIRESTORE QUERY: getGroupMealPlansStream ===');
    debugPrint('🔍 Query Parameters:');
    debugPrint('   - groupId: $groupId');
    debugPrint('   - startDate: ${_formatDateOnly(startDate)}');
    debugPrint('   - endDate: ${_formatDateOnly(endDate)}');
    debugPrint('🆔 Using deterministic document IDs');
    debugPrint('===============================================');

    // Generate list of document IDs for the date range
    final docIds = <String>[];
    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate.add(const Duration(days: 1)))) {
      docIds.add(_generateDocId(groupId, currentDate));
      currentDate = currentDate.add(const Duration(days: 1));
    }

    debugPrint('📄 Document IDs to fetch: $docIds');

    // Create a stream that fetches all documents by ID
    return Stream.periodic(const Duration(seconds: 1))
        .asyncMap((_) async {
          final plans = <GroupMealPlanModel>[];

          for (final docId in docIds) {
            try {
              final docSnapshot = await _firestore
                  .collection(_collection)
                  .doc(docId)
                  .get();

              if (docSnapshot.exists) {
                final data = docSnapshot.data();
                if (data != null) {
                  debugPrint('📄 Document $docId found');
                  plans.add(
                    GroupMealPlanModel.fromJson(data, docId: docSnapshot.id),
                  );
                }
              } else {
                debugPrint('📄 Document $docId does not exist');
              }
            } catch (e) {
              debugPrint('❌ Error fetching document $docId: $e');
            }
          }

          debugPrint('=== FIRESTORE FETCH COMPLETE ===');
          debugPrint('📦 Documents found: ${plans.length}');
          for (var plan in plans) {
            debugPrint('📄 Plan:');
            debugPrint('   - ID: ${plan.id}');
            debugPrint('   - groupId: ${plan.groupId}');
            debugPrint('   - date: ${_formatDateOnly(plan.date)}');
            debugPrint('   - mealSlots: ${plan.mealSlots}');
          }
          debugPrint('================================');

          return plans..sort((a, b) => a.date.compareTo(b.date));
        })
        .handleError((error) {
          debugPrint('❌ Error in stream: $error');
          return <GroupMealPlanModel>[];
        });
  }

  /// Get meal plan for a specific date using deterministic document ID
  Future<GroupMealPlanModel?> getMealPlanForDate(
    String groupId,
    DateTime date,
  ) async {
    try {
      final docId = _generateDocId(groupId, date);
      debugPrint('🔍 Fetching meal plan by document ID: $docId');

      final docSnapshot = await _firestore
          .collection(_collection)
          .doc(docId)
          .get();

      if (!docSnapshot.exists) {
        debugPrint('📄 Document $docId does not exist');
        return null;
      }

      final data = docSnapshot.data();
      if (data == null) {
        debugPrint('📄 Document $docId has no data');
        return null;
      }

      debugPrint('✅ Document $docId found');
      return GroupMealPlanModel.fromJson(data, docId: docSnapshot.id);
    } catch (e) {
      debugPrint('❌ Error getting meal plan for date: $e');
      return null;
    }
  }

  /// Create or update meal plan for a specific date
  /// Uses deterministic document ID: {groupId}_{yyyy-MM-dd}
  Future<void> setMealPlan(GroupMealPlanModel mealPlan) async {
    try {
      final docId = _generateDocId(mealPlan.groupId, mealPlan.date);

      debugPrint('=== SET MEAL PLAN ===');
      debugPrint('📅 Date: ${_formatDateOnly(mealPlan.date)}');
      debugPrint('🏢 Group ID: ${mealPlan.groupId}');
      debugPrint('🆔 Document ID: $docId');
      debugPrint('📊 Incoming mealSlots:');
      mealPlan.mealSlots.forEach((key, value) {
        debugPrint('   - $key: $value');
      });

      // Check if document exists
      final docSnapshot = await _firestore
          .collection(_collection)
          .doc(docId)
          .get();

      if (docSnapshot.exists) {
        debugPrint('📄 Existing document found, merging mealSlots');
        final existingData = docSnapshot.data();
        if (existingData != null) {
          final existingPlan = GroupMealPlanModel.fromJson(
            existingData,
            docId: docSnapshot.id,
          );

          debugPrint('📊 Existing mealSlots:');
          existingPlan.mealSlots.forEach((key, value) {
            debugPrint('   - $key: $value');
          });

          // MERGE mealSlots
          final mergedSlots = Map<String, String?>.from(existingPlan.mealSlots);
          mergedSlots.addAll(mealPlan.mealSlots);

          debugPrint('📊 Merged mealSlots (BEFORE save):');
          mergedSlots.forEach((key, value) {
            debugPrint('   - $key: $value');
          });

          // Update with merged data
          await _firestore.collection(_collection).doc(docId).update({
            'mealSlots': mergedSlots,
            'breakfastMealId': mergedSlots['Breakfast'],
            'lunchMealId': mergedSlots['Lunch'],
            'dinnerMealId': mergedSlots['Dinner'],
            'updatedAt': DateTime.now().toIso8601String(),
          });
          debugPrint('✅ Document updated with merged mealSlots');
        }
      } else {
        debugPrint('📄 No existing document, creating new one');
        // Create new document with deterministic ID
        await _firestore
            .collection(_collection)
            .doc(docId)
            .set(mealPlan.toJson());
        debugPrint('✅ New document created with ID: $docId');
      }
      debugPrint('=== END SET MEAL PLAN ===');
    } catch (e) {
      debugPrint('❌ Error setting meal plan: $e');
      rethrow;
    }
  }

  /// Update specific meal slot using deterministic document ID
  Future<void> updateMealSlot(
    String groupId,
    DateTime date,
    String mealType,
    String? mealId,
    String adminId,
    String adminName,
  ) async {
    try {
      final docId = _generateDocId(groupId, date);

      debugPrint('=== UPDATE MEAL SLOT ===');
      debugPrint('📅 Date: ${_formatDateOnly(date)}');
      debugPrint('🏢 Group ID: $groupId');
      debugPrint('🆔 Document ID: $docId');
      debugPrint('🍽️ Meal Type: $mealType');
      debugPrint('🆔 Meal ID: $mealId');

      // Check if document exists
      final docSnapshot = await _firestore
          .collection(_collection)
          .doc(docId)
          .get();

      if (docSnapshot.exists) {
        debugPrint('📄 Existing document found');
        final existingData = docSnapshot.data();
        if (existingData != null) {
          final existingPlan = GroupMealPlanModel.fromJson(
            existingData,
            docId: docSnapshot.id,
          );

          debugPrint('📊 Current mealSlots BEFORE update:');
          existingPlan.mealSlots.forEach((key, value) {
            debugPrint('   - $key: $value');
          });

          // MERGE with existing mealSlots
          final updatedSlots = Map<String, String?>.from(
            existingPlan.mealSlots,
          );
          updatedSlots[mealType] = mealId;

          debugPrint('📊 Updated mealSlots AFTER merge (BEFORE save):');
          updatedSlots.forEach((key, value) {
            debugPrint('   - $key: $value');
          });

          final updates = <String, dynamic>{
            'mealSlots': updatedSlots,
            if (mealType == 'Breakfast') 'breakfastMealId': mealId,
            if (mealType == 'Lunch') 'lunchMealId': mealId,
            if (mealType == 'Dinner') 'dinnerMealId': mealId,
            'updatedAt': DateTime.now().toIso8601String(),
          };

          debugPrint('💾 Updating document...');
          await _firestore.collection(_collection).doc(docId).update(updates);
          debugPrint('✅ Meal slot updated successfully');
        }
      } else {
        debugPrint('📄 No existing document, creating new one');
        // Create new document with deterministic ID
        final newPlan = GroupMealPlanModel(
          groupId: groupId,
          date: date,
          mealSlots: {mealType: mealId},
          createdBy: adminId,
          createdByName: adminName,
          createdAt: DateTime.now(),
        );

        debugPrint('📊 New plan mealSlots:');
        newPlan.mealSlots.forEach((key, value) {
          debugPrint('   - $key: $value');
        });

        debugPrint('💾 Creating new document with ID: $docId');
        await _firestore
            .collection(_collection)
            .doc(docId)
            .set(newPlan.toJson());
        debugPrint('✅ New meal plan created successfully');
      }
      debugPrint('=== END UPDATE ===');
    } catch (e) {
      debugPrint('❌ Error updating meal slot: $e');
      rethrow;
    }
  }

  /// Duplicate a day's meals to another date
  /// Uses deterministic document IDs
  Future<void> duplicateDayMeals(
    String groupId,
    DateTime sourceDate,
    DateTime targetDate,
    String adminId,
    String adminName,
  ) async {
    try {
      final sourceDocId = _generateDocId(groupId, sourceDate);
      final targetDocId = _generateDocId(groupId, targetDate);

      debugPrint('=== DUPLICATING DAY ===');
      debugPrint('Source date: ${_formatDateOnly(sourceDate)}');
      debugPrint('Target date: ${_formatDateOnly(targetDate)}');
      debugPrint('Source doc ID: $sourceDocId');
      debugPrint('Target doc ID: $targetDocId');
      debugPrint('GroupId: $groupId');

      final sourcePlan = await getMealPlanForDate(groupId, sourceDate);

      if (sourcePlan == null) {
        debugPrint('✗ No meal plan found for source date');
        throw Exception('No meal plan found for source date');
      }

      debugPrint('Source plan found:');
      debugPrint('  - mealSlots: ${sourcePlan.mealSlots}');
      debugPrint('  - meal count: ${sourcePlan.mealCount}');

      final newPlan = GroupMealPlanModel(
        groupId: groupId,
        date: targetDate,
        mealSlots: Map.from(sourcePlan.mealSlots),
        createdBy: adminId,
        createdByName: adminName,
        createdAt: DateTime.now(),
      );

      debugPrint('Creating new plan for target date with ID: $targetDocId');
      await setMealPlan(newPlan);
      debugPrint('✓ Day duplicated successfully');
      debugPrint('=== END DUPLICATION ===');
    } catch (e) {
      debugPrint('✗ Error duplicating day meals: $e');
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
        final mealSlots = <String, String?>{};
        if (breakfastMealId != null) mealSlots['Breakfast'] = breakfastMealId;
        if (lunchMealId != null) mealSlots['Lunch'] = lunchMealId;
        if (dinnerMealId != null) mealSlots['Dinner'] = dinnerMealId;

        final plan = GroupMealPlanModel(
          groupId: groupId,
          date: date,
          mealSlots: mealSlots,
          createdBy: adminId,
          createdByName: adminName,
          createdAt: DateTime.now(),
        );
        await setMealPlan(plan);
      }
    } catch (e) {
      debugPrint('Error applying week template: $e');
      rethrow;
    }
  }

  /// Delete meal plan for a specific date using deterministic document ID
  Future<void> deleteMealPlan(String groupId, DateTime date) async {
    try {
      final docId = _generateDocId(groupId, date);
      debugPrint('🗑️ Deleting meal plan document: $docId');

      await _firestore.collection(_collection).doc(docId).delete();
      debugPrint('✅ Meal plan deleted successfully');
    } catch (e) {
      debugPrint('❌ Error deleting meal plan: $e');
      rethrow;
    }
  }

  String _formatDateOnly(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
