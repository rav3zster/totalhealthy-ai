# Group Categories System - Architecture Diagram

## System Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                           UI LAYER                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌──────────────────┐  ┌──────────────────┐  ┌─────────────────┐  │
│  │ Profile Settings │  │ Meal Categories  │  │ Client Dashboard│  │
│  │      View        │──│      View        │  │      View       │  │
│  │                  │  │                  │  │                 │  │
│  │ • Navigation     │  │ • Admin: CRUD    │  │ • Dynamic Tabs  │  │
│  │ • Menu Items     │  │ • Member: View   │  │ • Category      │  │
│  │                  │  │ • Reorder        │  │   Filtering     │  │
│  └──────────────────┘  └──────────────────┘  └─────────────────┘  │
│           │                     │                      │            │
└───────────┼─────────────────────┼──────────────────────┼────────────┘
            │                     │                      │
            ▼                     ▼                      ▼
┌─────────────────────────────────────────────────────────────────────┐
│                        CONTROLLER LAYER                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌──────────────────────┐  ┌────────────────────────────────────┐  │
│  │ MealCategories       │  │ ClientDashboard                    │  │
│  │    Controller        │  │    Controller                      │  │
│  │                      │  │                                    │  │
│  │ • Load Categories    │  │ • Subscribe to Categories          │  │
│  │ • Create/Edit/Delete │  │ • Filter Meals by CategoryId       │  │
│  │ • Reorder            │  │ • Handle Category Changes          │  │
│  │ • Validate           │  │ • Cache Management                 │  │
│  │ • Admin Check        │  │                                    │  │
│  └──────────────────────┘  └────────────────────────────────────┘  │
│           │                              │                          │
│           │         ┌────────────────────┴──────────┐               │
│           │         │                               │               │
│           ▼         ▼                               ▼               │
│  ┌──────────────────────┐  ┌──────────────┐  ┌──────────────────┐  │
│  │ RolePermissions      │  │   Planner    │  │   Migration      │  │
│  │    Service           │  │  Controller  │  │    Service       │  │
│  │                      │  │              │  │                  │  │
│  │ • isAdmin()          │  │ • Dynamic    │  │ • Lazy Migration │  │
│  │ • canModifyCategory()│  │   Categories │  │ • Name→ID Lookup │  │
│  └──────────────────────┘  └──────────────┘  └──────────────────┘  │
│                                    │                  │              │
└────────────────────────────────────┼──────────────────┼──────────────┘
                                     │                  │
                                     ▼                  ▼
┌─────────────────────────────────────────────────────────────────────┐
│                        SERVICE LAYER                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌────────────────────────────────────────────────────────────┐    │
│  │         MealCategoriesFirestoreService                     │    │
│  │                                                            │    │
│  │  • getCategoriesStream(groupId)                           │    │
│  │  • createCategory(groupId, name, userId)                  │    │
│  │  • renameCategory(groupId, categoryId, newName)           │    │
│  │  • reorderCategories(groupId, categoryIds)                │    │
│  │  • deleteCategory(groupId, categoryId)                    │    │
│  │  • canDeleteCategory(groupId, categoryId)                 │    │
│  │  • initializeDefaultCategories(groupId, userId)           │    │
│  └────────────────────────────────────────────────────────────┘    │
│                                    │                                │
│  ┌─────────────────────┐  ┌────────┴──────────┐  ┌──────────────┐  │
│  │ MealsFirestore      │  │ GroupMealPlans    │  │ Groups       │  │
│  │    Service          │  │ FirestoreService  │  │ Firestore    │  │
│  │                     │  │                   │  │ Service      │  │
│  │ • getMealsStream()  │  │ • setMealFor      │  │              │  │
│  │ • updateMeal()      │  │   Category()      │  │ • addGroup() │  │
│  │ • Filter by         │  │ • Validate        │  │   (init cats)│  │
│  │   categoryId        │  │   categoryId      │  │              │  │
│  └─────────────────────┘  └───────────────────┘  └──────────────┘  │
│           │                        │                      │          │
└───────────┼────────────────────────┼──────────────────────┼──────────┘
            │                        │                      │
            ▼                        ▼                      ▼
