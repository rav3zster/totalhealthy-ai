import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:totalhealthy/app/core/base/controllers/auth_controller.dart';
import 'package:totalhealthy/app/data/models/user_model.dart';
import 'package:totalhealthy/app/data/models/group_model.dart';
import 'package:totalhealthy/app/data/services/groups_firestore_service.dart';
import 'package:totalhealthy/app/data/services/users_firestore_service.dart';
import 'package:totalhealthy/app/data/services/notifications_firestore_service.dart';
import 'package:totalhealthy/app/data/models/notification_model.dart';

class GroupController extends GetxController {
  final GroupsFirestoreService _groupsService = GroupsFirestoreService();
  final UsersFirestoreService _usersService = UsersFirestoreService();
  final NotificationsFirestoreService _notificationsService =
      NotificationsFirestoreService();

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
  /// Get users who can be invited (all Firebase users except current members and pending invites)
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

      // Show ALL Firebase users except current members and pending invites
      final availableUsers = users
          .where(
            (user) =>
                !currentMemberIds.contains(user.id) &&
                !pendingUserIds.contains(user.id),
          )
          .toList();

      // Sort alphabetically for better UX
      availableUsers.sort((a, b) => a.username.compareTo(b.username));

      return availableUsers;
    } catch (e) {
      print("Error getting available users: $e");
      return [];
    }
  }

  /// Add member to group in Firebase
  Future<void> addMemberToGroup(String groupId, String userId) async {
    try {
      await _groupsService.addMemberToGroup(groupId, userId);

      // Refresh group data
      await setCurrentGroup(groupId);

      // Send welcome notification to new member
      final newMember = users.firstWhereOrNull((u) => u.id == userId);
      final group = groupData.firstWhereOrNull((g) => g.id == groupId);

      if (newMember != null && group != null) {
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
  Future<void> removeMember(String groupId, String userId) async {
    try {
      final authController = Get.find<AuthController>();
      final currentUserId = authController.firebaseUser.value?.uid;
      final group = groupData.firstWhereOrNull((g) => g.id == groupId);

      if (group == null || !group.isAdmin(currentUserId ?? '')) {
        Get.snackbar(
          "Error",
          "Only group admin can remove members",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (group.isAdmin(userId)) {
        Get.snackbar(
          "Error",
          "Cannot remove group admin",
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

        // Force UI update
        groupMembers.refresh();
        availableUsers.refresh();
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
  Future<void> inviteUserToGroup(
    UserModel user, {
    String? groupId,
    String? groupName,
  }) async {
    try {
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

      // Refresh available users list
      if (groupId != null) {
        availableUsers.value = await getAvailableUsers(groupId);
      }

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
}
