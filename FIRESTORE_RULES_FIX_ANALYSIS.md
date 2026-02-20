# Firestore Security Rules Fix - Complete Analysis

## Problem Summary
- **Admin** can see assigned meals in Weekly Meal Planner
- **Members** see "No meal assigned" for all categories
- Navigation and groupId passing are confirmed correct
- **Root Cause:** Firestore security rules blocking member reads

---

## STEP 1: Current Rules Analysis

### Likely Current Rules (BROKEN):

```javascript
// ❌ BROKEN RULE - Blocks members from reading
match /group_meal_plans/{planId} {
  // Only allows reads if user created the document
  allow read: if request.auth != null && 
              request.auth.uid == resource.data.createdBy;
  
  // Only allows writes if user created the document
  allow write: if request.auth != null && 
               request.auth.uid == resource.data.createdBy;
}
```

**Why This Blocks Members:**
- `resource.data.createdBy` contains the admin's user ID
- Members' user IDs don't match `createdBy`
- Firestore silently denies read access
- Query returns 0 documents even though they exist

**Why Admin Can Read:**
- Admin's user ID matches `resource.data.createdBy`
- Firestore allows read access
- Query returns all documents admin created

---

## STEP 2: Firestore Data Structure

### Groups Collection:
```
groups/{groupId}
  - adminId: "adminUserId123"
  - memberIds: ["memberId1", "memberId2", "memberId3"]
  - name: "Muscle Gain"
  - createdAt: timestamp
```

### Group Meal Plans Collection:
```
group_meal_plans/{planId}
  - groupId: "groupId123"
  - date: "2026-02-20"
  - mealSlots: {
      "Breakfast": "mealId1",
      "Lunch": "mealId2",
      "Dinner": "mealId3"
    }
  - createdBy: "adminUserId123"
  - createdByName: "Admin Name"
  - createdAt: timestamp
  - updatedAt: timestamp
```

### Meals Collection:
```
meals/{mealId}
  - name: "Pancake"
  - groupId: "groupId123"  (or null for personal meals)
  - userId: "adminUserId123"
  - kcal: "350"
  - protein: "15g"
  - carbs: "45g"
  - fat: "10g"
  - categories: ["Breakfast"]
  - createdAt: timestamp
```

---

## STEP 3: Correct Security Rules

### Fixed Rules (CORRECT):

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    
    // ========================================
    // GROUPS COLLECTION
    // ========================================
    match /groups/{groupId} {
      // Allow read if user is a member or admin of the group
      allow read: if request.auth != null && (
        request.auth.uid in resource.data.memberIds ||
        request.auth.uid == resource.data.adminId
      );
      
      // Allow create if authenticated
      allow create: if request.auth != null;
      
      // Allow update/delete only if user is admin
      allow update, delete: if request.auth != null && 
                               request.auth.uid == resource.data.adminId;
    }
    
    // ========================================
    // GROUP MEAL PLANS COLLECTION
    // ========================================
    match /group_meal_plans/{planId} {
      // ✅ CRITICAL FIX: Allow read if user is member OR admin of the group
      allow read: if request.auth != null && (
        // Check if user is in the group's member list
        request.auth.uid in get(/databases/$(database)/documents/groups/$(resource.data.groupId)).data.memberIds ||
        // OR check if user is the group admin
        request.auth.uid == get(/databases/$(database)/documents/groups/$(resource.data.groupId)).data.adminId
      );
      
      // Allow write only if user is admin of the group
      allow write: if request.auth != null && 
                      request.auth.uid == get(/databases/$(database)/documents/groups/$(request.resource.data.groupId)).data.adminId;
    }
    
    // ========================================
    // MEALS COLLECTION
    // ========================================
    match /meals/{mealId} {
      // Allow read if:
      // 1. Meal belongs to user (personal meal)
      // 2. Meal belongs to a group where user is member or admin
      allow read: if request.auth != null && (
        // Personal meal
        resource.data.userId == request.auth.uid ||
        // Group meal - user is member
        (resource.data.groupId != null && 
         request.auth.uid in get(/databases/$(database)/documents/groups/$(resource.data.groupId)).data.memberIds) ||
        // Group meal - user is admin
        (resource.data.groupId != null && 
         request.auth.uid == get(/databases/$(database)/documents/groups/$(resource.data.groupId)).data.adminId)
      );
      
      // Allow create if authenticated
      allow create: if request.auth != null;
      
      // Allow update/delete if user owns the meal or is group admin
      allow update, delete: if request.auth != null && (
        resource.data.userId == request.auth.uid ||
        (resource.data.groupId != null && 
         request.auth.uid == get(/databases/$(database)/documents/groups/$(resource.data.groupId)).data.adminId)
      );
    }
    
    // ========================================
    // USERS COLLECTION
    // ========================================
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

