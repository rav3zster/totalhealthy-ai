# Trainer-Client Management Testing Guide

## Prerequisites
1. Firebase project configured
2. At least 2 test accounts:
   - Trainer account (admin@gmail.com or any account with role switching)
   - Member account (any regular user)

## Test Scenarios

### Test 1: Role-Based Filtering in Client List
**Steps:**
1. Login as trainer/advisor
2. Navigate to Trainer Dashboard
3. Click "Add Client" button
4. Verify Client List screen opens

**Expected Results:**
- ✅ Only users with role="member" appear
- ✅ No trainers or advisors in the list
- ✅ Search bar is functional
- ✅ If no members exist, shows "No members available" message

**Pass Criteria:**
- Client list contains only members
- No role leakage (trainers/advisors not shown)

---

### Test 2: Add Client Functionality
**Steps:**
1. On Client List screen, find a member
2. Click "Add Client" button on their card
3. Observe the button state
4. Wait for success notification

**Expected Results:**
- ✅ Button shows loading spinner during operation
- ✅ Success notification appears: "[Name] has been added as your client!"
- ✅ Client disappears from the list immediately
- ✅ No duplicate additions possible

**Pass Criteria:**
- Client is assigned to trainer in Firebase
- UI updates immediately
- No errors in console

---

### Test 3: Trainer Dashboard Updates
**Steps:**
1. After adding a client (Test 2)
2. Navigate back to Trainer Dashboard
3. Check "Your Clients" section

**Expected Results:**
- ✅ Heading says "Your Clients" (not "Client List")
- ✅ Added client appears in the list
- ✅ Client count in "Live Stats" updates
- ✅ Client card shows correct data (name, email, progress)

**Pass Criteria:**
- Dashboard updates without manual refresh
- Only assigned clients are visible
- Stats are accurate

---

### Test 4: Real-Time Updates
**Steps:**
1. Open Trainer Dashboard in one browser/device
2. Open Client List in another browser/device (same trainer account)
3. Add a client from the Client List
4. Observe the Trainer Dashboard

**Expected Results:**
- ✅ Dashboard updates automatically
- ✅ New client appears without refresh
- ✅ Client count increments

**Pass Criteria:**
- Real-time synchronization works
- No page refresh needed

---

### Test 5: Prevent Duplicate Additions
**Steps:**
1. Add a client to trainer
2. Go back to Client List
3. Try to find the same client

**Expected Results:**
- ✅ Client no longer appears in the list
- ✅ Cannot add the same client twice

**Pass Criteria:**
- Duplicate prevention works
- Already-assigned clients are filtered out

---

### Test 6: Empty State Handling
**Steps:**
1. Login as a new trainer with no clients
2. View Trainer Dashboard

**Expected Results:**
- ✅ Shows "No clients added yet" message
- ✅ Shows "Add your first client to get started" subtitle
- ✅ Empty state icon displays
- ✅ "Add Client" button is still accessible

**Pass Criteria:**
- Clean empty state UI
- No errors or crashes

---

### Test 7: Search Functionality
**Steps:**
1. Open Client List screen
2. Type in the search bar (email, name, or username)
3. Observe filtered results

**Expected Results:**
- ✅ Results filter in real-time
- ✅ Search works for email, username, and full name
- ✅ Shows "No members found" if no matches
- ✅ Clearing search shows all members again

**Pass Criteria:**
- Search is responsive and accurate
- Empty state appears when no results

---

### Test 8: Member UI (No Role Leakage)
**Steps:**
1. Login as a member (not trainer/advisor)
2. Navigate through the app

**Expected Results:**
- ✅ Member sees Client Dashboard (not Trainer Dashboard)
- ✅ No "Add Client" button visible
- ✅ No "Your Clients" section visible
- ✅ Member cannot access trainer features

**Pass Criteria:**
- Role-based access control works
- Members don't see trainer UI

---

### Test 9: Firebase Persistence
**Steps:**
1. Add a client to trainer
2. Close the app completely
3. Reopen and login as the same trainer

