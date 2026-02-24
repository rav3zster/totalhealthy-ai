# Meal Categories Management System

## Overview
Complete meal categories management system with iOS-style time pickers for setting meal times/reminders. Users can create custom meal categories under each group category with time ranges.

## Features

### 1. Default Categories (Cannot be deleted)
- **Breakfast** (07:00 - 09:00)
- **Lunch** (12:00 - 14:00)
- **Dinner** (19:00 - 21:00)

### 2. Custom Categories
Users can add custom categories like:
- Snacks
- Pre-workout
- Post-workout
- Medicine
- Supplements
- etc.

### 3. iOS-Style Time Picker
- Beautiful Cupertino time picker
- Set start and end times for each category
- Optional time ranges
- 12-hour format with AM/PM

### 4. Time-Based Reminders
Each category can have:
- Start time (e.g., 07:00 AM)
- End time (e.g., 09:00 AM)
- Used for notifications/reminders (future implementation)

## User Flow

### Access Meal Categories
1. Profile → Group Categories
2. Click on any group category (e.g., "Yoga" 🧘)
3. Opens Meal Categories Management screen

### View Meal Categories
- See all meal categories for that group category
- Default categories shown with "Default" badge
- Time ranges displayed (if set)
- Edit time button for each category

### Add Custom Category
1. Click "Add Category" FAB
2. Enter category name (e.g., "Snacks")
3. Optionally set time range:
   - Tap "Start Time" → iOS time picker opens
   - Select time (e.g., 10:00 AM)
   - Tap "End Time" → iOS time picker opens
   - Select time (e.g., 11:00 AM)
4. Click "Create"
5. Category added with time range

### Edit Category Time
1. Tap on time display in category card
2. Time picker dialog opens
3. Adjust start/end times using iOS picker
4. Click "Save"
5. Times updated

### Delete Custom Category
1. Tap delete icon on custom category
2. Confirmation dialog appears
3. Confirm deletion
4. Category removed

## Data Structure

### Firestore Path
```
users/{userId}/group_categories/{groupCategoryId}/meal_categories/{mealCategoryId}
```

### MealCategoryModel
```dart
{
  id: "category_id",
  groupCategoryId: "group_category_id",
  name: "Breakfast",
  startTime: "07:00",  // HH:mm format
  endTime: "09:00",    // HH:mm format
  order: 0,
  isDefault: true,
  createdAt: timestamp,
  createdBy: "user_id"
}
```

## UI Components

### Category Card
```
┌─────────────────────────────────────┐
│ Breakfast              [Default]    │
│                                      │
│ ┌─────────────────────────────┐    │
│ │ 🕐 07:00 AM - 09:00 AM  ✏️  │    │
│ └─────────────────────────────┘    │
└─────────────────────────────────────┘
```

### Time Picker Dialog
```
┌─────────────────────────────────────┐
│ Set Time for Breakfast               │
│                                      │
│ ┌──────────┐  ┌──────────┐         │
│ │Start Time│  │ End Time │         │
│ │ 07:00 AM │  │ 09:00 AM │         │
│ └──────────┘  └──────────┘         │
│                                      │
│              [Cancel] [Save]         │
└─────────────────────────────────────┘
```

### iOS Time Picker (Bottom Sheet)
```
┌─────────────────────────────────────┐
│ [Cancel]              [Done]         │
│                                      │
│      ┌───┐  ┌───┐  ┌────┐          │
│      │ 7 │  │30 │  │ AM │          │
│      │ 8 │  │45 │  │ PM │          │
│      │ 9 │  │00 │  │    │          │
│      └───┘  └───┘  └────┘          │
└─────────────────────────────────────┘
```

## Integration with Dashboard

### Future Implementation
When a group is selected in dashboard:

1. **Load Group's Category**
```dart
final group = await getGroup(groupId);
final groupCategoryId = group.groupCategoryId;
```

2. **Load Meal Categories**
```dart
final mealCategories = await getMealCategories(
  userId,
  groupCategoryId,
);
```

3. **Display Category Buttons**
```dart
// Dashboard shows:
// [🍳 Breakfast] [🥗 Lunch] [🍽️ Dinner] [🍿 Snacks]
```

4. **Filter Meals by Category**
```dart
final breakfastMeals = meals.where(
  (meal) => meal.categoryId == breakfastCategoryId
);
```

