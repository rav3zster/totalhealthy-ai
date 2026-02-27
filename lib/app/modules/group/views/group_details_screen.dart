import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../core/base/controllers/auth_controller.dart';
import '../../../widgets/member_action_menu.dart';
import 'group_meal_chat_view.dart';
import '../controllers/group_controller.dart';
import '../../../controllers/user_controller.dart';
import '../../../core/theme/theme_helper.dart';

class GroupDetailsScreen extends StatefulWidget {
  const GroupDetailsScreen({super.key});

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, dynamic> _groupData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Store group data from arguments once during initialization
    final arguments = Get.arguments;
    if (arguments is Map<String, dynamic>) {
      _groupData = arguments;
    } else {
      _groupData = {};
    }

    // Load group members when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('🔍 GROUP DETAILS DEBUG - Received arguments: $_groupData');
      final groupId = _groupData['id'] ?? '';
      print('🔍 GROUP DETAILS DEBUG - Group ID: $groupId');
      if (groupId.isNotEmpty) {
        final controller = Get.find<GroupController>();
        print(
          '🔍 GROUP DETAILS DEBUG - Calling setCurrentGroup with ID: $groupId',
        );
        controller.setCurrentGroup(groupId);
      } else {
        print('❌ GROUP DETAILS DEBUG - Group ID is empty!');
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use stored group data instead of Get.arguments
    final Map<String, dynamic> group = _groupData;
    final controller = Get.find<GroupController>();

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
                        Container(
                          decoration: BoxDecoration(
                            color: context.cardSecondary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: context.accent,
                              size: 20,
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Group Details',
                            style: TextStyle(
                              color: context.textPrimary,
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        // Leave Group Button
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.orange.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.exit_to_app_rounded,
                              color: Colors.orange,
                              size: 22,
                            ),
                            onPressed: () {
                              final authController = Get.find<AuthController>();
                              final currentUserId =
                                  authController.firebaseUser.value?.uid;
                              final groupId = group['id'] ?? '';
                              final groupName = group['name'] ?? 'Group';
                              final adminId = group['created_by'] ?? '';
                              final isAdmin = currentUserId == adminId;

                              if (isAdmin) {
                                controller.adminLeaveGroup(groupId, groupName);
                              } else {
                                controller.memberLeaveGroup(groupId, groupName);
                              }
                            },
                            tooltip: 'Leave Group',
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
                        tabs: const [
                          Tab(child: Text('Overview')),
                          Tab(child: Text('Members')),
                          Tab(child: Text('Meal Plan')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Overview Tab
                  _buildOverviewTab(group, controller),

                  // Members Tab
                  _buildMembersTab(group, controller),

                  // Meal Plan Tab
                  GroupMealChatView(
                    groupId: group['id'] ?? '',
                    isAdmin:
                        group['created_by'] ==
                        Get.find<AuthController>().userdataget()['id'],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(
    Map<String, dynamic> group,
    GroupController controller,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Group Info Card
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.95 + (0.05 * value),
                child: Opacity(opacity: value, child: child),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: context.cardGradient,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: context.accent.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: context.cardShadow,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Group Name
                    Text(
                      group['name'] ?? 'Weekly Meal Planning Group',
                      style: TextStyle(
                        color: context.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Description
                    Text(
                      group['description'] ??
                          'A support group for planning and tracking weekly meal prep, ideal for maintaining a balanced diet.',
                      style: TextStyle(
                        color: context.textSecondary,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Info Row
                    Row(
                      children: [
                        // Created Date
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: context.accent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: context.accent.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.calendar_today_rounded,
                                  color: context.accent,
                                  size: 20,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Created On',
                                  style: TextStyle(
                                    color: context.textTertiary,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  group['createdDate'] ?? 'August 1, 2024',
                                  style: TextStyle(
                                    color: context.accent,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Total Members
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: context.accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: context.accent.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.people_rounded,
                                color: context.accent,
                                size: 20,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Members',
                                style: TextStyle(
                                  color: context.textTertiary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              FutureBuilder<List<UserModel>>(
                                future: controller.getGroupMembers(
                                  group['id'] ?? '',
                                ),
                                builder: (context, snapshot) {
                                  final memberCount =
                                      snapshot.data?.length ?? 0;
                                  return Text(
                                    '$memberCount',
                                    style: TextStyle(
                                      color: context.accent,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Manage Members Button
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: context.accentGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: context.accent.withValues(alpha: 0.3),
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
                            Get.toNamed('/member-management', arguments: group);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.group_add_rounded,
                                  color: context.backgroundColor,
                                  size: 22,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Manage Members',
                                  style: TextStyle(
                                    color: context.backgroundColor,
                                    fontSize: 16,
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersTab(
    Map<String, dynamic> group,
    GroupController controller,
  ) {
    // CRITICAL: Persistent controllers for LEVEL 3 search - NEVER recreate these
    final TextEditingController memberSearchController =
        TextEditingController();
    final FocusNode memberSearchFocusNode = FocusNode();

    return Column(
      children: [
        // LEVEL 3: Members Search Bar (scoped to THIS group only)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
              controller: memberSearchController,
              focusNode: memberSearchFocusNode,
              onChanged: (query) {
                // Trigger member filtering for THIS group only
                controller.filterGroupMembers(query);
              },
              style: TextStyle(color: context.textPrimary),
              cursorColor: context.accent,
              decoration: InputDecoration(
                hintText: 'Search members in this group...',
                hintStyle: TextStyle(
                  color: context.textSecondary,
                  fontSize: 14,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(12),
                  child: Icon(Icons.search, color: context.accent, size: 20),
                ),
                suffixIcon: Obx(() {
                  if (controller.groupMembersSearchQuery.value.isNotEmpty) {
                    return IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: context.textSecondary,
                        size: 18,
                      ),
                      onPressed: () {
                        memberSearchController.clear();
                        controller.clearGroupMembersSearch();
                        memberSearchFocusNode.unfocus();
                      },
                    );
                  }
                  return const SizedBox.shrink();
                }),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Members List - Filtered
        Expanded(
          child: Obx(() {
            // Use filtered members from controller
            final members = controller.filteredGroupMembers;
            final isSearching =
                controller.groupMembersSearchQuery.value.isNotEmpty;

            print(
              '🔍 MEMBERS TAB DEBUG - filteredGroupMembers count: ${members.length}',
            );
            print(
              '🔍 MEMBERS TAB DEBUG - groupMembers count: ${controller.groupMembers.length}',
            );
            print('🔍 MEMBERS TAB DEBUG - isSearching: $isSearching');
            print(
              '🔍 MEMBERS TAB DEBUG - isMemberLoading: ${controller.isMemberLoading.value}',
            );

            if (controller.isMemberLoading.value) {
              return Center(
                child: CircularProgressIndicator(color: context.accent),
              );
            }

            if (members.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isSearching
                          ? Icons.search_off_rounded
                          : Icons.people_outline_rounded,
                      size: 64,
                      color: context.textTertiary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isSearching
                          ? "No members found"
                          : "No members in this group yet.",
                      style: TextStyle(
                        color: context.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                    if (isSearching) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Try a different search term',
                        style: TextStyle(
                          color: context.textTertiary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          memberSearchController.clear();
                          controller.clearGroupMembersSearch();
                        },
                        icon: const Icon(Icons.clear, size: 16),
                        label: const Text('Clear Search'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.accent,
                          foregroundColor: context.backgroundColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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
                final member = members[index];
                final isAdmin = group['created_by'] == member.id;
                return _buildMemberCard(
                  member,
                  controller,
                  group,
                  isAdmin,
                  index,
                );
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMemberCard(
    UserModel member,
    GroupController controller,
    Map<String, dynamic> group,
    bool isAdmin,
    int index,
  ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: context.cardGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isAdmin
                ? context.accent.withValues(alpha: 0.4)
                : context.border,
            width: 1.5,
          ),
          boxShadow: context.cardShadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              // Show member action menu
              MemberActionMenu.show(context, member, isAdmin);
            },
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  // Profile Image with admin indicator
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: isAdmin
                                ? [
                                    context.accent,
                                    context.accent.withValues(alpha: 0.8),
                                  ]
                                : [
                                    context.textPrimary.withValues(alpha: 0.1),
                                    context.textPrimary.withValues(alpha: 0.05),
                                  ],
                          ),
                          boxShadow: context.cardShadow,
                        ),
                        padding: const EdgeInsets.all(2),
                        child: CircleAvatar(
                          radius: 26,
                          backgroundImage: UserController.getImageProvider(
                            member.profileImage,
                          ),
                          child:
                              UserController.getImageProvider(
                                    member.profileImage,
                                  ) ==
                                  null
                              ? Icon(Icons.person, color: context.textSecondary)
                              : null,
                        ),
                      ),
                      if (isAdmin)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              gradient: context.accentGradient,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: context.backgroundColor,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: context.accent.withValues(alpha: 0.6),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.star_rounded,
                              color: context.backgroundColor,
                              size: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),

                  // Member Info - Compact Layout
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Name and Admin Badge Row
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                member.username,
                                style: TextStyle(
                                  color: context.textPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isAdmin) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  gradient: context.accentGradient,
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: context.accent.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  'ADMIN',
                                  style: TextStyle(
                                    color: context.backgroundColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Compact Info Grid
                        Row(
                          children: [
                            // Plan
                            Expanded(
                              child: _buildCompactInfo(
                                Icons.workspace_premium_rounded,
                                member.planName,
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Duration
                            Expanded(
                              child: _buildCompactInfo(
                                Icons.schedule_rounded,
                                member.planDuration,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        // Email and Action Buttons Row
                        Row(
                          children: [
                            Expanded(
                              child: _buildCompactInfo(
                                Icons.email_rounded,
                                member.email,
                              ),
                            ),
                            // Action Buttons (only for non-admin members)
                            if (!isAdmin) ...[
                              const SizedBox(width: 8),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildCompactActionButton(
                                    Icons.phone_rounded,
                                    () {},
                                  ),
                                  const SizedBox(width: 6),
                                  _buildCompactActionButton(
                                    Icons.email_rounded,
                                    () {},
                                  ),
                                  const SizedBox(width: 6),
                                  _buildCompactActionButton(
                                    Icons.chat_rounded,
                                    () {},
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ],
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

  Widget _buildCompactInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: context.accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 11, color: context.accent),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: context.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCompactActionButton(IconData icon, VoidCallback onTap) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: context.accentGradient,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: context.accent.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Icon(icon, color: context.backgroundColor, size: 15),
        ),
      ),
    );
  }
}
