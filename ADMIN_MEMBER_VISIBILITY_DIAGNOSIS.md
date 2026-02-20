# Admin vs Member Visibility Issue - Complete Diagnosis

## Problem Statement
- **Admin** assigns meals for group "Muscle Gain" on Feb 20, 2026
- **Admin** sees assigned meals correctly in Weekly Meal Planner
- **Member** of the same group opens Weekly Meal Planner for same date
- **Member** sees "No meal assigned" for all categories

## STEP 1: Code Analysis

### Save Logic (Admin Only)

**File:** `lib/app/modules/group/controllers/weekly_meal_planner_controller.dart`

**Method:** `updateMealSlot()` (Lines 195-245)
```dart
Future<void> updateMealSlot(
  DateTime date,
  String mealType,
  String? mealId,
) async {
  if (groupId == null || !isAdmin) return;  // ← Only admin can save

  // ... validation ...

  // Save to Firestore
  await _mealPlansService.updateMealSlot(
    groupId!,  // ← Uses controller's groupId
    date,
    mealType,
    mealId,
    userId,
    userName,
  );
}
```

**Firestore Service:** `lib/app/data/services/group_meal_plans_firestore_service.dart`

**Method:** `updateMealSlot()` (Lines 122-185)
```dart
Future<void> updateMealSlot(
  String groupId,  // ← Receives groupId from controller
  DateTime date,
  String mealType,
  String? mealId,
  String adminId,
  String adminName,
) async {
  // Query existing plan
  final existingPlan = await getMealPlanForDate(groupId, date);
  
  if (existingPlan != null) {
    // Update existing document
    await _firestore
        .collection(_collection)
        .doc(existingPlan.id)
        .update({
          'mealSlots': updatedSlots,
          'updatedAt': DateTime.now().toIso8601String(),
        });
  } else {
    // Create new document
    final newPlan = GroupMealPlanModel(
      groupId: groupId,  // ← Stores groupId in document
      date: date,
      mealSlots: {mealType: mealId},
      createdBy: adminId,
      createdByName: adminName,
      createdAt: DateTime.now(),
    );
    await _firestore.collection(_collection).add(newPlan.toJson());
  }
}
```

### Fetch Logic (Both Admin and Member)

**File:** `lib/app/modules/group/controllers/weekly_meal_planner_controller.dart`

**Method:** `_loadMealPlans()` (Lines 125-148)
```dart
void _loadMealPlans() {
  if (groupId == null) return;

  final startDate = currentWeekStart.value;
  final endDate = startDate.add(const Duration(days: 6));

  // BOTH admin and members use SAME query
  mealPlans.bindStream(
    _mealPlansService.getGroupMealPlansStream(
      groupId!,  // ← Uses controller's groupId
      startDate,
      endDate
    ),
  );
}
```

**Firestore Service:** `lib/app/data/services/group_meal_plans_firestore_service.dart`

**Method:** `getGroupMealPlansStream()` (Lines 9-36)
```dart
Stream<List<GroupMealPlanModel>> getGroupMealPlansStream(
  String groupId,
  DateTime startDate,
  DateTime endDate,
) {
  final startDateStr = _formatDateOnly(startDate);
  final endDateStr = _formatDateOnly(endDate);

  return _firestore
      .collection(_collection)
      .where('groupId', isEqualTo: groupId)  // ← Filters by groupId
      .where('date', isGreaterThanOrEqualTo: startDateStr)
      .where('date', isLessThanOrEqualTo: endDateStr)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => GroupMealPlanModel.fromJson(doc.data(), docId: doc.id))
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));
      });
}
```

### Initialization Logic

**File:** `lib/app/modules/group/controllers/weekly_meal_planner_controller.dart`

**Method:** `onInit()` (Lines 31-50)
```dart
@override
void onInit() {
  super.onInit();

  final args = Get.arguments as Map<String, dynamic>?;
  if (args != null) {
    groupId = args['id'] ?? args['groupId'];  // ← Extracts groupId from arguments
    groupName = args['name'] ?? 'Group';
    isAdmin = args['isAdmin'] ?? false;
  }

  // ... rest of initialization ...
}
```

---

## STEP 2: Potential Root Causes

### Hypothesis 1: Different groupId Values ⚠️ MOST LIKELY

**Scenario:**
- Admin opens planner with `groupId = "actualGroupId123"`
- Admin saves meals → Firestore document has `groupId: "actualGroupId123"`
- Member opens planner with `groupId = "differentId456"` (or null)
- Member queries Firestore with wrong groupId → No documents found

