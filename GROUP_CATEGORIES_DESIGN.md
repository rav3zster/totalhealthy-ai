# Group Categories System - Complete Design Document

## Executive Summary

Replace the user-level "Meal Timing" system with a group-level "Meal Categories" system that allows admins to dynamically manage meal categories per group while maintaining backward compatibility with existing data.

## 1. DATA MODEL CHANGES

### 1.1 New Model: MealCategoryModel

**Location:** `lib/app/data/models/meal_category_model.dart`

```dart
class MealCategoryModel {
  final String? id;
  final String groupId;
  final String name;
  final int order;
  final bool isDefault;
  final DateTime createdAt;
  final String createdBy;
  
  // Default categories that cannot be deleted
  static const List<String> defaultCategories = [
    'Breakfast',
    'Lunch', 
    'Dinner',
    'Snacks'
  ];
}
```

**Firestore Path:** `groups/{groupId}/categories/{categoryId}`

**Fields:**
- `name` (string): Category display name
- `order` (int): Sort order for display
- `isDefault` (bool): True for system defaults (cannot be deleted)
- `createdAt` (timestamp): Creation timestamp
- `createdBy` (string): User ID who created it

**Indexes Required:**
- Composite: `groupId ASC, order ASC`
- Single: `groupId ASC`

### 1.2 GroupMealPlanModel Changes

**Current Structure:**
```dart
final Map<String, String?> mealSlots; // Category name → mealId
```

**CHANGE TO:**
```dart
final Map<String, String?> mealSlots; // categoryId → mealId
```

**Migration Strategy:**
- Keep backward compatibility during transition
- `fromJson()` will check if keys are IDs or names
- If name detected, lookup categoryId from group's categories
- `toJson()` writes both categoryId and legacy name fields

### 1.3 MealModel Changes

**Current:**
```dart
final List<String> categories; // Category names
```

**CHANGE TO:**
```dart
final List<String> categoryIds; // Category IDs
final List<String> categories; // DEPRECATED - keep for backward compat
```

**Migration:**
- New meals store categoryIds
- Old meals with category names will be migrated on first read
- Lookup category by name in group's categories collection


## 2. FIRESTORE SERVICE LAYER

### 2.1 New Service: MealCategoriesFirestoreService

**Location:** `lib/app/data/services/meal_categories_firestore_service.dart`

**Methods:**

```dart
// Stream categories for a group (ordered)
Stream<List<MealCategoryModel>> getCategoriesStream(String groupId)

// Create category (admin only)
Future<String> createCategory(String groupId, String name, String userId)

// Rename category (admin only)
Future<void> renameCategory(String groupId, String categoryId, String newName)

// Reorder categories (admin only)
Future<void> reorderCategories(String groupId, List<String> categoryIds)

// Delete category (admin only, with validation)
Future<void> deleteCategory(String groupId, String categoryId)

// Initialize default categories for new group
Future<void> initializeDefaultCategories(String groupId, String userId)

// Validate category deletion (check if meals/plans reference it)
Future<bool> canDeleteCategory(String groupId, String categoryId)
```

**Validation Rules:**
1. Category names must be unique per group (case-insensitive)
2. Cannot delete if meals exist with this categoryId
3. Cannot delete if planner references this categoryId
4. Cannot delete default categories (isDefault = true)
5. Must maintain at least 1 category per group

### 2.2 GroupsFirestoreService Updates

**Add method:**
```dart
Future<void> addGroup(GroupModel group) async {
  // ... existing code ...
  
  // Initialize default categories
  await MealCategoriesFirestoreService().initializeDefaultCategories(
    groupId, 
    group.createdBy
  );
}
```

### 2.3 GroupMealPlansFirestoreService Updates

**Update validation:**
```dart
Future<void> setMealForCategory(
  String groupId, 
  DateTime date, 
  String categoryId,  // Changed from category name
  String? mealId
) async {
  // Validate categoryId exists in group
  final categories = await MealCategoriesFirestoreService()
    .getCategories(groupId);
  
  if (!categories.any((c) => c.id == categoryId)) {
    throw Exception('Invalid category ID');
  }
  
  // ... rest of logic ...
}
```


