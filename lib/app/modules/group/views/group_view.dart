import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/group_controller.dart';
import '../../../data/models/group_model.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_pages.dart';
import '../../../core/theme/app_theme.dart';

class GroupView extends GetView<GroupController> {
  const GroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundDark,
        body: SafeArea(
          child: Column(
            children: [
              // Header with gradient background
              Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.headerGradient,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: AppTheme.textPrimary,
                            ),
                            onPressed: () {
                              Get.offNamed(Routes.ClientDashboard);
                            },
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Text('Groups', style: AppTheme.headingMedium),
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusXL,
                              ),
                            ),
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _showCreateGroupDialog(context);
                              },
                              icon: const Icon(
                                Icons.add,
                                color: AppTheme.textPrimary,
                                size: 20,
                              ),
                              label: Text(
                                'Add Group',
                                style: AppTheme.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: AppTheme.primaryButtonStyle.copyWith(
                                backgroundColor: WidgetStateProperty.all(
                                  Colors.transparent,
                                ),
                                elevation: WidgetStateProperty.all(0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingM),
                      TabBar(
                        indicatorColor: AppTheme.primaryLight,
                        labelColor: AppTheme.textPrimary,
                        unselectedLabelColor: AppTheme.textTertiary,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelStyle: AppTheme.bodyLarge,
                        unselectedLabelStyle: AppTheme.bodyMedium,
                        tabs: const [
                          Tab(text: 'Groups'),
                          Tab(text: 'Members'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              Expanded(
                child: TabBarView(
                  children: [
                    // Groups Tab
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryBase,
                          ),
                        );
                      }

                      if (controller.groupData.isEmpty) {
                        return _buildEmptyState(
                          Icons.group_off,
                          "No groups found.\nCreate one to get started!",
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingM,
                        ),
                        itemCount: controller.groupData.length,
                        itemBuilder: (context, index) {
                          final group = controller.groupData[index];
                          return _buildGroupCard(group);
                        },
                      );
                    }),

                    // Members Tab
                    Obx(() {
                      if (controller.users.isEmpty) {
                        return _buildEmptyState(
                          Icons.people_outline,
                          "No platform members found.",
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingM,
                        ),
                        itemCount: controller.users.length,
                        itemBuilder: (context, index) {
                          final user = controller.users[index];
                          return _buildUserCard(user);
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppTheme.textTertiary),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(GroupModel group) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.GROUP_DETAILS, arguments: group.toJson());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
        decoration: AppTheme.cardDecoration,
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Group Name
              Text(group.name, style: AppTheme.headingSmall),
              const SizedBox(height: AppTheme.spacingS),

              // Description
              Text(group.description, style: AppTheme.bodyMedium),
              const SizedBox(height: AppTheme.spacingM),

              // Created Date
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: AppTheme.primaryLight,
                    size: 16,
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Text(
                    'Created On: ${DateFormat('MMM dd, yyyy').format(group.createdAt)}',
                    style: AppTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingS),

              // Total Members
              Row(
                children: [
                  Icon(Icons.people, color: AppTheme.primaryLight, size: 16),
                  const SizedBox(width: AppTheme.spacingS),
                  Obx(
                    () => Text(
                      'Total Members: ${controller.totalUsers.value} Members',
                      style: AppTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
        title: Text('Create New Group', style: AppTheme.headingSmall),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: AppTheme.getInputDecoration('Group Name'),
              style: AppTheme.bodyLarge,
            ),
            const SizedBox(height: AppTheme.spacingM),
            TextField(
              controller: descriptionController,
              decoration: AppTheme.getInputDecoration('Description'),
              style: AppTheme.bodyLarge,
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel', style: AppTheme.bodyMedium),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
            ),
            child: ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final desc = descriptionController.text.trim();

                if (name.isNotEmpty) {
                  controller.createGroup(name, desc);
                  Navigator.of(context).pop();
                } else {
                  Get.snackbar(
                    "Error",
                    "Group name is required",
                    backgroundColor: AppTheme.error,
                    colorText: AppTheme.textPrimary,
                  );
                }
              },
              style: AppTheme.primaryButtonStyle.copyWith(
                backgroundColor: WidgetStateProperty.all(Colors.transparent),
                elevation: WidgetStateProperty.all(0),
              ),
              child: Text('Create', style: AppTheme.bodyLarge),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(UserModel user) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      decoration: AppTheme.cardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                user.profileImage.isNotEmpty
                    ? user.profileImage
                    : 'https://via.placeholder.com/150',
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.username, style: AppTheme.bodyLarge),
                  Text('Plan: ${user.planName}', style: AppTheme.bodySmall),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.person_add_outlined,
                  color: AppTheme.textPrimary,
                  size: 24,
                ),
                onPressed: () {
                  // For now, we'll use a placeholder group ID
                  // In a real implementation, this should be passed from the parent widget
                  controller.inviteUser(
                    user,
                    groupId: 'default',
                    groupName: 'Default Group',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
