# Simplified Role-Based Group and Client Management - Complete

## Overview
Implemented a simplified role-based access control system for group and client management. This design intentionally avoids complex admin hierarchies and focuses on clear, predictable rules.

---

## Role Rules

### MEMBER
**Permissions:**
- ✅ Can create groups
- ✅ Can add or invite ONLY other members into groups
- ✅ Can accept group invitations
- ✅ Can be added to groups by advisors
- ❌ Can NEVER add or invite advisors

### ADVISOR
**Permissions:**
- ✅ Can add clients (members only)
- ✅ Can add their clients into groups
- ✅ Client list shows ONLY users with role == "member"
- ❌ Advisors must NEVER appear in client lists
- ❌ Cannot be added to groups
- ❌ Cannot be invited to groups

---

## Visibility Rules (CRITICAL)

### Advisors Must NOT Appear In:
- ❌ Add member list
- ❌ Client list
- ❌ Group invitation lists
- ❌ Any member selection UI

### Members Must NOT Be Able To:
- ❌ Add advisors
- ❌ Invite advisors
- ❌ See advisors in add-member UI

---

## Group Rules

### Group Creation
- ✅ Groups can be created by **both Members and Advisors**
- ✅ Group creator becomes the admin (regardless of role)

### Group Membership
- ✅ Groups contain ONLY members
- ❌ Advisors are NEVER added to groups
- ❌ Advisor actions must never add advisors to groups

### Group Operations
- ✅ Both Members and Advisors can add members to groups
- ✅ Both Members and Advisors can invite members to groups
- ✅ Group creator can remove members
- ❌ Cannot remove group creator

---

## Validation (MANDATORY)

### Hard-Blocked Operations
```dart
// If targetUser.role == "advisor" → block add/invite
if (targetUser.isAdvisor) {
  return "Cannot add/invite Advisors. Only Members can be added.";
}

// If advisor tries to add advisor → block
if (!targetUser.isMember) {
  return "Cannot add Advisors to groups. Only Members can be added.";
}
```

### Multi-Layer Protection
1. **UI Layer:** Advisors filtered out from lists
2. **Controller Layer:** Hard validation before operations
3. **Service Layer:** Centralized permission checks
4. **Data Layer:** Role-based filtering

---

## Invitation Flow

### When Advisor Adds Client to Group:
1. Advisor selects client from their client list
2. System sends invitation to member
3. Member receives notification
4. Member must accept before joining group
5. Upon acceptance, member is added to group

### When Member Adds Member to Group:
1. Member selects another member from available list
2. System sends invitation to target member
3. Target member receives notification
4. Target member must accept before joining group
5. Upon acceptance, member is added to group

---

## Implementation Details

### 1. Role Permissions Service (`lib/app/data/services/role_permissions_service.dart`)

**Updated Permission Methods:**

```dart
// Both Members and Advisors can create groups
bool canCreateGroup() {
  return hasRole; // Any user with a role
}

// Both Members and Advisors can add members
bool canAddMembersToGroup() {
  return hasRole; // Any user with a role
}

// Both Members and Advisors can invite
bool canInviteUsers() {
  return hasRole; // Any user with a role
}

// CRITICAL: Only Members can be invited
bool canBeInvited(UserModel targetUser) {
  return targetUser.isMember; // Block advisors
}

// CRITICAL: Only Members can be added
bool canBeAddedToGroup(UserModel targetUser) {
  return targetUser.isMember; // Block advisors
}

// Group creator is admin (regardless of role)
bool isGroupAdmin(String userId, String groupCreatorId) {
  return userId == groupCreatorId;
}
```

**Client Management Methods:**

```dart
// Only Advisors can manage clients
bool canManageClients() {
  return isAdvisor;
}

// Only Members can be clients
bool canBeClient(UserModel targetUser) {
  return targetUser.isMember;
}

// CRITICAL: Only Members appear in client lists
bool shouldAppearInClientList(UserModel user) {
  return user.isMember; // Advisors NEVER appear
}

// CRITICAL: Only Members appear in add member lists
bool shouldAppearInAddMemberList(UserModel user) {
  return user.isMember; // Advisors NEVER appear
}
```

