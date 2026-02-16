# Testing the Weekly Meal Planner Fix

## What Changed
- Simplified meal copying logic: ALWAYS copy meals when assigning (no conditional checks)
- Added comprehensive logging to track the entire flow
- Ensured both admin and members load from the same group meal collection

## How to Test

### Step 1: Clear Old Data (Optional but Recommended)
To start fresh, you can delete old meal plans from Firestore:
- Open Firebase Console → Firestore
- Navigate to `group_meal_plans` collection
- Delete documents for your test group
- Navigate to `meals` collection  
- Delete any test meals

### Step 2: Test as Admin

1. **Open Weekly Meal Planner**
   - Navigate to your group
   - Click "Meal Plan" tab
   - Check console output

2. **Expected Console Logs:**
   ```
   Admin loading personal meals for user: [userId]
   Available meals updated: X meals
   Loading assigned meals from group: [groupId]
   Assigned meals updated: Y meals
   Loading meal plans for group: [groupId]
   Meal plans updated: Z plans loaded
   ```

3. **Assign a Meal**
   - Click on any meal slot (e.g., Breakfast)
   - Select a meal from your personal meals
   - Click to assign

4. **Expected Console Logs:**
   ```
   === ASSIGNING MEAL ===
   Original meal ID: [mealId]
   Target groupId: [groupId]
   Original meal: [Meal Name]
   Original meal groupId: [originalGroupId]
   Copying meal to group...
   addMeal called:
     - name: [Meal Name]
     - userId: [adminUserId]
     - groupId: [groupId]
     - categories: [...]
   addMeal success: docId = [newMealId], groupId = [groupId]
   ✓ Meal copied successfully!
   New meal ID: [newMealId]
   New meal groupId: [groupId]
   Saving to meal plan...
     groupId: [groupId]
     date: [date]
     mealType: [category]
     mealId: [newMealId]
   ✓ Meal plan updated successfully!
   === END ASSIGNMENT ===
   ```

5. **Verify in UI**
   - Meal should appear immediately in the planner
   - Daily nutrition should update
   - Success snackbar should show

### Step 3: Test as Member

1. **Login as a Member** of the same group

2. **Open Weekly Meal Planner**
   - Navigate to the group
   - Click "Meal Plan" tab
   - Check console output

3. **Expected Console Logs:**
   ```
   Member loading group meals for group: [groupId]
   getMealsStream called for groupId: [groupId]
   getMealsStream snapshot received: X documents
     - Meal doc [docId]: name=[Meal Name], groupId=[groupId]
   getMealsStream returning X meals
   Available meals updated: X meals
   Loading assigned meals from group: [groupId]
   getMealsStream called for groupId: [groupId]
   getMealsStream snapshot received: X documents
   Assigned meals updated: X meals
   Loading meal plans for group: [groupId]
   Meal plans updated: 1 plans loaded
     - Date: [date], Slots: {Breakfast: [mealId], ...}
   ```

4. **Verify in UI**
   - Member should see the same meals admin assigned
   - Meal names should display (not "No meal assigned")
   - Daily nutrition should match admin's view
   - Member cannot edit (view-only mode)

### Step 4: Verify in Firestore

1. **Check `meals` collection:**
   - Find the copied meal document
   - Verify `groupId` field = your group's ID
   - Verify `userId` field = admin's user ID
   - Verify `name`, `kcal`, `protein`, etc. are correct

2. **Check `group_meal_plans` collection:**
   - Find the meal plan document
   - Verify `groupId` field = your group's ID
   - Verify `mealSlots` contains the new meal ID
   - Example: `{Breakfast: "newMealId123", Lunch: null, ...}`

## Troubleshooting

### Issue: Member sees "No meal assigned"

**Check Console Logs:**

1. **If you see "0 documents" or "0 meals":**
   - Problem: Meals aren't in Firestore with correct groupId
   - Solution: Check admin's assignment logs, verify meal was copied
   - Verify groupId in Firestore matches groupId in logs

2. **If you see meals loaded but "Meal NOT FOUND":**
   - Problem: Meal ID in plan doesn't match meal ID in collection
   - Solution: Check meal plan document in Firestore
   - Verify mealSlots contains correct meal IDs

3. **If you see "getMealsStream called for groupId: undefined":**
   - Problem: groupId not passed correctly to controller
   - Solution: Check route arguments when navigating to planner

### Issue: Meals duplicate every time admin assigns

**This is expected behavior now!**
- Every assignment creates a new copy
- This ensures members can always see meals
- To avoid duplicates, we can add deduplication logic later
- For now, this ensures functionality works

### Issue: Daily nutrition shows 0

**Check:**
1. Are meals loading? (check assignedMeals count)
2. Are meal IDs in plan correct? (check meal plan logs)
3. Is getMealById finding meals? (check getMealById logs)

## Success Criteria

✅ Admin can assign meals from their personal collection
✅ Meals are copied to group with correct groupId
✅ Members can see assigned meals in real-time
✅ Daily nutrition calculates correctly for both admin and members
✅ UI updates immediately after assignment
✅ No errors in console

## Next Steps After Testing

Once basic functionality works:
1. Add deduplication (check if meal already exists in group before copying)
2. Add "Copy to My Meals" button for members
3. Optimize queries (add Firestore indexes if needed)
4. Add loading states and error handling
5. Add meal editing/removal for admin
