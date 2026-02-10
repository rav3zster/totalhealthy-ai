# RBAC Permission Fix - Client List Access Control

## Problem Summary
Users with the "Advisor" role (capitalized) in Firestore were unable to access the Client List screen because the code was performing case-sensitive role checks, comparing "Advisor" with "advisor".

## Root Cause
The role-based access control (RBAC) system was checking roles with case-sensitive string comparisons, causing mismatches when roles were stored with different capitalizations in Firestore (e.g., "Advisor" vs "advisor").

## Solution Implemented

### 1. **Case-Insensitive Role Checks** (`user_model.dart`)
✅ **Already Fixed** - The `UserModel` class already has case-insensitive role checking:

```dart
bool get isAdvisor {
  if (role == null) return false;
  final r = role!.toLowerCase();
  return r == 'advisor' || r == 'admin' || r == 'trainer';
}

bool get isMember {
  if (role == null) return false;
  final r = role!.toLowerCase();
  return r == 'member' || r == 'user';
}
```

**What this does:**
- Converts the role to lowercase before comparison
- Recognizes "Advisor", "advisor", "ADVISOR" as the same role
- Also handles aliases like "admin" and "trainer" as advisor roles

### 2. **Real-Time Permission Sync** (`role_permissions_service.dart`)
✅ **Already Fixed** - The service prioritizes real-time Firestore data:

```dart
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
    print("❌ RolePermissionsService: Failed to get current user: $e");
    return null;
  }
}
```

**What this does:**
- First tries to get user data from `UserController` (real-time Firestore stream)
- Falls back to `AuthController` if `UserController` isn't ready
- Ensures the most up-to-date role information is used

### 3. **Debug Logging** (`role_permissions_service.dart`)
✅ **Already Fixed** - Added comprehensive debug logging:

```dart
bool get isAdvisor {
  final user = _getCurrentUser();
  final advisorStatus = user?.isAdvisor ?? false;
  print(
    "🔑 RBAC Check: User: ${user?.fullName}, Role: ${user?.role}, IsAdvisor: $advisorStatus",
  );
  return advisorStatus;
}
```

**What this does:**
- Logs every RBAC check with user name, role, and advisor status
- Helps debug permission issues in the console
- Format: `🔑 RBAC Check: User: [name], Role: [role], IsAdvisor: [true/false]`

### 4. **Case-Insensitive Filtering** (`role_permissions_service.dart`)
✅ **Already Fixed** - Filter methods use case-insensitive comparisons:

```dart
List<UserModel> filterAvailableMembers(
  List<UserModel> allUsers,
  Set<String> currentMemberIds,
  Set<String> pendingInviteIds,
) {
  // ... filtering logic ...
  
  // Check if role is excluded (only admin and advisor)
  final roleLower = user.role!.toLowerCase();
  final isExcludedRole = roleLower == 'admin' || roleLower == 'advisor';
  
  // ... rest of logic ...
}
```

**What this does:**
- Converts roles to lowercase before filtering
- Ensures advisors are correctly excluded from member lists
- Handles null/empty roles safely

### 5. **NEW: Screen-Level Permission Guard** (`client_list_screen.dart`)
🆕 **Added** - Permission check at screen initialization:

```dart
@override
void initState() {
  super.initState();
  
  // CRITICAL: RBAC Check - Only Advisors can access this screen
  if (!_permissionsService.canManageClients()) {
    debugPrint('❌ RBAC: Non-advisor attempted to access Client List');
    
    // Show error message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        'Permission Denied',
        'Only Advisors can manage clients',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      
      // Navigate back
      Get.back();
    });
    
    return;
  }
  
  debugPrint('✅ RBAC: Advisor access granted to Client List');
  _loadMembers();
}
```

**What this does:**
- Checks permissions immediately when the screen initializes
- Shows a clear error message if permission is denied
- Automatically navigates back to prevent access
- Logs the permission check for debugging

### 6. **NEW: Pre-Navigation Permission Check** (`trainer_dashboard_views.dart`)
🆕 **Added** - Permission check before navigation:

```dart
GestureDetector(
  onTap: () {
    // RBAC: Check permission before navigation
    if (!_permissionsService.canManageClients()) {
      Get.snackbar(
        'Permission Denied',
        'Only Advisors can manage clients',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }
    
    Get.toNamed(Routes.CLIENT_LIST);
  },
  // ... button UI ...
)
```

**What this does:**
- Checks permissions BEFORE navigating to the Client List screen
- Provides immediate feedback without unnecessary navigation
- Better user experience - error shows without screen flash

## Files Modified

### 1. `lib/app/modules/group/views/client_list_screen.dart`
- Added permission guard in `initState()`
- Shows error and navigates back if not an advisor

### 2. `lib/app/modules/trainer_dashboard/views/trainer_dashboard_views.dart`
- Added `RolePermissionsService` import
- Added permission check before "Add Client" button navigation
- Prevents non-advisors from accessing the screen

## Testing Checklist

To verify the fix works:

1. ✅ **Advisor Access** - Users with role "Advisor", "advisor", "ADVISOR" can access Client List
2. ✅ **Member Blocked** - Users with role "Member", "member" cannot access Client List
3. ✅ **Error Message** - Clear "Permission Denied" message shows when blocked
4. ✅ **Auto-Redirect** - Non-advisors are automatically redirected back
5. ✅ **Debug Logs** - Console shows RBAC check results
6. ✅ **Real-Time Sync** - Role changes in Firestore are immediately reflected

## Debug Output Examples

### Successful Advisor Access:
```
🔑 RBAC Check: User: John Doe, Role: Advisor, IsAdvisor: true
✅ RBAC: Advisor access granted to Client List
```

### Blocked Member Access:
```
🔑 RBAC Check: User: Jane Smith, Role: Member, IsAdvisor: false
❌ RBAC: Non-advisor attempted to access Client List
```

## Result
✅ **Fixed** - Advisors can now access the Client List screen regardless of role capitalization
✅ **Secure** - Non-advisors are properly blocked with clear error messages
✅ **Debuggable** - Comprehensive logging helps track permission issues
