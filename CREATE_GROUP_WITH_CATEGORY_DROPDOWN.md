# Create Group with Category Dropdown

## Overview
Added a dropdown in the Create Group screen that allows users to select which Group Category the new group belongs to. The dropdown fetches and displays all group categories created by the user.

## Implementation

### 1. Created CreateGroupController
**Path:** `lib/app/modules/group/controllers/create_group_controller.dart`

**Features:**
- Loads user's group categories on init
- Auto-selects first category by default
- Validates group name and category selection
- Creates group with selected category reference
- Shows loading states during operations

**Key Methods:**
- `_loadGroupCategories()` - Fetches categories via stream
- `selectGroupCategory(category)` - Updates selected category
- `createGroup()` - Validates and creates group with category reference

**Validation:**
- Group name required
- Group category selection required
- User authentication required

### 2. Updated CreateGroupScreen
**Path:** `lib/app/modules/group/views/create_group_screen.dart`

**Changes:**
- Converted from StatefulWidget to GetView
- Added Group Category dropdown at the top
- Shows loading indicator while fetching categories
- Shows warning if no categories exist with link to create one
- Dropdown displays category icon, name, description, and default badge
- Loading state on Save button during creation

**UI Flow:**
1. Screen opens → Auto-loads group categories
2. If loading → Shows loading indicator
3. If no categories → Shows warning with "Create" link
4. If categories exist → Shows dropdown with all categories
5. User selects category, enters name/description
6. Clicks "Save Group" → Creates group with category reference

### 3. Created CreateGroupBinding
**Path:** `lib/app/modules/group/bindings/create_group_binding.dart`

Lazy-loads the CreateGroupController when the route is accessed.

### 4. Updated Routes
**Path:** `lib/app/routes/app_pages.dart`

- Added import for `CreateGroupBinding`
- Updated CREATE_GROUP route to use `CreateGroupBinding` instead of `GroupBinding`
- Made CreateGroupScreen const

## Dropdown Features

### Display Format:
```
[Icon] Category Name          [Default Badge]
       Category Description
```

### Example:
```
🧘 Yoga                       Default
   Yoga and wellness meals
```

### States:

**Loading:**
```
⏳ Loading categories...
```

**No Categories:**
```
⚠️ No categories found. Create one first.  [Create]
```

**Categories Loaded:**
- Dropdown with all categories
- Icon + Name + Description
- Default badge for system categories
- Auto-selects first category

## Data Flow

### 1. Screen Opens
```
CreateGroupScreen
  ↓
CreateGroupController.onInit()
  ↓
_loadGroupCategories()
  ↓
GroupCategoriesFirestoreService.getGroupCategoriesStream(userId)
  ↓
groupCategories.value = categories
  ↓
Auto-select first category
```

### 2. User Creates Group
```
User fills form + selects category
  ↓
Clicks "Save Group"
  ↓
createGroup() validates inputs
  ↓
Creates GroupModel with groupCategoryId
  ↓
GroupsFirestoreService.addGroup(group)
  ↓
Success → Navigate back + Show snackbar
```

## GroupModel Update

The `GroupModel` now includes:
```dart
final String? groupCategoryId; // Reference to group category
```

When creating a group:
```dart
final group = GroupModel(
  name: nameController.text.trim(),
  description: descriptionController.text.trim(),
  groupCategoryId: selectedGroupCategory.value!.id, // ← Category reference
  createdBy: userId!,
  membersList: [userId!],
  createdAt: DateTime.now(),
  // ... other fields
);
```

## User Experience

### Happy Path:
1. User clicks "Add Group" button
2. Create Group screen opens
3. Dropdown shows available categories (e.g., General, Fitness, Yoga, Medication)
4. User selects "Yoga" category
5. User enters group name "Morning Yoga Group"
6. User enters description "Daily morning yoga sessions"
7. User clicks "Save Group"
8. Group is created with reference to Yoga category
9. Success message shown
10. User navigated back to groups list

### Edge Cases Handled:

**No Categories Exist:**
- Shows warning message
- Provides "Create" button to navigate to Group Categories screen
- User creates categories first, then returns to create group

**Loading State:**
- Shows loading indicator while fetching categories
- Prevents premature interaction

**Validation Errors:**
- Empty group name → "Please enter a group name"
- No category selected → "Please select a group category"
- Not authenticated → "User not authenticated"

**Network Errors:**
- Failed to load categories → Error snackbar
- Failed to create group → Error snackbar with details

## Benefits

### 1. Organized Groups
Groups are now categorized by type (Yoga, Fitness, Medication, etc.)

### 2. Inherited Meal Categories
When a group is created under a category, it inherits that category's meal categories:
- Yoga group → Gets Yoga meal categories
- Fitness group → Gets Fitness meal categories

### 3. Consistent Structure
All groups follow the same organizational pattern

### 4. Easy Discovery
Users can filter/organize groups by category

## Next Steps

### 1. Display Category in Group List
Show category icon/name in the groups list:
```dart
// In group card
Row(
  children: [
    Text(group.name),
    Spacer(),
    Text(groupCategory.icon), // Show category icon
  ],
)
```

### 2. Filter Groups by Category
Add category filter in groups screen:
```dart
// Category filter chips
Wrap(
  children: categories.map((cat) => 
    FilterChip(
      label: Text(cat.name),
      selected: selectedCategory == cat,
      onSelected: (selected) => filterByCategory(cat),
    )
  ).toList(),
)
```

### 3. Load Meal Categories Based on Group Category
When entering group mode, load meal categories from the group's category:
```dart
void enterGroupMode(String groupId) async {
  final group = await _groupsService.getGroup(groupId);
  if (group.groupCategoryId != null) {
    final mealCategories = await _mealCategoriesService
        .getMealCategories(userId, group.groupCategoryId!);
    // Display meal categories
  }
}
```

### 4. Category-Based Group Templates
Offer templates when creating groups:
- Yoga template → Pre-filled with yoga-related settings
- Fitness template → Pre-filled with workout settings
- Medication template → Pre-filled with medication tracking settings

## Testing Checklist

- [ ] Dropdown loads categories on screen open
- [ ] Loading indicator shows while fetching
- [ ] Warning shows when no categories exist
- [ ] "Create" link navigates to Group Categories
- [ ] Dropdown displays all categories correctly
- [ ] Icons, names, descriptions display properly
- [ ] Default badge shows for system categories
- [ ] Category selection updates correctly
- [ ] Validation prevents empty group name
- [ ] Validation prevents missing category
- [ ] Group creates successfully with category reference
- [ ] Success message shows after creation
- [ ] Navigation back to groups list works
- [ ] Error handling works for network issues
- [ ] Loading state shows on Save button

## Files Created

1. `lib/app/modules/group/controllers/create_group_controller.dart`
2. `lib/app/modules/group/bindings/create_group_binding.dart`

## Files Modified

1. `lib/app/modules/group/views/create_group_screen.dart` - Added dropdown, converted to GetView
2. `lib/app/routes/app_pages.dart` - Updated binding and imports
