import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/weekly_meal_planner_controller.dart';
import 'widgets/weekly_meal_slot_sheet.dart';
import 'widgets/duplicate_day_dialog.dart';
import '../../../core/theme/theme_helper.dart';

class WeeklyMealPlannerView extends GetView<WeeklyMealPlannerController> {
  const WeeklyMealPlannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: Container(
        decoration: BoxDecoration(gradient: context.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildModernHeader(),
              _buildWeekNavigation(),
              Expanded(child: _buildWeekView()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: BoxDecoration(
          gradient: context.headerGradient,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          boxShadow: context.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button and title row
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.cardSecondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: context.textPrimary,
                      size: 20,
                    ),
                    onPressed: () => Get.back(),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weekly Meal Planner',
                        style: TextStyle(
                          color: context.textPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFC2D86A,
                              ).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: context.accent.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              controller.groupName ?? 'Group',
                              style: TextStyle(
                                color: context.accent.withValues(alpha: 0.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (!controller.isAdmin) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.blue.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.visibility_outlined,
                                    color: Colors.blue.withValues(alpha: 0.9),
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'View Only',
                                    style: TextStyle(
                                      color: Colors.blue.withValues(alpha: 0.9),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Info card
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: context.accentSoft,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.accent.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    color: context.accent.withValues(alpha: 0.8),
                    size: 18,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      controller.isAdmin
                          ? 'Plan meals for the week ahead'
                          : 'View your weekly meal schedule',
                      style: TextStyle(
                        color: context.textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
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
    return Builder(
      builder: (context) => Container(
        margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: context.cardGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.accent.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: context.accent.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Obx(() {
          final weekStart = controller.currentWeekStart.value;
          final weekEnd = weekStart.add(const Duration(days: 6));

          final weekText = weekStart.month == weekEnd.month
              ? '${DateFormat('MMM d').format(weekStart)} - ${DateFormat('d, yyyy').format(weekEnd)}'
              : '${DateFormat('MMM d').format(weekStart)} - ${DateFormat('MMM d, yyyy').format(weekEnd)}';

          return Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: context.cardSecondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.chevron_left_rounded,
                    color: context.accent,
                    size: 24,
                  ),
                  onPressed: controller.previousWeek,
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    weekText,
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: context.cardSecondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.chevron_right_rounded,
                    color: context.accent,
                    size: 24,
                  ),
                  onPressed: controller.nextWeek,
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: context.accentGradient,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: context.accent.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: controller.goToCurrentWeek,
                  child: const Text(
                    'Today',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildWeekView() {
    return Obx(() {
      final weekStart = controller.currentWeekStart.value;

      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = weekStart.add(Duration(days: index));
          return _buildDayCard(date, index);
        },
      );
    });
  }

  Widget _buildDayCard(DateTime date, int index) {
    final isToday = _isToday(date);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Obx(() {
        // Get plan and nutrition INSIDE Obx so they're reactive
        final plan = controller.getMealPlanForDate(date);
        final nutrition = controller.getDailyNutrition(date);
        final isExpanded = controller.isDayExpanded(date);

        return Builder(
          builder: (context) => Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isToday
                    ? [context.cardColor, context.cardSecondary]
                    : [context.cardSecondary, context.cardColor],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isToday
                    ? context.accent.withValues(alpha: 0.5)
                    : context.border,
                width: isToday ? 2 : 1.5,
              ),
              boxShadow: isToday
                  ? [
                      BoxShadow(
                        color: context.accent.withValues(alpha: 0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : context.cardShadow,
            ),
            child: Column(
              children: [
                // Tappable header
                InkWell(
                  onTap: () => controller.toggleDayExpansion(date),
                  borderRadius: BorderRadius.circular(24),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Day Header
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: isToday
                                    ? context.accentGradient
                                    : context.cardGradient,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: isToday
                                    ? [
                                        BoxShadow(
                                          color: context.accent.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 12,
                                          spreadRadius: 0,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    DateFormat(
                                      'EEE',
                                    ).format(date).toUpperCase(),
                                    style: TextStyle(
                                      color: isToday
                                          ? Colors.black
                                          : context.accent,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('d').format(date),
                                    style: TextStyle(
                                      color: isToday
                                          ? Colors.black
                                          : context.textPrimary,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('MMMM d, yyyy').format(date),
                                    style: TextStyle(
                                      color: context.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  if (isToday)
                                    Container(
                                      margin: const EdgeInsets.only(top: 6),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            context.accent.withValues(
                                              alpha: 0.3,
                                            ),
                                            context.accent.withValues(
                                              alpha: 0.2,
                                            ),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: context.accent.withValues(
                                            alpha: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'TODAY',
                                        style: TextStyle(
                                          color: context.accent,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (controller.isAdmin && isExpanded)
                              Container(
                                decoration: BoxDecoration(
                                  color: context.accentSoft,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.copy_all_rounded,
                                    color: context.accent,
                                    size: 20,
                                  ),
                                  onPressed: () =>
                                      _showDuplicateDayDialog(date),
                                  tooltip: 'Duplicate Day',
                                  padding: const EdgeInsets.all(8),
                                  constraints: const BoxConstraints(),
                                ),
                              ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: context.accentSoft,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up_rounded
                                    : Icons.keyboard_arrow_down_rounded,
                                color: context.accent,
                                size: 24,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Daily Nutrition Summary (Always visible)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                context.cardColor,
                                context.cardSecondary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: context.accent.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFC2D86A,
                                      ).withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.analytics_outlined,
                                      color: const Color(
                                        0xFFC2D86A,
                                      ).withValues(alpha: 0.9),
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Daily Total',
                                    style: TextStyle(
                                      color: context.textPrimary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Obx(() {
                      final categories = controller.availableCategories;

                      if (categories.isEmpty) {
                        return Column(
                          children: [
                            Divider(color: context.divider, height: 1),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: context.cardSecondary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.restaurant_menu_outlined,
                                    color: context.textTertiary,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'No meal categories available',
                                    style: TextStyle(
                                      color: context.textSecondary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Create meals with categories to see them here',
                                    style: TextStyle(
                                      color: context.textTertiary,
                                      fontSize: 12,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: [
                          Divider(color: context.divider, height: 1),
                          const SizedBox(height: 16),
                          ...categories.map((category) {
                            final emoji = _getEmojiForCategory(category);
                            final mealId = plan?.getMealIdForCategory(category);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildMealSlot(
                                date,
                                category,
                                emoji,
                                mealId,
                              ),
                            );
                          }),
                        ],
                      );
                    }),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMealSlot(
    DateTime date,
    String mealType,
    String emoji,
    String? mealId,
  ) {
    final meal = controller.getMealById(mealId);
    final hasPermission = controller.isAdmin;

    return Builder(
      builder: (context) => GestureDetector(
        onTap: hasPermission
            ? () =>
                  _showMealSlotSheet(date, mealType, mealId) // Don't lowercase!
            : null,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: meal != null
                  ? [context.cardColor, context.cardSecondary]
                  : [context.cardSecondary, context.cardColor],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: meal != null
                  ? context.accent.withValues(alpha: 0.4)
                  : context.border,
              width: meal != null ? 1.5 : 1,
            ),
            boxShadow: meal != null
                ? [
                    BoxShadow(
                      color: context.accent.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: meal != null
                      ? LinearGradient(
                          colors: [
                            context.accent.withValues(alpha: 0.3),
                            context.accent.withValues(alpha: 0.15),
                          ],
                        )
                      : null,
                  color: meal == null ? context.cardSecondary : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(emoji, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mealType,
                      style: TextStyle(
                        color: meal != null
                            ? context.accent.withValues(alpha: 0.8)
                            : context.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (meal != null) ...[
                      Text(
                        meal.name,
                        style: TextStyle(
                          color: context.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ] else ...[
                      Text(
                        hasPermission ? '+ Add Meal' : 'No meal assigned',
                        style: TextStyle(
                          color: context.textTertiary,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (meal != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.withValues(alpha: 0.3),
                        Colors.orange.withValues(alpha: 0.2),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '${meal.kcal} kcal',
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (hasPermission) const SizedBox(width: 10),
              if (hasPermission)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: context.accentSoft,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    meal != null
                        ? Icons.edit_rounded
                        : Icons.add_circle_outline,
                    color: context.accent,
                    size: 18,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionBadge(String value, String label, Color color) {
    return Builder(
      builder: (context) => Column(
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
              color: context.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
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
