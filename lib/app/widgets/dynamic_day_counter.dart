import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class DynamicDayCounter extends StatelessWidget {
  final VoidCallback? onAddMealTap;

  const DynamicDayCounter({super.key, this.onAddMealTap});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      init: Get.find<UserController>(),
      builder: (controller) {
        if (controller.isLoading) {
          return _buildLoadingCounter();
        }

        if (controller.error.isNotEmpty) {
          return _buildErrorCounter(controller);
        }

        return _buildDayCounter(controller);
      },
    );
  }

  Widget _buildDayCounter(UserController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${controller.dayCountDisplay} (${controller.primaryGoal})',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                controller.planDateRange,
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ],
          ),
        ),
        if (onAddMealTap != null)
          ElevatedButton.icon(
            onPressed: onAddMealTap,
            icon: const Icon(Icons.add, color: Colors.black),
            label: const Text(
              'Add Meal',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC2D86A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingCounter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Skeleton for day counter
              Container(
                width: 200,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              // Skeleton for date range
              Container(
                width: 120,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        if (onAddMealTap != null)
          ElevatedButton.icon(
            onPressed: onAddMealTap,
            icon: const Icon(Icons.add, color: Colors.black),
            label: const Text(
              'Add Meal',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC2D86A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
      ],
    );
  }

  Widget _buildErrorCounter(UserController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 16),
                  const SizedBox(width: 4),
                  const Text(
                    'Day 1/55 (General Fitness)',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Text(
                    'Failed to load dates',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => controller.refreshUserData(),
                    child: const Text(
                      'Retry',
                      style: TextStyle(
                        color: Color(0xFFC2D86A),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (onAddMealTap != null)
          ElevatedButton.icon(
            onPressed: onAddMealTap,
            icon: const Icon(Icons.add, color: Colors.black),
            label: const Text(
              'Add Meal',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC2D86A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
      ],
    );
  }
}
