import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/weekly_meal_planner_controller.dart';
import 'widgets/weekly_meal_slot_sheet.dart';
import 'widgets/duplicate_day_dialog.dart';

class WeeklyMealPlannerView extends GetView<WeeklyMealPlannerController> {
  const WeeklyMealPlannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildWeekNavigation(),
            Expanded(child: _buildWeekView()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E1E1E), Color(0xFF121212)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Color(0xFFC2D86A),
                      size: 20,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Weekly Meal Planner',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        controller.groupName ?? 'Group',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // View-only indicator for members
            if (!controller.isAdmin)
              Container(
                margin: const EdgeInsets.only(top: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.visibility_outlined,
                      color: Colors.blue,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'View Only - Only admin can edit meals',
                      style: TextStyle(
                        color: Colors.blue.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekNavigation() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        final weekStart = controller.currentWeekStart.value;
        final weekEnd = weekStart.add(const Duration(days: 6));

        final weekText = weekStart.month == weekEnd.month
            ? '${DateFormat('MMM d').format(weekStart)} - ${DateFormat('d, yyyy').format(weekEnd)}'
            : '${DateFormat('MMM d').format(weekStart)} - ${DateFormat('MMM d, yyyy').format(weekEnd)}';

        return Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Color(0xFFC2D86A)),
              onPressed: controller.previousWeek,
            ),
            Expanded(
              child: Center(
                child: Text(
                  weekText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, color: Color(0xFFC2D86A)),
              onPressed: controller.nextWeek,
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: controller.goToCurrentWeek,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF2A2A2A),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Today',
                style: TextStyle(
                  color: Color(0xFFC2D86A),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildWeekView() {
    return Obx(() {
      final weekStart = controller.currentWeekStart.value;

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = weekStart.add(Duration(days: index));
          return _buildDayCard(date);
        },
      );
    });
  }

  Widget _buildDayCard(DateTime date) {
    final isToday = _isToday(date);

    return Obx(() {
      // Get plan and nutrition INSIDE Obx so they're reactive
      final plan = controller.getMealPlanForDate(date);
      final nutrition = controller.getDailyNutrition(date);
      final isExpanded = controller.isDayExpanded(date);

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isToday
                ? [const Color(0xFF2A2A2A), const Color(0xFF252525)]
                : [const Color(0xFF1E1E1E), const Color(0xFF1A1A1A)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isToday
                ? const Color(0xFFC2D86A).withOpacity(0.4)
                : Colors.white.withOpacity(0.05),
            width: isToday ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isToday
                  ? const Color(0xFFC2D86A).withOpacity(0.15)
                  : Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Tappable header
            InkWell(
              onTap: () => controller.toggleDayExpansion(date),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Day Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: isToday
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFFC2D86A),
                                      Color(0xFFD4E87C),
                                    ],
                                  )
                                : null,
                            color: isToday ? null : const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              Text(
                                DateFormat('EEE').format(date),
                                style: TextStyle(
                                  color: isToday
                                      ? Colors.black
                                      : const Color(0xFFC2D86A),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                DateFormat('d').format(date),
                                style: TextStyle(
                                  color: isToday ? Colors.black : Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('MMMM d, yyyy').format(date),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (isToday)
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFC2D86A,
                                    ).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'TODAY',
                                    style: TextStyle(
                                      color: Color(0xFFC2D86A),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (controller.isAdmin && isExpanded)
                          IconButton(
                            icon: const Icon(
                              Icons.copy_all_rounded,
                              color: Color(0xFFC2D86A),
                              size: 20,
                            ),
                            onPressed: () => _showDuplicateDayDialog(date),
                            tooltip: 'Duplicate Day',
                          ),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: const Color(0xFFC2D86A),
                          size: 28,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Daily Nutrition Summary (Always visible)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFC2D86A).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.analytics_outlined,
                                color: Color(0xFFC2D86A),
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Daily Total',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildNutritionBadge(
                                '${nutrition['calories']?.toInt() ?? 0}',
                                'kcal',
                                Colors.orange,
                              ),
                              _buildNutritionBadge(
                                '${nutrition['protein']?.toInt() ?? 0}g',
                                'Protein',
                                Colors.red,
                              ),
                              _buildNutritionBadge(
                                '${nutrition['carbs']?.toInt() ?? 0}g',
                                'Carbs',
                                Colors.yellow,
                              ),
                              _buildNutritionBadge(
                                '${nutrition['fat']?.toInt() ?? 0}g',
                                'Fat',
                                Colors.blue,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Expandable meal slots section
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Obx(() {
                  final categories = controller.availableCategories;

                  if (categories.isEmpty) {
                    return Column(
                      children: [
                        const Divider(color: Color(0xFF3A3A3A), height: 1),
                        const SizedBox(height: 16),
                        Text(
                          'No meal categories available',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create meals with categories to see them here',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      const Divider(color: Color(0xFF3A3A3A), height: 1),
                      const SizedBox(height: 16),
                      ...categories.map((category) {
                        final emoji = _getEmojiForCategory(category);
                        final mealId = plan?.getMealIdForCategory(category);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildMealSlot(date, category, emoji, mealId),
                        );
                      }).toList(),
                    ],
                  );
                }),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildMealSlot(
    DateTime date,
    String mealType,
    String emoji,
    String? mealId,
  ) {
    final meal = controller.getMealById(mealId);
    final hasPermission = controller.isAdmin;

    return GestureDetector(
      onTap: hasPermission
          ? () =>
                _showMealSlotSheet(date, mealType, mealId) // Don't lowercase!
          : null,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: meal != null
                ? const Color(0xFFC2D86A).withOpacity(0.3)
                : Colors.white.withOpacity(0.05),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mealType,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (meal != null) ...[
                    Text(
                      meal.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ] else ...[
                    Text(
                      hasPermission ? '+ Add Meal' : 'No meal assigned',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (meal != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${meal.kcal} kcal',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (hasPermission) const SizedBox(width: 8),
            if (hasPermission)
              Icon(
                meal != null ? Icons.edit_rounded : Icons.add_circle_outline,
                color: const Color(0xFFC2D86A),
                size: 18,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionBadge(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  void _showMealSlotSheet(
    DateTime date,
    String mealType,
    String? currentMealId,
  ) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WeeklyMealSlotSheet(
        date: date,
        mealType: mealType,
        currentMealId: currentMealId,
        controller: controller,
      ),
    );
  }

  void _showDuplicateDayDialog(DateTime date) {
    showDialog(
      context: Get.context!,
      builder: (context) =>
          DuplicateDayDialog(sourceDate: date, controller: controller),
    );
  }

  String _getEmojiForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'breakfast':
        return '🍳';
      case 'morning snacks':
        return '🍎';
      case 'lunch':
        return '🥗';
      case 'preworkout':
      case 'pre-workout':
      case 'pre workout':
        return '💪';
      case 'post workout':
      case 'post-workout':
        return '🥤';
      case 'dinner':
        return '🍽️';
      case 'afternoon snack':
        return '🥤';
      case 'evening snack':
        return '🍪';
      case 'snack':
        return '🍿';
      case 'dessert':
        return '🍰';
      default:
        return '🍴';
    }
  }
}