## 3. CONTROLLER LAYER

### 3.1 New Controller: MealCategoriesController

**Location:** `lib/app/modules/meal_categories/controllers/meal_categories_controller.dart`

**Properties:**
```dart
final categories = <MealCategoryModel>[].obs;
final isLoading = false.obs;
final selectedGroupId = Rxn<String>();
final isAdmin = false.obs;
StreamSubscription? _categoriesSubscription;
```

**Methods:**
```dart
void initForGroup(String groupId, bool isUserAdmin)
Future<void> createCategory(String name)
Future<void> renameCategory(String categoryId, String newName)
Future<void> reorderCategories(List<MealCategoryModel> reordered)
Future<void> deleteCategory(String categoryId)
```

**Validation:**
- Check admin status before mutations
- Validate unique names
- Check deletion constraints
- Show appropriate error messages

### 3.2 ClientDashboardController Updates

**Add properties:**
```dart
final mealCategories = <MealCategoryModel>[].obs;
StreamSubscription? _categoriesSubscription;
```

**Update methods:**
```dart
void _setupMealsStream(String userId) async {
  // ... existing code ...
  
  // Subscribe to categories for selected group
  if (selectedGroupId.value != null) {
    _categoriesSubscription = MealCategoriesFirestoreService()
      .getCategoriesStream(selectedGroupId.value!)
      .listen((cats) {
        mealCategories.value = cats;
        // Update selectedCategory if current one was deleted
        if (!cats.any((c) => c.id == selectedCategory.value)) {
          selectedCategory.value = cats.first.id;
        }
      });
  }
}

// Update category selection to use IDs
void selectCategory(String categoryId) {
  selectedCategory.value = categoryId;
  update();
}
```

**Filter logic update:**
```dart
List<MealModel> get filteredMeals {
  var result = isGroupMode.value ? groupMeals : meals;
  
  // Filter by categoryId instead of name
  if (selectedCategory.value.isNotEmpty) {
    result = result.where((meal) => 
      meal.categoryIds.contains(selectedCategory.value)
    ).toList();
  }
  
  // ... search filter ...
  return result;
}
```

### 3.3 PlannerController Updates

**Add properties:**
```dart
final mealCategories = <MealCategoryModel>[].obs;
```

**Update weekly plan generation:**
```dart
void _generateWeeklyPlan() {
  // Use dynamic categories instead of hardcoded
  Map<String, List<String>> mealsByCategory = {};
  
  for (var meal in meals) {
    for (var catId in meal.categoryIds) {
      final category = mealCategories.firstWhereOrNull((c) => c.id == catId);
      if (category != null) {
        mealsByCategory.putIfAbsent(category.name, () => []).add(meal.name);
      }
    }
  }
  
  // ... rest of logic ...
}
```


## 4. UI LAYER

### 4.1 Remove Meal Timing Screen

**Files to delete:**
- `lib/app/modules/meal_timing/` (entire directory)

**Routes to remove:**
- `Routes.MEAL_TIMING` from `app_routes.dart`
- Route binding from `app_pages.dart`

**Navigation updates:**
- Remove "Meal Timing" button from `member_profile_view.dart`

### 4.2 New Screen: Meal Categories Management

**Location:** `lib/app/modules/meal_categories/views/meal_categories_view.dart`

**Access:** Profile → Meal Categories (inside Profile Settings)

**UI Components:**

**For Admin:**
```
┌─────────────────────────────────────┐
│  Meal Categories                    │
│  ─────────────────────────────────  │
│                                     │
│  ☰ Breakfast          [Default]    │
│  ☰ Lunch              [Default]    │
│  ☰ Dinner             [Default]    │
│  ☰ Snacks             [Default]    │
│  ☰ Pre-Workout        [✏️] [🗑️]    │
│  ☰ Post-Workout       [✏️] [🗑️]    │
│                                     │
│  [+ Add Category]                   │
└─────────────────────────────────────┘
```

