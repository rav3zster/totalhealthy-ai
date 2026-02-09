# Switch Role Screen - Only After Signup

## Problem Statement
Switch Role screen was appearing after both signup AND login, causing confusion for existing users who had already selected their role.

## Solution Overview
Updated authentication logic to check Firestore user document for role field. Switch Role screen now only appears when:
1. User document doesn't exist in Firestore, OR
2. User document exists but role field is null/empty

## Changes Implemented

### 1. User Model - Made Role Nullable
**Before:**
```dart
final String role; // Default: "member"
```

**After:**
```dart
final String? role; // Can be null if not selected
```

**Changes:**
- ✅ Changed role field from `String` to `String?`
- ✅ Removed default "member" value from constructor
- ✅ Updated `fromJson()` to not provide default value
- ✅ Role is now `null` until explicitly selected

### 2. Auth Controller - `_setInitialScreen()` Method
**Before:**
- Checked local storage for role
- Showed Switch Role if no local role found

**After:**
- ✅ Fetches user profile from Firestore
- ✅ Checks if user document exists
- ✅ Checks if role field is null/empty in Firestore
- ✅ Shows Switch Role ONLY if document missing or role null
- ✅ Navigates to dashboard if role exists
- ✅ Syncs Firestore role to local storage

**Logic Flow:**
```dart
1. Check if signup flow (don't interrupt)
2. Fetch user profile from Firestore
3. If profile null → Switch Role
4. If profile.role null/empty → Switch Role
5. If profile.role exists → Dashboard
```

### 3. Login Method
**Before:**
- Set default "user" role for non-admin users
- Created legacy profiles with default role

**After:**
- ✅ Creates legacy profiles WITHOUT role (role: null)
- ✅ Does NOT set any default role
- ✅ Lets `_setInitialScreen()` handle navigation based on Firestore

### 4. Register Method
**Before:**
- Created user with default "user" role

**After:**
- ✅ Creates user profile with `role: null`
- ✅ Does NOT set any default role
- ✅ User must select role via Switch Role screen

### 5. Switch Role Screen - Save to Firestore
**Before:**
- Only saved role to local storage
- Did not update Firestore

**After:**
- ✅ Saves role to local storage
- ✅ Fetches user profile from Firestore
- ✅ Updates profile with selected role
- ✅ Saves updated profile to Firestore
- ✅ Syncs to local storage
- ✅ Then navigates to appropriate screen

**New Logic:**
```dart
1. User selects role
2. Save to local storage (roleStore)
3. Fetch current profile from Firestore
4. Create updated profile with role
5. Save to Firestore (updateUserProfile)
6. Sync to local storage (userdataStore)
7. Navigate to dashboard
```

## Navigation Flows

### Signup Flow (New User)
```
1. Signup Screen
   ↓ (creates user with role: null)
2. Auth listener checks Firestore
   ↓ (role is null)
3. Switch Role Screen
   ↓ (user selects role, saves to Firestore)
4a. Advisor → Trainer Dashboard
4b. Member → Nutrition Goals → Client Dashboard
```

### Login Flow (Existing User with Role)
```
1. Login Screen
   ↓ (success)
2. Auth listener fetches Firestore profile
   ↓ (role exists in Firestore)
3. Navigate directly to Dashboard
   ↓
4. NO Switch Role screen shown
```

### Login Flow (Existing User without Role)
```
1. Login Screen
   ↓ (success)
2. Auth listener fetches Firestore profile
   ↓ (role is null in Firestore)
3. Switch Role Screen
   ↓ (user selects role, saves to Firestore)
4. Navigate to Dashboard
```

### Login Flow (Legacy User - No Document)
```
1. Login Screen
   ↓ (success, creates profile with role: null)
2. Auth listener fetches Firestore profile
   ↓ (role is null)
3. Switch Role Screen
   ↓ (user selects role, saves to Firestore)
4. Navigate to Dashboard
```

## Key Rules Enforced

### 1. Firestore is Source of Truth
- ✅ Role checked from Firestore, not local storage
- ✅ Local storage synced from Firestore
- ✅ Single source of truth for role state

### 2. Switch Role Conditions
- ✅ Shows ONLY if Firestore document missing
- ✅ Shows ONLY if role field is null/empty
- ✅ Never shows if role already exists

### 3. Role Persistence
- ✅ Role saved to Firestore when selected
- ✅ Role persists across app restarts
- ✅ Role synced to local storage for quick access