**Why This Happens:**
- Navigation arguments passed differently for admin vs member
- Admin might use `args['id']` while member uses `args['groupId']`
- One of them might be null or have wrong value

### Hypothesis 2: Date Format Mismatch ❌ UNLIKELY

**Verification:**
Both save and fetch use identical date formatting:
```dart
String _formatDateOnly(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
```
✅ Date format is consistent.

### Hypothesis 3: Document ID Issue ❌ NOT APPLICABLE

**Verification:**
- Documents use auto-generated IDs (`.add()` method)
- Query uses `where('groupId', isEqualTo: groupId)` not document ID
- Document ID is not used for filtering

✅ Document ID is not the issue.

### Hypothesis 4: Permission/Security Rules ⚠️ POSSIBLE

**Scenario:**
- Firestore security rules might prevent members from reading documents
- Admin can read because they created the document
- Member cannot read due to security rules

---

## STEP 3: Enhanced Debug Logging

### Changes Made:

**1. Controller Initialization Logging:**
```dart
@override
void onInit() {
  // ... existing code ...
  
  print('=== WEEKLY MEAL PLANNER INIT ===');
  print('👤 User Role: ${isAdmin ? "ADMIN" : "MEMBER"}');
  print('🏢 Group ID: $groupId');
  print('📛 Group Name: $groupName');
  print('📦 Arguments received: $args');
  print('=================================');
}
```

**2. Load Meal Plans Logging:**
```dart
void _loadMealPlans() {
  print('=== LOADING MEAL PLANS ===');
  print('👤 User Role: ${isAdmin ? "ADMIN" : "MEMBER"}');
  print('🏢 Group ID for query: $groupId');
  print('📅 Date range: ${_formatDateOnly(startDate)} to ${_formatDateOnly(endDate)}');
  print('🔍 Firestore Query:');
  print('   - Collection: group_meal_plans');
  print('   - WHERE groupId == $groupId');
  print('   - WHERE date >= ${_formatDateOnly(startDate)}');
  print('   - WHERE date <= ${_formatDateOnly(endDate)}');
  print('==========================');
}
```

**3. Firestore Query Logging:**
```dart
Stream<List<GroupMealPlanModel>> getGroupMealPlansStream(...) {
  print('=== FIRESTORE QUERY: getGroupMealPlansStream ===');
  print('🔍 Query Parameters:');
  print('   - groupId: $groupId');
  print('   - startDate: $startDateStr');
  print('   - endDate: $endDateStr');
  print('===============================================');
  
  return _firestore
      .collection(_collection)
      .where('groupId', isEqualTo: groupId)
      // ... rest of query ...
      .snapshots()
      .map((snapshot) {
        print('=== FIRESTORE SNAPSHOT RECEIVED ===');
        print('📦 Documents found: ${snapshot.docs.length}');
        for (var doc in snapshot.docs) {
          final data = doc.data();
          print('📄 Document ${doc.id}:');
          print('   - groupId: ${data['groupId']}');
          print('   - date: ${data['date']}');
          print('   - mealSlots: ${data['mealSlots']}');
        }
        print('===================================');
        // ... rest of mapping ...
      });
}
```

**4. Meal Plans Stream Update Logging:**
```dart
ever(mealPlans, (plans) {
  print('=== MEAL PLANS STREAM UPDATE ===');
  print('👤 User Role: ${isAdmin ? "ADMIN" : "MEMBER"}');
  print('📊 Plans loaded: ${plans.length}');
  for (var plan in plans) {
    print('📄 Plan Document:');
    print('   - ID: ${plan.id}');
    print('   - Date: ${_formatDateOnly(plan.date)}');
    print('   - GroupId: ${plan.groupId}');
    print('   - MealSlots: ${plan.mealSlots}');
    print('   - Meal Count: ${plan.mealCount}');
  }
  print('================================');
});
```

---

## STEP 4: Verification Steps

### Run the App and Check Console Logs:

**1. Admin Flow:**
```
1. Admin opens Weekly Meal Planner
2. Check console for:
   === WEEKLY MEAL PLANNER INIT ===
   👤 User Role: ADMIN
   🏢 Group ID: [ADMIN_GROUP_ID]
   📛 Group Name: Muscle Gain
   📦 Arguments received: {id: ..., name: ..., isAdmin: true}
   
3. Admin assigns a meal
4. Check console for:
   === UPDATE MEAL SLOT ===
   🏢 Group ID: [ADMIN_GROUP_ID]
   📅 Date: 2026-02-20
   
5. Check console for stream update:
   === MEAL PLANS STREAM UPDATE ===
   👤 User Role: ADMIN
   📊 Plans loaded: 1
   📄 Plan Document:
      - GroupId: [ADMIN_GROUP_ID]
      - Date: 2026-02-20
      - MealSlots: {Breakfast: mealId1, ...}
```

