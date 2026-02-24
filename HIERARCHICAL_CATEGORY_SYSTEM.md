# Hierarchical Category System Implementation

## Overview
Replaced the flat "Meal Categories" system with a hierarchical "Group Categories" system that allows users to organize meal categories under different group types (e.g., Yoga, Fitness, Medication).

## Architecture

### 3-Level Hierarchy:
```
User
└── Group Categories (e.g., Yoga, Fitness, Medication)
    └── Meal Categories (e.g., Breakfast, Lunch, Dinner)
        └── Meals
```

### Firestore Structure:
```
users/{userId}/group_categories/{groupCategoryId}
  - name: "Yoga"
  - description: "Yoga and wellness meals"
  - icon: "🧘"
  - order: 0
  - isDefault: true/false
  - createdAt: timestamp
  - createdBy: userId

users/{userId}/group_categories/{groupCategoryId}/meal_categories/{mealCategoryId}
  - name: "Breakfast"
  - startTime: "07:00"
  - endTime: "09:00"
  - order: 0
  - isDefault: true/false
  - createdAt: timestamp
  - createdBy: userId
  - groupCategoryId: reference to parent

groups/{groupId}
  - name: "My Yoga Group"
  - group_category_id: reference to group category
  - ... other fields
```

## New Models

### 1. GroupCategoryModel
**Path:** `lib/app/data/models/group_category_model.dart`

**Fields:**
- `id`: Document ID
- `name`: Category name (e.g., "Yoga", "Fitness")
- `description`: Optional description
- `icon`: Emoji icon (e.g., "🧘", "💪")
- `order`: Display order
- `isDefault`: Whether it's a system default
- `createdAt`: Creation timestamp
- `createdBy`: User ID who created it

**Default Categories:**
1. General (🍽️) - General meal planning
2. Fitness (💪) - Workout and fitness meals
3. Yoga (🧘) - Yoga and wellness meals
4. Medication (💊) - Medical and supplement tracking

### 2. Updated MealCategoryModel
**Path:** `lib/app/data/models/meal_category_model.dart`

**New Fields:**
- `groupCategoryId`: Reference to parent group category
- `startTime`: Start time (e.g., "07:00")
- `endTime`: End time (e.g., "09:00")

**Default Meal Categories (with timings):**
1. Breakfast (07:00 - 09:00)
2. Lunch (12:00 - 14:00)
3. Dinner (19:00 - 21:00)

### 3. Updated GroupModel
**Path:** `lib/app/data/models/group_model.dart`

**New Field:**
- `groupCategoryId`: Reference to which group category this group belongs to

## New Services

### GroupCategoriesFirestoreService
**Path:** `lib/app/data/services/group_categories_firestore_service.dart`

**Methods:**
- `getGroupCategoriesStream(userId)` - Real-time stream of user's group categories
- `getGroupCategories(userId)` - One-time fetch
- `createGroupCategory(userId, name, icon, description)` - Create new category
- `updateGroupCategory(userId, categoryId, updates)` - Update category
- `deleteGroupCategory(userId, categoryId)` - Delete category
- `initializeDefaultGroupCategories(userId)` - Initialize 4 default categories
- `isGroupCategoryNameUnique(userId, name)` - Validate uniqueness

### Updated MealCategoriesFirestoreService
**Path:** `lib/app/data/services/meal_categories_firestore_service.dart`

**Updated Methods:**
- `getMealCategoriesStream(userId, groupCategoryId)` - Get meal categories for a group category
- `createMealCategory(userId, groupCategoryId, name, startTime, endTime)` - Create with timing
- `initializeDefaultMealCategories(userId, groupCategoryId)` - Initialize 3 default meal categories

**Legacy Methods (Deprecated):**
- `getCategoriesStream(groupId)` - For backward compatibility
- `getCategories(groupId)` - For backward compatibility

## New Screens

### GroupCategoriesView
**Path:** `lib/app/modules/group_categories/views/group_categories_view.dart`

**Features:**
- List all group categories (default + custom)
- Create new group category with icon picker
- Delete custom categories (default categories protected)
- Navigate to meal categories when clicking a group category
- Beautiful card-based UI with gradients

**UI Components:**
- Icon picker with 10 emoji options
- Name and description fields
- Default badge for system categories
- Delete confirmation dialog

### GroupCategoriesController
**Path:** `lib/app/modules/group_categories/controllers/group_categories_controller.dart`

**Features:**
- Real-time category loading
- Create/delete operations
- Auto-initialize default meal categories when creating group category
- Navigation to meal categories screen

## User Flow

### 1. Access Group Categories
Profile → Group Categories

### 2. View Group Categories
- See default categories: General, Fitness, Yoga, Medication
- See custom categories created by user
- Each category shows icon, name, description, and default badge