**Features:**
- Drag handles (☰) for reordering
- Edit icon (✏️) for renaming
- Delete icon (🗑️) for custom categories
- Default categories show badge, no delete option
- Add button at bottom

**For Member (Read-only):**
```
┌─────────────────────────────────────┐
│  Meal Categories                    │
│  ─────────────────────────────────  │
│                                     │
│  • Breakfast                        │
│  • Lunch                            │
│  • Dinner                           │
│  • Snacks                           │
│  • Pre-Workout                      │
│  • Post-Workout                     │
│                                     │
│  ℹ️ Only admins can modify          │
└─────────────────────────────────────┘
```

**Dialogs:**

1. **Add Category Dialog:**
   - Text input for name
   - Validation: unique, not empty, max 30 chars
   - Cancel / Create buttons

2. **Rename Category Dialog:**
   - Pre-filled text input
   - Same validation
   - Cancel / Save buttons

3. **Delete Confirmation:**
   - Warning message
   - Check if meals/plans reference it
   - If referenced: "Cannot delete - X meals use this category"
   - Cancel / Delete buttons

### 4.3 Profile Settings Integration

**Update:** `lib/app/modules/setting/views/profile_settings_view.dart`

**Add navigation item:**
```dart
ListTile(
  leading: Icon(Icons.category),
  title: Text('Meal Categories'),
  trailing: Icon(Icons.chevron_right),
  onTap: () => Get.toNamed(Routes.MEAL_CATEGORIES),
)
```

**Position:** Between "Goal Setting" and "Setting"

### 4.4 Dashboard Category Tabs Update

**Update:** `lib/app/modules/client_dashboard/views/client_dashboard_views.dart`

**Current (hardcoded):**
```dart
final categories = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];
```

**Change to (dynamic):**
```dart
Obx(() {
  final categories = controller.mealCategories;
  return TabBar(
    tabs: categories.map((cat) => Tab(text: cat.name)).toList(),
  );
})
```

**Handle empty state:**
```dart
if (controller.mealCategories.isEmpty) {
  return Center(child: Text('No categories available'));
}
```


## 5. MIGRATION STRATEGY

### 5.1 Data Migration Approach

**Phase 1: Initialize Categories (One-time)**
```dart
// Run for all existing groups
Future<void> migrateExistingGroups() async {
  final groups = await FirebaseFirestore.instance
    .collection('groups')
    .get();
  
  for (var groupDoc in groups.docs) {
    final groupId = groupDoc.id;
    final createdBy = groupDoc.data()['created_by'];
    
    // Check if categories already exist
    final existingCats = await FirebaseFirestore.instance
      .collection('groups')
      .doc(groupId)
      .collection('categories')
      .limit(1)
      .get();
    
    if (existingCats.docs.isEmpty) {
      // Initialize default categories
      await MealCategoriesFirestoreService()
        .initializeDefaultCategories(groupId, createdBy);
    }
  }
}
```

**Phase 2: Migrate Meal Data (Lazy)**
```dart
// In MealModel.fromJson()
factory MealModel.fromJson(Map<String, dynamic> json, {String? docId}) {
  List<String> categoryIds = [];
  
  // Try new format first
  if (json['categoryIds'] != null) {
    categoryIds = List<String>.from(json['categoryIds']);
  } 
  // Fallback to old format - migrate on read
  else if (json['categories'] != null) {
    final categoryNames = List<String>.from(json['categories']);
    final groupId = json['groupId'];
    
    // Lookup category IDs by name (requires async, handle in controller)
    // For now, store names and migrate in background
    categoryIds = categoryNames; // Temporary
  }
  
  return MealModel(
    // ... other fields ...
    categoryIds: categoryIds,
    categories: List<String>.from(json['categories'] ?? []), // Keep for compat
  );
}
```

