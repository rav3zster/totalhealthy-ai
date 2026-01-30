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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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

            // Group Info Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Group Name
                  Text(
                    group['name'] ?? 'Weekly Meal Planning Group',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
                      height: 1.4,
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
                      Obx(
                        () => Text(
                          'Total Members: ${controller.totalUsers.value} Members',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Members List
            Expanded(
              child: Obx(() {
                if (controller.users.isEmpty) {
                  return const Center(
                    child: Text(
                      "No members signed up yet.",
                      style: TextStyle(color: Colors.white54),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.users.length,
                  itemBuilder: (context, index) {
                    final member = controller.users[index];
                    return _buildMemberCard(member, controller, group);
                  },
                );
              }),
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
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Profile Image
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  member.profileImage.isNotEmpty
                      ? member.profileImage
                      : 'https://via.placeholder.com/150',
                ),
              ),
              const SizedBox(width: 16),

              // Member Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Name: ${member.username}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Plan Name: ${member.planName}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Plan Duration: ${member.planDuration}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Email: ${member.email}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Action Buttons
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFC2D86A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.phone,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFC2D86A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.email,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFC2D86A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chat,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Add Client Button
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Obx(() {
              final isPending = controller.sentInvitations.any(
                (n) => n.recipientId == member.id && n.groupId == group['id'],
              );

              return ElevatedButton(
                onPressed: isPending
                    ? null
                    : () {
                        controller.inviteUser(
                          member,
                          groupId: group['id'],
                          groupName: group['name'],
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPending
                      ? Colors.grey
                      : const Color(0xFFC2D86A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
                child: Text(
                  isPending ? 'Pending' : 'Add Client',
                  style: TextStyle(
                    color: isPending ? Colors.white70 : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
