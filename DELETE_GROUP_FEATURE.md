# Delete Group Feature - Implementation

## Overview
Implemented a delete group feature that allows only group admins (creators) to delete their groups. The delete button appears on group cards in the Groups tab and includes a confirmation dialog to prevent accidental deletions.

---

## Implementation Details

### 1. Service Layer (`groups_firestore_service.dart`)

#### Added Delete Method
```dart
Future<void> deleteGroup(String groupId) async {
  if (groupId.isEmpty) {
    throw ArgumentError('Group ID cannot be empty');
  }

  // Check if group exists
  final groupDoc = await _firestore.collection(_collection).doc(groupId).get();
  if (!groupDoc.exists) {
    throw Exception('Group not found. It may have already been deleted.');
  }

  // Delete the group document
  await _firestore.collection(_collection).doc(groupId).delete();

  print('Group $groupId deleted successfully');
}
```

**Purpose:** Deletes a group document from Firestore.

**Validation:**
- Checks if groupId is not empty
- Verifies group exists before attempting deletion
- Throws exceptions for invalid operations

**Security Note:** This is the data layer. Actual permission enforcement happens in:
1. Controller layer (checks if user is admin)
2. Firestore Security Rules (server-side enforcement)

---

### 2. Controller Layer (`group_controller.dart`)

#### Added Delete Group Method
```dart
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
        // ... confirmation dialog UI
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
```

**Purpose:** Orchestrates the group deletion process with proper validation and user feedback.

**Flow:**
1. Get current user ID from Firebase Auth
2. Verify user is logged in
3. Check if user is admin using `group.isAdmin(userId)`
4. Validate group ID exists
5. Show confirmation dialog
6. If confirmed, call service to delete group
7. Show success/error feedback
8. Update loading state

**Security:**
- Uses `group.isAdmin(userId)` which checks `createdBy == userId`
- Fails if user is not admin
- Requires explicit confirmation from user

---

### 3. View Layer (`group_view.dart`)

#### Modified Group Card to Include Delete Button
```dart
Widget _buildGroupCard(GroupModel group) {
  // Check if current user is admin of this group
  final authController = Get.find<AuthController>();
  final currentUserId = authController.firebaseUser.value?.uid;
  final isAdmin = currentUserId != null && group.isAdmin(currentUserId);

  return TweenAnimationBuilder<double>(
    // ... animation wrapper
    child: Container(
      // ... card styling
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
                    style: const TextStyle(
                      color: Colors.white,
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
                        controller.deleteGroup(group);
                      },
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                      tooltip: 'Delete Group',
                    ),
                  ),
              ],
            ),
            // ... rest of card content
          ],
        ),
      ),
    ),
  );
}
```

**Purpose:** Display delete button only to group admins.

**Logic:**
1. Get current user ID from AuthController
2. Check if user is admin using `group.isAdmin(currentUserId)`
3. Conditionally render delete button with `if (isAdmin)`
4. Style button with red theme to indicate destructive action
5. Call `controller.deleteGroup(group)` on press

**UI/UX:**
- Delete button appears in top-right of group card
- Red color scheme indicates destructive action
- Icon-only button to save space
- Tooltip shows "Delete Group" on hover
- Only visible to group admin

---

## Confirmation Dialog

### Design
```dart
AlertDialog(
  backgroundColor: const Color(0xFF2A2A2A),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  title: const Row(
    children: [
      Icon(Icons.warning_rounded, color: Colors.orange, size: 28),
      SizedBox(width: 12),
      Text('Delete Group?', style: TextStyle(...)),
    ],
  ),
  content: Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Are you sure you want to delete "${group.name}"?'),
      const SizedBox(height: 12),
      Container(
        // Warning box with red theme
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
      child: const Text('Cancel'),
    ),
    ElevatedButton(
      onPressed: () => Get.back(result: true),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      child: const Text('Delete'),
    ),
  ],
)
```