**Phase 3: Migrate Planner Data (Lazy)**
```dart
// In GroupMealPlanModel.fromJson()
factory GroupMealPlanModel.fromJson(Map<String, dynamic> json, {String? docId}) {
  Map<String, String?> slots = {};
  
  if (json['mealSlots'] != null) {
    final slotsData = json['mealSlots'] as Map<String, dynamic>;
    
    for (var entry in slotsData.entries) {
      // Check if key is an ID (starts with category_) or a name
      if (entry.key.startsWith('category_')) {
        // New format - already an ID
        slots[entry.key] = entry.value;
      } else {
        // Old format - name, needs migration
        // Lookup category ID by name (handle in controller)
        slots[entry.key] = entry.value; // Temporary
      }
    }
  }
  
  // ... backward compatibility for old fields ...
  
  return GroupMealPlanModel(/* ... */);
}
```

### 5.2 Migration Script

**Location:** `lib/app/data/services/migration_service.dart`

```dart
class MigrationService {
  // Run once on app startup (for current user's groups)
  static Future<void> migrateUserData(String userId) async {
    final groups = await GroupsFirestoreService().getUserGroups(userId);
    
    for (var group in groups) {
      if (group.id == null) continue;
      
      // 1. Ensure categories exist
      await _ensureCategories(group.id!, group.createdBy);
      
      // 2. Migrate meals (if user is admin)
      if (group.isAdmin(userId)) {
        await _migrateMeals(group.id!);
      }
      
      // 3. Migrate planner data
      await _migratePlannerData(group.id!);
    }
  }
  
  static Future<void> _ensureCategories(String groupId, String createdBy) async {
    // Check if categories exist
    final cats = await MealCategoriesFirestoreService().getCategories(groupId);
    
    if (cats.isEmpty) {
      await MealCategoriesFirestoreService()
        .initializeDefaultCategories(groupId, createdBy);
    }
  }
  
  static Future<void> _migrateMeals(String groupId) async {
    // Fetch all meals for group
    final meals = await MealsFirestoreService().getMeals(groupId);
    final categories = await MealCategoriesFirestoreService().getCategories(groupId);
    
    for (var meal in meals) {
      // Skip if already migrated
      if (meal.categoryIds.isNotEmpty && 
          meal.categoryIds.first.startsWith('category_')) {
        continue;
      }
      
      // Map names to IDs
      final categoryIds = <String>[];
      for (var name in meal.categories) {
        final cat = categories.firstWhereOrNull(
          (c) => c.name.toLowerCase() == name.toLowerCase()
        );
        if (cat != null && cat.id != null) {
          categoryIds.add(cat.id!);
        }
      }
      
      // Update meal
      if (categoryIds.isNotEmpty) {
        await MealsFirestoreService().updateMeal(
          meal.id!,
          {'categoryIds': categoryIds}
        );
      }
    }
  }
  
  static Future<void> _migratePlannerData(String groupId) async {
    // Similar logic for group_meal_plans collection
    // Map category names in mealSlots to category IDs
  }
}
```

**Trigger migration:**
```dart
// In AuthController or AppController onInit
@override
void onInit() {
  super.onInit();
  
  FirebaseAuth.instance.authStateChanges().listen((user) async {
    if (user != null) {
      // Run migration in background
      MigrationService.migrateUserData(user.uid).catchError((e) {
        print('Migration error: $e');
      });
    }
  });
}
```


## 6. VALIDATION & EDGE CASES

### 6.1 Category Name Uniqueness

**Validation:**
```dart
Future<bool> isCategoryNameUnique(String groupId, String name, {String? excludeId}) async {
  final categories = await getCategories(groupId);
  
  return !categories.any((cat) => 
    cat.name.toLowerCase() == name.toLowerCase() && 
    cat.id != excludeId
  );
}
```

**Error Message:** "A category with this name already exists"

### 6.2 Category Deletion Constraints

