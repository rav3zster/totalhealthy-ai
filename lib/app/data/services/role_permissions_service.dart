import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../../core/base/controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
/// Centralized Role-Based Access Control (RBAC) Service
/// Enforces strict permission rules for Advisor and Member roles
class RolePermissionsService {
  static final RolePermissionsService _instance =
      RolePermissionsService._internal();
  factory RolePermissionsService() => _instance;
  RolePermissionsService._internal();

  /// Get current user from Controllers (prefers UserController for real-time data)
  UserModel? _getCurrentUser() {
    try {
      // 1. Try UserController (Real-time stream data)
      try {
        final userController = Get.find<UserController>();
        if (userController.currentUser != null) {
          return userController.currentUser;
        }
      } catch (e) {
        // UserController not initialized yet
      }

      // 2. Fallback to AuthController (Local cache data)
      final authController = Get.find<AuthController>();
      return authController.getCurrentUser();
    } catch (e) {
      debugPrint("❌ RolePermissionsService: Failed to get current user: $e");
      return null;
    }
  }

  /// Check if current user is an Advisor
  bool get isAdvisor {
    final user = _getCurrentUser();
    final advisorStatus = user?.isAdvisor ?? false;
    debugPrint(
      "🔑 RBAC Check: User: ${user?.fullName}, Role: ${user?.role}, IsAdvisor: $advisorStatus",
    );
    return advisorStatus;
  }

  /// Check if current user is a Member
  bool get isMember {
    final user = _getCurrentUser();
    return user?.isMember ?? false;
  }

  /// Check if current user has a role assigned
  bool get hasRole {
    final user = _getCurrentUser();
    return user?.hasRole ?? false;
  }

  /// Check if role is locked (immutable)
  bool get isRoleLocked {
    final user = _getCurrentUser();
    return user?.isRoleLocked ?? false;
  }

  /// Get normalized role (advisor/member)
  String get normalizedRole {
    final user = _getCurrentUser();
    return user?.normalizedRole ?? '';
  }

  // ==================== GROUP PERMISSIONS ====================

  /// Can user create groups?
  /// RULE: Both Members and Advisors can create groups
  bool canCreateGroup() {
    return hasRole; // Any user with a role can create groups
  }

  /// Can user add members to a group?
  /// RULE: Both Members and Advisors can add members
  bool canAddMembersToGroup() {
    return hasRole; // Any user with a role can add members
  }

  /// Can user invite users to a group?
  /// RULE: Both Members and Advisors can send invitations
  bool canInviteUsers() {
    return hasRole; // Any user with a role can invite
  }

  /// Can user remove members from a group?
  /// RULE: Group creators can remove members
  bool canRemoveMembers() {
    return hasRole; // Any user with a role can remove (if they're the creator)
  }

  /// Can user be invited to a group?
  /// RULE: ONLY Members can be invited (Advisors CANNOT be invited)
  bool canBeInvited(UserModel targetUser) {
    return targetUser.isMember; // CRITICAL: Block advisors from being invited
  }

  /// Can user be added to a group?
  /// RULE: ONLY Members can be added (Advisors CANNOT be added)
  bool canBeAddedToGroup(UserModel targetUser) {
    return targetUser.isMember; // CRITICAL: Block advisors from being added
  }

  /// Is user a group admin?
  /// RULE: Group creator is the admin (regardless of role)
  bool isGroupAdmin(String userId, String groupCreatorId) {
    return userId == groupCreatorId;
  }

  // ==================== CLIENT MANAGEMENT PERMISSIONS ====================

  /// Can user manage clients?
  /// RULE: Only Advisors can manage clients
  bool canManageClients() {
    return isAdvisor;
  }

  /// Can user be added as a client?
  /// RULE: Only Members can be clients (Advisors cannot be clients)
  bool canBeClient(UserModel targetUser) {
    return targetUser.isMember;
  }

  /// Should user appear in client list?
  /// RULE: ONLY Members appear in client lists (Advisors NEVER appear)
  bool shouldAppearInClientList(UserModel user) {
    return user.isMember; // CRITICAL: Advisors must NEVER appear
  }

  /// Should user appear in add member list?
  /// RULE: ONLY Members appear (Advisors NEVER appear)
  bool shouldAppearInAddMemberList(UserModel user) {
    return user.isMember; // CRITICAL: Advisors must NEVER appear
  }

  // ==================== VALIDATION METHODS ====================

  /// Validate if current user can perform group creation
  /// Returns error message if not allowed, null if allowed
  String? validateGroupCreation() {
    if (!hasRole) {
      return "Please select your role first";
    }
    if (!canCreateGroup()) {
      return "You need a role to create groups";
    }
    return null;
  }

