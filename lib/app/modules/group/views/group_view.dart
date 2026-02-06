import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/group_controller.dart';
import '../../../data/models/group_model.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_pages.dart';

class GroupView extends GetView<GroupController> {
  const GroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A1A),
        body: SafeArea(
          child: Column(
            children: [
              // Header with gradient background
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Get.offNamed(Routes.ClientDashboard);
                            },
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Groups',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: () {
                              _showCreateGroupDialog(context);
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.black,
                              size: 20,
                            ),
                            label: const Text(
                              'Add Group',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC2D86A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TabBar(
                        indicatorColor: const Color(0xFFC2D86A),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white54,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        unselectedLabelStyle: const TextStyle(fontSize: 14),
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
                            color: Color(0xFFC2D86A),
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
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
          Icon(icon, size: 64, color: Colors.white54),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
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
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Group Name
              Text(
                group.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                group.description,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
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
                    'Created On: ${DateFormat('MMM dd, yyyy').format(group.createdAt)}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Total Members
              Row(
                children: [
                  const Icon(Icons.people, color: Color(0xFFC2D86A), size: 16),
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
      ),
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Create New Group',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Group Name',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF1E252D),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFC2D86A),
                    width: 2,
                  ),
                ),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: const Color(0xFF1E252D),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFC2D86A),
                    width: 2,
                  ),
                ),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          ElevatedButton(
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
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC2D86A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Create',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(UserModel user) {
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
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                user.profileImage.isNotEmpty
                    ? user.profileImage
                    : 'https://via.placeholder.com/150',
              ),
            ),
            const SizedBox(width: 16),
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
                  Text(
                    'Plan: ${user.planName}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.info_outline,
                  color: Colors.white54,
                  size: 24,
                ),
                onPressed: () {
                  Get.snackbar(
                    "Info",
                    "To invite users, please open a specific group and use the 'Manage Members' option.",
                    backgroundColor: const Color(0xFF2A2A2A),
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(16),
                    borderRadius: 12,
                    duration: const Duration(seconds: 4),
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