**Check meals:**
```dart
Future<bool> canDeleteCategory(String groupId, String categoryId) async {
  // 1. Check if default
  final category = await getCategory(groupId, categoryId);
  if (category.isDefault) {
    return false; // Cannot delete defaults
  }
  
  // 2. Check if meals reference it
  final meals = await FirebaseFirestore.instance
    .collection('meals')
    .where('groupId', isEqualTo: groupId)
    .where('categoryIds', arrayContains: categoryId)
    .limit(1)
    .get();
  
  if (meals.docs.isNotEmpty) {
    return false; // Meals exist
  }
  
  // 3. Check if planner references it
  final plans = await FirebaseFirestore.instance
    .collection('group_meal_plans')
    .where('groupId', isEqualTo: groupId)
    .get();
  
  for (var plan in plans.docs) {
    final mealSlots = plan.data()['mealSlots'] as Map<String, dynamic>?;
    if (mealSlots != null && mealSlots.containsKey(categoryId)) {
      return false; // Planner references it
    }
  }
  
  // 4. Check if last category
  final allCategories = await getCategories(groupId);
  if (allCategories.length <= 1) {
    return false; // Must keep at least one
  }
  
  return true;
}
```

**Error Messages:**
- "Cannot delete default categories"
- "Cannot delete - X meals use this category"
- "Cannot delete - meal plans reference this category"
- "Cannot delete - at least one category is required"

### 6.3 Multiple Groups Per User

**Scenario:** User is in Group A and Group B, each with different categories

**Solution:**
- Categories are scoped to groupId
- Dashboard loads categories for selectedGroupId
- When switching groups, reload categories
- Cache categories per group in controller

```dart
final categoriesByGroup = <String, List<MealCategoryModel>>{}.obs;

void switchGroup(String groupId) {
  selectedGroupId.value = groupId;
  
  // Load categories for this group
  if (!categoriesByGroup.containsKey(groupId)) {
    _loadCategoriesForGroup(groupId);
  } else {
    mealCategories.value = categoriesByGroup[groupId]!;
  }
}
```

### 6.4 Category Reorder Conflicts

**Scenario:** Two admins reorder categories simultaneously

**Solution:**
- Use optimistic updates in UI
- Server-side: Last write wins
- On conflict, reload categories from server

```dart
Future<void> reorderCategories(String groupId, List<String> categoryIds) async {
  final batch = FirebaseFirestore.instance.batch();
  
  for (int i = 0; i < categoryIds.length; i++) {
    final docRef = FirebaseFirestore.instance
      .collection('groups')
      .doc(groupId)
      .collection('categories')
      .doc(categoryIds[i]);
    
    batch.update(docRef, {'order': i});
  }
  
  await batch.commit();
}
```

### 6.5 Race Condition on Delete

**Scenario:** Admin deletes category while another admin assigns meal to it

**Solution:**
- Use Firestore transactions for deletion
- Validate constraints inside transaction
- If meal added during deletion, transaction fails

```dart
Future<void> deleteCategory(String groupId, String categoryId) async {
  await FirebaseFirestore.instance.runTransaction((transaction) async {
    // Re-check constraints inside transaction
    final canDelete = await canDeleteCategory(groupId, categoryId);
    
    if (!canDelete) {
      throw Exception('Category cannot be deleted');
    }
    
    final docRef = FirebaseFirestore.instance
      .collection('groups')
      .doc(groupId)
      .collection('categories')
      .doc(categoryId);
    
    transaction.delete(docRef);
  });
}
```

### 6.6 Category Renaming & Planner Integrity

**Scenario:** Admin renames "Breakfast" to "Morning Meal"

**Solution:**
- Planner uses categoryId, not name
- Renaming only updates category document
- Planner automatically reflects new name via ID lookup
- No data migration needed

```dart
Future<void> renameCategory(String groupId, String categoryId, String newName) async {
  // Validate unique name
  final isUnique = await isCategoryNameUnique(groupId, newName, excludeId: categoryId);
  
  if (!isUnique) {
    throw Exception('Category name already exists');
  }
  
  // Update only the category document
  await FirebaseFirestore.instance
    .collection('groups')
    .doc(groupId)
    .collection('categories')
    .doc(categoryId)
    .update({'name': newName});
  
  // Planner data unchanged - still references categoryId
}
```