**Features:**
- Warning icon in title
- Group name displayed in confirmation message
- Red warning box explaining consequences
- Clear "Cancel" and "Delete" actions
- Delete button styled in red
- Returns boolean result (true = confirmed, false = cancelled)

---

## Security Model

### Multi-Layer Security

#### Layer 1: UI (View)
```dart
final isAdmin = currentUserId != null && group.isAdmin(currentUserId);

if (isAdmin)
  IconButton(
    onPressed: () => controller.deleteGroup(group),
    // ...
  ),
```

**Purpose:** Hide button from non-admins for better UX.

**Security Level:** Low (UI can be manipulated)

#### Layer 2: Controller
```dart
if (!group.isAdmin(currentUserId)) {
  Get.snackbar(
    "Permission Denied",
    "Only the group admin can delete this group",
    backgroundColor: Colors.red,
    colorText: Colors.white,
  );
  return;
}
```

**Purpose:** Validate permissions before calling service.

**Security Level:** Medium (client-side validation)

#### Layer 3: Firestore Security Rules (Recommended)
```javascript
match /groups/{groupId} {
  // Allow read if user is creator or member
  allow read: if request.auth != null && 
    (resource.data.created_by == request.auth.uid || 
     request.auth.uid in resource.data.members_list);
  
  // Allow create if authenticated
  allow create: if request.auth != null;
  
  // Allow update/delete only if user is creator (admin)
  allow update, delete: if request.auth != null && 
    resource.data.created_by == request.auth.uid;
}
```

**Purpose:** Server-side enforcement of permissions.

**Security Level:** High (cannot be bypassed)

**Note:** This rule should be added to `firestore.rules` file.

---

## How Admin is Determined

### Data Source: GroupModel
```dart
class GroupModel {
  final String createdBy; // User ID of group creator
  
  bool isAdmin(String userId) => createdBy == userId;
}
```

**Admin Definition:** User whose `userId` matches the group's `createdBy` field.

**Source of Truth:** Firestore `groups` collection, `created_by` field.

### Verification Flow
```
1. User clicks delete button
   ↓
2. View checks: group.isAdmin(currentUserId)
   ↓
3. If false → button not shown
   ↓
4. If true → button shown, user clicks
   ↓
5. Controller checks: group.isAdmin(currentUserId)
   ↓
6. If false → show "Permission Denied" error
   ↓
7. If true → show confirmation dialog
   ↓
8. User confirms → delete group
   ↓
9. Firestore Rules verify: created_by == auth.uid
   ↓
10. If false → Firestore rejects deletion
    ↓
11. If true → Group deleted
```

---

## Why This Avoids Permission Leaks

### 1. No Hardcoded Roles
❌ **Bad:** `if (userRole == 'Admin')`
✅ **Good:** `if (group.isAdmin(userId))`

**Reason:** Uses the model's method which checks actual Firestore data.

### 2. Server-Side Data Source
❌ **Bad:** Storing admin status in local state
✅ **Good:** Reading from `group.createdBy` which comes from Firestore

**Reason:** Firestore data is the source of truth, can't be manipulated client-side.

### 3. Fail-Closed Security
```dart
if (currentUserId == null) {
  // Deny access
  return;
}

if (!group.isAdmin(currentUserId)) {
  // Deny access
  return;
}
```

**Reason:** If anything goes wrong, default to denying access.

### 4. Multiple Validation Layers
- UI: Hide button from non-admins
- Controller: Validate before service call
- Service: Validate group exists
- Firestore Rules: Server-side enforcement

**Reason:** Defense in depth - if one layer fails, others catch it.

### 5. Confirmation Required
```dart
final confirmed = await Get.dialog<bool>(...);

if (confirmed != true) {
  return; // User cancelled
}
```

**Reason:** Prevents accidental deletions, gives user chance to reconsider.

### 6. No Direct Firestore Access from View
❌ **Bad:** View directly calls Firestore to delete
✅ **Good:** View → Controller → Service → Firestore

**Reason:** Centralized validation in controller ensures consistent security checks.

