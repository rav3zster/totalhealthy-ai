import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../controllers/group_controller.dart';

class GroupDetailsScreen extends StatelessWidget {
  const GroupDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get group data from arguments
    final Map<String, dynamic> group = Get.arguments ?? {};
    final controller = Get.find<GroupController>();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            // Header with gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Groups Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Group Info Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group Name
                    Text(
                      group['name'] ?? 'Weekly Meal Planning Group',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      group['description'] ??
                          'A support group for planning and tracking weekly meal prep, ideal for maintaining a balanced diet.',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Created Date
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Color(0xFFC2D86A),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Created On: ${group['createdDate'] ?? 'August 1, 2024'}',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Total Members
                    Row(
                      children: [
                        const Icon(
                          Icons.people,
                          color: Color(0xFFC2D86A),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        FutureBuilder<List<UserModel>>(
                          future: controller.getGroupMembers(group['id'] ?? ''),
                          builder: (context, snapshot) {
                            final memberCount = snapshot.data?.length ?? 0;
                            return Text(
                              'Total Members: $memberCount Members',
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Manage Members Button
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.toNamed('/member-management', arguments: group);
                      },
                      icon: const Icon(Icons.group_add, color: Colors.black),
                      label: const Text(
                        'Manage Members',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC2D86A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Members List
            Expanded(
              child: FutureBuilder<List<UserModel>>(
                future: controller.getGroupMembers(group['id'] ?? ''),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFC2D86A),
                      ),
                    );
                  }

                  final members = snapshot.data ?? [];

                  if (members.isEmpty) {
                    return const Center(
                      child: Text(
                        "No members in this group yet.",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: isAdmin
            ? Border.all(
                color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
                width: 1,
              )
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                      decoration: const BoxDecoration(
                        color: Color(0xFFC2D86A),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.star,
                        color: Colors.black,
                        size: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),

            // Member Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        member.username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (isAdmin) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC2D86A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Group Admin',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Plan: ${member.planName}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Duration: ${member.planDuration}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Email: ${member.email}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            // Action Buttons (only for non-admin members)
            if (!isAdmin)
              Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFC2D86A),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.phone,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFC2D86A),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.email,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFC2D86A),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.chat,
                        color: Colors.black,
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