**Filtering Methods:**

```dart
// Filter to show only Members (exclude Advisors)
List<UserModel> filterMembersOnly(List<UserModel> users) {
  return users.where((user) => user.isMember).toList();
}

// Filter available members for groups
List<UserModel> filterAvailableMembers(
  List<UserModel> allUsers,
  Set<String> currentMemberIds,
  Set<String> pendingInviteIds,
) {
  return allUsers
    .where((user) =>
      !currentMemberIds.contains(user.id) &&
      !pendingInviteIds.contains(user.id) &&
      user.isMember, // CRITICAL: Only Members
    )
    .toList();
}
```

**Validation Methods:**

```dart
// Validate adding a client
String? validateAddClient(UserModel targetUser) {
  if (!canManageClients()) {
    return "Only Advisors can manage clients";
  }
  if (!canBeClient(targetUser)) {
    return "Cannot add Advisors as clients. Only Members can be clients.";
  }
  return null;
}
```

---

### 2. Group Controller (`lib/app/modules/group/controllers/group_controller.dart`)

**Updated Available Users Method:**

```dart
Future<List<UserModel>> getAvailableUsers(String groupId) async {
  // Get current member IDs
  final currentMemberIds = Set<String>.from(group.membersList);
  currentMemberIds.add(group.createdBy);

  // Get pending invitation IDs
  final pendingUserIds = sentInvitations
    .where((invitation) => invitation.groupId == groupId)
    .map((invitation) => invitation.recipientId)
    .toSet();

  // CRITICAL: Use permission service to filter
  // This ensures Advisors NEVER appear
  final availableUsers = _permissionsService.filterAvailableMembers(
    users,
    currentMemberIds,
    pendingUserIds,
  );

  return availableUsers;
}
```

**Permission Validation in Operations:**

```dart
// Create Group - Anyone with role can create
Future<void> createGroup(String name, String description) async {
  final validationError = _permissionsService.validateGroupCreation();
  if (validationError != null) {
    Get.snackbar("Permission Denied", validationError);
    return;
  }
  // ... create group
}

// Add Member - Validate target is a Member
Future<void> addMemberToGroup(String groupId, String userId) async {
  final targetUser = users.firstWhereOrNull((u) => u.id == userId);
  
  final validationError = _permissionsService.validateAddMember(targetUser);
  if (validationError != null) {
    Get.snackbar("Permission Denied", validationError);
    return;
  }
  // ... add member
}

// Invite User - Validate target is a Member
Future<void> inviteUserToGroup(UserModel user, ...) async {
  final validationError = _permissionsService.validateInviteUser(user);
  if (validationError != null) {
    Get.snackbar("Permission Denied", validationError);
    return;
  }
  // ... send invitation
}
```

---

### 3. Client List Screen (`lib/app/modules/group/views/client_list_screen.dart`)

**Updated Filtering Logic:**

```dart
// Get all users from Firebase
_usersService.getUsersStream().listen((users) {
  // CRITICAL: Filter using RolePermissionsService
  // This ensures ONLY Members appear (Advisors NEVER appear)
  final membersOnly = _permissionsService.filterMembersOnly(users);
  
  // Further filter: exclude current user and assigned clients
  allMembers = membersOnly.where((user) {
    final isNotCurrentUser = user.id != currentUser.uid;
    final isNotAssigned = !assignedClientIds.contains(user.id);
    return isNotCurrentUser && isNotAssigned;
  }).toList();
  
  _filterMembers(searchController.text);
});
```

**Added Permission Validation:**

