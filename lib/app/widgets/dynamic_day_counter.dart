import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class DynamicDayCounter extends StatelessWidget {
  final VoidCallback? onAddMealTap;
  final bool showAddButton;

  const DynamicDayCounter({
    super.key,
    this.onAddMealTap,
    this.showAddButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<UserController>();

      if (controller.isLoading && controller.currentUser == null) {
        return _buildLoadingCounter();
      }

      if (controller.error.isNotEmpty && controller.currentUser == null) {
        return _buildErrorCounter(controller);
      }

      return _buildDayCounter(controller);
    });
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                controller.planDateRange.isNotEmpty
                    ? controller.planDateRange
                    : '23 Oct - 17 Dec',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ],
          ),
        ),
        if (showAddButton && onAddMealTap != null)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
              ),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFC2D86A).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: onAddMealTap,
              icon: Icon(Icons.add, color: Colors.black),
              label: Text(
                'Add Meal',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
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
              Container(
                height: 18,
                width: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 14,
                width: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 40,
          width: 120,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(20),
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
              const Text(
                'Day 1/55 (Weight Loss)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Oct 1 - Nov 1',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ],
          ),
        ),
        if (showAddButton && onAddMealTap != null)
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
