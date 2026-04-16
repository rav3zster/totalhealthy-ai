import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/group_meal_calendar_controller.dart';
import '../../../../data/models/meal_model.dart';

class PlanWeekDialog extends StatefulWidget {
  final GroupMealCalendarController controller;

  const PlanWeekDialog({super.key, required this.controller});

  @override
  State<PlanWeekDialog> createState() => _PlanWeekDialogState();
}

class _PlanWeekDialogState extends State<PlanWeekDialog> {
  DateTime? selectedWeekStart;
  MealModel? breakfastMeal;
  MealModel? lunchMeal;
  MealModel? dinnerMeal;

  @override
  void initState() {
    super.initState();
    selectedWeekStart = widget.controller.currentWeekStart.value;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFC2D86A), Color(0xFFD4E87C)],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    color: Colors.black,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Plan Full Week',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Week selection
                    const Text(
                      'Select Week',
                      style: TextStyle(
                        color: Color(0xFFC2D86A),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _selectWeek,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Color(0xFFC2D86A),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _getWeekRangeText(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFFC2D86A),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Breakfast selection
                    _buildMealSelection('Breakfast', '🍳', breakfastMeal, (
                      meal,
                    ) {
                      setState(() => breakfastMeal = meal);
                    }),

                    const SizedBox(height: 16),

                    // Lunch selection
                    _buildMealSelection('Lunch', '🥗', lunchMeal, (meal) {
                      setState(() => lunchMeal = meal);
                    }),

                    const SizedBox(height: 16),

                    // Dinner selection
                    _buildMealSelection('Dinner', '🍽️', dinnerMeal, (meal) {
                      setState(() => dinnerMeal = meal);
                    }),

                    const SizedBox(height: 24),

                    // Apply button
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: widget.controller.isLoading.value
                              ? null
                              : _applyWeekPlan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC2D86A),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: widget.controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Apply to Week',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealSelection(
    String mealType,
    String emoji,
    MealModel? selectedMeal,
    Function(MealModel?) onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              mealType,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selectedMeal != null
                    ? const Color(0xFFC2D86A).withValues(alpha: 0.3)
                    : Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<MealModel?>(
                value: selectedMeal,
                isExpanded: true,
                hint: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Select meal (optional)',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                  ),
                ),
                dropdownColor: const Color(0xFF2A2A2A),
                icon: const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(Icons.arrow_drop_down, color: Color(0xFFC2D86A)),
                ),
                items: [
                  DropdownMenuItem<MealModel?>(
                    value: null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'No meal',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                      ),
                    ),
                  ),
                  ...widget.controller.availableMeals.map((meal) {
                    return DropdownMenuItem<MealModel?>(
                      value: meal,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          meal.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }),
                ],
                onChanged: onSelect,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getWeekRangeText() {
    if (selectedWeekStart == null) return 'Select week';

    final start = selectedWeekStart!;
    final end = start.add(const Duration(days: 6));

    if (start.month == end.month) {
      return '${DateFormat('MMM d').format(start)} - ${DateFormat('d, yyyy').format(end)}';
    } else {
      return '${DateFormat('MMM d').format(start)} - ${DateFormat('MMM d, yyyy').format(end)}';
    }
  }

  Future<void> _selectWeek() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedWeekStart ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFC2D86A),
              surface: Color(0xFF2A2A2A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        selectedWeekStart = _getWeekStart(date);
      });
    }
  }

  DateTime _getWeekStart(DateTime date) {
    final weekday = date.weekday;
    return date.subtract(Duration(days: weekday - 1));
  }

  void _applyWeekPlan() {
    if (selectedWeekStart == null) {
      Get.snackbar(
        'Error',
        'Please select a week',
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    if (breakfastMeal == null && lunchMeal == null && dinnerMeal == null) {
      Get.snackbar(
        'Error',
        'Please select at least one meal',
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    widget.controller.applyWeekTemplate(
      selectedWeekStart!,
      breakfastMeal?.id,
      lunchMeal?.id,
      dinnerMeal?.id,
    );
  }
}