### 3. Create Group Category
1. Click "Add Category" FAB
2. Select icon from 10 options
3. Enter category name (required)
4. Enter description (optional)
5. Click "Create"
6. System auto-creates 3 default meal categories (Breakfast, Lunch, Dinner)

### 4. Manage Meal Categories
1. Click on a group category card
2. Navigate to meal categories screen
3. View/edit meal categories for that group category
4. Add custom meal categories with timings

### 5. Create Group with Category
1. Go to Create Group screen
2. Select group category from dropdown
3. Group will inherit meal categories from selected group category

## Integration Points

### 1. Profile Screen
**Updated:** `lib/app/modules/profile/views/profile_main_view.dart`
- Changed "Meal Categories" to "Group Categories"
- Simplified navigation (no group check needed)
- Direct route to GROUP_CATEGORIES

### 2. Routes
**Updated:** `lib/app/routes/app_routes.dart` and `lib/app/routes/app_pages.dart`
- Added `GROUP_CATEGORIES` route
- Added binding and view imports
- Configured smooth transitions

### 3. Create Group Screen (TODO)
**Needs Update:** Add dropdown to select group category
- Fetch user's group categories
- Display in dropdown with icons
- Save `groupCategoryId` when creating group

### 4. Dashboard (TODO)
**Needs Update:** Load meal categories based on group's category
- When entering group mode, fetch group's `groupCategoryId`
- Load meal categories from that group category
- Display categories with timings

## Migration Strategy

### For Existing Users:
1. Run `initializeDefaultGroupCategories(userId)` on first login
2. Migrate existing meal categories to "General" group category
3. Update existing groups to reference "General" category

### For New Users:
1. Auto-initialize 4 default group categories on signup
2. Each group category gets 3 default meal categories
3. User can create custom categories immediately

## Benefits

### 1. Better Organization
- Users can organize meals by activity type (Yoga, Fitness, etc.)
- Clear separation between different meal planning contexts

### 2. Flexible Timing
- Each meal category has start/end time
- Users can customize timings per group category
- Example: Yoga breakfast at 6am, Fitness breakfast at 8am

### 3. Scalability
- Easy to add new group categories
- Each category can have unique meal categories
- No limit on customization

### 4. User Experience
- Intuitive hierarchy
- Visual icons for quick identification
- Default categories for quick start

## Next Steps

### 1. Update Create Group Screen
Add dropdown to select group category:
```dart
// In create_group_controller.dart
final groupCategories = <GroupCategoryModel>[].obs;
final selectedGroupCategory = Rxn<GroupCategoryModel>();

void loadGroupCategories() {
  _groupCategoriesService
      .getGroupCategoriesStream(userId!)
      .listen((categories) {
    groupCategories.value = categories;
    if (categories.isNotEmpty) {
      selectedGroupCategory.value = categories.first;
    }
  });
}
```

### 2. Update Dashboard
Load meal categories based on group's category:
```dart
void _loadGroupCategories(String groupId) async {
  final group = await _groupsService.getGroup(groupId);
  if (group.groupCategoryId != null) {
    _categoriesSubscription = _mealCategoriesService
        .getMealCategoriesStream(userId!, group.groupCategoryId!)
        .listen((categories) {
          groupCategories.value = categories.map((c) => c.name).toList();
        });
  }
}
```

### 3. Create Meal Categories Management Screen
Allow users to:
- View meal categories for a group category
- Add custom meal categories with timings
- Edit timings for existing categories
- Delete custom categories

### 4. Add Time-Based Filtering
Use meal category timings to:
- Show relevant categories based on current time
- Suggest meals based on time of day
- Display countdown to next meal time

## Testing Checklist

- [ ] Create new group category
- [ ] Delete custom group category
- [ ] Cannot delete default group category
- [ ] Navigate to meal categories from group category
- [ ] Default meal categories auto-created
- [ ] Icon picker works correctly
- [ ] Validation prevents duplicate names
- [ ] Real-time updates work
- [ ] Profile navigation works
- [ ] Routes configured correctly

## Files Created

1. `lib/app/data/models/group_category_model.dart`
2. `lib/app/data/services/group_categories_firestore_service.dart`
3. `lib/app/modules/group_categories/controllers/group_categories_controller.dart`
4. `lib/app/modules/group_categories/views/group_categories_view.dart`
5. `lib/app/modules/group_categories/bindings/group_categories_binding.dart`

## Files Modified

1. `lib/app/data/models/meal_category_model.dart` - Added groupCategoryId, timings
2. `lib/app/data/models/group_model.dart` - Added groupCategoryId
3. `lib/app/data/services/meal_categories_firestore_service.dart` - Updated for hierarchy
4. `lib/app/modules/profile/views/profile_main_view.dart` - Changed to Group Categories
5. `lib/app/routes/app_routes.dart` - Added GROUP_CATEGORIES route
6. `lib/app/routes/app_pages.dart` - Added route configuration