### 4. No Default Roles
- ✅ No "member" default
- ✅ No "user" default
- ✅ User must explicitly select role

## Technical Details

### Firestore Document Structure
```json
{
  "id": "user_id",
  "email": "user@example.com",
  "role": null,  // null until selected
  // ... other fields
}
```

After role selection:
```json
{
  "id": "user_id",
  "email": "user@example.com",
  "role": "admin",  // or "user"
  // ... other fields
}
```

### Navigation Decision Logic
```dart
// In _setInitialScreen()
UserModel? profile = await usersService.getUserProfile(user.uid);

if (profile == null || profile.role == null || profile.role!.isEmpty) {
  // Show Switch Role
  Get.offAllNamed(Routes.SWITCHROLE);
} else {
  // Navigate to dashboard
  roleStore(profile.role!);
  if (profile.role == "admin" || profile.role == "trainer") {
    Get.offAllNamed(Routes.TrainerDashboard);
  } else {
    Get.offAllNamed(Routes.ClientDashboard);
  }
}
```

### Role Update in Switch Role
```dart
// When user selects role
final updatedProfile = UserModel(
  // ... copy all existing fields
  role: selectedRole, // Set the selected role
);

await usersService.updateUserProfile(updatedProfile);
await authController.userdataStore(updatedProfile.toJson());
```

## Code Quality

### Improvements
- ✅ Single source of truth (Firestore)
- ✅ Consistent role checking
- ✅ Proper async/await handling
- ✅ No diagnostics errors
- ✅ Clean navigation logic

### Performance
- Single Firestore fetch per auth event
- Efficient role checking
- No redundant queries
- Proper state management

## Testing Checklist

### New User Signup
- [ ] Sign up with new account
- [ ] Verify Switch Role screen appears
- [ ] Select Advisor role
- [ ] Verify role saved to Firestore
- [ ] Verify navigation to Trainer Dashboard
- [ ] Logout and login again
- [ ] Verify NO Switch Role screen (goes directly to dashboard)

### New User Signup (Member)
- [ ] Sign up with new account
- [ ] Verify Switch Role screen appears
- [ ] Select Member role
- [ ] Verify role saved to Firestore
- [ ] Complete nutrition goals
- [ ] Verify navigation to Client Dashboard
- [ ] Logout and login again
- [ ] Verify NO Switch Role screen (goes directly to dashboard)

### Existing User Login (With Role)
- [ ] Login with account that has role in Firestore
- [ ] Verify NO Switch Role screen
- [ ] Verify direct navigation to dashboard
- [ ] Verify correct dashboard based on role

### Existing User Login (Without Role)
- [ ] Login with account that has null role in Firestore
- [ ] Verify Switch Role screen appears
- [ ] Select role
- [ ] Verify role saved to Firestore
- [ ] Verify navigation to dashboard
- [ ] Logout and login again
- [ ] Verify NO Switch Role screen

### Legacy User (No Document)
- [ ] Login with account that has no Firestore document
- [ ] Verify document created with role: null
- [ ] Verify Switch Role screen appears
- [ ] Select role
- [ ] Verify role saved to Firestore
- [ ] Logout and login again
- [ ] Verify NO Switch Role screen

### Role Persistence
- [ ] Select role via Switch Role
- [ ] Close app completely
- [ ] Reopen app
- [ ] Verify goes directly to dashboard
- [ ] Verify correct dashboard based on saved role

## Files Modified
1. `lib/app/data/models/user_model.dart`
   - Made role field nullable
   - Removed default value

2. `lib/app/core/base/controllers/auth_controller.dart`
   - Updated `_setInitialScreen()` to check Firestore
   - Updated `login()` to not set default role
   - Updated `register()` to create user with null role

3. `lib/app/widgets/switch_role_screen.dart`
   - Added Firestore update logic
   - Saves role to Firestore when selected
   - Added necessary imports

## Status
✅ **COMPLETE** - Switch Role only appears after signup
- Firestore is source of truth for role
- Switch Role shown only when role is null
- Existing users go directly to dashboard
- Role persists across sessions
- No diagnostics errors
- Clean, efficient navigation

## Summary
Switch Role screen now only appears when necessary (after signup or for users without a role). Existing users with a role go directly to their dashboard. The role is stored in Firestore as the source of truth and synced to local storage for performance.
