import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/group_controller.dart';
import '../../../data/models/group_model.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/phone_nav_bar.dart';
import '../../../controllers/user_controller.dart';
import '../../../core/base/controllers/auth_controller.dart';
import '../../../core/theme/theme_helper.dart';
import 'widgets/create_group_bottom_sheet.dart';

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
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header
            Container(
              decoration: BoxDecoration(
                gradient: context.headerGradient,
                boxShadow: context.cardShadow,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        Text(
                          'groups'.tr,
                          style: TextStyle(
                            color: context.textPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            gradient: context.accentGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: context.accent.withValues(alpha: 0.3),
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
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.add_rounded,
                                      color: context.backgroundColor,
                                      size: 20,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'add_group'.tr,
                                      style: TextStyle(
                                        color: context.backgroundColor,
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
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: context.border, width: 1),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          gradient: context.accentGradient,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: context.accent.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelColor: context.backgroundColor,
                        unselectedLabelColor: context.textSecondary,
                        labelStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        tabs: [
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.groups_rounded, size: 18),
                                const SizedBox(width: 6),
                                Text('groups'.tr),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.people_rounded, size: 18),
                                const SizedBox(width: 6),
                                Text('members'.tr),
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
                  Column(
                    children: [
                      // LEVEL 1: Groups Search Bar
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: context.cardGradient,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: context.accent.withValues(alpha: 0.2),
                              width: 1,
                            ),
                            boxShadow: context.cardShadow,
                          ),
                          child: TextField(
                            onChanged: (query) {
                              controller.filterGroupsInView(query);
                            },
                            style: TextStyle(color: context.textPrimary),
                            cursorColor: context.accent,
                            decoration: InputDecoration(
                              hintText: 'search_groups'.tr,
                              hintStyle: TextStyle(
                                color: context.textSecondary,
                                fontSize: 15,
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(12),
                                child: Icon(
                                  Icons.search,
                                  color: context.accent,
                                  size: 22,
                                ),
                              ),
                              suffixIcon: Obx(() {
                                if (controller
                                    .groupsViewSearchQuery
                                    .value
                                    .isNotEmpty) {
                                  return IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: context.textSecondary,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      controller.clearGroupsViewSearch();
                                    },
                                  );
                                }
                                return const SizedBox.shrink();
                              }),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Groups List - Filtered
                      Expanded(
                        child: Obx(() {
                          if (controller.isLoading.value) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: context.accent,
                              ),
                            );
                          }

                          final groups = controller.filteredGroupsView;
                          final isSearching =
                              controller.groupsViewSearchQuery.value.isNotEmpty;

                          if (groups.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isSearching
                                        ? Icons.search_off_rounded
                                        : Icons.group_off,
                                    size: 80,
                                    color: context.textTertiary,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    isSearching
                                        ? 'No groups found'
                                        : 'No groups found.\nCreate one to get started!',
                                    style: TextStyle(
                                      color: context.textPrimary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    isSearching
                                        ? 'Try a different search term'
                                        : 'Groups you create or join will appear here',
                                    style: TextStyle(
                                      color: context.textSecondary,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  if (isSearching) ...[
                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        controller.clearGroupsViewSearch();
                                      },
                                      icon: const Icon(Icons.clear, size: 18),
                                      label: const Text('Clear Search'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: context.accent,
                                        foregroundColor:
                                            context.backgroundColor,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: groups.length,
                            itemBuilder: (context, index) {
                              final group = groups[index];
                              return _buildGroupCard(group);
                            },
                          );
                        }),
                      ),
                    ],
                  ),

                  // Members Tab
                  Column(
                    children: [
                      // LEVEL 2: Global Members Search Bar
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: context.cardGradient,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: context.accent.withValues(alpha: 0.2),
                              width: 1,
                            ),
                            boxShadow: context.cardShadow,
                          ),
                          child: TextField(
                            onChanged: (query) {
                              controller.filterMembers(query);
                            },
                            style: TextStyle(color: context.textPrimary),
                            cursorColor: context.accent,
                            decoration: InputDecoration(
                              hintText: 'search_members'.tr,
                              hintStyle: TextStyle(
                                color: context.textSecondary,
                                fontSize: 15,
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(12),
                                child: Icon(
                                  Icons.search,
                                  color: context.accent,
                                  size: 22,
                                ),
                              ),
                              suffixIcon: Obx(() {
                                if (controller
                                    .membersSearchQuery
                                    .value
                                    .isNotEmpty) {
                                  return IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      color: context.textSecondary,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      controller.clearMembersSearch();
                                    },
                                  );
                                }
                                return const SizedBox.shrink();
                              }),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Members List - Filtered
                      Expanded(
                        child: Obx(() {
                          final members = controller.filteredMembers;
                          final isSearching =
                              controller.membersSearchQuery.value.isNotEmpty;

                          debugPrint(
                            '🔍 MEMBERS TAB - filteredMembers count: ${members.length}',
                          );
                          debugPrint(
                            '🔍 MEMBERS TAB - users count: ${controller.users.length}',
                          );
                          debugPrint(
                            '🔍 MEMBERS TAB - isSearching: $isSearching',
                          );

                          if (members.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    isSearching
                                        ? Icons.search_off_rounded
                                        : Icons.people_outline,
                                    size: 80,
                                    color: context.textTertiary,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    isSearching
                                        ? 'No members found'
                                        : 'No platform members found.',
                                    style: TextStyle(
                                      color: context.textPrimary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    isSearching
                                        ? 'Try a different search term'
                                        : 'Members will appear here once they sign up',
                                    style: TextStyle(
                                      color: context.textSecondary,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  if (isSearching) ...[
                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        controller.clearMembersSearch();
                                      },
                                      icon: const Icon(Icons.clear, size: 18),
                                      label: const Text('Clear Search'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: context.accent,
                                        foregroundColor:
                                            context.backgroundColor,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: members.length,
                            itemBuilder: (context, index) {
                              final user = members[index];
                              return _buildUserCard(user);
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MobileNavBar(),
    );
  }

  Widget _buildGroupCard(GroupModel group) {
    // Check if current user is admin of this group
    final authController = Get.find<AuthController>();
    final currentUserId = authController.firebaseUser.value?.uid;
    final isAdmin = currentUserId != null && group.isAdmin(currentUserId);

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
            gradient: context.cardGradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.border, width: 1.5),
            boxShadow: context.cardShadow,
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
                    // Header Row with Group Name and Delete Button
                    Row(
                      children: [
                        // Group Name
                        Expanded(
                          child: Text(
                            group.name,
                            style: TextStyle(
                              color: context.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),

                        // Delete Button (Admin Only)
                        if (isAdmin)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.red.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red,
                                size: 20,
                              ),
                              onPressed: () {
                                // Prevent card tap when deleting
                                controller.deleteGroup(group);
                              },
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(),
                              tooltip: 'Delete Group',
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      group.description,
                      style: TextStyle(
                        color: context.textSecondary,
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
                              color: context.accent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: context.accent.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  color: context.accent,
                                  size: 14,
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    'Created On: ${DateFormat('MMM dd, yyyy').format(group.createdAt)}',
                                    style: TextStyle(
                                      color: context.accent,
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
                            color: context.accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: context.accent.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.people_rounded,
                                color: context.accent,
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Obx(
                                () => Text(
                                  '${controller.totalUsers.value}',
                                  style: TextStyle(
                                    color: context.accent,
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: context.backgroundColor.withValues(alpha: 0.5),
      builder: (context) => CreateGroupBottomSheet(controller: controller),
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
          gradient: context.cardGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.border, width: 1.5),
          boxShadow: context.cardShadow,
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
                          context.textPrimary.withValues(alpha: 0.1),
                          context.textPrimary.withValues(alpha: 0.05),
                        ],
                      ),
                      boxShadow: context.cardShadow,
                    ),
                    padding: const EdgeInsets.all(3),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundImage: UserController.getImageProvider(
                        user.profileImage,
                      ),
                      child:
                          UserController.getImageProvider(user.profileImage) ==
                              null
                          ? Icon(Icons.person, color: context.textSecondary)
                          : null,
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
                          style: TextStyle(
                            color: context.textPrimary,
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
                            color: context.accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: context.accent.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.workspace_premium_rounded,
                                size: 12,
                                color: context.accent,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                user.planName,
                                style: TextStyle(
                                  color: context.accent,
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
                      color: context.cardSecondary,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: context.border, width: 1),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.info_outline_rounded,
                        color: context.textSecondary,
                        size: 20,
                      ),
                      onPressed: () {
                        Get.snackbar(
                          "Info",
                          "To invite users, please open a specific group and use the 'Manage Members' option.",
                          backgroundColor: context.cardColor,
                          colorText: context.textPrimary,
                          snackPosition: SnackPosition.BOTTOM,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12,
                          duration: const Duration(seconds: 4),
                          icon: Icon(Icons.info_rounded, color: context.accent),
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
