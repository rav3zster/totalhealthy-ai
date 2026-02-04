import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../core/theme/app_theme.dart';

class DynamicDayCounter extends StatelessWidget {
  final VoidCallback? onAddMealTap;

  const DynamicDayCounter({super.key, this.onAddMealTap});

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
                style: AppTheme.headingSmall,
              ),
              const SizedBox(height: 4),
              Text(
                controller.planDateRange,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textTertiary,
                ),
              ),
            ],
          ),
        ),
        if (onAddMealTap != null)
          Container(
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusXL),
            ),
            child: ElevatedButton.icon(
              onPressed: onAddMealTap,
              icon: const Icon(Icons.add, color: AppTheme.textPrimary),
              label: Text(
                'Add Meal',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: AppTheme.primaryButtonStyle.copyWith(
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                elevation: WidgetStateProperty.all(0),
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
              // Skeleton for day counter
              Container(
                width: 200,
                height: 18,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                ),
              ),
              const SizedBox(height: 8),
              // Skeleton for date range
              Container(
                width: 120,
                height: 14,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                ),
              ),
            ],
          ),
        ),
        if (onAddMealTap != null)
          Container(
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusXL),
            ),
            child: ElevatedButton.icon(
              onPressed: onAddMealTap,
              icon: const Icon(Icons.add, color: AppTheme.textPrimary),
              label: Text(
                'Add Meal',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: AppTheme.primaryButtonStyle.copyWith(
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                elevation: WidgetStateProperty.all(0),
              ),
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
                  const Icon(
                    Icons.error_outline,
                    color: AppTheme.error,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Day 1/55 (General Fitness)',
                    style: AppTheme.headingSmall,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Failed to load dates',
                    style: AppTheme.bodySmall.copyWith(color: AppTheme.error),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => controller.refreshUserData(),
                    child: Text(
                      'Retry',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.primaryBase,
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
          Container(
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusXL),
            ),
            child: ElevatedButton.icon(
              onPressed: onAddMealTap,
              icon: const Icon(Icons.add, color: AppTheme.textPrimary),
              label: Text(
                'Add Meal',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: AppTheme.primaryButtonStyle.copyWith(
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                elevation: WidgetStateProperty.all(0),
              ),
            ),
          ),
      ],
    );
  }
}
