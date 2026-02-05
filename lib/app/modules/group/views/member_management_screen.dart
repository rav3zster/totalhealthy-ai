import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../controllers/group_controller.dart';

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
                      onPressed: () => Get.back(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Manage Members - ${group['name'] ?? 'Group'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF242B33),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        indicator: BoxDecoration(
                          color: const Color(0xFFC2D86A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.white70,
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: const TextStyle(fontSize: 14),
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
              CircularProgressIndicator(color: Color(0xFFC2D86A)),
              SizedBox(height: 16),
              Text(
                'Loading members...',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
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
              Icon(Icons.people_outline, size: 64, color: Colors.white54),
              SizedBox(height: 16),
              Text(
                'No members in this group yet',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
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
              CircularProgressIndicator(color: Color(0xFFC2D86A)),
              SizedBox(height: 16),
              Text(
                'Loading available users...',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
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
              Icon(Icons.person_add_disabled, size: 64, color: Colors.white54),
              SizedBox(height: 16),
              Text(
                'No users available to invite',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                'All users are either already members or have pending invitations',
                style: TextStyle(color: Colors.white54, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
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
                      decoration: const BoxDecoration(
                        color: Color(0xFFC2D86A),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.star,
                        color: Colors.black,
                        size: 10,
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
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC2D86A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Admin',
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
                    member.email,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
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
                  color: Colors.red,
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
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
            const SizedBox(width: 16),

            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Plan: ${user.planName}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
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

              return ElevatedButton.icon(
                onPressed: isPending
                    ? null
                    : () => _inviteUser(user, controller, group),
                icon: Icon(
                  isPending ? Icons.schedule : Icons.person_add,
                  size: 16,
                  color: isPending ? Colors.white54 : Colors.black,
                ),
                label: Text(
                  isPending ? 'Pending' : 'Invite',
                  style: TextStyle(
                    color: isPending ? Colors.white54 : Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
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
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Remove Member',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to remove ${member.username} from this group?',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.removeMember(group['id'], member.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Remove',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
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