**Expected Results:**
- ✅ Client still appears in "Your Clients"
- ✅ Data persists across sessions
- ✅ No data loss

**Pass Criteria:**
- Firebase persistence works correctly
- Data survives app restarts

---

### Test 10: Error Handling
**Steps:**
1. Turn off internet connection
2. Try to add a client
3. Observe error handling

**Expected Results:**
- ✅ Error notification appears
- ✅ Button returns to normal state
- ✅ No crash or freeze
- ✅ User can retry after reconnecting

**Pass Criteria:**
- Graceful error handling
- Clear error messages

---

## Firebase Verification

### Check Firestore Data:
1. Open Firebase Console
2. Navigate to Firestore Database
3. Open `user` collection
4. Find a member document
5. Verify fields:
   ```json
   {
     "role": "member",
     "assignedTrainerId": "trainer_uid_here"
   }
   ```

**Expected:**
- ✅ `role` field exists and is set correctly
- ✅ `assignedTrainerId` field exists for assigned clients
- ✅ `assignedTrainerId` matches the trainer's UID

---

## Performance Testing

### Load Test:
1. Create 50+ member accounts
2. Assign 20+ clients to one trainer
3. Open Trainer Dashboard
4. Measure load time

**Expected:**
- ✅ Dashboard loads in < 3 seconds
- ✅ Smooth scrolling through client list
- ✅ No lag or stuttering

---

## Regression Testing

### Ensure No Breaking Changes:
- ✅ Existing user authentication still works
- ✅ Member dashboard functions normally
- ✅ Group features still work
- ✅ Meal management unaffected
- ✅ Profile settings accessible
- ✅ Notifications working

---

## Test Results Template

```
Test Date: ___________
Tester: ___________

| Test # | Test Name | Status | Notes |
|--------|-----------|--------|-------|
| 1 | Role-Based Filtering | ☐ Pass ☐ Fail | |
| 2 | Add Client | ☐ Pass ☐ Fail | |
| 3 | Dashboard Updates | ☐ Pass ☐ Fail | |
| 4 | Real-Time Updates | ☐ Pass ☐ Fail | |
| 5 | Prevent Duplicates | ☐ Pass ☐ Fail | |
| 6 | Empty State | ☐ Pass ☐ Fail | |
| 7 | Search | ☐ Pass ☐ Fail | |
| 8 | No Role Leakage | ☐ Pass ☐ Fail | |
| 9 | Firebase Persistence | ☐ Pass ☐ Fail | |
| 10 | Error Handling | ☐ Pass ☐ Fail | |

Overall Status: ☐ All Tests Passed ☐ Issues Found

Issues Found:
1. ___________
2. ___________
3. ___________
```

---

## Known Limitations

1. **Role Migration**: Existing users need `role` field set manually or via migration script
2. **Single Trainer**: Currently, a client can only be assigned to one trainer
3. **No Unassign**: No UI to remove a client from a trainer (can be added later)
4. **No Notifications**: Clients are not notified when assigned to a trainer

---

## Troubleshooting

### Issue: Clients not appearing on dashboard
**Solution:** 
- Check Firebase: Verify `assignedTrainerId` field is set
- Check role: Ensure user has `role: "member"`
- Check auth: Verify trainer is logged in correctly

### Issue: "No members available" in Client List
**Solution:**
- Check Firebase: Verify users have `role: "member"`
- Check assignments: All members might already be assigned
- Create new member accounts for testing

### Issue: Real-time updates not working
**Solution:**
- Check internet connection
- Verify Firestore rules allow read/write
- Check console for errors
- Restart the app

---

## Sign-Off

Before committing, ensure:
- [ ] All 10 tests pass
- [ ] Firebase data is correct
- [ ] No console errors
- [ ] Performance is acceptable
- [ ] No breaking changes
- [ ] Documentation is complete

**Tested By:** ___________  
**Date:** ___________  
**Approved By:** ___________  
**Date:** ___________
