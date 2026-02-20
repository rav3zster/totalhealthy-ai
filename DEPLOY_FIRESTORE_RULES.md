# Quick Deployment Guide - Firestore Rules Fix

## Problem
Members cannot see assigned meals because Firestore security rules block their read access.

## Solution
Deploy the corrected `firestore.rules` file to allow members to read meal plans.

---

## Deployment Steps

### Method 1: Firebase Console (Easiest - 2 minutes)

1. **Open Firebase Console:**
   - Go to https://console.firebase.google.com/
   - Select your project

2. **Navigate to Firestore Rules:**
   - Click "Firestore Database" in left sidebar
   - Click "Rules" tab at the top

3. **Copy New Rules:**
   - Open the `firestore.rules` file in your project
   - Copy ALL contents (Ctrl+A, Ctrl+C)

4. **Paste and Publish:**
   - Paste into the Firebase Console rules editor
   - Click "Publish" button
   - Wait for confirmation (usually instant)

5. **Verify:**
   - Test with member account
   - Member should now see assigned meals

---

### Method 2: Firebase CLI (For Developers)

```bash
# 1. Install Firebase CLI (if not installed)
npm install -g firebase-tools

# 2. Login to Firebase
firebase login

# 3. Initialize Firestore (if not done)
firebase init firestore
# Select your project
# Accept default firestore.rules location

# 4. Deploy rules
firebase deploy --only firestore:rules

# 5. Verify deployment
# Check Firebase Console → Firestore → Rules
```

---

## Critical Rule Changes

### OLD RULE (BROKEN):
```javascript
match /group_meal_plans/{planId} {
  // ❌ Only creator can read
  allow read: if request.auth.uid == resource.data.createdBy;
}
```

### NEW RULE (FIXED):
```javascript
match /group_meal_plans/{planId} {
  // ✅ Members and admin can read
  allow read: if request.auth != null && (
    request.auth.uid in get(/databases/$(database)/documents/groups/$(resource.data.groupId)).data.memberIds ||
    request.auth.uid == get(/databases/$(database)/documents/groups/$(resource.data.groupId)).data.adminId
  );
  
  // ✅ Only admin can write
  allow write: if request.auth != null && 
                  request.auth.uid == get(/databases/$(database)/documents/groups/$(request.resource.data.groupId)).data.adminId;
}
```

---

## Verification Checklist

After deploying rules, verify:

- [ ] Member can open Weekly Meal Planner
- [ ] Member sees assigned meals (not "No meal assigned")
- [ ] Member CANNOT assign/edit meals (read-only)
- [ ] Admin can still assign/edit meals
- [ ] Real-time updates work for both admin and members

---

## Troubleshooting

### If member still can't see meals:

**1. Check group document has memberIds:**
```javascript
// In Firestore Console, check groups collection:
{
  adminId: "adminUserId",
  memberIds: ["memberId1", "memberId2"],  // ← Must exist!
  name: "Muscle Gain"
}
```

**2. Verify member is in memberIds array:**
- Open Firestore Console
- Navigate to groups/{groupId}
- Check if member's user ID is in `memberIds` array

**3. Check console logs:**
```
=== FIRESTORE SNAPSHOT RECEIVED ===
📦 Documents found: 0  ← If still 0, check memberIds
```

**4. Force refresh:**
- Logout and login again
- Clear app cache
- Restart app

---

## Expected Result

**Before Fix:**
- Admin: ✅ Sees meals
- Member: ❌ Sees "No meal assigned"

**After Fix:**
- Admin: ✅ Sees meals (can edit)
- Member: ✅ Sees meals (read-only)

---

## Need Help?

If issues persist after deployment:
1. Check Firebase Console → Firestore → Rules (verify rules are published)
2. Check console logs for error messages
3. Verify group document structure has `memberIds` array
4. Ensure member's user ID is in the `memberIds` array
