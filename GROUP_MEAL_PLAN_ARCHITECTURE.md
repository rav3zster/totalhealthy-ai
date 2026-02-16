# Group Meal Plan Data Architecture

## Problem Fixed
**Issue**: Admin could assign meals to group, but members couldn't see those meals.

**Root Cause**: Controller was loading user-specific meals (`getUserMealsStream(userId)`) instead of group meals.

---

## Data Structure

### 1. Meal Plans Storage
```
Firestore Collection: group_meal_plans
Document Structure:
{
  groupId: "group123",
  date: "2026-02-17",  // YYYY-MM-DD format
  breakfastMealId: "meal_abc",
  lunchMealId: "meal_def",
  dinnerMealId: "meal_ghi",
  createdBy: "admin_user_id",
  createdByName: "Admin Name",
  createdAt: "2026-02-16T10:30:00Z",
  updatedAt: "2026-02-16T11:00:00Z"
}
```

### 2. Meals Storage
```
Firestore Collection: meals
Document Structure:
{
  id: "meal_abc",
  groupId: "group123",  // Links meal to group
  userId: "creator_user_id",
  name: "Scrambled Eggs",
  description: "Protein-rich breakfast",
  kcal: "250",
  protein: "20",
  carbs: "5",
  fat: "15",
  categories: ["Breakfast"],  // Used for filtering
  imageUrl: "https://...",
  ingredients: [...],
  instructions: "...",
  createdAt: "2026-02-15T08:00:00Z",
  prepTime: "10 mins",
  difficulty: "Easy"
}
```

---

## Data Loading Logic

### Both Admin and Members Load From:
1. **Meal Plans**: `group_meal_plans` collection filtered by `groupId`
2. **Available Meals**: `meals` collection filtered by `groupId`

### Real-Time Updates
- Uses Firestore `snapshots()` for live data
- Changes by admin instantly visible to members
- No polling or manual refresh needed

---

## Category Filtering

### Meal Slot → Category Mapping
- **Breakfast slot** → Shows only meals with "Breakfast" category
- **Lunch slot** → Shows only meals with "Lunch" category  
- **Dinner slot** → Shows only meals with "Dinner" category

### Implementation
```dart
// In weekly_meal_slot_sheet.dart
final filteredMeals = controller.availableMeals
    .where((meal) => meal.categories.any(
          (cat) => cat.toLowerCase() == categoryFilter.toLowerCase(),
        ))
    .toList();
```

---

## Permission Model

### Admin Permissions
- ✅ View all meal plans
- ✅ Add/edit/delete meals in slots
- ✅ Duplicate days
- ✅ Navigate weeks
- ✅ See nutrition totals

### Member Permissions
- ✅ View all meal plans
- ❌ Cannot add/edit/delete meals
- ❌ Cannot duplicate days
- ✅ Navigate weeks
- ✅ See nutrition totals

### UI Differences
- **Admin**: Shows edit icons, duplicate buttons, tappable slots
- **Member**: Shows "View Only" badge, no edit icons, non-tappable slots

---

## Key Files Modified

### 1. `weekly_meal_planner_controller.dart`
**Changed**: `_loadAvailableMeals()` method
```dart
// BEFORE (Wrong - user-specific)
availableMeals.bindStream(_mealsService.getUserMealsStream(userId));

// AFTER (Correct - group-wide)
availableMeals.bindStream(_mealsService.getMealsStream(groupId!));
```

### 2. `meals_firestore_service.dart`
**Added**: `getMealsByCategory()` method for filtering by meal type

### 3. `weekly_meal_slot_sheet.dart`
**Added**: Category filtering logic to show only relevant meals per slot

### 4. `group_meal_chat_view.dart`
**Changed**: Button now visible to all users (admin sees "Weekly Planner", members see "View Planner")

### 5. `weekly_meal_planner_view.dart`
**Added**: "View Only" indicator badge for members

---

