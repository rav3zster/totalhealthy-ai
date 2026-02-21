# Group Leave Functionality - Implementation

## Overview
Implemented group leave functionality with a single-admin model. Members can leave groups with simple confirmation, while admins must transfer ownership to another member before leaving. All admin transfers use Firestore transactions to ensure atomic operations.

---

## Data Structure

### Group Document
```
groups/{groupId}
  - created_by: string (admin user ID)
  - members_list: array<string> (member user IDs)
  - member_count: number
  - name: string
  - description: string
  - created_at: timestamp
```

### Member Documents
```
groups/{groupId}/members/{userId}
  - (member-specific data)
```

---

## Implementation Details

### 1. Service Layer (`groups_firestore_service.dart`)

#### A) Get Group Members
```dart
Future<List<String>> getGroupMembers(String groupId) async {
  if (groupId.isEmpty) {
    throw ArgumentError('Group ID cannot be empty');
  }

  final membersSnapshot = await _firestore
      .collection(_collection)
      .doc(groupId)
      .collection('members')
      .get();

  return membersSnapshot.docs.map((doc) => doc.id).toList();
}
```

**Purpose:** Fetch all member IDs from the members subcollection.

**Returns:** List of user IDs who are members.

#### B) Member Leave Group
```dart
Future<void> memberLeaveGroup(String groupId, String userId) async {
  if (groupId.isEmpty || userId.isEmpty) {
    throw ArgumentError('Group ID and User ID cannot be empty');
  }

  // Check if group exists
  final groupDoc = await _firestore.collection(_collection).doc(groupId).get();
  if (!groupDoc.exists) {
    throw Exception('Group not found');
  }

  final groupData = groupDoc.data()!;
  final adminId = groupData['created_by'] as String?;

  // Prevent admin from using simple leave
  if (adminId == userId) {
    throw Exception(
      'Admin cannot leave without transferring ownership. Use adminLeaveGroup instead.',
    );
  }

  // Remove member document
  await _firestore
      .collection(_collection)
      .doc(groupId)
      .collection('members')
      .doc(userId)
      .delete();

  // Update members_list array
  await _firestore.collection(_collection).doc(groupId).update({
    'members_list': FieldValue.arrayRemove([userId]),
    'member_count': FieldValue.increment(-1),
  });

  print('Member $userId left group $groupId');
}
```

**Purpose:** Allow non-admin members to leave the group.

**Validation:**
- Checks group exists
- Prevents admin from using this method
- Throws exception if admin attempts to use it

**Operations:**
1. Delete member document from `groups/{groupId}/members/{userId}`
2. Remove user ID from `members_list` array
3. Decrement `member_count`

**Security:** Firestore rules should enforce that users can only delete their own membership document.