┌─────────────────────────────────────────────────────────────────────┐
│                        DATA LAYER                                   │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ┌──────────────────┐  ┌──────────────────┐  ┌─────────────────┐  │
│  │ MealCategory     │  │ Meal             │  │ GroupMealPlan   │  │
│  │    Model         │  │ Model            │  │    Model        │  │
│  │                  │  │                  │  │                 │  │
│  │ • id             │  │ • id             │  │ • id            │  │
│  │ • groupId        │  │ • name           │  │ • groupId       │  │
│  │ • name           │  │ • categoryIds ✨ │  │ • date          │  │
│  │ • order          │  │ • categories     │  │ • mealSlots     │  │
│  │ • isDefault      │  │   (deprecated)   │  │   Map<catId,    │  │
│  │ • createdAt      │  │ • nutrition      │  │   mealId> ✨    │  │
│  │ • createdBy      │  │ • ingredients    │  │                 │  │
│  └──────────────────┘  └──────────────────┘  └─────────────────┘  │
│           │                     │                      │            │
└───────────┼─────────────────────┼──────────────────────┼────────────┘
            │                     │                      │
            ▼                     ▼                      ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      FIRESTORE DATABASE                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  groups/{groupId}                                                   │
│  ├── name, description, created_by, members_list                    │
│  │                                                                   │
│  └── categories/{categoryId} ✨ NEW                                 │
│      ├── name: "Breakfast"                                          │
│      ├── order: 0                                                   │
│      ├── isDefault: true                                            │
│      ├── createdAt: timestamp                                       │
│      └── createdBy: userId                                          │
│                                                                     │
│  meals/{mealId}                                                     │
│  ├── name, description, nutrition                                   │
│  ├── categoryIds: ["category_abc123"] ✨ NEW                        │
│  ├── categories: ["Breakfast"] (deprecated)                         │
│  ├── groupId                                                        │
│  └── userId                                                         │
│                                                                     │
│  group_meal_plans/{groupId}_{date}                                  │
│  ├── groupId                                                        │
│  ├── date                                                           │
│  ├── mealSlots: {                                                   │
│  │     "category_abc123": "meal_xyz789" ✨ UPDATED                  │
│  │   }                                                              │
│  ├── breakfastMealId (deprecated)                                   │
│  └── lunchMealId (deprecated)                                       │
│                                                                     │
│  ✨ = New or Updated                                                │
└─────────────────────────────────────────────────────────────────────┘
```

## Data Flow Diagrams

### 1. Category Creation Flow (Admin)

```
User (Admin)                Controller              Service              Firestore
    │                           │                      │                    │
    │ Click "Add Category"      │                      │                    │
    ├──────────────────────────>│                      │                    │
    │                           │                      │                    │
    │ Enter "Pre-Workout"       │                      │                    │
    ├──────────────────────────>│                      │                    │
    │                           │                      │                    │
    │                           │ Validate Unique      │                    │
    │                           │ Name                 │                    │
    │                           ├─────────────────────>│                    │
    │                           │                      │ Query Existing     │
    │                           │                      ├───────────────────>│
    │                           │                      │<───────────────────┤
    │                           │<─────────────────────┤                    │
    │                           │                      │                    │
    │                           │ Create Category      │                    │
    │                           ├─────────────────────>│                    │
    │                           │                      │ Add Document       │
    │                           │                      ├───────────────────>│
    │                           │                      │<───────────────────┤
    │                           │<─────────────────────┤                    │
    │                           │                      │                    │
    │<──────────────────────────┤ Success              │                    │
    │ Show Success Message      │                      │                    │
    │                           │                      │                    │
    │                           │ Stream Update        │                    │
    │<──────────────────────────┼──────────────────────┼────────────────────┤
    │ UI Refreshes              │                      │                    │
