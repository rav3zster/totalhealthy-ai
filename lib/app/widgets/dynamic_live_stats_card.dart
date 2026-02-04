import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../core/theme/app_theme.dart';

class DynamicLiveStatsCard extends StatelessWidget {
  const DynamicLiveStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<UserController>();

      if (controller.isLoading && controller.currentUser == null) {
        return _buildLoadingCard();
      }

      if (controller.error.isNotEmpty && controller.currentUser == null) {
        return _buildErrorCard(controller);
      }

      return _buildStatsCard(controller);
    });
  }

  Widget _buildStatsCard(UserController controller) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Live Stats', style: AppTheme.headingSmall),
          const SizedBox(height: AppTheme.spacingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                controller.goalAchievedPercent,
                'Goal Achieved',
                AppTheme.warning,
              ),
              _buildStatItem(
                controller.fatLost,
                'Fat Lost',
                AppTheme.primaryLight,
              ),
              _buildStatItem(
                controller.muscleGained,
                'Muscle Gained',
                AppTheme.success,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Live Stats', style: AppTheme.headingSmall),
          const SizedBox(height: AppTheme.spacingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLoadingStatItem('Goal Achieved'),
              _buildLoadingStatItem('Fat Lost'),
              _buildLoadingStatItem('Muscle Gained'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(UserController controller) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Live Stats', style: AppTheme.headingSmall),
              const Spacer(),
              GestureDetector(
                onTap: () => controller.refreshUserData(),
                child: const Icon(
                  Icons.refresh,
                  color: AppTheme.primaryBase,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          const Center(
            child: Column(
              children: [
                Icon(Icons.error_outline, color: AppTheme.error, size: 32),
                SizedBox(height: 8),
                Text(
                  'Failed to load stats',
                  style: TextStyle(color: AppTheme.error, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          child: Text(value),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoadingStatItem(String label) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 20,
          decoration: BoxDecoration(
            color: AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
          ),
          child: const Center(
            child: SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: AppTheme.primaryBase,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
