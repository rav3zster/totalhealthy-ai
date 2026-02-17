# Group Mode Implementation Guide

## Changes Made

### 1. Controller (client_dashboard_controllers.dart)
Added properties:
- `isGroupMode` - RxBool to track if in group mode
- `selectedGroupId` - Rxn<String> for current group ID
- `selectedGroupName` - String for group name display
- `groupMeals` - RxList<MealModel> for group-specific meals
- `_groupMealsSubscription` - StreamSubscription for group meals

Added methods:
- `enterGroupMode(groupId, groupName)` - Switch to group mode
- `exitGroupMode()` - Return to normal dashboard
- `fetchGroupMeals(groupId)` - Load group meals stream
- `displayedMeals` - Getter that returns correct meals based on mode
- `_filterMeals(mealsList)` - Filter meals by category/search

### 2. Group Dropdown (dynamic_profile_header.dart)
- Updated `onSelected` callback to call `enterGroupMode()` instead of navigating
- Added import for ClientDashboardControllers
- Added fallback to navigate to weekly planner if controller not found

### 3. Dashboard View (client_dashboard_views.dart)
Need to wrap main content in Obx() and conditionally render:

```dart
Obx(() {
  if (controller.isGroupMode.value) {
    return _buildGroupMealView(controller);
  } else {
    return _buildNormalDashboard(controller);
  }
})
```

## Group Mode View Requirements

When in group mode, show:
1. Group name header with "X" button to exit
2. Search bar (filters group meals only)
3. All group meals (no category filtering)
4. NO day counter
5. NO category buttons
6. NO "Add Meal" button

## Normal Dashboard View

Keep existing:
1. Welcome header with group dropdown
2. Live stats card
3. Weekly planner button
4. Search bar
5. Day counter with "Add Meal" button
6. Category buttons (Breakfast/Lunch/Dinner)
7. Personal meals filtered by category

## Implementation Steps

1. ✅ Add controller properties and methods
2. ✅ Update group dropdown to enter group mode
3. ⏳ Update dashboard view to conditionally render
4. ⏳ Create group mode header with exit button
5. ⏳ Test group mode switching
6. ⏳ Test meal filtering in both modes
7. ⏳ Test search in both modes

## Next Steps

Update client_dashboard_views.dart to:
1. Wrap content in Obx()
2. Create `_buildGroupMealView()` method
3. Extract existing content into `_buildNormalDashboard()` method
4. Add group mode header with exit button
5. Update meal list to use `controller.displayedMeals`
