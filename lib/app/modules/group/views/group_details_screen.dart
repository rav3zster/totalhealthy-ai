import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../controllers/group_controller.dart';
import '../../../core/theme/app_theme.dart';

class GroupDetailsScreen extends StatelessWidget {
  const GroupDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get group data from arguments
    final Map<String, dynamic> group = Get.arguments ?? {};
    final controller = Get.find<GroupController>();

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
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    const SizedBox(width: AppTheme.spacingS),
                    Text('Groups Details', style: AppTheme.headingMedium),
                  ],
                ),
              ),
            ),

            // Group Info Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
              decoration: AppTheme.highlightCardDecoration,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group Name
                    Text(
                      group['name'] ?? 'Weekly Meal Planning Group',
                      style: AppTheme.headingSmall,
                    ),
                    const SizedBox(height: AppTheme.spacingS),

                    // Description
                    Text(
                      group['description'] ??
                          'A support group for planning and tracking weekly meal prep, ideal for maintaining a balanced diet.',
                      style: AppTheme.bodyMedium,
                    ),
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
                          'Created On: ${group['createdDate'] ?? 'August 1, 2024'}',
                          style: AppTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingS),

                    // Total Members
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          color: AppTheme.primaryLight,
                          size: 16,
                        ),
                        const SizedBox(width: AppTheme.spacingS),
                        FutureBuilder<List<UserModel>>(
                          future: controller.getGroupMembers(group['id'] ?? ''),
                          builder: (context, snapshot) {
                            final memberCount = snapshot.data?.length ?? 0;
                            return Text(
                              'Total Members: $memberCount Members',
                              style: AppTheme.bodySmall,
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: AppTheme.spacingM),

                    // Manage Members Button
                    Container(
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.toNamed('/member-management', arguments: group);
                        },
                        icon: const Icon(
                          Icons.group_add,
                          color: AppTheme.textPrimary,
                        ),
                        label: Text(
                          'Manage Members',
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
              ),
            ),

            const SizedBox(height: AppTheme.spacingL),

            // Members List
            Expanded(
              child: FutureBuilder<List<UserModel>>(
                future: controller.getGroupMembers(group['id'] ?? ''),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryBase,
                      ),
                    );
                  }

                  final members = snapshot.data ?? [];

                  if (members.isEmpty) {
                    return Center(
                      child: Text(
                        "No members in this group yet.",
                        style: AppTheme.bodyMedium,
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingM,
                    ),
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      final member = members[index];
                      final isAdmin = group['created_by'] == member.id;
                      return _buildMemberCard(
                        member,
                        controller,
                        group,
                        isAdmin,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberCard(
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
                  radius: 30,
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
                        size: 12,
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
                            horizontal: AppTheme.spacingS,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusM,
                            ),
                          ),
                          child: Text(
                            'Group Admin',
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
                  Text('Plan: ${member.planName}', style: AppTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Duration: ${member.planDuration}',
                    style: AppTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text('Email: ${member.email}', style: AppTheme.bodyMedium),
                ],
              ),
            ),

            // Action Buttons (only for non-admin members)
            if (!isAdmin)
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.phone,
                        color: AppTheme.textPrimary,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.email,
                        color: AppTheme.textPrimary,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.chat,
                        color: AppTheme.textPrimary,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