  /// Validate if current user can add a specific user to a group
  /// Returns error message if not allowed, null if allowed
  String? validateAddMember(UserModel targetUser) {
    if (!hasRole) {
      return "Please select your role first";
    }
    if (!canAddMembersToGroup()) {
      return "You need a role to add members to groups";
    }
    if (!canBeAddedToGroup(targetUser)) {
      return "Cannot add Advisors to groups. Only Members can be added.";
    }
    return null;
  }

  /// Validate if current user can invite a specific user
  /// Returns error message if not allowed, null if allowed
  String? validateInviteUser(UserModel targetUser) {
    if (!hasRole) {
      return "Please select your role first";
    }
    if (!canInviteUsers()) {
      return "You need a role to send invitations";
    }
    if (!canBeInvited(targetUser)) {
      return "Cannot invite Advisors. Only Members can be invited.";
    }
    return null;
  }

  /// Validate if current user can remove a member
  /// Returns error message if not allowed, null if allowed
  String? validateRemoveMember(String targetUserId, String groupCreatorId) {
    if (!hasRole) {
      return "Please select your role first";
    }
    if (!canRemoveMembers()) {
      return "You need a role to remove members";
    }
    if (targetUserId == groupCreatorId) {
      return "Cannot remove group creator";
    }
    return null;
  }

  /// Validate if user can be added as a client
  /// Returns error message if not allowed, null if allowed
  String? validateAddClient(UserModel targetUser) {
    if (!canManageClients()) {
      return "Only Advisors can manage clients";
    }
    if (!canBeClient(targetUser)) {
      return "Cannot add Advisors as clients. Only Members can be clients.";
    }
    return null;
  }

  // ==================== UI HELPER METHODS ====================

  /// Should show "Create Group" button?
  bool shouldShowCreateGroupButton() {
    return canCreateGroup();
  }

  /// Should show "Add Member" button?
  bool shouldShowAddMemberButton() {
    return canAddMembersToGroup();
  }

  /// Should show "Invite" button?
  bool shouldShowInviteButton() {
    return canInviteUsers();
  }

  /// Should show "Remove" button for a member?
  bool shouldShowRemoveButton(String targetUserId, String groupCreatorId) {
    return canRemoveMembers() && targetUserId != groupCreatorId;
  }

  /// Get role display name
  String getRoleDisplayName() {
    if (isAdvisor) return "Advisor";
    if (isMember) return "Member";
    return "No Role";
  }

  /// Get role description
  String getRoleDescription() {
    if (isAdvisor) {
      return "Manage clients and create meal plans";
    }
    if (isMember) {
      return "Track your nutrition and fitness goals";
    }
    return "Please select your role";
  }

  // ==================== FILTERING METHODS ====================

  /// Filter users to show only Members (exclude Advisors)
  /// Used for: Client lists, Add member lists, Invitation lists
  List<UserModel> filterMembersOnly(List<UserModel> users) {
    return users.where((user) => user.isMember).toList();
  }

  /// Filter users to exclude current members and pending invites
  /// Shows Members, Trainers, and users with no role, but excludes Advisors/Admins only
  List<UserModel> filterAvailableMembers(
    List<UserModel> allUsers,
    Set<String> currentMemberIds,
    Set<String> pendingInviteIds,
  ) {
    debugPrint("\n🔍 FILTER DEBUG:");
    debugPrint("Total users to filter: ${allUsers.length}");

    int excludedByMembership = 0;
    int excludedByPending = 0;
    int excludedByRole = 0;

    final result = allUsers.where((user) {
      // Check if already a member
      if (currentMemberIds.contains(user.id)) {
        excludedByMembership++;
        return false;
      }

      // Check if has pending invite
      if (pendingInviteIds.contains(user.id)) {
        excludedByPending++;
        return false;
      }

      // Check if role is null or empty - INCLUDE them (they can be invited)
      if (user.role == null || user.role!.isEmpty) {
        debugPrint("  ✓ User ${user.username} included (no role assigned)");
        return true;
      }

      // Check if role is excluded (only admin and advisor)
      final roleLower = user.role!.toLowerCase();
      final isExcludedRole = roleLower == 'admin' || roleLower == 'advisor';

      if (isExcludedRole) {
        excludedByRole++;
        debugPrint("  ⚠️ User ${user.username} excluded by role: ${user.role}");
        return false;
      }

      // Include all other roles (member, user, trainer, etc.)
      return true;
    }).toList();

    debugPrint("Excluded by membership: $excludedByMembership");
    debugPrint("Excluded by pending invite: $excludedByPending");
    debugPrint("Excluded by role type (admin/advisor): $excludedByRole");
    debugPrint("Final result: ${result.length} users");

    return result;
  }
}