#### C) Admin Leave Group (with Transaction)
```dart
Future<void> adminLeaveGroup(
  String groupId,
  String currentAdminId,
  String newAdminId,
) async {
  if (groupId.isEmpty || currentAdminId.isEmpty || newAdminId.isEmpty) {
    throw ArgumentError('Group ID, current admin ID, and new admin ID cannot be empty');
  }

  if (currentAdminId == newAdminId) {
    throw ArgumentError('New admin cannot be the same as current admin');
  }

  // Use transaction to ensure atomic operation
  await _firestore.runTransaction((transaction) async {
    // 1. Get group document
    final groupRef = _firestore.collection(_collection).doc(groupId);
    final groupDoc = await transaction.get(groupRef);

    if (!groupDoc.exists) {
      throw Exception('Group not found');
    }

    final groupData = groupDoc.data()!;
    final adminId = groupData['created_by'] as String?;

    // 2. Verify current user is admin
    if (adminId != currentAdminId) {
      throw Exception('Only the current admin can transfer ownership');
    }

    // 3. Check if new admin is a member
    final newAdminMemberRef = _firestore
        .collection(_collection)
        .doc(groupId)
        .collection('members')
        .doc(newAdminId);
    final newAdminMemberDoc = await transaction.get(newAdminMemberRef);

    if (!newAdminMemberDoc.exists) {
      throw Exception('New admin must be a member of the group');
    }

    // 4. Get all members to verify group won't be empty
    final membersSnapshot = await _firestore
        .collection(_collection)
        .doc(groupId)
        .collection('members')
        .get();

    final memberIds = membersSnapshot.docs.map((doc) => doc.id).toList();

    // Remove current admin from member list
    memberIds.remove(currentAdminId);

    if (memberIds.isEmpty) {
      throw Exception(
        'Cannot leave group: No other members available. Delete the group instead.',
      );
    }

    // Verify new admin is in the remaining members
    if (!memberIds.contains(newAdminId)) {
      throw Exception('Selected user is not a valid member');
    }

    // 5. Update group admin (atomic operation)
    transaction.update(groupRef, {
      'created_by': newAdminId,
    });

    // 6. Remove old admin from members
    final oldAdminMemberRef = _firestore
        .collection(_collection)
        .doc(groupId)
        .collection('members')
        .doc(currentAdminId);
    transaction.delete(oldAdminMemberRef);

    // 7. Update members_list array
    transaction.update(groupRef, {
      'members_list': FieldValue.arrayRemove([currentAdminId]),
      'member_count': FieldValue.increment(-1),
    });

    print('Admin transfer completed: $currentAdminId → $newAdminId');
  });

  print('Admin $currentAdminId left group $groupId, new admin: $newAdminId');
}
```

**Purpose:** Allow admin to transfer ownership and leave the group atomically.

**Transaction Steps:**
1. Get group document
2. Verify current user is admin
3. Verify new admin is a member
4. Get all members and verify group won't be empty
5. Update `created_by` to new admin ID
6. Delete old admin's member document
7. Update `members_list` array and `member_count`

**Why Transaction:**
- Ensures all operations succeed or all fail
- Prevents partial updates
- Guarantees group always has an admin
- Prevents race conditions

**Validation:**
- Group must exist
- Current user must be admin
- New admin must be a member
- At least one other member must exist
- New admin cannot be current admin

---

### 2. Controller Layer (`group_controller.dart`)

#### A) Member Leave Group
```dart
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
        // ... confirmation dialog UI
      ),
    );

    if (confirmed != true) {
      return; // User cancelled
    }

    isLoading.value = true;

    // Leave the group
    await _groupsService.memberLeaveGroup(groupId, currentUserId);

    Get.snackbar(
      'Success',
      'You have left "$groupName"',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );

    // Navigate back to groups list
    Get.back();

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
```

**Purpose:** Handle member leave with confirmation.

**Flow:**
1. Get current user ID
2. Show confirmation dialog
3. If confirmed, call service to leave
4. Show success message
5. Navigate back to groups list

**UI:** Simple confirmation dialog with warning about losing access.

#### B) Admin Leave Group
```dart
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

    // Get all members except current admin
    final memberIds = await _groupsService.getGroupMembers(groupId);
    memberIds.remove(currentUserId); // Remove current admin

    if (memberIds.isEmpty) {
      isLoading.value = false;
      Get.snackbar(
        "Cannot Leave",
        "You are the only member. Please delete the group instead or invite members first.",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      return;
    }

    // Get member details
    final memberUsers = <UserModel>[];
    for (final memberId in memberIds) {
      final user = users.firstWhereOrNull((u) => u.id == memberId);
      if (user != null) {
        memberUsers.add(user);
      }
    }

    isLoading.value = false;

    if (memberUsers.isEmpty) {
      Get.snackbar(
        "Cannot Leave",
        "No valid members found to transfer ownership",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Show member selection dialog
    final selectedUser = await Get.dialog<UserModel>(
      AlertDialog(
        // ... member selection dialog UI
      ),
    );

    if (selectedUser == null) {
      return; // User cancelled
    }

    // Confirm transfer
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        // ... confirmation dialog UI
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

    Get.snackbar(
      'Success',
      'Ownership transferred to ${selectedUser.username}. You have left "$groupName".',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );

    // Navigate back to groups list
    Get.back();

    print('Admin $currentUserId left group $groupId, new admin: ${selectedUser.id}');
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
```