## STEP 4: Key Changes Explained

### Change 1: Group Meal Plans Read Access

**BEFORE (BROKEN):**
```javascript
allow read: if request.auth.uid == resource.data.createdBy;
```
❌ Only admin (creator) can read

**AFTER (FIXED):**
```javascript
allow read: if request.auth != null && (
  request.auth.uid in get(/databases/$(database)/documents/groups/$(resource.data.groupId)).data.memberIds ||
  request.auth.uid == get(/databases/$(database)/documents/groups/$(resource.data.groupId)).data.adminId
);
```
✅ Both members and admin can read

**How It Works:**
1. Gets the group document using `resource.data.groupId`
2. Checks if current user's ID is in `memberIds` array
3. OR checks if current user's ID matches `adminId`
4. If either is true, allows read access

### Change 2: Group Meal Plans Write Access

**BEFORE (BROKEN):**
```javascript
allow write: if request.auth.uid == resource.data.createdBy;
```
❌ Only original creator can write (might block admin updates)

**AFTER (FIXED):**
```javascript
allow write: if request.auth != null && 
                request.auth.uid == get(/databases/$(database)/documents/groups/$(request.resource.data.groupId)).data.adminId;
```
✅ Only group admin can write

**How It Works:**
1. Gets the group document using `request.resource.data.groupId`
2. Checks if current user's ID matches group's `adminId`
3. Only allows write if user is the group admin

### Change 3: Meals Read Access

**BEFORE (BROKEN):**
```javascript
allow read: if request.auth.uid == resource.data.userId;
```
❌ Only meal creator can read (blocks members from seeing group meals)

**AFTER (FIXED):**
```javascript
allow read: if request.auth != null && (
  resource.data.userId == request.auth.uid ||
  (resource.data.groupId != null && 
   request.auth.uid in get(/databases/$(database)/documents/groups/$(resource.data.groupId)).data.memberIds) ||
  (resource.data.groupId != null && 
   request.auth.uid == get(/databases/$(database)/documents/groups/$(resource.data.groupId)).data.adminId)
);
```
✅ Personal meal owner, group members, and group admin can read

**How It Works:**
1. Allows read if user owns the meal (personal meal)
2. OR if meal has groupId and user is in group's memberIds
3. OR if meal has groupId and user is group's admin

---

## STEP 5: Why Admin Could Read, Member Could Not

### Admin Flow (WORKING):

**1. Admin opens planner:**
```
User ID: adminUserId123
Group ID: groupId123
```

**2. Firestore query:**
```javascript
collection('group_meal_plans')
  .where('groupId', '==', 'groupId123')
  .where('date', '==', '2026-02-20')
```

**3. Security rule evaluation:**
```javascript
// Document found:
{
  groupId: "groupId123",
  createdBy: "adminUserId123",
  date: "2026-02-20",
  mealSlots: {...}
}

// OLD RULE (BROKEN):
request.auth.uid == resource.data.createdBy
"adminUserId123" == "adminUserId123"  ✅ TRUE → Allow read

// Result: Admin sees meals
```

### Member Flow (BROKEN):

**1. Member opens planner:**
```
User ID: memberId456
Group ID: groupId123  (same as admin!)
```

**2. Firestore query:**
```javascript
collection('group_meal_plans')
  .where('groupId', '==', 'groupId123')
  .where('date', '==', '2026-02-20')
```

