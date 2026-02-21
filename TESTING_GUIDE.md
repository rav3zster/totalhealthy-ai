# Admin Leave Bug Fix - Testing Guide

## Before Testing

### 1. Clean and Rebuild
```bash
flutter clean
flutter pub get
flutter run
```

This ensures you're running the latest code with all fixes applied.

---

## What to Test

### Test 1: Admin Leave with Members Present

**Setup:**
- Group has admin + at least 1 member
- You are logged in as the admin

**Steps:**
1. Open the group
2. Go to Members tab
3. Verify you see 2 members (admin + member)
4. Click the leave button (exit icon)

**Expected Console Output:**
```
=== ADMIN LEAVE VALIDATION ===
Group ID: sdluFIPyFV9mMH1BGrjZ
Current Admin ID: [your-user-id]
Querying Firestore: groups/sdluFIPyFV9mMH1BGrjZ/members

=== FETCHING GROUP MEMBERS ===
Group ID: sdluFIPyFV9mMH1BGrjZ
Collection path: groups/sdluFIPyFV9mMH1BGrjZ/members

=== CHECKING ADMIN MEMBERSHIP ===
Group ID: sdluFIPyFV9mMH1BGrjZ
Admin ID: [admin-user-id]
⚠️ Admin membership document missing - auto-creating...
✓ Admin membership document created
=================================

Documents found: 2
Member IDs: [admin-id, member-id]
==============================

Total members in subcollection: 2
All member IDs: [admin-id, member-id]
Other members (excluding admin): 1
Other member IDs: [member-id]
==============================
✓ 1 other members available for transfer
  - [member-username] (member-id)
✓ 1 valid users for selection
```

**Expected UI:**
1. Dialog: "You are the Admin" - confirmation dialog
2. Click "Assign New Admin"
3. Dialog: "Select New Admin" - shows list of members
4. Select a member
5. Dialog: "Confirm Transfer" - final confirmation
6. Click "Transfer & Leave"
7. Success message: "Ownership transferred to [member]. You have left [group]."
8. Navigate back to groups list

**Expected Result:** ✓ Admin successfully transfers ownership and leaves

---

### Test 2: Admin Leave as Only Member

**Setup:**
- Group has only admin (no other members)
- You are logged in as the admin

**Steps:**
1. Open the group
2. Go to Members tab
3. Verify you see 1 member (only admin)
4. Click the leave button (exit icon)

**Expected Console Output:**
```
=== ADMIN LEAVE VALIDATION ===
Group ID: sdluFIPyFV9mMH1BGrjZ
Current Admin ID: [your-user-id]
Querying Firestore: groups/sdluFIPyFV9mMH1BGrjZ/members

=== FETCHING GROUP MEMBERS ===
=== CHECKING ADMIN MEMBERSHIP ===
✓ Admin membership document exists
=================================

Documents found: 1
Member IDs: [admin-id]
==============================

Total members in subcollection: 1
All member IDs: [admin-id]
Other members (excluding admin): 0
Other member IDs: []
==============================
❌ No other members - admin cannot leave
```

**Expected UI:**
1. Dialog: "Cannot Leave Group"
2. Message: "You are the only member of this group."
3. Suggestion: "Invite members first, or delete the group instead."
4. Click "OK"
5. Dialog closes, admin remains in group

**Expected Result:** ✓ Admin blocked from leaving, helpful message shown

---

### Test 3: Member Leave

**Setup:**
- Group has admin + at least 1 member
- You are logged in as a member (NOT admin)

**Steps:**
1. Open the group
2. Go to Members tab
3. Click the leave button (exit icon)

**Expected Console Output:**
```
Member [member-id] left group [group-id]
```

**Expected UI:**
1. Dialog: "Leave Group?"
2. Message: "Are you sure you want to leave [group]?"
3. Warning: "You will lose access to group meals and plans."
4. Click "Leave"
5. Success message: "You have left [group]"
6. Navigate back to groups list

**Expected Result:** ✓ Member successfully leaves group

---

## Troubleshooting

### Issue: Still seeing old logs

**Old Log Format:**
```
Total members fetched from Firestore: 0
All member IDs: []
! WARNING: Admin not found in members subcollection!
```

