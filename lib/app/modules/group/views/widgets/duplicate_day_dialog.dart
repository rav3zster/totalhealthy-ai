import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/weekly_meal_planner_controller.dart';

class DuplicateDayDialog extends StatefulWidget {
  final DateTime sourceDate;
  final WeeklyMealPlannerController controller;

  const DuplicateDayDialog({
    super.key,
    required this.sourceDate,
    required this.controller,
  });

  @override
  State<DuplicateDayDialog> createState() => _DuplicateDayDialogState();
}

class _DuplicateDayDialogState extends State<DuplicateDayDialog> {
  DateTime? selectedTargetDate;

  @override
  Widget build(BuildContext context) {
    final sourcePlan = widget.controller.getMealPlanForDate(widget.sourceDate);
    final hasMeals = sourcePlan?.hasAnyMeal ?? false;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
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
                    Icons.copy_all_rounded,
                    color: Colors.black,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Duplicate Day',
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'From: ${DateFormat('EEEE, MMM d').format(widget.sourceDate)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                hasMeals
                                    ? '${sourcePlan!.mealCount} meal(s) assigned'
                                    : 'No meals assigned',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (!hasMeals) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Colors.orange,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'This day has no meals to duplicate',
                              style: TextStyle(
                                color: Colors.orange.withValues(alpha: 0.9),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Duplicate options
                  const Text(
                    'Duplicate To',
                    style: TextStyle(
                      color: Color(0xFFC2D86A),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Next day option
                  _buildDuplicateOption(
                    'Next Day',
                    DateFormat(
                      'EEEE, MMM d',
                    ).format(widget.sourceDate.add(const Duration(days: 1))),
                    Icons.arrow_forward,
                    () {
                      if (!hasMeals) return;
                      final nextDay = widget.sourceDate.add(
                        const Duration(days: 1),
                      );
                      widget.controller.duplicateDay(
                        widget.sourceDate,
                        nextDay,
                      );
                    },
                    enabled: hasMeals,
                  ),

                  const SizedBox(height: 12),

                  // Entire week option
                  _buildDuplicateOption(
                    'Entire Week',
                    'Apply to all 7 days',
                    Icons.calendar_view_week,
                    () {
                      if (!hasMeals) return;
                      widget.controller.duplicateDayToWeek(widget.sourceDate);
                    },
                    enabled: hasMeals,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDuplicateOption(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool enabled = true,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF2A2A2A) : const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: enabled
                ? const Color(0xFFC2D86A).withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: enabled
                    ? const Color(0xFFC2D86A).withValues(alpha: 0.2)
                    : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: enabled
                    ? const Color(0xFFC2D86A)
                    : Colors.white.withValues(alpha: 0.3),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: enabled
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: enabled
                          ? Colors.white.withValues(alpha: 0.6)
                          : Colors.white.withValues(alpha: 0.3),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: enabled
                  ? const Color(0xFFC2D86A)
                  : Colors.white.withValues(alpha: 0.2),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
