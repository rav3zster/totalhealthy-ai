import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/group_meal_calendar_controller.dart';
import '../../../data/models/group_meal_plan_model.dart';
import 'widgets/meal_slot_bottom_sheet.dart';
import 'widgets/plan_week_dialog.dart';

class GroupMealCalendarView extends GetView<GroupMealCalendarController> {
  const GroupMealCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildViewToggle(),
            _buildNavigationBar(),
            Expanded(
              child: Obx(() {
                if (controller.isWeekView.value) {
                  return _buildWeekView();
                } else {
                  return _buildMonthView();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E1E1E), Color(0xFF121212)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
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
                    'Group Meal Calendar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    controller.groupName ?? 'Group',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (controller.isAdmin)
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFC2D86A), Color(0xFFD4E87C)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _showPlanWeekDialog(context),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: Colors.black, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Plan Week',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewToggle() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(
        () => Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildToggleButton(
                  'Week View',
                  Icons.view_week_rounded,
                  controller.isWeekView.value,
                  () => controller.toggleView(),
                ),
              ),
              Expanded(
                child: _buildToggleButton(
                  'Month View',
                  Icons.calendar_month_rounded,
                  !controller.isWeekView.value,
                  () => controller.toggleView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFC2D86A), Color(0xFFD4E87C)],
                )
              : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.black : Colors.white.withValues(alpha: 0.5),
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.black
                    : Colors.white.withValues(alpha: 0.5),
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Obx(() {
        final dateText = controller.isWeekView.value
            ? _getWeekRangeText()
            : DateFormat('MMMM yyyy').format(controller.currentMonth.value);

        return Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left, color: Color(0xFFC2D86A)),
              onPressed: controller.previousPeriod,
            ),
            Expanded(
              child: Center(
                child: Text(
                  dateText,
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
              onPressed: controller.nextPeriod,
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: controller.goToToday,
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

  String _getWeekRangeText() {
    final start = controller.currentWeekStart.value;
    final end = start.add(const Duration(days: 6));

    if (start.month == end.month) {
      return '${DateFormat('MMM d').format(start)} - ${DateFormat('d, yyyy').format(end)}';
    } else {
      return '${DateFormat('MMM d').format(start)} - ${DateFormat('MMM d, yyyy').format(end)}';
    }
  }

  Widget _buildWeekView() {
    return Obx(() {
      final weekStart = controller.currentWeekStart.value;

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 7,
        itemBuilder: (context, index) {
          final date = weekStart.add(Duration(days: index));
          final mealPlan = controller.getMealPlanForDate(date);
          final isToday = _isToday(date);

          return _buildDayCard(date, mealPlan, isToday);
        },
      );
    });
  }

  Widget _buildDayCard(
    DateTime date,
    GroupMealPlanModel? mealPlan,
    bool isToday,
  ) {
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
              ? const Color(0xFFC2D86A).withValues(alpha: 0.4)
              : Colors.white.withValues(alpha: 0.05),
          width: isToday ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isToday
                ? const Color(0xFFC2D86A).withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: isToday
                        ? const LinearGradient(
                            colors: [Color(0xFFC2D86A), Color(0xFFD4E87C)],
                          )
                        : null,
                    color: isToday ? null : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(10),
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    DateFormat('MMMM d, yyyy').format(date),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (isToday)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC2D86A).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'TODAY',
                      style: TextStyle(
                        color: Color(0xFFC2D86A),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Meal slots
            _buildMealSlot(date, 'Breakfast', '🍳', mealPlan?.breakfastMealId),
            const SizedBox(height: 12),
            _buildMealSlot(date, 'Lunch', '🥗', mealPlan?.lunchMealId),
            const SizedBox(height: 12),
            _buildMealSlot(date, 'Dinner', '🍽️', mealPlan?.dinnerMealId),
          ],
        ),
      ),
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

    return GestureDetector(
      onTap: hasPermission
          ? () => _showMealSlotBottomSheet(date, mealType.toLowerCase(), mealId)
          : null,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: meal != null
                ? const Color(0xFFC2D86A).withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.05),
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
                      color: Colors.white.withValues(alpha: 0.6),
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
                    const SizedBox(height: 4),
                    Text(
                      '${meal.kcal} kcal',
                      style: TextStyle(
                        color: Colors.orange.withValues(alpha: 0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ] else ...[
                    Text(
                      hasPermission ? 'Tap to add meal' : 'No meal assigned',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (hasPermission)
              Icon(
                meal != null ? Icons.edit_rounded : Icons.add_circle_outline,
                color: const Color(0xFFC2D86A),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Widget _buildMonthView() {
    return Obx(() {
      final month = controller.currentMonth.value;
      final firstDay = DateTime(month.year, month.month, 1);
      final lastDay = DateTime(month.year, month.month + 1, 0);
      final startWeekday = firstDay.weekday;
      final daysInMonth = lastDay.day;

      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 0.8,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: startWeekday - 1 + daysInMonth,
        itemBuilder: (context, index) {
          if (index < startWeekday - 1) {
            return const SizedBox.shrink();
          }

          final day = index - startWeekday + 2;
          final date = DateTime(month.year, month.month, day);
          final mealPlan = controller.getMealPlanForDate(date);
          final isToday = _isToday(date);

          return _buildMonthDayCell(date, mealPlan, isToday);
        },
      );
    });
  }

  Widget _buildMonthDayCell(
    DateTime date,
    GroupMealPlanModel? mealPlan,
    bool isToday,
  ) {
    final hasMeals = mealPlan?.hasAnyMeal ?? false;
    final mealCount = mealPlan?.mealCount ?? 0;

    return GestureDetector(
      onTap: () => _showDayDetailBottomSheet(date, mealPlan),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isToday
                ? [const Color(0xFF2A2A2A), const Color(0xFF252525)]
                : [const Color(0xFF1E1E1E), const Color(0xFF1A1A1A)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isToday
                ? const Color(0xFFC2D86A).withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.05),
            width: isToday ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: TextStyle(
                color: isToday ? const Color(0xFFC2D86A) : Colors.white,
                fontSize: 16,
                fontWeight: isToday ? FontWeight.bold : FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            if (hasMeals)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  mealCount,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC2D86A),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showMealSlotBottomSheet(
    DateTime date,
    String mealType,
    String? currentMealId,
  ) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MealSlotBottomSheet(
        date: date,
        mealType: mealType,
        currentMealId: currentMealId,
        controller: controller,
      ),
    );
  }

  void _showDayDetailBottomSheet(DateTime date, GroupMealPlanModel? mealPlan) {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
                    child: Text(
                      DateFormat('EEEE, MMMM d, yyyy').format(date),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                  children: [
                    _buildMealSlot(
                      date,
                      'Breakfast',
                      '🍳',
                      mealPlan?.breakfastMealId,
                    ),
                    const SizedBox(height: 16),
                    _buildMealSlot(date, 'Lunch', '🥗', mealPlan?.lunchMealId),
                    const SizedBox(height: 16),
                    _buildMealSlot(
                      date,
                      'Dinner',
                      '🍽️',
                      mealPlan?.dinnerMealId,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPlanWeekDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PlanWeekDialog(controller: controller),
    );
  }
}