## Firestore Index Required

### Composite Index Needed
```
Collection: group_meal_plans
Fields:
  - groupId (Ascending)
  - date (Ascending)
```

### How to Create
1. Run app and navigate to Weekly Planner
2. Check console for error with Firebase URL
3. Click the URL to auto-create index
4. Wait 2-5 minutes for index to build

---

## Testing Checklist

### Admin Testing
- [ ] Can see "Weekly Planner" button
- [ ] Can add meals to breakfast/lunch/dinner slots
- [ ] Only sees breakfast meals when adding to breakfast slot
- [ ] Only sees lunch meals when adding to lunch slot
- [ ] Only sees dinner meals when adding to dinner slot
- [ ] Can duplicate day to next day
- [ ] Can duplicate day to entire week
- [ ] Can navigate between weeks
- [ ] Sees daily nutrition totals
- [ ] Changes reflect immediately

### Member Testing
- [ ] Can see "View Planner" button
- [ ] Sees "View Only" badge at top
- [ ] Can view all assigned meals
- [ ] Cannot tap meal slots (no bottom sheet)
- [ ] No duplicate day button visible
- [ ] Can navigate between weeks
- [ ] Sees daily nutrition totals
- [ ] Sees admin's changes in real-time

### Cross-Role Testing
- [ ] Admin assigns meal → Member sees it immediately
- [ ] Admin removes meal → Member sees removal immediately
- [ ] Admin duplicates day → Member sees duplicated meals
- [ ] Both see same nutrition totals
- [ ] Both see same week navigation

---

## Data Flow Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    FIRESTORE                            │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Collection: group_meal_plans                          │
│  ├─ Document: {groupId}/{date}                         │
│  │   ├─ breakfastMealId                                │
│  │   ├─ lunchMealId                                    │
│  │   └─ dinnerMealId                                   │
│                                                         │
│  Collection: meals                                      │
│  ├─ Document: {mealId}                                 │
│  │   ├─ groupId (filter key)                           │
│  │   ├─ categories: ["Breakfast"]                      │
│  │   └─ nutrition data                                 │
│                                                         │
└─────────────────────────────────────────────────────────┘
                        ↓ snapshots()
                        ↓ Real-time stream
┌─────────────────────────────────────────────────────────┐
│            WEEKLY MEAL PLANNER CONTROLLER               │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  mealPlans.bindStream(                                 │
│    getGroupMealPlansStream(groupId, start, end)        │
│  )                                                      │
│                                                         │
│  availableMeals.bindStream(                            │
│    getMealsStream(groupId)  ← GROUP-WIDE, NOT USER     │
│  )                                                      │
│                                                         │
└─────────────────────────────────────────────────────────┘
                        ↓
                        ↓ Reactive binding
┌─────────────────────────────────────────────────────────┐
│              WEEKLY MEAL PLANNER VIEW                   │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌─────────────────────────────────────────┐          │
│  │  ADMIN VIEW              MEMBER VIEW     │          │
│  ├─────────────────────────────────────────┤          │
│  │  • Edit icons            • View Only    │          │
│  │  • Tappable slots        • No tapping   │          │
│  │  • Duplicate button      • No duplicate │          │
│  │  • Add meals             • Read only    │          │
│  └─────────────────────────────────────────┘          │
│                                                         │
│  BOTH SEE:                                             │
│  • Same meal plans                                     │
│  • Same nutrition totals                               │
│  • Real-time updates                                   │
│  • Week navigation                                     │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## Summary

✅ **Fixed**: Members can now see meals assigned by admin  
✅ **Fixed**: Category filtering (breakfast/lunch/dinner)  
✅ **Fixed**: Real-time updates for both roles  
✅ **Fixed**: Proper data architecture (group-wide, not user-specific)  
✅ **Maintained**: Admin-only editing permissions  
✅ **Maintained**: Member view-only access  

**Next Step**: Create Firestore composite index when you first run the app.
