import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:totalhealthy/app/core/base/controllers/auth_controller.dart';
import 'package:totalhealthy/app/data/models/user_model.dart';
import 'package:totalhealthy/app/data/models/group_model.dart';
import 'package:totalhealthy/app/data/models/group_category_model.dart';
import 'package:totalhealthy/app/data/services/groups_firestore_service.dart';
import 'package:totalhealthy/app/data/services/users_firestore_service.dart';
import 'package:totalhealthy/app/data/services/notifications_firestore_service.dart';
import 'package:totalhealthy/app/data/services/group_categories_firestore_service.dart';
import 'package:totalhealthy/app/data/models/notification_model.dart';
import 'package:totalhealthy/app/data/services/role_permissions_service.dart';

class GroupController extends GetxController {
  final GroupsFirestoreService _groupsService = GroupsFirestoreService();
  final UsersFirestoreService _usersService = UsersFirestoreService();
  final NotificationsFirestoreService _notificationsService =
      NotificationsFirestoreService();
  final GroupCategoriesFirestoreService _groupCategoriesService =
      GroupCategoriesFirestoreService();
  final RolePermissionsService _permissionsService = RolePermissionsService();

  final groupData = <GroupModel>[].obs;
  final users = <UserModel>[].obs; // All system users
  final sentInvitations =
      <AppNotification>[].obs; // Invitations sent by current user
  final isLoading = true.obs;
  final totalUsers = 0.obs;

  // Group categories for create dialog
  final groupCategories = <GroupCategoryModel>[].obs;
  final selectedGroupCategory = Rxn<GroupCategoryModel>();
  final isLoadingCategories = false.obs;

  // New reactive state for member management
  final Rx<GroupModel?> currentGroup = Rx<GroupModel?>(null);
  final RxList<UserModel> groupMembers = <UserModel>[].obs;
  final RxList<UserModel> availableUsers = <UserModel>[].obs;
  final RxBool isMemberLoading = false.obs;

  // LEVEL 1: Groups Search State (scoped to Groups list only)
  final RxString groupSearchQuery = ''.obs;
  final RxList<Map<String, dynamic>> filteredGroups =
      <Map<String, dynamic>>[].obs;

  // LEVEL 1b: Groups View Search State (scoped to Groups tab in group_view.dart)
  final RxString groupsViewSearchQuery = ''.obs;
  final RxList<GroupModel> filteredGroupsView = <GroupModel>[].obs;

  // LEVEL 2: Global Members Search State (scoped to Members tab only)
  final RxString membersSearchQuery = ''.obs;
  final RxList<UserModel> filteredMembers = <UserModel>[].obs;

  // LEVEL 3: Group Details Members Search State (scoped to specific group members only)
  final RxString groupMembersSearchQuery = ''.obs;
  final RxList<UserModel> filteredGroupMembers = <UserModel>[].obs;

  // LEVEL 4: Member Management Invite Search State (scoped to available users in invite tab)
  final RxString availableUsersSearchQuery = ''.obs;
  final RxList<UserModel> filteredAvailableUsers = <UserModel>[].obs;

