# Weekly Meal Planner - Complete Fix

## Problem
- Admin assigns meals but members see "No meal assigned"
- Meals are saved to meal plans but not visible to members
- Root cause: Meals exist in admin's personal collection, not in group collection

## Solution Architecture

### Data Flow
1. **Admin's Personal Meals** → stored with admin's userId, admin's groupId
2. **When Admin Assigns** → meal gets COPIED to group with group's groupId
3. **Group Meals** → stored with admin's userId, group's groupId
4. **Members View** → load meals where groupId = group's groupId

### Key Changes Needed

1. **Meal Selection (Bottom Sheet)**
   - Admin: Shows personal meals (getUserMealsStream)
   - Member: Shows group meals (getMealsStream)

2. **Meal Display (Planner)**
   - Both: Load from assignedMeals (getMealsStream with groupId)
   - This ensures everyone sees the same data

3. **Meal Assignment**
   - Always copy meal to group (even if it seems to already have groupId)
   - Use the NEW meal ID in the plan
   - This creates a group-owned copy

## Implementation Steps

### Step 1: Verify groupId is correct
- Check that groupId passed to controller is the actual group ID
- Not the admin's personal groupId

### Step 2: Ensure meal copying works
- Log the groupId being used for copying
- Verify new meal is created with correct groupId
- Confirm new meal ID is used in plan

### Step 3: Verify member can query
- Member must use same groupId as admin
- Query: meals.where('groupId', '==', groupId)
- Should return the copied meals

## Testing Checklist

1. Admin assigns meal → Check console for "Meal copied to group: [newId]"
2. Check Firestore → Verify meal exists with groupId = group's ID
3. Member opens planner → Check console for "Assigned meals updated: X meals"
4. Member should see meals → If not, check getMealById logs

## Console Logs to Check

Admin side:
- "Admin loading personal meals for user: [userId]"
- "Meal copied to group: [newMealId]"
- "addMeal success: docId = [id], groupId = [groupId]"

Member side:
- "Member loading group meals for group: [groupId]"
- "getMealsStream called for groupId: [groupId]"
- "getMealsStream snapshot received: X documents"
- "Assigned meals updated: X meals"

If member sees "0 meals", the groupId is wrong or meals weren't copied.
