import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../data/services/groups_firestore_service.dart';
import '../data/models/group_model.dart';
import '../routes/app_pages.dart';
import '../core/base/controllers/auth_controller.dart';
import '../modules/client_dashboard/controllers/client_dashboard_controllers.dart';

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
              backgroundColor: const Color(0xFF2A2A2A),
              backgroundImage: UserController.getImageProvider(
                controller.profileImage,
              ),
              onBackgroundImageError: controller.profileImage.isNotEmpty
                  ? (_, __) {
                      // Image failed to load
                    }
                  : null,
              child: controller.profileImage.isEmpty
                  ? const Icon(Icons.person, color: Colors.white24, size: 25)
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                controller.fullName,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Group Dropdown
        _GroupDropdown(),
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

// Group Dropdown Widget
class _GroupDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final userId = authController.firebaseUser.value?.uid;

    if (userId == null) {
      return SizedBox.shrink();
    }

    final groupsService = GroupsFirestoreService();

    return StreamBuilder<List<GroupModel>>(
      stream: groupsService.getUserGroupsStream(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFFC2D86A),
              ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return SizedBox.shrink();
        }

        final groups = snapshot.data!;

        return PopupMenuButton<GroupModel>(
          icon: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFC2D86A).withValues(alpha: 0.2),
                  Color(0xFFC2D86A).withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Color(0xFFC2D86A).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.groups, color: Color(0xFFC2D86A), size: 20),
                SizedBox(width: 6),
                Text(
                  '${groups.length}',
                  style: TextStyle(
                    color: Color(0xFFC2D86A),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_drop_down, color: Color(0xFFC2D86A), size: 20),
              ],
            ),
          ),
          color: Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Color(0xFFC2D86A).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          offset: Offset(0, 50),
          itemBuilder: (context) {
            return groups.map((group) {
              // Determine if user is admin
              final isAdmin = group.createdBy == userId;

              return PopupMenuItem<GroupModel>(
                value: group,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFC2D86A).withValues(alpha: 0.3),
                              Color(0xFFC2D86A).withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.group,
                          color: Color(0xFFC2D86A),
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              group.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(
                                  isAdmin
                                      ? Icons.admin_panel_settings
                                      : Icons.person,
                                  color: Colors.white54,
                                  size: 12,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  isAdmin ? 'Admin' : 'Member',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.people,
                                  color: Colors.white54,
                                  size: 12,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '${group.membersList.length}',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.calendar_month,
                        color: Color(0xFFC2D86A).withValues(alpha: 0.6),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              );
            }).toList();
          },
          onSelected: (GroupModel group) {
            // Enter Group Mode in the dashboard
            final isAdmin = group.createdBy == userId;

            // Get the dashboard controller and enter group mode
            try {
              final dashboardController =
                  Get.find<ClientDashboardControllers>();
              dashboardController.enterGroupMode(group.id!, group.name);
            } catch (e) {
              print('Error entering group mode: $e');
              // Fallback: Navigate to weekly planner
              Get.toNamed(
                Routes.WEEKLY_MEAL_PLANNER,
                arguments: {
                  'id': group.id,
                  'groupId': group.id,
                  'name': group.name,
                  'isAdmin': isAdmin,
                },
              );
            }
          },
        );
      },
    );
  }
}
