import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../controllers/weekly_meal_planner_controller.dart';
import '../../../../data/models/meal_model.dart';
import '../../../../routes/app_pages.dart';
import '../../../../core/base/controllers/auth_controller.dart';

class WeeklyMealSlotSheet extends StatelessWidget {
  final DateTime date;
  final String mealType;
  final String? currentMealId;
  final WeeklyMealPlannerController controller;

  const WeeklyMealSlotSheet({
    super.key,
    required this.date,
    required this.mealType,
    this.currentMealId,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the category filter based on meal type
    final categoryFilter = _getCategoryForMealType(mealType);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_capitalize(mealType)} - ${DateFormat('MMM d').format(date)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('EEEE').format(date),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick actions
                  _buildQuickActions(context),
                  const SizedBox(height: 24),

                  // Available meals
                  Text(
                    'Select ${_capitalize(mealType)} Meal',
                    style: const TextStyle(
                      color: Color(0xFFC2D86A),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    // Filter meals by category
                    final filteredMeals = controller.availableMeals
                        .where(
                          (meal) => meal.categories.any(
                            (cat) =>
                                cat.toLowerCase() ==
                                categoryFilter.toLowerCase(),
                          ),
                        )
                        .toList();

                    if (filteredMeals.isEmpty) {
                      return _buildEmptyState(context, categoryFilter);
                    }

                    return Column(
                      children: filteredMeals.map((meal) {
                        final isSelected = meal.id == currentMealId;
                        return _buildMealCard(meal, isSelected);
                      }).toList(),
                    );
                  }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCategoryForMealType(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return 'Breakfast';
      case 'lunch':
        return 'Lunch';
      case 'dinner':
        return 'Dinner';
      default:
        return mealType;
    }
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        _buildActionButton(
          'Create New Meal',
          Icons.add_circle_outline,
          const Color(0xFFC2D86A),
          () async {
            Get.back();

            // Store groupId so the meal is created with it
            final authController = Get.find<AuthController>();
            if (controller.groupId != null) {
              await authController.groupIdStore(controller.groupId!);
            }

            // Get the group's category ID to pass to Create Meal
            String? groupCategoryId;
            if (controller.groupId != null) {
              try {
                final groupDoc = await FirebaseFirestore.instance
                    .collection('groups')
                    .doc(controller.groupId!)
                    .get();

                if (groupDoc.exists) {
                  final groupData = groupDoc.data();
                  groupCategoryId = groupData?['group_category_id'] as String?;
                }
                debugPrint(
                  '🚀 Weekly Planner: Navigating with groupCategoryId: $groupCategoryId',
                );
              } catch (e) {
                debugPrint('❌ Error getting group category ID: $e');
              }
            }

            final userData = authController.userdataget();
            Get.toNamed(
              "${Routes.createMeal}?id=${userData["id"] ?? userData["_id"] ?? ""}&from=weekly_planner",
              arguments: groupCategoryId != null
                  ? {'groupCategoryId': groupCategoryId}
                  : null,
            );
          },
        ),
        if (currentMealId != null) ...[
          const SizedBox(height: 12),
          _buildActionButton(
            'Remove Meal',
            Icons.delete_outline,
            Colors.red,
            () {
              controller.updateMealSlot(date, mealType, null);
              Get.back();
            },
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard(MealModel meal, bool isSelected) {
    return GestureDetector(
      onTap: () {
        controller.updateMealSlot(date, mealType, meal.id);
        Get.back();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? [const Color(0xFF2A2A2A), const Color(0xFF252525)]
                : [const Color(0xFF1E1E1E), const Color(0xFF1A1A1A)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFC2D86A).withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.05),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            if (meal.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  meal.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3A3A3A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.restaurant,
                        color: Colors.white24,
                        size: 24,
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildMacroChip('${meal.kcal} kcal', Colors.orange),
                      const SizedBox(width: 6),
                      _buildMacroChip('${meal.protein}g P', Colors.red),
                    ],
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFFC2D86A),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String category) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.restaurant_menu_rounded,
            size: 64,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No $category meals available',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a $category meal first to assign it',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
