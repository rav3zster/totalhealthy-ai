import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../core/utitlity/responsive_helper.dart';

class DynamicLiveStatsCard extends StatelessWidget {
  const DynamicLiveStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<UserController>();

      if (controller.isLoading && controller.currentUser == null) {
        return _buildLoadingCard(context);
      }

      if (controller.error.isNotEmpty && controller.currentUser == null) {
        return _buildErrorCard(controller, context);
      }

      return _buildStatsCard(controller, context);
    });
  }

  Widget _buildStatsCard(UserController controller, BuildContext context) {
    final padding = ResponsiveHelper.getResponsivePadding(context, 20);
    final fontSize = ResponsiveHelper.getResponsiveFontSize(context, 20);
    final isSmallScreen = ResponsiveHelper.isSmallPhone(context);

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2D2D2D), Color(0xFF1D1D1D)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFFC2D86A).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Live Stats',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 20)),
          // Use Wrap for better responsiveness on small screens
          isSmallScreen
              ? Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildModernStatItem(
                      controller.goalAchievedPercent,
                      'Goal Achieved',
                      Colors.orange,
                      context,
                    ),
                    _buildModernStatItem(
                      controller.fatLost,
                      'Fat Lost',
                      Colors.yellow,
                      context,
                    ),
                    _buildModernStatItem(
                      controller.muscleGained,
                      'Muscle Gained',
                      Colors.purple,
                      context,
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: _buildModernStatItem(
                        controller.goalAchievedPercent,
                        'Goal Achieved',
                        Colors.orange,
                        context,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildModernStatItem(
                        controller.fatLost,
                        'Fat Lost',
                        Colors.yellow,
                        context,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildModernStatItem(
                        controller.muscleGained,
                        'Muscle Gained',
                        Colors.purple,
                        context,
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildModernStatItem(
    String value,
    String label,
    Color color,
    BuildContext context,
  ) {
    final isSmallScreen = ResponsiveHelper.isSmallPhone(context);
    final fontSize = ResponsiveHelper.getResponsiveFontSize(context, 18);
    final labelFontSize = ResponsiveHelper.getResponsiveFontSize(context, 11);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8 : 12,
        vertical: isSmallScreen ? 10 : 14,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.05),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: TextStyle(color: Colors.white70, fontSize: labelFontSize),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    final padding = ResponsiveHelper.getResponsivePadding(context, 20);

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 18,
            width: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF3A3A3A),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: _buildLoadingStatItem()),
              SizedBox(width: 8),
              Expanded(child: _buildLoadingStatItem()),
              SizedBox(width: 8),
              Expanded(child: _buildLoadingStatItem()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingStatItem() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            height: 20,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF4A4A4A),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 12,
            width: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF4A4A4A),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(UserController controller, BuildContext context) {
    final padding = ResponsiveHelper.getResponsivePadding(context, 20);

    return Container(
      padding: EdgeInsets.all(padding),
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
              Expanded(
                child: _buildStatItem(
                  '0%',
                  'Goal Achieved',
                  Colors.orange,
                  context,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildStatItem(
                  '0kg',
                  'Fat Lost',
                  Colors.yellow,
                  context,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _buildStatItem(
                  '0g',
                  'Muscle Gained',
                  Colors.purple,
                  context,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String value,
    String label,
    Color color,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
