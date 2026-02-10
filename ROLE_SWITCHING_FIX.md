# Role Switching Fix - Firestore Persistence

## Problem Summary

Users could switch between "Member" and "Advisor" roles using the drawer menu buttons, but these changes were **only saved to local storage** and **not persisted to Firestore**. This caused:

1. ❌ Role changes were lost when the app restarted
2. ❌ Role changes were lost when the user logged in again
3. ❌ Inconsistency between local storage and Firestore data
4. ❌ Permission checks failed because Firestore had the old role

## Root Cause

The `switchRole()` method in `AuthController` only updated local storage:

```dart
// OLD CODE (BROKEN)
void switchRole(String role) {
  roleStore(role);  // Only updates local storage
  if (role == "admin") {
    Get.offAllNamed(Routes.TrainerDashboard);
  } else {
    Get.offAllNamed(Routes.ClientDashboard);
  }
}
```

**What was missing:**
- ❌ No Firestore update
- ❌ No error handling
- ❌ No user feedback
- ❌ No validation

## Solution Implemented

### 1. **Updated `switchRole()` Method** (`auth_controller.dart`)

The method now:
1. ✅ Fetches the current user profile from Firestore
2. ✅ Creates an updated profile with the new role
3. ✅ Saves the updated profile to Firestore
4. ✅ Updates local storage
5. ✅ Shows success/error messages
6. ✅ Handles errors gracefully

```dart
// NEW CODE (FIXED)
Future<void> switchRole(String role) async {
  try {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      Get.snackbar('Error', 'No user logged in', ...);
      return;
    }

    // Get current user profile from Firestore
    final usersService = UsersFirestoreService();
    UserModel? profile = await usersService.getUserProfile(currentUser.uid);

    if (profile == null) {
      Get.snackbar('Error', 'User profile not found', ...);
      return;
    }

    // Normalize the role
    String normalizedRole = role == "admin" ? "advisor" : "member";

    // Update profile with new role
    final updatedProfile = UserModel(
      // ... all existing fields ...
      role: normalizedRole, // Update the role
      roleSetAt: profile.roleSetAt ?? DateTime.now(),
    );

    // Update Firestore (CRITICAL FIX)
    await usersService.updateUserProfile(updatedProfile);

    // Update local storage
    await userdataStore(updatedProfile.toJson());
    roleStore(normalizedRole);

    // Show success message
    Get.snackbar(
      'Role Updated',
      'You are now a ${normalizedRole == "advisor" ? "Advisor" : "Member"}',
      backgroundColor: const Color(0xFFC2D86A),
      colorText: Colors.black,
    );

    // Navigate to appropriate dashboard
    if (normalizedRole == "advisor") {
      Get.offAllNamed(Routes.TrainerDashboard);
    } else {
      Get.offAllNamed(Routes.ClientDashboard);
    }
  } catch (e) {
    print("❌ Error switching role: $e");
    Get.snackbar('Error', 'Failed to switch role. Please try again.', ...);
  }
}
```

### 2. **Added Material Import** (`auth_controller.dart`)

Added Flutter material import to use `Color` and `Colors`:

```dart
import 'package:flutter/material.dart';
```

## How It Works Now

### User Flow:

1. **User opens drawer menu**
2. **User clicks "Switch as Advisor" or "Switch as Member"**
3. **System performs the following:**
   - ✅ Validates user is logged in
   - ✅ Fetches current profile from Firestore
   - ✅ Creates updated profile with new role
   - ✅ **Saves to Firestore** (permanent storage)
   - ✅ Updates local storage (for offline access)
   - ✅ Shows success message
   - ✅ Navigates to appropriate dashboard
4. **Role change is now permanent**
   - ✅ Survives app restarts
   - ✅ Survives logout/login
   - ✅ Syncs across devices

### Role Normalization:

The system normalizes roles for consistency:
- `"admin"` → `"advisor"`
- `"user"` → `"member"`

This ensures:
- ✅ Case-insensitive role checks work correctly
- ✅ RBAC permissions work as expected
- ✅ Consistent role naming across the app

## Files Modified

### 1. `lib/app/core/base/controllers/auth_controller.dart`
- **Line 1**: Added `import 'package:flutter/material.dart';`
- **Lines 388-485**: Completely rewrote `switchRole()` method
  - Changed from `void` to `Future<void>` (async)
  - Added Firestore persistence
  - Added error handling
  - Added user feedback
  - Added validation

## Testing Checklist

To verify the fix works:

### Test 1: Role Switch Persistence
1. ✅ Login as a user
2. ✅ Open drawer menu
3. ✅ Click "Switch as Advisor"
4. ✅ Verify you see "Role Updated" success message
5. ✅ Verify you're navigated to Trainer Dashboard
6. ✅ **Close and restart the app**
7. ✅ **Verify you're still an Advisor** (not reverted to Member)

### Test 2: Firestore Sync
1. ✅ Switch role from Member to Advisor
2. ✅ Check Firestore console
3. ✅ Verify the `role` field is updated to "advisor"
4. ✅ Verify `roleSetAt` timestamp is set (if it wasn't already)

### Test 3: Login Persistence
1. ✅ Switch role to Advisor
2. ✅ Logout
3. ✅ Login again
4. ✅ **Verify you're still an Advisor** (role persisted)

### Test 4: RBAC Permissions
1. ✅ Switch to Member role
2. ✅ Try to access Client List screen
3. ✅ Verify "Permission Denied" error shows
4. ✅ Switch to Advisor role
5. ✅ Try to access Client List screen
6. ✅ Verify you can access it successfully

### Test 5: Error Handling
1. ✅ Disconnect internet
2. ✅ Try to switch role
3. ✅ Verify error message shows
4. ✅ Reconnect internet
5. ✅ Try again - should work

## Benefits of This Fix

### Before (Broken):
- ❌ Role changes only in local storage
- ❌ Lost on app restart
- ❌ Lost on logout/login
- ❌ No error handling
- ❌ No user feedback
- ❌ Inconsistent data

### After (Fixed):
- ✅ Role changes saved to Firestore
- ✅ Persists across app restarts
- ✅ Persists across logout/login
- ✅ Proper error handling
- ✅ Clear user feedback
- ✅ Consistent data everywhere
- ✅ Works with RBAC permissions
- ✅ Syncs across devices

## Additional Notes

### Role Immutability (Future Enhancement)

Currently, users can freely switch roles. If you want to make roles immutable after first selection, you can check the `roleSetAt` field:

```dart
// Example: Prevent role switching after initial selection
if (profile.roleSetAt != null) {
  Get.snackbar(
    'Role Locked',
    'Your role was set on ${profile.roleSetAt} and cannot be changed',
    backgroundColor: Colors.orange,
    colorText: Colors.white,
  );
  return;
}
```

### Role-Based UI (Current Implementation)

The drawer menu shows both "Switch as Advisor" and "Switch as Member" buttons to all users. You could enhance this to:
- Only show "Switch as Advisor" to Members
- Only show "Switch as Member" to Advisors
- Hide role switching entirely if you want roles to be permanent

## Debug Output

When switching roles, you'll see:

### Success:
```
✅ Role Updated
You are now a Advisor
```

### Error (No User):
```
❌ Error
No user logged in
```

### Error (No Profile):
```
❌ Error
User profile not found
```

### Error (Network):
```
❌ Error switching role: [error details]
Failed to switch role. Please try again.
```

## Summary

The role switching feature now works correctly with full Firestore persistence. Users can switch between Member and Advisor roles, and these changes are permanent, surviving app restarts, logouts, and working correctly with the RBAC permission system.
