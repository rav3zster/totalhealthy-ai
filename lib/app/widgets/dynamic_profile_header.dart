import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';

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
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                controller.fullName,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
        if (onNotificationTap != null)
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF242424),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
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
          decoration: const BoxDecoration(
            color: Color(0xFF2A2A2A),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFFC2D86A),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Skeleton text
              Container(
                width: 120,
                height: 16,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
        if (onNotificationTap != null)
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF242424),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
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
          backgroundColor: const Color(0xFF2A2A2A),
          child: const Icon(Icons.person, color: Colors.white54, size: 30),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 16),
                  const SizedBox(width: 4),
                  const Text(
                    'Failed to load profile',
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
        if (onNotificationTap != null)
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF242424),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: onNotificationTap,
            ),
          ),
      ],
    );
  }
}