**Purpose:** Handle admin leave with ownership transfer.

**Flow:**
1. Get current user ID
2. Fetch all members except current admin
3. If no members, show error (must delete group or invite members)
4. Get member details for display
5. Show member selection dialog
6. User selects new admin
7. Show confirmation dialog
8. If confirmed, call service to transfer and leave
9. Show success message
10. Navigate back to groups list

**UI:** 
- Member selection dialog with user profiles
- Confirmation dialog with warning about irreversibility

---

### 3. View Layer (`group_details_screen.dart`)

#### Leave Button in Header
```dart
Row(
  children: [
    // Back button
    Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Color(0xFFC2D86A),
          size: 20,
        ),
        onPressed: () {
          Get.back();
        },
      ),
    ),
    const SizedBox(width: 16),
    const Expanded(
      child: Text(
        'Group Details',
        style: TextStyle(
          color: Colors.white,
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
          final currentUserId = authController.firebaseUser.value?.uid;
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
```

**Purpose:** Provide leave button in group details header.

**Logic:**
1. Get current user ID and group admin ID
2. Determine if user is admin
3. Call appropriate method (admin or member leave)

**UI:**
- Orange-themed button to indicate caution
- Exit icon
- Positioned in header next to title

---

## Transaction Guarantees

### How Transaction Ensures Atomic Transfer

**Firestore Transaction Properties:**
1. **Atomicity:** All operations succeed or all fail
2. **Consistency:** Database remains in valid state
3. **Isolation:** Concurrent transactions don't interfere
4. **Durability:** Committed changes are permanent

**In Our Implementation:**

```dart
await _firestore.runTransaction((transaction) async {
  // 1. Read operations (get group, verify admin, check members)
  final groupDoc = await transaction.get(groupRef);
  final newAdminMemberDoc = await transaction.get(newAdminMemberRef);
  
  // 2. Validation (all checks must pass)
  if (!groupDoc.exists) throw Exception('Group not found');
  if (adminId != currentAdminId) throw Exception('Not admin');
  if (!newAdminMemberDoc.exists) throw Exception('Not a member');
  if (memberIds.isEmpty) throw Exception('No members');
  
  // 3. Write operations (all or nothing)
  transaction.update(groupRef, {'created_by': newAdminId});
  transaction.delete(oldAdminMemberRef);
  transaction.update(groupRef, {
    'members_list': FieldValue.arrayRemove([currentAdminId]),
    'member_count': FieldValue.increment(-1),
  });
});
```

**Guarantees:**
- If any validation fails → No changes made
- If any write fails → All writes rolled back
- If transaction succeeds → All changes committed atomically
- Group always has exactly one admin
- No intermediate state where group has no admin

---

## Edge Cases Handled

### 1. Admin Attempts Simple Leave
**Scenario:** Admin tries to use `memberLeaveGroup()`

**Handling:**
```dart
if (adminId == userId) {
  throw Exception(
    'Admin cannot leave without transferring ownership. Use adminLeaveGroup instead.',
  );
}
```

**Result:** Exception thrown, no changes made.

### 2. Admin is Only Member
**Scenario:** Admin tries to leave but no other members exist

**Handling:**
```dart
if (memberIds.isEmpty) {
  Get.snackbar(
    "Cannot Leave",
    "You are the only member. Please delete the group instead or invite members first.",
    backgroundColor: Colors.orange,
    colorText: Colors.white,
    duration: const Duration(seconds: 4),
  );
  return;
}
```

**Result:** Operation blocked, user shown message to delete group or invite members.

### 3. Selected User is Not a Member
**Scenario:** Admin selects user who is not in members subcollection

