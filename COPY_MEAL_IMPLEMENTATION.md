# Copy Meal Functionality Setup

## Feature Overview
Implemented "Copy From Existing" meal functionality. This allows users to browse their entire meal history/library and create a new meal based on an existing one.

## Changes

### 1. `lib/app/modules/create_meal/controllers/create_meal_controller.dart`
- Added `populateForCopy(MealModel meal)`:
  - Populates the form fields with data from the source meal.
  - Sets `isEditing = false` and `editingMealId = null` to ensure a **new** meal is created upon submission.
  - Appends "(Copy)" to the meal name for clarity.

### 2. `lib/app/modules/create_meal/views/create_meal_page.dart`
- Updated `initState` to handle a new argument structure: `{'mode': 'copy', 'meal': meal}`.
- If this argument is present, it triggers `controller.populateForCopy`.

### 3. `lib/app/modules/meal_history/controllers/meal_history_controller.dart`
- Rewrote the controller to:
  - Fetch all meals from `MealsFirestoreService`.
  - Implement reactive state for `meals`, `filteredMeals`, and `searchQuery`.
  - Handle search filtering logic.

### 4. `lib/app/modules/meal_history/views/meal_history_page.dart`
- Completely redesigned this page to be a "Select Meal to Copy" screen.
- **UI Details**:
  - Search Bar for filtering meals (Corrected usage of `SimpleRealTimeSearchBar`).
  - List of modern meal cards (Image, Name, Macros).
  - "Copy to New Meal" button on each card.
  - Navigates to `CreateMeal` route with copy mode.
- **Fixes**:
  - Correctly passes `searchQuery` (RxString) to SearchBar.
  - Handles non-nullable `prepTime` with `isEmpty` check.

### 5. `lib/app/modules/meal_history/views/meal_history_screen.dart`
- Simplified to remove unused `id` parameter.
- **Fix**: Removed invalid `controller` argument from `MealHistoryPage` instantiation.

## Usage
1. User taps "Copy From Existing" (mapped to `Routes.MEAL_HISTORY`).
2. User sees a list of all their meals.
3. User selects "Copy to New Meal" on a desired meal.
4. "Create Meal" screen opens with data pre-filled.
5. User can edit details and save as a new meal.
