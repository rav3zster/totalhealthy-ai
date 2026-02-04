import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../controllers/group_controller.dart';
import '../../../core/theme/app_theme.dart';

class MemberManagementScreen extends StatelessWidget {
  const MemberManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> group = Get.arguments ?? {};
    final controller = Get.find<GroupController>();
    final groupId = group['id'] ?? '';

    // Set current group for member management
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setCurrentGroup(groupId);
    });

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header with gradient
            Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.headerGradient,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: AppTheme.textPrimary,
                      ),
                      onPressed: () => Get.back(),
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                    Expanded(
                      child: Text(
                        'Manage Members - ${group['name'] ?? 'Group'}',
                        style: AppTheme.headingSmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
              decoration: AppTheme.cardDecoration,
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.subtleGradient,
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        ),
                        labelColor: AppTheme.textPrimary,
                        unselectedLabelColor: AppTheme.textSecondary,
                        labelStyle: AppTheme.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: AppTheme.bodyMedium,
                        tabs: const [
                          Tab(text: 'Current Members'),
                          Tab(text: 'Invite Users'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      child: TabBarView(
                        children: [
                          _buildCurrentMembersTab(controller, group),
                          _buildInviteUsersTab(controller, group),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentMembersTab(
    GroupController controller,
    Map<String, dynamic> group,
  ) {
    return Obx(() {
      if (controller.isMemberLoading.value) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppTheme.primaryBase),
              SizedBox(height: AppTheme.spacingM),
              Text('Loading members...', style: AppTheme.bodyMedium),
            ],
          ),
        );
      }

      final members = controller.groupMembers;
      final currentGroup = controller.currentGroup.value;

      if (members.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                size: 64,
                color: AppTheme.textTertiary,
              ),
              SizedBox(height: AppTheme.spacingM),
              Text('No members in this group yet', style: AppTheme.bodyMedium),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        itemCount: members.length,
        itemBuilder: (context, index) {
          final member = members[index];
          final isAdmin = currentGroup?.isAdmin(member.id) ?? false;
          return _buildCurrentMemberCard(member, controller, group, isAdmin);
        },
      );
    });
  }

  Widget _buildInviteUsersTab(
    GroupController controller,
    Map<String, dynamic> group,
  ) {
    return Obx(() {
      if (controller.isMemberLoading.value) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppTheme.primaryBase),
              SizedBox(height: AppTheme.spacingM),
              Text('Loading available users...', style: AppTheme.bodyMedium),
            ],
          ),
        );
      }

      final availableUsers = controller.availableUsers;

      if (availableUsers.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_add_disabled,
                size: 64,
                color: AppTheme.textTertiary,
              ),
              SizedBox(height: AppTheme.spacingM),
              Text('No users available to invite', style: AppTheme.bodyMedium),
              SizedBox(height: AppTheme.spacingS),
              Text(
                'All users are either already members or have pending invitations',
                style: AppTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        itemCount: availableUsers.length,
        itemBuilder: (context, index) {
          final user = availableUsers[index];
          return _buildInviteUserCard(user, controller, group);
        },
      );
    });
  }

  Widget _buildCurrentMemberCard(
    UserModel member,
    GroupController controller,
    Map<String, dynamic> group,
    bool isAdmin,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      decoration: isAdmin
          ? AppTheme.highlightCardDecoration
          : AppTheme.cardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Row(
          children: [
            // Profile Image with admin indicator
            Stack(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    member.profileImage.isNotEmpty
                        ? member.profileImage
                        : 'https://via.placeholder.com/150',
                  ),
                ),
                if (isAdmin)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.star,
                        color: AppTheme.textPrimary,
                        size: 10,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: AppTheme.spacingM),

            // Member Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(member.username, style: AppTheme.bodyLarge),
                      if (isAdmin) ...[
                        const SizedBox(width: AppTheme.spacingS),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Admin',
                            style: AppTheme.caption.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(member.email, style: AppTheme.bodyMedium),
                ],
              ),
            ),

            // Remove Button (only for non-admin members)
            if (!isAdmin)
              IconButton(
                onPressed: () =>
                    _showRemoveMemberDialog(member, controller, group),
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: AppTheme.error,
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteUserCard(
    UserModel user,
    GroupController controller,
    Map<String, dynamic> group,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
      decoration: AppTheme.cardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Row(
          children: [
            // Profile Image
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                user.profileImage.isNotEmpty
                    ? user.profileImage
                    : 'https://via.placeholder.com/150',
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),

            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.username, style: AppTheme.bodyLarge),
                  const SizedBox(height: 4),
                  Text(user.email, style: AppTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Text('Plan: ${user.planName}', style: AppTheme.bodySmall),
                ],
              ),
            ),

            // Invite Button
            Obx(() {
              // Check invitation status
              final invitation = controller.sentInvitations.firstWhereOrNull(
                (n) => n.recipientId == user.id && n.groupId == group['id'],
              );

              final isPending = invitation != null;

              return Container(
                decoration: BoxDecoration(
                  gradient: isPending ? null : AppTheme.primaryGradient,
                  color: isPending ? AppTheme.textTertiary : null,
                  borderRadius: BorderRadius.circular(AppTheme.radiusXL),
                ),
                child: ElevatedButton.icon(
                  onPressed: isPending
                      ? null
                      : () => _inviteUser(user, controller, group),
                  icon: Icon(
                    isPending ? Icons.schedule : Icons.person_add,
                    size: 16,
                    color: AppTheme.textPrimary,
                  ),
                  label: Text(
                    isPending ? 'Pending' : 'Invite',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textPrimary,
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
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showRemoveMemberDialog(
    UserModel member,
    GroupController controller,
    Map<String, dynamic> group,
  ) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
        title: Text('Remove Member', style: AppTheme.headingSmall),
        content: Text(
          'Are you sure you want to remove ${member.username} from this group?',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: AppTheme.bodyMedium),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.error,
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
            ),
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                controller.removeMember(group['id'], member.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              child: Text(
                'Remove',
                style: AppTheme.bodyLarge.copyWith(color: AppTheme.textPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _inviteUser(
    UserModel user,
    GroupController controller,
    Map<String, dynamic> group,
  ) {
    controller.inviteUserToGroup(
      user,
      groupId: group['id'],
      groupName: group['name'],
    );
  }
}