**Handling:**
```dart
if (!newAdminMemberDoc.exists) {
  throw Exception('New admin must be a member of the group');
}
```

**Result:** Transaction fails, no changes made.

### 4. Current Admin is Not Actually Admin
**Scenario:** User's admin status changed between UI check and transaction

**Handling:**
```dart
if (adminId != currentAdminId) {
  throw Exception('Only the current admin can transfer ownership');
}
```

**Result:** Transaction fails, no changes made.

### 5. Group Deleted During Operation
**Scenario:** Group is deleted while user is selecting new admin

**Handling:**
```dart
if (!groupDoc.exists) {
  throw Exception('Group not found');
}
```

**Result:** Transaction fails, user shown error message.

### 6. New Admin Same as Current Admin
**Scenario:** Admin somehow selects themselves

**Handling:**
```dart
if (currentAdminId == newAdminId) {
  throw ArgumentError('New admin cannot be the same as current admin');
}
```

**Result:** Exception thrown before transaction starts.

### 7. Concurrent Admin Transfers
**Scenario:** Two admins try to transfer ownership simultaneously (shouldn't happen with single-admin model, but handled anyway)

**Handling:** Firestore transaction isolation ensures only one succeeds. The second transaction will fail when it reads the group document and sees a different admin ID.

**Result:** First transaction succeeds, second fails with "Not admin" error.

### 8. Member Leaves While Admin is Transferring
**Scenario:** Member leaves group while admin is selecting them as new admin

**Handling:**
```dart
if (!newAdminMemberDoc.exists) {
  throw Exception('New admin must be a member of the group');
}
```

**Result:** Transaction fails when it checks if selected user is still a member.

---

## What Happens if Transaction Fails

### Failure Scenarios

#### 1. Validation Failure
**Cause:** Any validation check fails (group not found, not admin, not a member, etc.)

**Result:**
- Transaction aborted before any writes
- No changes made to database
- Exception thrown with descriptive message
- User shown error snackbar
- User remains in group
- Admin status unchanged

#### 2. Network Failure
**Cause:** Network connection lost during transaction

**Result:**
- Firestore automatically retries transaction
- If retry succeeds → Changes committed
- If retry fails → Transaction aborted
- No partial updates
- User shown error message
- Can retry operation

#### 3. Concurrent Modification
**Cause:** Another transaction modifies the same documents

**Result:**
- Firestore detects conflict
- Transaction automatically retried with fresh data
- If conflict persists → Transaction fails
- User shown error message
- Can retry operation

#### 4. Permission Denied
**Cause:** Firestore Security Rules reject the operation

**Result:**
- Transaction fails immediately
- No changes made
- User shown permission error
- Indicates security rules need updating

### Error Handling in Code

```dart
try {
  await _groupsService.adminLeaveGroup(
    groupId,
    currentUserId,
    selectedUser.id,
  );
  
  // Success handling
  Get.snackbar('Success', 'Ownership transferred...');
  Get.back();
  
} catch (e) {
  // Failure handling
  print("Error leaving group as admin: $e");
  Get.snackbar(
    'Error',
    'Failed to leave group: $e',
    backgroundColor: Colors.red,
    colorText: Colors.white,
  );
  // User remains on group details screen
  // Can retry operation
} finally {
  isLoading.value = false;
}
```

**User Experience on Failure:**
1. Loading indicator stops
2. Error message shown in snackbar
3. User remains on group details screen
4. Group state unchanged
5. User can retry operation
6. No data corruption

---

## Firestore Security Rules (Recommended)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /groups/{groupId} {
      // Allow read if user is creator or member
      allow read: if request.auth != null && 
        (resource.data.created_by == request.auth.uid || 
         request.auth.uid in resource.data.members_list);
      
      // Allow create if authenticated
      allow create: if request.auth != null &&
        request.resource.data.created_by == request.auth.uid;
      
      // Allow update only if user is creator (admin)
      // This includes updating created_by for admin transfer
      allow update: if request.auth != null && 
        resource.data.created_by == request.auth.uid;
      
      // Allow delete only if user is creator (admin)
      allow delete: if request.auth != null && 
        resource.data.created_by == request.auth.uid;
      
      // Member documents
      match /members/{userId} {
        // Allow read if user is creator or member of group
        allow read: if request.auth != null && 
          (get(/databases/$(database)/documents/groups/$(groupId)).data.created_by == request.auth.uid ||
           request.auth.uid in get(/databases/$(database)/documents/groups/$(groupId)).data.members_list);
        
        // Allow create if user is admin (for invitations)
        allow create: if request.auth != null &&
          get(/databases/$(database)/documents/groups/$(groupId)).data.created_by == request.auth.uid;
        
        // Allow delete only if user is deleting their own membership
        // OR if user is admin (for removing members)
        allow delete: if request.auth != null && 
          (userId == request.auth.uid ||
           get(/databases/$(database)/documents/groups/$(groupId)).data.created_by == request.auth.uid);
      }
    }
  }
}
```

**Key Rules:**
- Only admin can update `created_by` field (for ownership transfer)
- Members can delete their own membership document
- Admin can delete any member document (for removing members)
- All operations require authentication

---

## Testing Scenarios

### Scenario 1: Member Leaves Group
```
Given: User is a member (not admin) of "Fitness Group"
When: User clicks leave button
Then: Confirmation dialog appears
When: User clicks "Leave"
Then: User is removed from group
And: Success message is shown
And: User navigated back to groups list
And: Group still has admin
```

### Scenario 2: Admin Leaves with Transfer
```
Given: User is admin of "Yoga Group" with 3 members
When: User clicks leave button
Then: Member selection dialog appears
When: User selects "John Doe" as new admin
Then: Confirmation dialog appears
When: User clicks "Transfer & Leave"
Then: Ownership transferred to John Doe
And: Old admin removed from group
And: Success message is shown
And: User navigated back to groups list
And: John Doe is now admin
```

### Scenario 3: Admin is Only Member
```
Given: User is admin of "Solo Group" with no other members
When: User clicks leave button
Then: Error message shown: "You are the only member. Please delete the group instead or invite members first."
And: User remains in group
And: Admin status unchanged
```

### Scenario 4: Admin Cancels Transfer
```
Given: User is admin of "Running Group"
When: User clicks leave button
Then: Member selection dialog appears
When: User clicks "Cancel"
Then: Dialog closes
And: User remains in group
And: Admin status unchanged
```

### Scenario 5: Transaction Fails
```
Given: User is admin of "Cycling Group"
When: User selects new admin and confirms
And: Network connection is lost during transaction
Then: Transaction fails
And: Error message shown
And: User remains in group
And: Admin status unchanged
And: User can retry operation
```

---

## Summary

**What was implemented:**
- `getGroupMembers()` method in service
- `memberLeaveGroup()` method in service (simple removal)
- `adminLeaveGroup()` method in service (with transaction)
- `memberLeaveGroup()` method in controller (with confirmation)
- `adminLeaveGroup()` method in controller (with member selection)
- Leave button in group details header

**How transaction ensures atomic transfer:**
- All operations in single transaction
- All succeed or all fail
- No intermediate state
- Group always has admin
- Prevents race conditions

**How edge cases are handled:**
- Admin using simple leave → Blocked
- Admin is only member → Blocked
- Selected user not a member → Transaction fails
- Current user not admin → Transaction fails
- Group deleted → Transaction fails
- New admin same as current → Blocked
- Concurrent modifications → Firestore handles

**What happens if transaction fails:**
- No changes made to database
- User shown error message
- User remains in group
- Admin status unchanged
- Can retry operation
- No data corruption

**Result:**
- Safe, atomic admin transfers
- Simple member leave process
- Comprehensive error handling
- Group always has exactly one admin
- No orphaned groups
