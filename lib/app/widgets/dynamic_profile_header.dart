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
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFC2D86A).withValues(alpha: 0.3),
                  Color(0xFFC2D86A).withValues(alpha: 0.1),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFC2D86A).withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            padding: EdgeInsets.all(3),
            child: CircleAvatar(
              radius: 25,
              backgroundImage: controller.profileImage.isNotEmpty
                  ? NetworkImage(controller.profileImage)
                  : const AssetImage('assets/user_avatar.png') as ImageProvider,
              onBackgroundImageError: (_, _) {
                // Handle image loading error
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                controller.fullName,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
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
            child: CircularProgressIndicator(
              color: Color(0xFFC2D86A),
              strokeWidth: 2,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 20,
                width: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 16,
                width: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFF2A2A2A),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorHeader(UserController controller) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: Color(0xFF2A2A2A),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.error_outline, color: Colors.red, size: 24),
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
                'Error loading profile',
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