## 7. FIRESTORE INDEXES

### 7.1 Required Composite Indexes

**Index 1: Categories by Group (ordered)**
```
Collection: groups/{groupId}/categories
Fields: 
  - groupId: Ascending
  - order: Ascending
```

**Index 2: Meals by Group and Category**
```
Collection: meals
Fields:
  - groupId: Ascending
  - categoryIds: Array-contains
  - createdAt: Descending
```

**Index 3: Group Meal Plans by Group**
```
Collection: group_meal_plans
Fields:
  - groupId: Ascending
  - date: Ascending
```

### 7.2 Index Creation Commands

**Firebase Console:**
1. Go to Firestore → Indexes
2. Create composite indexes manually
3. Or deploy via `firestore.indexes.json`

**firestore.indexes.json:**
```json
{
  "indexes": [
    {
      "collectionGroup": "categories",
      "queryScope": "COLLECTION",
      "fields": [
        {"fieldPath": "groupId", "order": "ASCENDING"},
        {"fieldPath": "order", "order": "ASCENDING"}
      ]
    },
    {
      "collectionGroup": "meals",
      "queryScope": "COLLECTION",
      "fields": [
        {"fieldPath": "groupId", "order": "ASCENDING"},
        {"fieldPath": "categoryIds", "arrayConfig": "CONTAINS"},
        {"fieldPath": "createdAt", "order": "DESCENDING"}
      ]
    }
  ]
}
```

## 8. FUTURE-PROOFING: MULTIPLE ITEMS PER CATEGORY

### 8.1 Current Limitation

**GroupMealPlanModel:**
```dart
final Map<String, String?> mealSlots; // categoryId → single mealId
```

**Limitation:** Only one meal per category per day

### 8.2 Future Enhancement Design

**Change to:**
```dart
final Map<String, List<String>> mealSlots; // categoryId → List<mealId>
```

**Migration Path:**
```dart
// Backward compatible fromJson
factory GroupMealPlanModel.fromJson(Map<String, dynamic> json) {
  Map<String, List<String>> slots = {};
  
  if (json['mealSlots'] != null) {
    final slotsData = json['mealSlots'] as Map<String, dynamic>;
    
    for (var entry in slotsData.entries) {
      final value = entry.value;
      
      if (value is String) {
        // Old format - single meal
        slots[entry.key] = [value];
      } else if (value is List) {
        // New format - multiple meals
        slots[entry.key] = List<String>.from(value);
      }
    }
  }
  
  return GroupMealPlanModel(mealSlots: slots);
}
```

**UI Changes:**
```dart
// Dashboard - show multiple meals per category
Column(
  children: mealSlots[categoryId]?.map((mealId) {
    final meal = meals.firstWhere((m) => m.id == mealId);
    return MealCard(meal: meal);
  }).toList() ?? [],
)

// Planner - allow adding multiple meals
FloatingActionButton(
  onPressed: () => addMealToCategory(categoryId),
  child: Icon(Icons.add),
)
```

**No Breaking Changes:**
- Existing single-meal data works as List with 1 item
- UI can handle both single and multiple meals
- Controllers check list length to determine display

### 8.3 Conflict Resolution

**Scenario:** Multiple meals in same category - which to show first?

**Solution:**
- Add `order` field to meal slots
- Or use meal creation time
- Or allow user to reorder within category

```dart
// Enhanced structure
final Map<String, List<MealSlotItem>> mealSlots;

class MealSlotItem {
  final String mealId;
  final int order;
  final DateTime addedAt;
}
```


## 9. IMPLEMENTATION CHECKLIST

### Phase 1: Data Layer (Foundation)
- [ ] Create `MealCategoryModel` with validation
- [ ] Create `MealCategoriesFirestoreService` with all CRUD methods
- [ ] Update `MealModel` to add `categoryIds` field
- [ ] Update `GroupMealPlanModel` to support categoryId keys
- [ ] Update `GroupsFirestoreService.addGroup()` to initialize categories
- [ ] Create `MigrationService` for data migration
- [ ] Add Firestore indexes

