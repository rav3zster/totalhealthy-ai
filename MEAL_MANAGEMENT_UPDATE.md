# Meal Management Enhancements

## Features Added

1. **Delete Meal Button**
   - Added a dedicated "Delete" button to each meal card in the Client Dashboard.
   - Preserves the existing long-press functionality but improves discoverability.
   - Uses the existing confirmation dialog and deletes the meal from Firebase Firestore.

2. **Edit Meal Functionality**
   - Added an "Edit" button to each meal card.
   - **Navigation**: Tapping "Edit" navigates to the Create Meal screen, passing the existing meal data.
   - **Pre-population**: The Create Meal form (Name, Description, Calories, Macros, Ingredients, Image, Categories) is automatically filled with the meal's data.
   - **Update Logic**: The submit action now detects if it's an edit or a new creation.
     - **Create**: Adds a new document to Firestore.
     - **Update**: Updates the specific existing document in Firestore using its ID.
     - **UI Updates**: Header title changes to "Edit Meal" and button changes to "Update Meal" when editing.

## Technical Implementation

### `lib/app/modules/client_dashboard/views/client_dashboard_views.dart`
- Modified `_buildModernMealCard` to include a row of Action Buttons (Edit/Delete) below the nutritional info.
- The "Edit" button passes the `MealModel` object as arguments to the named route.

### `lib/app/modules/create_meal/controllers/create_meal_controller.dart`
- Added `isEditing` state and `editingMealId`.
- Added `populateForEdit(MealModel meal)` to fill all `TextEditingController`s and `Rx` variables from the meal model.
- Updated `submitUser` to handle the update scenario:
  - If `isEditing` is true, calls `_mealsService.updateMeal(meal)` instead of `addMeal`.
  - Preserves the original meal ID.

### `lib/app/modules/create_meal/views/create_meal_page.dart`
- In `initState`, checks for `MealModel` in `Get.arguments` and calls `controller.populateForEdit`.
- Updated Header Title and Submit Button Text to be dynamic based on `controller.isEditing`.

## Verification
- **Delete**: Tap "Delete" -> Confirm Dialog -> Meal removed from list and Firestore.
- **Edit**: Tap "Edit" -> Form opens with data -> Change value -> Tap "Update Meal" -> Success Snackbar -> Meal updated in list and Firestore.
