import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';

class DynamicLiveStatsCard extends StatelessWidget {
  const DynamicLiveStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      init: Get.find<UserController>(),
      builder: (controller) {
        if (controller.isLoading) {
          return _buildLoadingCard();
        }

        if (controller.error.isNotEmpty) {
          return _buildErrorCard(controller);
        }

        return _buildStatsCard(controller);
      },
    );
  }

  Widget _buildStatsCard(UserController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live Stats',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                controller.goalAchievedPercent,
                'Goal Achieved',
                Colors.orange,
              ),
              _buildStatItem(controller.fatLost, 'Fat Lost', Colors.yellow),
              _buildStatItem(
                controller.muscleGained,
                'Muscle Gained',
                Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Live Stats',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Live Stats',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => controller.refreshUserData(),
                child: const Icon(
                  Icons.refresh,
                  color: Color(0xFFC2D86A),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Center(
            child: Column(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 32),
                SizedBox(height: 8),
                Text(
                  'Failed to load stats',
                  style: TextStyle(color: Colors.red, fontSize: 14),
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
          style: const TextStyle(color: Colors.white70, fontSize: 12),
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
            color: const Color(0xFF3A3A3A),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Center(
            child: SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: Color(0xFFC2D86A),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