**New Log Format:**
```
Total members in subcollection: 2
All member IDs: [admin-id, member-id]
```

**Solution:**
1. Stop the app completely
2. Run `flutter clean`
3. Run `flutter pub get`
4. Run `flutter run`
5. Try again

---

### Issue: Auto-heal not creating document

**Symptoms:**
- Console shows "⚠️ Admin membership document missing"
- But still shows "Documents found: 0"

**Check:**
1. Firestore security rules allow writes to `members/` subcollection
2. No errors in console after "auto-creating" message
3. User has proper authentication

**Solution:**
Check Firestore security rules:
```javascript
match /groups/{groupId}/members/{userId} {
  // Allow admin to create/update/delete any member
  allow write: if request.auth != null && 
    get(/databases/$(database)/documents/groups/$(groupId)).data.created_by == request.auth.uid;
  
  // Allow users to read members if they're in the group
  allow read: if request.auth != null && 
    (get(/databases/$(database)/documents/groups/$(groupId)).data.created_by == request.auth.uid ||
     request.auth.uid in get(/databases/$(database)/documents/groups/$(groupId)).data.members_list);
}
```

---

### Issue: "Cannot Leave Group" still showing with 2 members

**Possible Causes:**
1. Old code still running (need hot restart)
2. Auto-heal failed silently (check console for errors)
3. Firestore security rules blocking write

**Debug Steps:**
1. Check console for "=== CHECKING ADMIN MEMBERSHIP ===" logs
2. Check if "✓ Admin membership document created" appears
3. Check if "Documents found: 2" appears
4. If not, check Firestore security rules

---

## Expected Firestore Structure After Auto-Heal

### Before Auto-Heal
```
groups/sdluFIPyFV9mMH1BGrjZ/
  created_by: "admin123"
  members_list: ["admin123", "member456"]
  
  members/ (subcollection)
    member456/
      role: "member"
      joinedAt: timestamp
    
    (admin123 missing!)
```

### After Auto-Heal
```
groups/sdluFIPyFV9mMH1BGrjZ/
  created_by: "admin123"
  members_list: ["admin123", "member456"]
  
  members/ (subcollection)
    admin123/  ← Auto-created!
      role: "admin"
      joinedAt: timestamp
      autoHealed: true
    
    member456/
      role: "member"
      joinedAt: timestamp
```

---

## Success Criteria

### ✓ Test 1 Passes
- Admin can transfer ownership when other members exist
- 3-step dialog flow works correctly
- Transfer succeeds and admin leaves group

### ✓ Test 2 Passes
- Admin blocked from leaving when only member
- Helpful message shown
- Admin remains in group

### ✓ Test 3 Passes
- Member can leave with simple confirmation
- Member removed from group
- Navigate back to groups list

### ✓ Console Logs Correct
- Auto-heal logs appear
- Member count correct
- No errors in console

### ✓ Firestore Data Correct
- Admin document exists in members/ subcollection
- Role field set to "admin"
- autoHealed flag present (if auto-created)

---

## Next Steps After Testing

1. If all tests pass → Deploy to production
2. If tests fail → Check troubleshooting section
3. Monitor console logs for any errors
4. Verify Firestore data structure matches expected

---

## Quick Test Checklist

- [ ] Run `flutter clean` and rebuild
- [ ] Test admin leave with members (should work)
- [ ] Test admin leave alone (should block)
- [ ] Test member leave (should work)
- [ ] Check console logs match expected output
- [ ] Verify Firestore has admin document in members/
- [ ] Verify no errors in console
- [ ] Verify UI dialogs show correctly

---

## Important Notes

1. **Hot Restart Required:** After code changes, you MUST hot restart (not just hot reload)
2. **Console Logs:** New logs say "Total members in subcollection" not "Total members fetched"
3. **Auto-Heal:** Happens automatically on first load after fix is applied
4. **One-Time Operation:** Auto-heal only creates document once, then it exists permanently
5. **No Migration Needed:** Auto-heal handles existing groups automatically

---

## Contact

If issues persist after following this guide:
1. Share full console output (from app start to leave attempt)
2. Share screenshot of Firestore data structure
3. Share Firestore security rules
4. Confirm you ran `flutter clean` and rebuilt