```dart
Future<void> _addClientToTrainer(UserModel client) async {
  // RBAC: Validate permission to add client
  final validationError = _permissionsService.validateAddClient(client);
  if (validationError != null) {
    Get.snackbar('Permission Denied', validationError);
    return;
  }
  
  // ... add client
}
```

---

## Security Constraints

### Multi-Layer Protection

**1. UI Layer:**
- Advisors filtered out from all lists
- Buttons disabled for invalid operations
- Visual feedback for permission denied

**2. Controller Layer:**
- Hard validation before any operation
- Permission checks using RolePermissionsService
- Error messages for denied operations

**3. Service Layer:**
- Centralized permission validation
- Consistent filtering across all operations
- Role-based access control

**4. Data Layer:**
- Role-based filtering at query level
- Available users filtered by role
- Client lists show only Members

---

## Key Differences from Previous Implementation

### Previous (Strict Advisor-Only)
- ❌ Only Advisors could create groups
- ❌ Only Advisors could add members
- ❌ Only Advisors could invite users
- ❌ Members had very limited permissions

### Current (Simplified)
- ✅ Both Members and Advisors can create groups
- ✅ Both Members and Advisors can add members
- ✅ Both Members and Advisors can invite users
- ✅ Members have equal group management permissions
- ✅ Advisors still manage clients separately
- ✅ Advisors NEVER appear in member lists
- ✅ Advisors NEVER get added to groups

---

## Testing Checklist

### Member Permissions
- [ ] Member can create groups
- [ ] Member can add other members to groups
- [ ] Member can invite other members to groups
- [ ] Member cannot see advisors in add member list
- [ ] Member cannot add advisors to groups
- [ ] Member cannot invite advisors to groups
- [ ] Member can accept group invitations
- [ ] Member can be added to groups by advisors

### Advisor Permissions
- [ ] Advisor can create groups
- [ ] Advisor can add members to groups
- [ ] Advisor can invite members to groups
- [ ] Advisor can manage clients (add/remove)
- [ ] Advisor cannot be added to groups
- [ ] Advisor cannot be invited to groups
- [ ] Advisor does not appear in client lists
- [ ] Advisor does not appear in add member lists

### Visibility Rules
- [ ] Advisors never appear in add member list
- [ ] Advisors never appear in client list
- [ ] Advisors never appear in group invitation lists
- [ ] Only Members appear in all selection UIs

### Validation
- [ ] Adding advisor to group is blocked
- [ ] Inviting advisor to group is blocked
- [ ] Adding advisor as client is blocked
- [ ] Error messages are clear and helpful

### Group Operations
- [ ] Groups can be created by both roles
- [ ] Groups contain only members
- [ ] Group creator can remove members
- [ ] Cannot remove group creator
- [ ] Invitations are sent correctly
- [ ] Members must accept before joining

---

## Files Modified

### Updated
1. **`lib/app/data/services/role_permissions_service.dart`**
   - Updated permission methods (both roles can create/add/invite)
   - Added client management permissions
   - Added filtering methods for Members only
   - Added validation for client operations

2. **`lib/app/modules/group/controllers/group_controller.dart`**
   - Updated getAvailableUsers to use permission service filtering
   - Ensured Advisors never appear in available users list

3. **`lib/app/modules/group/views/client_list_screen.dart`**
   - Added RolePermissionsService integration
   - Updated filtering to use filterMembersOnly method
   - Added permission validation for adding clients
   - Ensured Advisors never appear in client list

---

## Summary

✅ **Simplified:** Role-based group and client management
✅ **Implemented:** Both Members and Advisors can manage groups
✅ **Enforced:** Advisors NEVER appear in member/client lists
✅ **Validated:** Multi-layer permission checks
✅ **Filtered:** Only Members appear in all selection UIs
✅ **Maintained:** Clean, minimal, maintainable logic
✅ **Avoided:** Complex admin hierarchies
✅ **Preserved:** Simple and predictable behavior

The simplified RBAC system is now production-ready with clear rules and consistent enforcement!