```

### 2. Dashboard Category Filtering Flow

```
User                    Dashboard Controller      Categories Service      Meals Service
 │                              │                         │                     │
 │ Select Group                 │                         │                     │
 ├─────────────────────────────>│                         │                     │
 │                              │                         │                     │
 │                              │ Load Categories         │                     │
 │                              ├────────────────────────>│                     │
 │                              │<────────────────────────┤                     │
 │                              │ [Breakfast, Lunch, ...] │                     │
 │                              │                         │                     │
 │                              │ Load Meals              │                     │
 │                              ├─────────────────────────┼────────────────────>│
 │                              │<────────────────────────┼─────────────────────┤
 │                              │ [Meal1, Meal2, ...]     │                     │
 │                              │                         │                     │
 │<─────────────────────────────┤ Render Category Tabs    │                     │
 │ Display: [Breakfast|Lunch|..]│                         │                     │
 │                              │                         │                     │
 │ Click "Lunch" Tab            │                         │                     │
 ├─────────────────────────────>│                         │                     │
 │                              │                         │                     │
 │                              │ Filter Meals            │                     │
 │                              │ where categoryIds       │                     │
 │                              │ contains "lunch_id"     │                     │
 │                              │                         │                     │
 │<─────────────────────────────┤ Display Filtered Meals  │                     │
 │ Show only Lunch meals        │                         │                     │
```

### 3. Category Deletion Validation Flow

```
Admin                   Controller              Service              Firestore
  │                         │                      │                    │
  │ Click Delete "Snacks"   │                      │                    │
  ├────────────────────────>│                      │                    │
  │                         │                      │                    │
  │                         │ Check if Default     │                    │
  │                         ├─────────────────────>│                    │
  │                         │<─────────────────────┤                    │
  │                         │ isDefault = false ✓  │                    │
  │                         │                      │                    │
  │                         │ Check Meals          │                    │
  │                         ├─────────────────────>│                    │
  │                         │                      │ Query meals        │
  │                         │                      │ WHERE categoryIds  │
  │                         │                      │ CONTAINS snacks_id │
  │                         │                      ├───────────────────>│
  │                         │                      │<───────────────────┤
  │                         │<─────────────────────┤ Found 3 meals ✗    │
  │                         │                      │                    │
  │<────────────────────────┤ Show Error           │                    │
  │ "Cannot delete - 3      │                      │                    │
  │  meals use this         │                      │                    │
  │  category"              │                      │                    │
```

## Migration Flow

```
App Startup
    │
    ▼
┌─────────────────────────┐
│ User Authenticates      │
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│ MigrationService.       │
│ migrateUserData()       │
└───────────┬─────────────┘
            │
            ├──────────────────────────────────┐
            │                                  │
            ▼                                  ▼
┌─────────────────────────┐      ┌─────────────────────────┐
│ For Each User Group:    │      │ Background Process      │
│                         │      │ (Non-blocking)          │
│ 1. Check if categories  │      └─────────────────────────┘
│    exist                │
│                         │
│ 2. If not, initialize   │
│    default categories   │
│                         │
│ 3. Migrate meals:       │
│    - Read category names│
│    - Lookup category IDs│
│    - Update categoryIds │
│                         │
│ 4. Migrate planner:     │
│    - Read mealSlots     │
│    - Convert name keys  │
│      to ID keys         │
│    - Update document    │
└───────────┬─────────────┘
            │
            ▼
┌─────────────────────────┐
│ App Ready               │
│ (Uses new system)       │
└─────────────────────────┘
```

## Permission Matrix

```
┌──────────────────────┬─────────┬─────────┐
│ Action               │ Admin   │ Member  │
├──────────────────────┼─────────┼─────────┤
│ View Categories      │   ✓     │   ✓     │
│ Create Category      │   ✓     │   ✗     │
│ Rename Category      │   ✓     │   ✗     │
│ Reorder Categories   │   ✓     │   ✗     │
│ Delete Category      │   ✓*    │   ✗     │
│ Assign Meal to Cat   │   ✓     │   ✗     │
└──────────────────────┴─────────┴─────────┘

* Admin can delete only if:
  - Not a default category
  - No meals reference it
  - No planner references it
  - At least 1 other category exists
```
