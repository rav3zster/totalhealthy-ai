import 'package:cloud_firestore/cloud_firestore.dart';
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
    print('=== FIRESTORE QUERY: getGroupMealPlansStream ===');
    print('🔍 Query Parameters:');
    print('   - groupId: $groupId');
    print('   - startDate: ${_formatDateOnly(startDate)}');
    print('   - endDate: ${_formatDateOnly(endDate)}');
    print('🆔 Using deterministic document IDs');
    print('===============================================');

    // Generate list of document IDs for the date range
    final docIds = <String>[];
    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate.add(const Duration(days: 1)))) {
      docIds.add(_generateDocId(groupId, currentDate));
      currentDate = currentDate.add(const Duration(days: 1));
    }

    print('📄 Document IDs to fetch: $docIds');

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
                  print('📄 Document $docId found');
                  plans.add(
                    GroupMealPlanModel.fromJson(data, docId: docSnapshot.id),
                  );
                }
              } else {
                print('📄 Document $docId does not exist');
              }
            } catch (e) {
              print('❌ Error fetching document $docId: $e');
            }
          }

          print('=== FIRESTORE FETCH COMPLETE ===');
          print('📦 Documents found: ${plans.length}');
          for (var plan in plans) {
            print('📄 Plan:');
            print('   - ID: ${plan.id}');
            print('   - groupId: ${plan.groupId}');
            print('   - date: ${_formatDateOnly(plan.date)}');
            print('   - mealSlots: ${plan.mealSlots}');
          }
          print('================================');

          return plans..sort((a, b) => a.date.compareTo(b.date));
        })
        .handleError((error) {
          print('❌ Error in stream: $error');
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
      print('🔍 Fetching meal plan by document ID: $docId');

      final docSnapshot = await _firestore
          .collection(_collection)
          .doc(docId)
          .get();

      if (!docSnapshot.exists) {
        print('📄 Document $docId does not exist');
        return null;
      }

      final data = docSnapshot.data();
      if (data == null) {
        print('📄 Document $docId has no data');
        return null;
      }

      print('✅ Document $docId found');
      return GroupMealPlanModel.fromJson(data, docId: docSnapshot.id);
    } catch (e) {
      print('❌ Error getting meal plan for date: $e');
      return null;
    }
  }

  /// Create or update meal plan for a specific date
  /// Uses deterministic document ID: {groupId}_{yyyy-MM-dd}
  Future<void> setMealPlan(GroupMealPlanModel mealPlan) async {
    try {
      final docId = _generateDocId(mealPlan.groupId, mealPlan.date);

      print('=== SET MEAL PLAN ===');
      print('📅 Date: ${_formatDateOnly(mealPlan.date)}');
      print('🏢 Group ID: ${mealPlan.groupId}');
      print('🆔 Document ID: $docId');
      print('📊 Incoming mealSlots:');
      mealPlan.mealSlots.forEach((key, value) {
        print('   - $key: $value');
      });

      // Check if document exists
      final docSnapshot = await _firestore
          .collection(_collection)
          .doc(docId)
          .get();

      if (docSnapshot.exists) {
        print('📄 Existing document found, merging mealSlots');
        final existingData = docSnapshot.data();
        if (existingData != null) {
          final existingPlan = GroupMealPlanModel.fromJson(
            existingData,
            docId: docSnapshot.id,
          );

          print('📊 Existing mealSlots:');
          existingPlan.mealSlots.forEach((key, value) {
            print('   - $key: $value');
          });

          // MERGE mealSlots
          final mergedSlots = Map<String, String?>.from(existingPlan.mealSlots);
          mergedSlots.addAll(mealPlan.mealSlots);

          print('📊 Merged mealSlots (BEFORE save):');
          mergedSlots.forEach((key, value) {
            print('   - $key: $value');
          });

          // Update with merged data
          await _firestore.collection(_collection).doc(docId).update({
            'mealSlots': mergedSlots,
            'breakfastMealId': mergedSlots['Breakfast'],
            'lunchMealId': mergedSlots['Lunch'],
            'dinnerMealId': mergedSlots['Dinner'],
            'updatedAt': DateTime.now().toIso8601String(),
          });
          print('✅ Document updated with merged mealSlots');
        }
      } else {
        print('📄 No existing document, creating new one');
        // Create new document with deterministic ID
        await _firestore
            .collection(_collection)
            .doc(docId)
            .set(mealPlan.toJson());
        print('✅ New document created with ID: $docId');
      }
      print('=== END SET MEAL PLAN ===');
    } catch (e) {
      print('❌ Error setting meal plan: $e');
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

      print('=== UPDATE MEAL SLOT ===');
      print('📅 Date: ${_formatDateOnly(date)}');
      print('🏢 Group ID: $groupId');
      print('🆔 Document ID: $docId');
      print('🍽️ Meal Type: $mealType');
      print('🆔 Meal ID: $mealId');

      // Check if document exists
      final docSnapshot = await _firestore
          .collection(_collection)
          .doc(docId)
          .get();

      if (docSnapshot.exists) {
        print('📄 Existing document found');
        final existingData = docSnapshot.data();
        if (existingData != null) {
          final existingPlan = GroupMealPlanModel.fromJson(
            existingData,
            docId: docSnapshot.id,
          );

          print('📊 Current mealSlots BEFORE update:');
          existingPlan.mealSlots.forEach((key, value) {
            print('   - $key: $value');
          });

          // MERGE with existing mealSlots
          final updatedSlots = Map<String, String?>.from(
            existingPlan.mealSlots,
          );
          updatedSlots[mealType] = mealId;

          print('📊 Updated mealSlots AFTER merge (BEFORE save):');
          updatedSlots.forEach((key, value) {
            print('   - $key: $value');
          });

          final updates = <String, dynamic>{
            'mealSlots': updatedSlots,
            if (mealType == 'Breakfast') 'breakfastMealId': mealId,
            if (mealType == 'Lunch') 'lunchMealId': mealId,
            if (mealType == 'Dinner') 'dinnerMealId': mealId,
            'updatedAt': DateTime.now().toIso8601String(),
          };

          print('💾 Updating document...');
          await _firestore.collection(_collection).doc(docId).update(updates);
          print('✅ Meal slot updated successfully');
        }
      } else {
        print('📄 No existing document, creating new one');
        // Create new document with deterministic ID
        final newPlan = GroupMealPlanModel(
          groupId: groupId,
          date: date,
          mealSlots: {mealType: mealId},
          createdBy: adminId,
          createdByName: adminName,
          createdAt: DateTime.now(),
        );

        print('📊 New plan mealSlots:');
        newPlan.mealSlots.forEach((key, value) {
          print('   - $key: $value');
        });

        print('💾 Creating new document with ID: $docId');
        await _firestore
            .collection(_collection)
            .doc(docId)
            .set(newPlan.toJson());
        print('✅ New meal plan created successfully');
      }
      print('=== END UPDATE ===');
    } catch (e) {
      print('❌ Error updating meal slot: $e');
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

      print('=== DUPLICATING DAY ===');
      print('Source date: ${_formatDateOnly(sourceDate)}');
      print('Target date: ${_formatDateOnly(targetDate)}');
      print('Source doc ID: $sourceDocId');
      print('Target doc ID: $targetDocId');
      print('GroupId: $groupId');

      final sourcePlan = await getMealPlanForDate(groupId, sourceDate);

      if (sourcePlan == null) {
        print('✗ No meal plan found for source date');
        throw Exception('No meal plan found for source date');
      }

      print('Source plan found:');
      print('  - mealSlots: ${sourcePlan.mealSlots}');
      print('  - meal count: ${sourcePlan.mealCount}');

      final newPlan = GroupMealPlanModel(
        groupId: groupId,
        date: targetDate,
        mealSlots: Map.from(sourcePlan.mealSlots),
        createdBy: adminId,
        createdByName: adminName,
        createdAt: DateTime.now(),
      );

      print('Creating new plan for target date with ID: $targetDocId');
      await setMealPlan(newPlan);
      print('✓ Day duplicated successfully');
      print('=== END DUPLICATION ===');
    } catch (e) {
      print('✗ Error duplicating day meals: $e');
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
      print('Error applying week template: $e');
      rethrow;
    }
  }

  /// Delete meal plan for a specific date using deterministic document ID
  Future<void> deleteMealPlan(String groupId, DateTime date) async {
    try {
      final docId = _generateDocId(groupId, date);
      print('🗑️ Deleting meal plan document: $docId');

      await _firestore.collection(_collection).doc(docId).delete();
      print('✅ Meal plan deleted successfully');
    } catch (e) {
      print('❌ Error deleting meal plan: $e');
      rethrow;
    }
  }

  String _formatDateOnly(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