5. **Create Meal - Category Selection**
```dart
// Only show categories from current group's category
DropdownButton(
  items: mealCategories.map((cat) => 
    DropdownMenuItem(
      value: cat.id,
      child: Text(cat.name),
    )
  ).toList(),
)
```

## Time-Based Features (Future)

### 1. Smart Suggestions
```dart
// Show relevant categories based on current time
if (currentTime >= 07:00 && currentTime <= 09:00) {
  suggestedCategory = "Breakfast";
}
```

### 2. Notifications
```dart
// Schedule notification 15 minutes before meal time
scheduleNotification(
  time: category.startTime.subtract(Duration(minutes: 15)),
  title: "Time for ${category.name}",
  body: "Your ${category.name} time is coming up!",
);
```

### 3. Time-Based Filtering
```dart
// Show only current meal categories
final currentCategories = mealCategories.where((cat) {
  final now = TimeOfDay.now();
  return now >= cat.startTime && now <= cat.endTime;
});
```

### 4. Meal Timing Analytics
```dart
// Track if meals are logged within time range
final isOnTime = mealLoggedTime >= category.startTime &&
                 mealLoggedTime <= category.endTime;
```

## Validation Rules

### Category Name
- Required
- Must be unique within group category
- Max 30 characters

### Time Range
- Optional
- Start time must be before end time
- Can span across midnight (e.g., 23:00 - 01:00)

### Default Categories
- Cannot be deleted
- Can edit time ranges
- Always present in every group category

## Files Created

1. `lib/app/modules/meal_categories_management/controllers/meal_categories_management_controller.dart`
2. `lib/app/modules/meal_categories_management/views/meal_categories_management_view.dart`
3. `lib/app/modules/meal_categories_management/bindings/meal_categories_management_binding.dart`

## Files Modified

1. `lib/app/modules/group_categories/controllers/group_categories_controller.dart` - Updated navigation
2. `lib/app/routes/app_routes.dart` - Added MEAL_CATEGORIES_MANAGEMENT route
3. `lib/app/routes/app_pages.dart` - Added route configuration

## Testing Checklist

- [ ] Navigate from Group Categories to Meal Categories
- [ ] View default categories (Breakfast, Lunch, Dinner)
- [ ] Default badge shows on default categories
- [ ] Add custom category without time
- [ ] Add custom category with time range
- [ ] iOS time picker opens and works
- [ ] Time displays correctly in 12-hour format
- [ ] Edit time for existing category
- [ ] Delete custom category
- [ ] Cannot delete default category
- [ ] Time validation works
- [ ] Real-time updates work
- [ ] Empty state shows when no categories
- [ ] Loading state shows while fetching

## Next Steps

### 1. Dashboard Integration
Update dashboard to load meal categories based on selected group:
```dart
void enterGroupMode(String groupId) async {
  final group = await _groupsService.getGroup(groupId);
  if (group.groupCategoryId != null) {
    _loadMealCategories(group.groupCategoryId!);
  }
}
```

### 2. Create Meal Integration
Filter category dropdown based on group's meal categories:
```dart
// In CreateMealController
void loadMealCategories(String groupCategoryId) async {
  final categories = await _categoriesService.getMealCategories(
    userId,
    groupCategoryId,
  );
  availableCategories.value = categories;
}
```

### 3. Meal Model Update
Add categoryId reference:
```dart
class MealModel {
  final String categoryId; // Reference to meal category
  // ... other fields
}
```

### 4. Notification System
Implement time-based notifications:
```dart
void scheduleM ealReminders() {
  for (var category in mealCategories) {
    if (category.startTime != null) {
      scheduleNotification(
        time: category.startTime,
        title: "Time for ${category.name}",
      );
    }
  }
}
```

## Benefits

1. **Organized Meal Planning**: Categories help organize meals by time of day
2. **Flexible Scheduling**: Custom categories for any meal type
3. **Time Awareness**: Time ranges help users plan meals appropriately
4. **Reminder Ready**: Foundation for notification system
5. **Group-Specific**: Each group category has its own meal categories
6. **User-Friendly**: iOS-style pickers provide familiar UX

## Remember

- Meal categories are nested under group categories
- Each group category can have different meal categories
- When a group is created, it references a group category
- Dashboard loads meal categories from the group's category
- Meals can only be added to categories that exist in that group
- Time ranges are optional but recommended for better organization