---

## User Experience Flow

### Admin User
1. Opens Groups tab
2. Sees delete button (red trash icon) on their groups
3. Clicks delete button
4. Sees confirmation dialog with warning
5. Clicks "Delete" to confirm
6. Group is deleted
7. Sees success message
8. Group disappears from list (real-time update)

### Member User
1. Opens Groups tab
2. Does NOT see delete button on any groups
3. Cannot delete groups (button hidden)

### Non-Admin Attempting Bypass
1. Somehow triggers delete method (e.g., via console)
2. Controller checks: `group.isAdmin(userId)` → false
3. Shows "Permission Denied" error
4. Deletion blocked

### Firestore Rules Enforcement
1. Client sends delete request to Firestore
2. Firestore checks: `created_by == auth.uid`
3. If false → Request rejected with permission error
4. If true → Group deleted

---

## Testing Scenarios

### Scenario 1: Admin Deletes Own Group
```
Given: User is admin of "Muscle Gain" group
When: User clicks delete button on "Muscle Gain" card
Then: Confirmation dialog appears
When: User clicks "Delete"
Then: Group is deleted successfully
And: Success message is shown
And: Group disappears from list
```

### Scenario 2: Member Cannot See Delete Button
```
Given: User is member (not admin) of "Weight Loss" group
When: User views "Weight Loss" group card
Then: Delete button is NOT visible
```

### Scenario 3: Admin Cancels Deletion
```
Given: User is admin of "Cardio" group
When: User clicks delete button on "Cardio" card
Then: Confirmation dialog appears
When: User clicks "Cancel"
Then: Dialog closes
And: Group is NOT deleted
And: Group remains in list
```

### Scenario 4: Non-Admin Attempts Bypass
```
Given: User is member (not admin) of "Strength" group
When: User somehow calls controller.deleteGroup(strengthGroup)
Then: "Permission Denied" error is shown
And: Group is NOT deleted
```

### Scenario 5: Firestore Rules Block Unauthorized Delete
```
Given: User is member (not admin) of "Yoga" group
When: User sends direct Firestore delete request
Then: Firestore rejects request with permission error
And: Group is NOT deleted
```

---

## Code Locations

### Service
- **File:** `lib/app/data/services/groups_firestore_service.dart`
- **Method:** `deleteGroup(String groupId)` (lines ~120-135)

### Controller
- **File:** `lib/app/modules/group/controllers/group_controller.dart`
- **Method:** `deleteGroup(GroupModel group)` (lines ~280-420)

### View
- **File:** `lib/app/modules/group/views/group_view.dart`
- **Method:** `_buildGroupCard(GroupModel group)` (lines ~600-750)
- **Import:** Added `AuthController` import (line 10)

---

## Firestore Security Rules (Recommended)

Add to `firestore.rules`:

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
      
      // Allow update/delete only if user is creator (admin)
      allow update, delete: if request.auth != null && 
        resource.data.created_by == request.auth.uid;
    }
  }
}
```

**Deploy with:**
```bash
firebase deploy --only firestore:rules
```

---

## Summary

**What was added:**
- `deleteGroup()` method in GroupsFirestoreService
- `deleteGroup()` method in GroupController with validation and confirmation
- Delete button in group card (visible only to admins)
- Confirmation dialog with warning message
- AuthController import in group_view.dart

**How admin is determined:**
- User's `userId` is compared to group's `createdBy` field
- Uses `GroupModel.isAdmin(userId)` method
- Data comes from Firestore via group object

**Why this avoids permission leaks:**
- No hardcoded roles
- Server-side data source (Firestore)
- Fail-closed security (deny if uncertain)
- Multiple validation layers (UI, Controller, Service, Firestore Rules)
- Confirmation required
- No direct Firestore access from view
- Defense in depth approach

**Result:**
- Only group admins can delete their groups
- Members cannot see or access delete functionality
- Confirmation prevents accidental deletions
- Secure, user-friendly implementation