### Phase 2: Controller Layer (Business Logic)
- [ ] Create `MealCategoriesController` with admin checks
- [ ] Update `ClientDashboardController` to load categories
- [ ] Update `ClientDashboardController` filtering to use categoryIds
- [ ] Update `PlannerController` to use dynamic categories
- [ ] Add category subscription management
- [ ] Implement validation logic (unique names, deletion constraints)

### Phase 3: UI Layer (Views)
- [ ] Create `MealCategoriesView` (admin + member modes)
- [ ] Create category management dialogs (add, rename, delete)
- [ ] Update `ProfileSettingsView` to add navigation
- [ ] Update `ClientDashboardView` to use dynamic category tabs
- [ ] Update `MemberProfileView` to remove Meal Timing button
- [ ] Add loading states and error handling

### Phase 4: Routes & Navigation
- [ ] Add `MEAL_CATEGORIES` route to `app_routes.dart`
- [ ] Add route binding to `app_pages.dart`
- [ ] Remove `MEAL_TIMING` route
- [ ] Update navigation flows

### Phase 5: Cleanup
- [ ] Delete `lib/app/modules/meal_timing/` directory
- [ ] Remove meal timing references from controllers
- [ ] Remove unused imports
- [ ] Update documentation

### Phase 6: Testing & Migration
- [ ] Test category CRUD operations
- [ ] Test admin vs member permissions
- [ ] Test category deletion validation
- [ ] Test planner with dynamic categories
- [ ] Test dashboard filtering
- [ ] Run migration script on test data
- [ ] Verify backward compatibility

### Phase 7: Deployment
- [ ] Deploy Firestore indexes
- [ ] Deploy code to staging
- [ ] Run migration for existing groups
- [ ] Monitor for errors
- [ ] Deploy to production

## 10. ROLLBACK PLAN

### If Issues Arise

**Step 1: Revert Code**
- Restore meal_timing module
- Revert model changes
- Restore old routes

**Step 2: Data Integrity**
- Categories remain in Firestore (no harm)
- Old code still reads category names from meals
- Planner still works with name-based keys

**Step 3: Gradual Rollout**
- Feature flag: `enableDynamicCategories`
- If false, use old meal timing system
- If true, use new categories system

```dart
class FeatureFlags {
  static const bool enableDynamicCategories = true;
  
  static bool get useMealCategories => enableDynamicCategories;
}

// In controllers
if (FeatureFlags.useMealCategories) {
  // New logic
} else {
  // Old logic
}
```

## 11. SUMMARY

### What Changes
1. **Data Model:** Categories move from user-level to group-level with IDs
2. **Storage:** New subcollection `groups/{groupId}/categories`
3. **Planner:** Uses categoryId instead of category name
4. **Meals:** Store categoryIds instead of category names
5. **UI:** Dynamic category tabs, new management screen
6. **Navigation:** Remove Meal Timing, add Meal Categories

### What Stays the Same
1. **Planner Logic:** Still maps categories to meals
2. **Dashboard Filtering:** Still filters by category
3. **User Experience:** Similar workflow, better flexibility
4. **Backward Compatibility:** Old data migrates automatically

### Key Benefits
1. **Flexibility:** Admins can customize categories per group
2. **Scalability:** Supports unlimited categories
3. **Maintainability:** Category renames don't break planner
4. **Future-Ready:** Easy to extend to multiple meals per category
5. **Clean Architecture:** Separation of concerns (group-level vs user-level)

### Risks Mitigated
1. **Data Loss:** Migration is lazy and backward compatible
2. **Race Conditions:** Transactions for critical operations
3. **Validation:** Multiple layers of constraint checking
4. **Conflicts:** Optimistic updates with server reconciliation
5. **Rollback:** Feature flags and gradual deployment