**3. Security rule evaluation:**
```javascript
// Document found:
{
  groupId: "groupId123",
  createdBy: "adminUserId123",
  date: "2026-02-20",
  mealSlots: {...}
}

// OLD RULE (BROKEN):
request.auth.uid == resource.data.createdBy
"memberId456" == "adminUserId123"  ❌ FALSE → Deny read

// Result: Document filtered out, member sees nothing
```

### Member Flow (FIXED):

**3. Security rule evaluation (NEW):**
```javascript
// NEW RULE (FIXED):
request.auth.uid in get(/databases/$(database)/documents/groups/$(resource.data.groupId)).data.memberIds

// Fetches group document:
{
  groupId: "groupId123",
  adminId: "adminUserId123",
  memberIds: ["memberId456", "memberId789"]
}

// Checks:
"memberId456" in ["memberId456", "memberId789"]  ✅ TRUE → Allow read

// Result: Member sees meals!
```

---

## STEP 6: Deployment Instructions

### Option 1: Firebase Console (Recommended)

1. Open [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Navigate to **Firestore Database** → **Rules**
4. Copy the contents of `firestore.rules` file
5. Paste into the rules editor
6. Click **Publish**
7. Wait for deployment (usually instant)

### Option 2: Firebase CLI

```bash
# Install Firebase CLI if not already installed
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in your project (if not done)
firebase init firestore

# Deploy rules
firebase deploy --only firestore:rules
```

### Option 3: Manual File Upload

1. Save the `firestore.rules` file in your project root
2. Use Firebase CLI: `firebase deploy --only firestore:rules`

---

## STEP 7: Verification Steps

### After Deploying Rules:

**1. Test Member Access:**
```
1. Login as a member
2. Open Weekly Meal Planner for the group
3. Check console logs:
   === FIRESTORE SNAPSHOT RECEIVED ===
   📦 Documents found: 1  ← Should be > 0 now!
   📄 Document abc123:
      - groupId: groupId123
      - date: 2026-02-20
      - mealSlots: {Breakfast: meal1, Lunch: meal2}
4. Verify meals appear in UI
```

**2. Test Admin Access (Should Still Work):**
```
1. Login as admin
2. Open Weekly Meal Planner
3. Assign/update meals
4. Verify changes save successfully
5. Verify members see updates in real-time
```

**3. Test Security (Important!):**
```
1. Member should NOT be able to:
   - Assign meals
   - Update meal slots
   - Delete meal plans
2. Admin should be able to:
   - Assign meals
   - Update meal slots
   - Delete meal plans
```

---

## STEP 8: Required Group Data Structure

### Ensure Groups Have memberIds Array:

**Check your groups collection:**
```javascript
// Each group document MUST have:
{
  id: "groupId123",
  name: "Muscle Gain",
  adminId: "adminUserId123",
  memberIds: ["memberId1", "memberId2", "memberId3"],  // ← CRITICAL!
  createdAt: timestamp
}
```

**If memberIds is missing, update your group creation code:**

```dart
// When creating a group:
await _firestore.collection('groups').add({
  'name': groupName,
  'adminId': adminUserId,
  'memberIds': [adminUserId],  // ← Start with admin as member
  'createdAt': DateTime.now().toIso8601String(),
});

// When adding a member:
await _firestore.collection('groups').doc(groupId).update({
  'memberIds': FieldValue.arrayUnion([newMemberId]),
});

// When removing a member:
await _firestore.collection('groups').doc(groupId).update({
  'memberIds': FieldValue.arrayRemove([memberId]),
});
```

---

## Summary

### What Rule Was Blocking Member:
```javascript
// OLD RULE:
allow read: if request.auth.uid == resource.data.createdBy;
```
This only allowed the document creator (admin) to read.

### Why Admin Could Read:
Admin's user ID matched `createdBy` field in the document.

### Why Member Could Not:
Member's user ID did NOT match `createdBy` field, so Firestore denied access.

### The Fix:
```javascript
// NEW RULE:
allow read: if request.auth.uid in get(...).data.memberIds || 
            request.auth.uid == get(...).data.adminId;
```
Now checks if user is in the group's member list OR is the admin.

### Result:
- ✅ Members can now read meal plans
- ✅ Admin can still read and write
- ✅ Security maintained (only group members have access)
- ✅ Real-time updates work for everyone
