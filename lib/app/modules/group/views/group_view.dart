import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/group_controller.dart';
import '../../../data/models/group_model.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/phone_nav_bar.dart';

class GroupView extends StatefulWidget {
  const GroupView({super.key});

  @override
  State<GroupView> createState() => _GroupViewState();
}

class _GroupViewState extends State<GroupView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final controller = Get.find<GroupController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    OntapStore.index = 1; // Set to Groups tab
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFF1E1E1E), const Color(0xFF121212)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        const Text(
                          'Groups',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFC2D86A), Color(0xFFD4E87C)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFC2D86A,
                                ).withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                _showCreateGroupDialog(context);
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add_rounded,
                                      color: Color(0xFF121212),
                                      size: 20,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Add Group',
                                      style: TextStyle(
                                        color: Color(0xFF121212),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Modern Tab Bar
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.05),
                          width: 1,
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFC2D86A), Color(0xFFD4E87C)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFC2D86A,
                              ).withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelColor: const Color(0xFF121212),
                        unselectedLabelColor: Colors.white.withValues(
                          alpha: 0.5,
                        ),
                        labelStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        tabs: const [
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.groups_rounded, size: 18),
                                SizedBox(width: 6),
                                Text('Groups'),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.people_rounded, size: 18),
                                SizedBox(width: 6),
                                Text('Members'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
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
      bottomNavigationBar: const MobileNavBar(),
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
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTap: () {
          Get.toNamed(Routes.GROUP_DETAILS, arguments: group.toJson());
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E1E1E), Color(0xFF1A1A1A)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Get.toNamed(Routes.GROUP_DETAILS, arguments: group.toJson());
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group Name
                    Text(
                      group.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      group.description,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),

                    // Info Row
                    Row(
                      children: [
                        // Created Date
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFC2D86A,
                              ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(
                                  0xFFC2D86A,
                                ).withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  color: Color(0xFFC2D86A),
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    'Created On: ${DateFormat('MMM dd, yyyy').format(group.createdAt)}',
                                    style: const TextStyle(
                                      color: Color(0xFFC2D86A),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Total Members
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFC2D86A,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(
                                0xFFC2D86A,
                              ).withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.people_rounded,
                                color: Color(0xFFC2D86A),
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Obx(
                                () => Text(
                                  '${controller.totalUsers.value}',
                                  style: const TextStyle(
                                    color: Color(0xFFC2D86A),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (0.05 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E1E1E), Color(0xFF1A1A1A)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Modern Profile Image
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.1),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(3),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(
                        user.profileImage.isNotEmpty
                            ? user.profileImage
                            : 'https://via.placeholder.com/150',
                      ),
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
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.3,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFC2D86A,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(
                                0xFFC2D86A,
                              ).withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.workspace_premium_rounded,
                                size: 12,
                                color: Color(0xFFC2D86A),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                user.planName,
                                style: const TextStyle(
                                  color: Color(0xFFC2D86A),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Info Button
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.info_outline_rounded,
                        color: Colors.white.withValues(alpha: 0.6),
                        size: 20,
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
                          icon: const Icon(
                            Icons.info_rounded,
                            color: Color(0xFFC2D86A),
                          ),
                        );
                      },
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
