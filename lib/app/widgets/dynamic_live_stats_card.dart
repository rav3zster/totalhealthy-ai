import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../modules/client_dashboard/controllers/client_dashboard_controllers.dart';
import '../core/utitlity/responsive_helper.dart';
import '../core/theme/theme_helper.dart';

class DynamicLiveStatsCard extends StatelessWidget {
  const DynamicLiveStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Get dashboard controller to check for group mode
    final dashboardController = Get.find<ClientDashboardControllers>();

    return Obx(() {
      debugPrint(
        "📊 LIVE STATS UI REBUILD → Group: ${dashboardController.selectedGroupId.value}",
      );

      // Check if in group mode
      if (dashboardController.isGroupMode.value &&
          dashboardController.selectedGroupId.value != null) {
        // Group mode - use group stats
        return _buildGroupStatsCard(dashboardController, context);
      } else {
        // Personal mode - use user stats
        final userController = Get.find<UserController>();

        if (userController.isLoading && userController.currentUser == null) {
          return _buildLoadingCard(context);
        }

        if (userController.error.isNotEmpty &&
            userController.currentUser == null) {
          return _buildErrorCard(userController, context);
        }

        return _buildStatsCard(userController, context);
      }
    });
  }

  Widget _buildGroupStatsCard(
    ClientDashboardControllers controller,
    BuildContext context,
  ) {
    final padding = ResponsiveHelper.getResponsivePadding(context, 20);
    final fontSize = ResponsiveHelper.getResponsiveFontSize(context, 20);
    final isSmallScreen = ResponsiveHelper.isSmallPhone(context);

    // Extract stats from groupStats map (placeholder values for now)
    final stats = controller.groupStats;
    final goalAchieved = stats['goalAchieved']?.toString() ?? '0%';
    final fatLost = stats['fatLost']?.toString() ?? '0kg';
    final muscleGained = stats['muscleGained']?.toString() ?? '0g';

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        gradient: context.isLightTheme
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2D2D2D), Color(0xFF1D1D1D)],
              ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.isLightTheme
              ? context.borderColor
              : context.accentColor.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.isLightTheme
                ? Colors.black.withValues(alpha: 0.04)
                : Colors.black.withValues(alpha: 0.3),
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
                    colors: context.isLightTheme
                        ? [Color(0xFFC2FF00), Color(0xFFB8FF00)]
                        : [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Live Stats',
                style: TextStyle(
                  color: context.textPrimary,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(width: 8),
              // Group indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: context.accent.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  controller.selectedGroupName.value,
                  style: TextStyle(
                    color: context.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveHelper.getResponsiveSpacing(context, 20)),
          isSmallScreen
              ? Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildModernStatItem(
                      goalAchieved,
                      'Goal Achieved',
                      Colors.orange,
                      context,
                    ),
                    _buildModernStatItem(
                      fatLost,
                      'Fat Lost',
                      Colors.yellow,
                      context,
                    ),
                    _buildModernStatItem(
                      muscleGained,
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
                        goalAchieved,
                        'Goal Achieved',
                        Colors.orange,
                        context,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildModernStatItem(
                        fatLost,
                        'Fat Lost',
                        Colors.yellow,
                        context,
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: _buildModernStatItem(
                        muscleGained,
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

  Widget _buildStatsCard(UserController controller, BuildContext context) {
    final padding = ResponsiveHelper.getResponsivePadding(context, 20);
    final fontSize = ResponsiveHelper.getResponsiveFontSize(context, 20);
    final isSmallScreen = ResponsiveHelper.isSmallPhone(context);

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        gradient: context.isLightTheme
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF2D2D2D), Color(0xFF1D1D1D)],
              ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.isLightTheme
              ? context.borderColor
              : context.accentColor.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.isLightTheme
                ? Colors.black.withValues(alpha: 0.04)
                : Colors.black.withValues(alpha: 0.3),
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
                    colors: context.isLightTheme
                        ? [
                            Color(0xFFC2FF00),
                            Color(0xFFB8FF00),
                          ] // Bright green for light theme
                        : [
                            Color(0xFFC2D86A),
                            Color(0xFFB8CC5A),
                          ], // Muted green for dark theme
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Live Stats',
                style: TextStyle(
                  color: context.textPrimary,
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
        color: context.isLightTheme
            ? Color(0xFFF5F6F7) // Light gray for light theme
            : Color(0xFF3A3A3A).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.isLightTheme
              ? context.borderColor
              : Colors.white.withValues(alpha: 0.15),
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
              style: TextStyle(
                color: context.isLightTheme
                    ? context.textSecondary
                    : Colors.white70,
                fontSize: labelFontSize,
              ),
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
