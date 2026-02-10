import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:totalhealthy/app/core/base/controllers/auth_controller.dart';
import 'package:totalhealthy/app/data/models/user_model.dart';
import 'package:totalhealthy/app/data/models/group_model.dart';
import 'package:totalhealthy/app/data/services/groups_firestore_service.dart';
import 'package:totalhealthy/app/data/services/users_firestore_service.dart';
import 'package:totalhealthy/app/data/services/notifications_firestore_service.dart';
import 'package:totalhealthy/app/data/models/notification_model.dart';
import 'package:totalhealthy/app/data/services/role_permissions_service.dart';

class GroupController extends GetxController {
  final GroupsFirestoreService _groupsService = GroupsFirestoreService();
  final UsersFirestoreService _usersService = UsersFirestoreService();
  final NotificationsFirestoreService _notificationsService =
      NotificationsFirestoreService();
  final RolePermissionsService _permissionsService = RolePermissionsService();

  final groupData = <GroupModel>[].obs;
  final users = <UserModel>[].obs; // All system users
  final sentInvitations =
      <AppNotification>[].obs; // Invitations sent by current user
  final isLoading = true.obs;
  final totalUsers = 0.obs;

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

  Future<void> createGroup(String name, String description) async {
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
  /// RBAC: Only Members can be invited (Advisors are filtered out)
  /// CRITICAL: Advisors must NEVER appear in this list
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

      // Get current member IDs (including creator)
      final currentMemberIds = Set<String>.from(group.membersList);
      currentMemberIds.add(group.createdBy); // Always include creator

      // Get users who have pending invitations for this group
      final pendingUserIds = sentInvitations
          .where((invitation) => invitation.groupId == groupId)
          .map((invitation) => invitation.recipientId)
          .toSet();

      // CRITICAL: Use permission service to filter available members
      // This ensures Advisors NEVER appear in the list
      final availableUsers = _permissionsService.filterAvailableMembers(
        users,
        currentMemberIds,
        pendingUserIds,
      );

      // Sort alphabetically for better UX
      availableUsers.sort((a, b) => a.username.compareTo(b.username));

      print(
        "DEBUG: Filtered ${availableUsers.length} available members (Advisors excluded)",
      );

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
      final group = groupData.firstWhereOrNull((g) => g.id == groupId);
      if (group != null) {
        print("DEBUG: Setting current group: ${group.name} (${group.id})");

        // Ensure creator is in members list for existing groups
        await ensureCreatorIsMember(groupId);

        currentGroup.value = group;

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

        // Force UI update
        groupMembers.refresh();
        availableUsers.refresh();
        filteredGroupMembers.refresh();
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

  /// Clear group members search
  void clearGroupMembersSearch() {
    groupMembersSearchQuery.value = '';
    filteredGroupMembers.value = groupMembers;
  }
}