  /// Initialize filtered groups list when groups data changes
  @override
  void onInit() {
    super.onInit();
    print("GroupController: onInit called");

    // Initialize immediately after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initGroups();
      _initUsers();
    });

    // Listen for auth state changes and refresh groups
    final authController = Get.find<AuthController>();
    ever(authController.firebaseUser, (User? user) {
      print("GroupController: Auth state changed - User: ${user?.uid}");
      if (user != null) {
        // User logged in, refresh groups with their data
        groupData.bindStream(_groupsService.getUserGroupsStream(user.uid));
      } else {
        // User logged out, clear groups
        groupData.value = [];
        filteredGroups.value = [];
      }
    });

    // Initialize filtered groups when groupData changes
    ever(groupData, (_) {
      if (groupSearchQuery.value.isEmpty) {
        filteredGroups.value = groupData
            .map(
              (group) => {
                'id': group.id,
                'name': group.name,
                'description': group.description,
                'createdDate': group.createdAt.toString(),
                'created_by': group.createdBy,
              },
            )
            .toList();
      } else {
        filterGroups(groupSearchQuery.value);
      }

      // Also initialize filteredGroupsView for the Groups tab
      if (groupsViewSearchQuery.value.isEmpty) {
        filteredGroupsView.value = groupData;
      } else {
        filterGroupsInView(groupsViewSearchQuery.value);
      }
    });

    // Initialize filtered group members when groupMembers changes
    ever(groupMembers, (_) {
      print(
        '🔍 EVER LISTENER - groupMembers changed, count: ${groupMembers.length}',
      );
      print(
        '🔍 EVER LISTENER - groupMembersSearchQuery: "${groupMembersSearchQuery.value}"',
      );
      if (groupMembersSearchQuery.value.isEmpty) {
        filteredGroupMembers.value = groupMembers;
        print(
          '🔍 EVER LISTENER - Set filteredGroupMembers to ${filteredGroupMembers.length} members',
        );
      } else {
        filterGroupMembers(groupMembersSearchQuery.value);
        print(
          '🔍 EVER LISTENER - Filtered to ${filteredGroupMembers.length} members',
        );
      }
    });

    // Initialize filtered members when users changes (LEVEL 2 search)
    ever(users, (_) {
      print('🔍 EVER LISTENER - users changed, count: ${users.length}');
      print(
        '🔍 EVER LISTENER - membersSearchQuery: "${membersSearchQuery.value}"',
      );
      if (membersSearchQuery.value.isEmpty) {
        filteredMembers.value = users;
        print(
          '🔍 EVER LISTENER - Set filteredMembers to ${filteredMembers.length} members',
        );
      } else {
        filterMembers(membersSearchQuery.value);
        print(
          '🔍 EVER LISTENER - Filtered to ${filteredMembers.length} members',
        );
      }
    });

    // Initialize filtered available users when availableUsers changes (LEVEL 4 search)
    ever(availableUsers, (_) {
      print(
        '🔍 EVER LISTENER - availableUsers changed, count: ${availableUsers.length}',
      );
      print(
        '🔍 EVER LISTENER - availableUsersSearchQuery: "${availableUsersSearchQuery.value}"',
      );
      if (availableUsersSearchQuery.value.isEmpty) {
        filteredAvailableUsers.value = availableUsers;
        print(
          '🔍 EVER LISTENER - Set filteredAvailableUsers to ${filteredAvailableUsers.length} users',
        );
      } else {
        filterAvailableUsers(availableUsersSearchQuery.value);
        print(
          '🔍 EVER LISTENER - Filtered to ${filteredAvailableUsers.length} users',
        );
      }
    });
  }

  void _initUsers() {
    print("GroupController: Initializing users");
    totalUsers.bindStream(_usersService.getTotalUsersCountStream());
    users.bindStream(_usersService.getUsersStream());

    final authController = Get.find<AuthController>();
    final currentUser = authController.firebaseUser.value;
    if (currentUser != null) {
      print(
        "GroupController: Binding to invitations stream for user: ${currentUser.uid}",
      );
      sentInvitations.bindStream(
        _notificationsService.getSentInvitationsStream(currentUser.uid),
      );
    }
  }

  void _initGroups() {
    print("GroupController: Initializing groups");
    isLoading.value = true;

    // Get current user ID
    final authController = Get.find<AuthController>();
    final currentUser = authController.firebaseUser.value;
    final currentUserId = currentUser?.uid;

    if (currentUserId != null) {
      print(
        "GroupController: Binding to groups stream for user: $currentUserId",
      );
      // Bind the groupData to the filtered Firestore stream
      groupData.bindStream(_groupsService.getUserGroupsStream(currentUserId));
    } else {
      print("GroupController: No user logged in, showing empty list");
      // If no user is logged in, show empty list
      groupData.value = [];
    }

    // Set isLoading to false when the first batch of data is received
    ever(groupData, (_) {
      print("GroupController: Groups data received, clearing loading state");
      isLoading.value = false;
    });

    // Safety timeout
    Future.delayed(const Duration(seconds: 5), () {
      if (isLoading.value) {
        print("GroupController: Timeout reached, clearing loading state");
        isLoading.value = false;
      }
    });
  }

  Future<void> createGroup(
    String name,
    String description, {
    String? groupCategoryId,
  }) async {
    try {
      // RBAC: Validate permission to create group
      final validationError = _permissionsService.validateGroupCreation();
      if (validationError != null) {
        Get.snackbar(
          "Permission Denied",
          validationError,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (name.trim().isEmpty) {
        Get.snackbar(
          "Error",
          "Group name cannot be empty",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      isLoading.value = true;
      final authController = Get.find<AuthController>();
      final currentUser = authController.firebaseUser.value;
      final currentUserId = currentUser?.uid ?? 'unknown';

      final newGroup = GroupModel(
        name: name.trim(),
        description: description.trim(),
        groupCategoryId: groupCategoryId, // Add category reference
        createdBy: currentUserId,
        membersList: [
          currentUserId, // Admin is automatically a member
        ],
        createdAt: DateTime.now(),
      );

      await _groupsService.addGroup(newGroup);

      Get.snackbar(
        'Success',
        'Group "$name" created successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print("Error creating group: $e");
      Get.snackbar(
        'Error',
        'Failed to create group: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Load group categories for the create dialog
  Future<void> loadGroupCategories() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      isLoadingCategories.value = true;
      final categories = await _groupCategoriesService.getGroupCategories(
        userId,
      );
      groupCategories.value = categories;

      // Don't auto-select - let user choose explicitly
      selectedGroupCategory.value = null;
    } catch (e) {
      print('Error loading group categories: $e');
    } finally {
      isLoadingCategories.value = false;
    }
  }

  /// Select a group category
  void selectGroupCategory(GroupCategoryModel? category) {
    selectedGroupCategory.value = category;
  }

  /// Delete a group (admin only)
  /// Only the group creator can delete the group
  Future<void> deleteGroup(GroupModel group) async {
    try {
      // Verify user is admin of the group
      final authController = Get.find<AuthController>();
      final currentUser = authController.firebaseUser.value;
      final currentUserId = currentUser?.uid;

      if (currentUserId == null) {
        Get.snackbar(
          "Error",
          "You must be logged in to delete a group",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Check if user is the creator (admin)
      if (!group.isAdmin(currentUserId)) {
        Get.snackbar(
          "Permission Denied",
          "Only the group admin can delete this group",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (group.id == null) {
        Get.snackbar(
          "Error",
          "Invalid group ID",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Show confirmation dialog
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.orange, size: 28),
              SizedBox(width: 12),
              Text(
                'Delete Group?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to delete "${group.name}"?',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This action cannot be undone. All group data will be permanently deleted.',
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );

      if (confirmed != true) {
        return; // User cancelled
      }

      isLoading.value = true;

      // Delete the group
      await _groupsService.deleteGroup(group.id!);

      Get.snackbar(
        'Success',
        'Group "${group.name}" deleted successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      print('Group ${group.id} deleted successfully');
    } catch (e) {
      print("Error deleting group: $e");
      Get.snackbar(
        'Error',
        'Failed to delete group: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Member leaves group (simple confirmation)
  /// Only for non-admin members
  Future<void> memberLeaveGroup(String groupId, String groupName) async {
    try {
      final authController = Get.find<AuthController>();
      final currentUserId = authController.firebaseUser.value?.uid;

      if (currentUserId == null) {
        Get.snackbar(
          "Error",
          "You must be logged in to leave a group",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Show confirmation dialog
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.exit_to_app_rounded, color: Colors.orange, size: 28),
              SizedBox(width: 12),
              Text(
                'Leave Group?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to leave "$groupName"?',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You will lose access to group meals and plans.',
                        style: TextStyle(color: Colors.orange, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Leave',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );

      if (confirmed != true) {
        return; // User cancelled
      }

      isLoading.value = true;

      // Leave the group
      await _groupsService.memberLeaveGroup(groupId, currentUserId);

      isLoading.value = false;

      Get.snackbar(
        'Success',
        'You have left "$groupName"',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Navigate back to groups list (pop all group-related screens)
      Get.until((route) => route.settings.name == '/groups' || route.isFirst);

      print('Member $currentUserId left group $groupId');
    } catch (e) {
      print("Error leaving group: $e");
      Get.snackbar(
        'Error',
        'Failed to leave group: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Admin leaves group with ownership transfer
  /// Shows dialog to select new admin from members
  Future<void> adminLeaveGroup(String groupId, String groupName) async {
    try {
      final authController = Get.find<AuthController>();
      final currentUserId = authController.firebaseUser.value?.uid;

      if (currentUserId == null) {
        Get.snackbar(
          "Error",
          "You must be logged in to leave a group",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      isLoading.value = true;

      print('=== ADMIN LEAVE VALIDATION ===');
      print('Group ID: $groupId');
      print('Current Admin ID: $currentUserId');
      print('Querying Firestore: groups/$groupId/members');

      // Fetch ALL members from Firestore subcollection
      // Auto-healing will create admin membership if missing
      final allMemberIds = await _groupsService.getGroupMembers(groupId);

      print('Total members in subcollection: ${allMemberIds.length}');
      print('All member IDs: $allMemberIds');

      // Filter out current admin to get OTHER members
      final otherMemberIds = allMemberIds
          .where((id) => id != currentUserId)
          .toList();

      print('Other members (excluding admin): ${otherMemberIds.length}');
      print('Other member IDs: $otherMemberIds');
      print('==============================');

      // Check if there are other members besides the admin
      if (otherMemberIds.isEmpty) {
        isLoading.value = false;
        print('❌ No other members - admin cannot leave');

        // Show dialog suggesting to delete group instead
        await Get.dialog(
          AlertDialog(
            backgroundColor: const Color(0xFF2A2A2A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange, size: 28),
                SizedBox(width: 12),
                Text(
                  'Cannot Leave Group',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'You are the only member of this group.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC2D86A).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Color(0xFFC2D86A),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Invite members first, or delete the group instead.',
                          style: TextStyle(
                            color: Color(0xFFC2D86A),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Color(0xFFC2D86A),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
        return;
      }

      print('✓ ${otherMemberIds.length} other members available for transfer');

      // Get member details for display
      final memberUsers = <UserModel>[];
      for (final memberId in otherMemberIds) {
        final user = users.firstWhereOrNull((u) => u.id == memberId);
        if (user != null) {
          memberUsers.add(user);
          print('  - ${user.username} (${user.id})');
        } else {
          print('  - Warning: User $memberId not found in users list');
        }
      }

      isLoading.value = false;

      if (memberUsers.isEmpty) {
        print('❌ No valid user details found');
        Get.snackbar(
          "Cannot Leave",
          "No valid members found to transfer ownership",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      print('✓ ${memberUsers.length} valid users for selection');

      // Show confirmation dialog first
      final shouldProceed = await Get.dialog<bool>(
        AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.admin_panel_settings_rounded,
                color: Color(0xFFC2D86A),
                size: 28,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'You are the Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'As the admin, you must assign a new admin before leaving.',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFC2D86A).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xFFC2D86A),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Select a member to become the new admin.',
                        style: TextStyle(
                          color: Color(0xFFC2D86A),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC2D86A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Assign New Admin',
                style: TextStyle(
                  color: Color(0xFF121212),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );

      if (shouldProceed != true) {
        return; // User cancelled
      }

      // Show member selection dialog
      final selectedUser = await Get.dialog<UserModel>(
        AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.person_add_alt_1_rounded,
                color: Color(0xFFC2D86A),
                size: 28,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Select New Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose a member to transfer admin rights:',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                constraints: const BoxConstraints(maxHeight: 300),
                child: SingleChildScrollView(
                  child: Column(
                    children: memberUsers.map((user) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: user.profileImage != null
                                ? NetworkImage(user.profileImage!)
                                : null,
                            child: user.profileImage == null
                                ? const Icon(
                                    Icons.person,
                                    color: Colors.white54,
                                  )
                                : null,
                          ),
                          title: Text(
                            user.username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            user.email,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Color(0xFFC2D86A),
                            size: 16,
                          ),
                          onTap: () => Get.back(result: user),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: null),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),
            ),
          ],
        ),
      );

      if (selectedUser == null) {
        return; // User cancelled
      }

      // Final confirmation
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.orange, size: 28),
              SizedBox(width: 12),
              Text(
                'Confirm Transfer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transfer admin rights to ${selectedUser.username} and leave "$groupName"?',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This action cannot be undone. The new admin will have full control.',
                        style: TextStyle(color: Colors.orange, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Transfer & Leave',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );

      if (confirmed != true) {
        return; // User cancelled
      }

      isLoading.value = true;

      // Transfer ownership and leave
      await _groupsService.adminLeaveGroup(
        groupId,
        currentUserId,
        selectedUser.id,
      );

      isLoading.value = false;

      Get.snackbar(
        'Success',
        'Ownership transferred to ${selectedUser.username}. You have left "$groupName".',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Navigate back to groups list (pop all group-related screens)
      // This ensures we go back to the groups list, not just one screen back
      Get.until((route) => route.settings.name == '/groups' || route.isFirst);

      print(
        'Admin $currentUserId left group $groupId, new admin: ${selectedUser.id}',
      );
    } catch (e) {
      print("Error leaving group as admin: $e");
      Get.snackbar(
        'Error',
        'Failed to leave group: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get only active members of a specific group from Firebase
  Future<List<UserModel>> getGroupMembers(String groupId) async {
    try {
      final group = groupData.firstWhereOrNull((g) => g.id == groupId);
      if (group == null) return [];

      final memberUsers = <UserModel>[];
      final memberIds = Set<String>.from(group.membersList);

      // Always include the group creator as a member (even if not in members_list)
      memberIds.add(group.createdBy);

      // Get users who are in the group's members_list or are the creator
      for (final memberId in memberIds) {
        final user = users.firstWhereOrNull((u) => u.id == memberId);
        if (user != null) {
          memberUsers.add(user);
        }
      }

      // Sort so admin appears first
      memberUsers.sort((a, b) {
        if (group.isAdmin(a.id)) return -1;
        if (group.isAdmin(b.id)) return 1;
        return a.username.compareTo(b.username);
      });

      return memberUsers;
    } catch (e) {
      print("Error getting group members: $e");
      return [];
    }
  }

  /// Get users who can be invited (all Firebase users except current members and pending invites)
  /// RBAC: Includes Members, Trainers, and users with no role assigned
  /// Excludes only Advisors and Admins
  Future<List<UserModel>> getAvailableUsers(String groupId) async {
    try {
      if (groupId.isEmpty) {
        print("DEBUG: Empty group ID provided");
        return [];
      }

      final group = groupData.firstWhereOrNull((g) => g.id == groupId);
      if (group == null) {
        print("DEBUG: Group not found for ID: $groupId");
        return [];
      }

      print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
      print("DEBUG AVAILABLE USERS FILTERING:");
      print("Total users in system: ${users.length}");

      // Get current member IDs (including creator)
      final currentMemberIds = Set<String>.from(group.membersList);
      currentMemberIds.add(group.createdBy); // Always include creator
      print("Current members in group: ${currentMemberIds.length}");
      print("Current member IDs: $currentMemberIds");

      // Get users who have pending invitations for this group
      final pendingUserIds = sentInvitations
          .where((invitation) => invitation.groupId == groupId)
          .map((invitation) => invitation.recipientId)
          .toSet();
      print("Pending invitations: ${pendingUserIds.length}");
      print("Pending user IDs: $pendingUserIds");

      // Debug: Check each user's role
      print("\nUser roles breakdown:");
      final roleCount = <String, int>{};
      for (final user in users) {
        final role = user.role ?? 'null';
        roleCount[role] = (roleCount[role] ?? 0) + 1;
      }
      roleCount.forEach((role, count) {
        print("  $role: $count users");
      });

      // CRITICAL: Use permission service to filter available members
      // Includes all users except Advisors/Admins and current members
      final availableUsers = _permissionsService.filterAvailableMembers(
        users,
        currentMemberIds,
        pendingUserIds,
      );

      // Sort alphabetically for better UX
      availableUsers.sort((a, b) => a.username.compareTo(b.username));

      print("\nFinal available users: ${availableUsers.length}");
      print("Available users list:");
      for (final user in availableUsers.take(10)) {
        print(
          "  - ${user.username} (${user.email}) [${user.role ?? 'no role'}]",
        );
      }
      if (availableUsers.length > 10) {
        print("  ... and ${availableUsers.length - 10} more");
      }
      print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");

      return availableUsers;
    } catch (e) {
      print("Error getting available users: $e");
      return [];
    }
  }

  /// Add member to group in Firebase
  /// RBAC: Only Advisors can add members, and only Members can be added
  Future<void> addMemberToGroup(String groupId, String userId) async {
    try {
      // Get target user
      final targetUser = users.firstWhereOrNull((u) => u.id == userId);
      if (targetUser == null) {
        Get.snackbar(
          "Error",
          "User not found",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // RBAC: Validate permission to add member
      final validationError = _permissionsService.validateAddMember(targetUser);
      if (validationError != null) {
        Get.snackbar(
          "Permission Denied",
          validationError,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      await _groupsService.addMemberToGroup(groupId, userId);

      // Refresh group data
      await setCurrentGroup(groupId);

      // Send welcome notification to new member
      final group = groupData.firstWhereOrNull((g) => g.id == groupId);

      if (group != null) {
        final notification = AppNotification(
          id: "",
          recipientId: userId,
          senderId: group.createdBy,
          senderName: "Group System",
          title: "Welcome to Group",
          message:
              "Welcome to the group '${group.name}'! You are now an active member.",
          type: NotificationType.info,
          timestamp: DateTime.now(),
          groupId: groupId,
          groupName: group.name,
        );

        await _notificationsService.sendNotification(notification);
      }

      Get.snackbar(
        "Success",
        "Member added successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to add member: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Remove member from group
  /// RBAC: Only Advisors can remove members
  Future<void> removeMember(String groupId, String userId) async {
    try {
      final authController = Get.find<AuthController>();
      final currentUserId = authController.firebaseUser.value?.uid;
      final group = groupData.firstWhereOrNull((g) => g.id == groupId);

      if (group == null) {
        Get.snackbar(
          "Error",
          "Group not found",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // RBAC: Validate permission to remove member
      final validationError = _permissionsService.validateRemoveMember(
        userId,
        group.createdBy,
      );
      if (validationError != null) {
        Get.snackbar(
          "Permission Denied",
          validationError,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (!group.isAdmin(currentUserId ?? '')) {
        Get.snackbar(
          "Error",
          "Only group admin can remove members",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Remove from Firebase using existing service method
      final updatedGroup = group.removeMember(userId);
      await _groupsService.updateGroup(updatedGroup);

      // Refresh group data
      await setCurrentGroup(groupId);

      // Send notification to removed member
      final removedUser = users.firstWhereOrNull((u) => u.id == userId);
      if (removedUser != null) {
        final authController = Get.find<AuthController>();
        final admin = authController.getCurrentUser();

        final notification = AppNotification(
          id: "",
          recipientId: userId,
          senderId: admin.id,
          senderName: "${admin.firstName} ${admin.lastName}",
          title: "Removed from Group",
          message:
              "You have been removed from the group '${group.name}' by ${admin.firstName}.",
          type: NotificationType.info,
          timestamp: DateTime.now(),
          groupId: groupId,
          groupName: group.name,
        );

        await _notificationsService.sendNotification(notification);
      }

      Get.snackbar(
        "Success",
        "Member removed successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to remove member: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Ensure group creator is in members list (for existing groups)
  Future<void> ensureCreatorIsMember(String groupId) async {
    try {
      final group = groupData.firstWhereOrNull((g) => g.id == groupId);
      if (group == null) return;

      // Check if creator is already in members list
      if (!group.membersList.contains(group.createdBy)) {
        // Add creator to members list
        await _groupsService.addMemberToGroup(groupId, group.createdBy);
      }
    } catch (e) {
      print("Error ensuring creator is member: $e");
    }
  }

  /// Set current group and load its members
  Future<void> setCurrentGroup(String groupId) async {
    try {
      isMemberLoading.value = true;

      // Force refresh group data from Firestore
      print("DEBUG: Refreshing group data from Firestore for: $groupId");
      final freshGroup = await _groupsService.getGroupById(groupId);

      if (freshGroup != null) {
        print(
          "DEBUG: Setting current group: ${freshGroup.name} (${freshGroup.id})",
        );
        print("DEBUG: Group members_list: ${freshGroup.membersList}");
        print("DEBUG: Group admin (created_by): ${freshGroup.createdBy}");

        // Ensure creator is in members list for existing groups
        await ensureCreatorIsMember(groupId);

        currentGroup.value = freshGroup;

        // Load members and available users
        final members = await getGroupMembers(groupId);
        final available = await getAvailableUsers(groupId);

        print(
          "DEBUG: Loaded ${members.length} members and ${available.length} available users",
        );

        // Update reactive lists
        groupMembers.value = members;
        availableUsers.value = available;

        // Initialize filtered members (LEVEL 3 search)
        filteredGroupMembers.value = members;
        groupMembersSearchQuery.value = '';

        // Initialize filtered available users (LEVEL 4 search)
        filteredAvailableUsers.value = available;
        availableUsersSearchQuery.value = '';

        // Force UI update
        groupMembers.refresh();
        availableUsers.refresh();
        filteredGroupMembers.refresh();
        filteredAvailableUsers.refresh();
      }
    } catch (e) {
      print("Error in setCurrentGroup: $e");
      Get.snackbar(
        "Error",
        "Failed to load group data: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isMemberLoading.value = false;
    }
  }

  /// Send invitation to user
  /// RBAC: Only Advisors can send invitations, and only Members can be invited
  Future<void> inviteUserToGroup(
    UserModel user, {
    String? groupId,
    String? groupName,
  }) async {
    try {
      // Validate groupId
      if (groupId == null || groupId.isEmpty || groupId == 'default') {
        Get.snackbar(
          "Error",
          "Invalid group. Please select a specific group to send invitations.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // RBAC: Validate permission to invite user
      final validationError = _permissionsService.validateInviteUser(user);
      if (validationError != null) {
        Get.snackbar(
          "Permission Denied",
          validationError,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Prevent duplicate pending invitations
      final isAlreadyPending = sentInvitations.any(
        (n) => n.recipientId == user.id && n.groupId == groupId,
      );

      if (isAlreadyPending) {
        Get.snackbar("Info", "Invitation is already pending.");
        return;
      }

      final authController = Get.find<AuthController>();
      final sender = authController.getCurrentUser();

      final notification = AppNotification(
        id: "", // Generated by Firestore
        recipientId: user.id,
        senderId: sender.id,
        senderName: "${sender.firstName} ${sender.lastName}",
        title: "Group Invitation",
        message:
            "${sender.firstName} invited you to join ${groupName ?? 'their group'}.",
        type: NotificationType.invitation,
        timestamp: DateTime.now(),
        groupId: groupId,
        groupName: groupName,
      );

      await _notificationsService.sendNotification(notification);

      // Refresh available users list (groupId is guaranteed to be valid here)
      availableUsers.value = await getAvailableUsers(groupId);

      Get.snackbar(
        "Invitation Sent",
        "Invitation sent to ${user.username}",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to send invitation: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Backward compatibility method for existing UI
  Future<void> inviteUser(
    UserModel user, {
    String? groupId,
    String? groupName,
  }) async {
    await inviteUserToGroup(user, groupId: groupId, groupName: groupName);
  }

  // ==================== RBAC UI HELPER METHODS ====================

  /// Should show "Create Group" button in UI?
  bool get canShowCreateGroupButton {
    return _permissionsService.shouldShowCreateGroupButton();
  }

  /// Should show "Add Member" button in UI?
  bool get canShowAddMemberButton {
    return _permissionsService.shouldShowAddMemberButton();
  }

  /// Should show "Invite" button in UI?
  bool get canShowInviteButton {
    return _permissionsService.shouldShowInviteButton();
  }

  /// Should show "Remove" button for a specific member?
  bool canShowRemoveButton(String userId, String groupCreatorId) {
    return _permissionsService.shouldShowRemoveButton(userId, groupCreatorId);
  }

  /// Get current user's role display name
  String get currentUserRole {
    return _permissionsService.getRoleDisplayName();
  }

  /// Is current user an Advisor?
  bool get isAdvisor {
    return _permissionsService.isAdvisor;
  }

  /// Is current user a Member?
  bool get isMember {
    return _permissionsService.isMember;
  }

  // ==================== SCOPED SEARCH METHODS ====================

  /// LEVEL 1: Filter groups by name or description
  /// This search is scoped ONLY to the Groups list screen
  void filterGroups(String query) {
    groupSearchQuery.value = query;

    if (query.trim().isEmpty) {
      // Show all groups when search is empty
      filteredGroups.value = groupData
          .map(
            (group) => {
              'id': group.id,
              'name': group.name,
              'description': group.description,
              'createdDate': group.createdAt.toString(),
              'created_by': group.createdBy,
            },
          )
          .toList();
    } else {
      // Filter groups by name or description
      final lowerQuery = query.toLowerCase();
      filteredGroups.value = groupData
          .where((group) {
            return group.name.toLowerCase().contains(lowerQuery) ||
                group.description.toLowerCase().contains(lowerQuery);
          })
          .map(
            (group) => {
              'id': group.id,
              'name': group.name,
              'description': group.description,
              'createdDate': group.createdAt.toString(),
              'created_by': group.createdBy,
            },
          )
          .toList();
    }

    print(
      '🔍 LEVEL 1 - Groups filtered: ${filteredGroups.length} results for "$query"',
    );
  }

  /// Clear groups search
  void clearGroupSearch() {
    groupSearchQuery.value = '';
    filteredGroups.value = groupData
        .map(
          (group) => {
            'id': group.id,
            'name': group.name,
            'description': group.description,
            'createdDate': group.createdAt.toString(),
            'created_by': group.createdBy,
          },
        )
        .toList();
  }

  /// LEVEL 1b: Filter groups in the Groups tab view
  /// This search is scoped ONLY to the Groups tab in group_view.dart
  void filterGroupsInView(String query) {
    groupsViewSearchQuery.value = query;

    if (query.trim().isEmpty) {
      // Show all groups when search is empty
      filteredGroupsView.value = groupData;
    } else {
      // Filter groups by name or description
      final lowerQuery = query.toLowerCase();
      filteredGroupsView.value = groupData.where((group) {
        return group.name.toLowerCase().contains(lowerQuery) ||
            group.description.toLowerCase().contains(lowerQuery);
      }).toList();
    }

    print(
      '🔍 LEVEL 1b - Groups view filtered: ${filteredGroupsView.length} results for "$query"',
    );
  }

  /// Clear groups view search
  void clearGroupsViewSearch() {
    groupsViewSearchQuery.value = '';
    filteredGroupsView.value = groupData;
  }

  /// LEVEL 2: Filter global members by name or email
  /// This search is scoped ONLY to the Members tab (all platform members)
  void filterMembers(String query) {
    membersSearchQuery.value = query;

    if (query.trim().isEmpty) {
      // Show all members when search is empty
      filteredMembers.value = users;
    } else {
      // Filter members by name or email
      final lowerQuery = query.toLowerCase();
      filteredMembers.value = users.where((member) {
        return member.username.toLowerCase().contains(lowerQuery) ||
            member.email.toLowerCase().contains(lowerQuery) ||
            member.fullName.toLowerCase().contains(lowerQuery);
      }).toList();
    }

    print(
      '🔍 LEVEL 2 - Global members filtered: ${filteredMembers.length} results for "$query"',
    );
  }

  /// Clear global members search
  void clearMembersSearch() {
    membersSearchQuery.value = '';
    filteredMembers.value = users;
  }

  /// LEVEL 3: Filter members within a specific group
  /// This search is scoped ONLY to members of the current group
  void filterGroupMembers(String query) {
    groupMembersSearchQuery.value = query;

    if (query.trim().isEmpty) {
      // Show all group members when search is empty
      filteredGroupMembers.value = groupMembers;
    } else {
      // Filter members by name or email
      final lowerQuery = query.toLowerCase();
      filteredGroupMembers.value = groupMembers.where((member) {
        return member.username.toLowerCase().contains(lowerQuery) ||
            member.email.toLowerCase().contains(lowerQuery) ||
            member.fullName.toLowerCase().contains(lowerQuery);
      }).toList();
    }

    print(
      '🔍 LEVEL 3 - Group members filtered: ${filteredGroupMembers.length} results for "$query"',
    );
  }

  /// LEVEL 4: Filter available users for invitation
  /// This search is scoped ONLY to available users in the invite tab
  void filterAvailableUsers(String query) {
    availableUsersSearchQuery.value = query;

    if (query.trim().isEmpty) {
      // Show all available users when search is empty
      filteredAvailableUsers.value = availableUsers;
    } else {
      // Filter users by name or email
      final lowerQuery = query.toLowerCase();
      filteredAvailableUsers.value = availableUsers.where((user) {
        return user.username.toLowerCase().contains(lowerQuery) ||
            user.email.toLowerCase().contains(lowerQuery) ||
            user.fullName.toLowerCase().contains(lowerQuery);
      }).toList();
    }

    print(
      '🔍 LEVEL 4 - Available users filtered: ${filteredAvailableUsers.length} results for "$query"',
    );
  }

  /// Clear available users search
  void clearAvailableUsersSearch() {
    availableUsersSearchQuery.value = '';
    filteredAvailableUsers.value = availableUsers;
  }

  /// Clear group members search
  void clearGroupMembersSearch() {
    groupMembersSearchQuery.value = '';
    filteredGroupMembers.value = groupMembers;
  }
}