**2. Member Flow:**
```
1. Member opens Weekly Meal Planner
2. Check console for:
   === WEEKLY MEAL PLANNER INIT ===
   👤 User Role: MEMBER
   🏢 Group ID: [MEMBER_GROUP_ID]  ← COMPARE WITH ADMIN!
   📛 Group Name: Muscle Gain
   📦 Arguments received: {id: ..., name: ..., isAdmin: false}
   
3. Check console for query:
   === LOADING MEAL PLANS ===
   👤 User Role: MEMBER
   🏢 Group ID for query: [MEMBER_GROUP_ID]  ← COMPARE WITH ADMIN!
   
4. Check console for Firestore results:
   === FIRESTORE SNAPSHOT RECEIVED ===
   📦 Documents found: 0  ← If 0, groupId mismatch!
```

### Compare the Values:

**Critical Comparison:**
```
ADMIN Group ID:  [ADMIN_GROUP_ID]
MEMBER Group ID: [MEMBER_GROUP_ID]

Are they IDENTICAL? 
- YES → Check Firestore security rules
- NO → FIX: Ensure both receive same groupId in navigation arguments
```

---

## STEP 5: Expected Findings

### If groupId Mismatch:

**Console Output (Admin):**
```
🏢 Group ID: abc123xyz
📄 Plan Document:
   - GroupId: abc123xyz
   - MealSlots: {Breakfast: meal1, Lunch: meal2}
```

**Console Output (Member):**
```
🏢 Group ID: null  ← OR different value!
📦 Documents found: 0  ← No documents match!
```

**Root Cause:** Navigation arguments not passing groupId correctly to member.

**Fix Location:** Check where Weekly Meal Planner is opened for members. Ensure `Get.toNamed()` or `Get.to()` passes correct arguments:
```dart
Get.toNamed(
  Routes.WEEKLY_MEAL_PLANNER,
  arguments: {
    'id': group.id,  // ← Must be same field name as admin uses
    'groupId': group.id,  // ← Provide both for compatibility
    'name': group.name,
    'isAdmin': false,
  },
);
```

---

## STEP 6: Fix Implementation

### If groupId is null or wrong for member:

**Find where member opens planner:**
```bash
# Search for navigation to weekly planner
grep -r "WEEKLY_MEAL_PLANNER" lib/
grep -r "WeeklyMealPlannerView" lib/
```

**Fix the navigation call:**
```dart
// BEFORE (BROKEN):
Get.toNamed(Routes.WEEKLY_MEAL_PLANNER, arguments: {
  'name': group.name,
  'isAdmin': false,
});

// AFTER (FIXED):
Get.toNamed(Routes.WEEKLY_MEAL_PLANNER, arguments: {
  'id': group.id,  // ← ADD THIS!
  'groupId': group.id,  // ← AND THIS for compatibility
  'name': group.name,
  'isAdmin': false,
});
```

### If Firestore Security Rules Block Member:

**Check Firestore Rules:**
```javascript
// firestore.rules
match /group_meal_plans/{planId} {
  // Allow read if user is member of the group
  allow read: if request.auth != null && 
              exists(/databases/$(database)/documents/groups/$(resource.data.groupId)/members/$(request.auth.uid));
  
  // Allow write only if user is admin of the group
  allow write: if request.auth != null && 
               get(/databases/$(database)/documents/groups/$(resource.data.groupId)).data.adminId == request.auth.uid;
}
```

---

## Summary

**Most Likely Root Cause:** Member receives different or null `groupId` in navigation arguments.

**Why Admin Sees Meals:** Admin's `groupId` matches the document's `groupId` field.

**Why Member Doesn't:** Member's `groupId` is different/null, so Firestore query returns 0 documents.

**Exact Field Causing Issue:** The `groupId` field in navigation arguments (`args['id']` or `args['groupId']`).

**Next Steps:**
1. Run the app with both admin and member
2. Compare console logs for `Group ID` values
3. If different, fix navigation arguments where member opens planner
4. If same, check Firestore security rules
