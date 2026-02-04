import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../core/theme/app_theme.dart';

class DynamicProfileHeader extends StatelessWidget {
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;

  const DynamicProfileHeader({
    super.key,
    this.onProfileTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<UserController>();

      if (controller.isLoading && controller.currentUser == null) {
        return _buildLoadingHeader();
      }

      if (controller.error.isNotEmpty && controller.currentUser == null) {
        return _buildErrorHeader(controller);
      }

      return _buildProfileHeader(controller);
    });
  }

  Widget _buildProfileHeader(UserController controller) {
    return Row(
      children: [
        GestureDetector(
          onTap: onProfileTap,
          child: CircleAvatar(
            radius: 25,
            backgroundImage: controller.profileImage.isNotEmpty
                ? NetworkImage(controller.profileImage)
                : const AssetImage('assets/user_avatar.png') as ImageProvider,
            onBackgroundImageError: (_, __) {
              // Handle image loading error
            },
          ),
        ),
        const SizedBox(width: AppTheme.spacingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome!', style: AppTheme.headingMedium),
              Text(
                controller.fullName,
                style: AppTheme.bodyLarge.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (onNotificationTap != null)
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: AppTheme.textPrimary,
              ),
              onPressed: onNotificationTap,
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingHeader() {
    return Row(
      children: [
        // Skeleton avatar
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppTheme.primaryBase,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppTheme.spacingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome!', style: AppTheme.headingMedium),
              // Skeleton text
              Container(
                width: 120,
                height: 16,
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                ),
              ),
            ],
          ),
        ),
        if (onNotificationTap != null)
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: AppTheme.textPrimary,
              ),
              onPressed: onNotificationTap,
            ),
          ),
      ],
    );
  }

  Widget _buildErrorHeader(UserController controller) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: AppTheme.surfaceDark,
          child: const Icon(
            Icons.person,
            color: AppTheme.textTertiary,
            size: 30,
          ),
        ),
        const SizedBox(width: AppTheme.spacingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome!', style: AppTheme.headingMedium),
              Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppTheme.error,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Failed to load profile',
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
        if (onNotificationTap != null)
          Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: AppTheme.textPrimary,
              ),
              onPressed: onNotificationTap,
            ),
          ),
      ],
    );
  }
}
