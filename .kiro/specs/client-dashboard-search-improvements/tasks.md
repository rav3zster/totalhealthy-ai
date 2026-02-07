# Implementation Plan: Client Dashboard Search Improvements

## Overview

This implementation plan breaks down the client dashboard improvements into discrete, testable steps. The changes focus on three main areas: removing the notification button, fixing the search logic to operate on the master meal list, and implementing conditional visibility for category buttons. Each task builds incrementally to ensure the feature works correctly at every step.

## Tasks

- [-] 1. Remove notification button from DynamicProfileHeader
  - Open `lib/app/widgets/dynamic_profile_header.dart`
  - Remove the notification button IconButton widget and its container from the `_buildProfileHeader` method
  - Keep the `onNotificationTap` parameter in the constructor for backward compatibility (mark as deprecated)
  - Update the Row widget to remove the trailing notification button
  - Ensure the header layout adjusts correctly without empty spacing
  - _Requirements: 1.1, 1.2_

- [ ] 1.1 Write unit tests for DynamicProfileHeader changes
  - Test that notification button widget is not rendered in the widget tree
  - Test that header layout is correct without notification button
  - Test that profile tap callback still works
  - _Requirements: 1.1, 1.2_

- [x] 2. Update ClientDashboardScreen to remove notification callback
  - Open `lib/app/modules/client_dashboard/views/client_dashboard_views.dart`
  - Remove the `onNotificationTap` parameter from the DynamicProfileHeader widget instantiation
  - Verify notification access still works via bottom navigation bar
  - _Requirements: 1.3, 1.4_

- [ ] 3. Fix search filtering logic in ClientDashboardControllers
  - [x] 3.1 Modify the `filteredMeals` getter to check search state first
    - Open `lib/app/modules/client_dashboard/controllers/client_dashboard_controllers.dart`
    - Rewrite the `filteredMeals` getter to check if `searchQuery.value.isNotEmpty` FIRST
    - If search is active: filter meals from the master `meals` list using search criteria (ignore category)
    - If search is empty: filter meals by `selectedCategory` as before
    - Ensure search matches on: name, kcal, protein, fat, carbs, and categories (all case-insensitive)
    - _Requirements: 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8_

  - [ ] 3.2 Write unit tests for search logic
    - Test that search with empty query returns category-filtered meals
    - Test that search with query returns meals from ALL categories
    - Test that search matches meal name (case-insensitive)
    - Test that search matches kcal, protein, fat, carbs fields
    - Test that search matches category names
    - Test that clearing search restores category filter
    - _Requirements: 2.1, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8_

  - [ ] 3.3 Write property test for search operates on master list
    - **Property 1: Search operates on master meal list**
    - Generate random meal lists with meals in different categories
    - Generate random search queries
    - Verify search results include meals from ALL categories matching the query
    - Run 100+ iterations
    - **Validates: Requirements 2.1**

  - [ ] 3.4 Write property test for category filter when search is empty
    - **Property 2: Category filter applies only when search is empty**
    - Generate random meal lists
    - Set search query to empty
    - Select random category
    - Verify all returned meals belong to selected category
    - Run 100+ iterations
    - **Validates: Requirements 2.1, 5.1, 5.3**

- [-] 4. Add shouldShowCategoryButtons computed property
  - Open `lib/app/modules/client_dashboard/controllers/client_dashboard_controllers.dart`
  - Add a new getter: `bool get shouldShowCategoryButtons => searchQuery.value.isEmpty;`
  - This property will control category button visibility in the view
  - _Requirements: 3.1, 3.2, 3.3_

- [ ] 4.1 Write unit tests for shouldShowCategoryButtons
  - Test that shouldShowCategoryButtons returns true when search is empty
  - Test that shouldShowCategoryButtons returns false when search has text
  - _Requirements: 3.1, 3.2_

- [ ] 4.2 Write property test for category button visibility
  - **Property 3: Category buttons visibility is inverse of search state**
  - Generate random search query states (empty and non-empty)
  - Verify shouldShowCategoryButtons == searchQuery.isEmpty
  - Run 100+ iterations
  - **Validates: Requirements 3.1, 3.2, 3.3**

- [x] 5. Implement conditional category button visibility in view
  - Open `lib/app/modules/client_dashboard/views/client_dashboard_views.dart`
  - Locate the category buttons Row widget (around line 140)
  - Wrap the category buttons Row in an Obx widget for reactivity
  - Add conditional logic: if `controller.shouldShowCategoryButtons` show buttons, else return `SizedBox.shrink()`
  - Ensure proper spacing is maintained when buttons are hidden
  - _Requirements: 3.1, 3.2, 3.3_

- [ ] 5.1 Write widget tests for category button visibility
  - Test that category buttons are visible when search is empty
  - Test that category buttons are hidden when search has text
  - Test that category buttons reappear when search is cleared
  - _Requirements: 3.1, 3.2, 3.3_

- [ ] 6. Checkpoint - Manual testing of core functionality
  - Ensure all tests pass, ask the user if questions arise
  - Manually verify:
    - Notification button is removed from header
    - Search works in real-time as user types
    - Search finds meals from all categories
    - Category buttons hide when typing in search
    - Category buttons show when search is empty
    - "No meals found" displays correctly
    - Clear search button works

- [ ] 7. Write property test for case-insensitive search
  - **Property 4: Search matches are case-insensitive**
  - Generate random meals with random case in name
  - Generate search query with different case
  - Verify meal is found regardless of case differences
  - Run 100+ iterations
  - **Validates: Requirements 2.3**

- [ ] 8. Write property test for clearing search
  - **Property 5: Clearing search restores category filter**
  - Generate random meal list
  - Perform random search
  - Clear search
  - Verify results match category filter
  - Run 100+ iterations
  - **Validates: Requirements 5.1, 5.2**

- [ ] 9. Write property test for multi-field search
  - **Property 6: Search matches multiple fields**
  - Generate random meals with random values in all searchable fields
  - For each field (name, kcal, protein, fat, carbs, categories), generate query matching that field
  - Verify meal is found when query matches ANY field
  - Run 100+ iterations
  - **Validates: Requirements 2.3, 2.4, 2.5, 2.6, 2.7, 2.8**

- [ ] 10. Write integration tests
  - Test complete user flow: open dashboard → type search → verify results → clear search → verify category view
  - Test complete user flow: open dashboard → select category → type search → verify search ignores category
  - Test notification access via bottom navigation bar
  - _Requirements: 1.3, 1.4, 2.1, 3.1, 3.2, 5.1_

- [ ] 11. Final checkpoint and platform verification
  - Ensure all tests pass, ask the user if questions arise
  - Verify functionality on web platform
  - Verify functionality on mobile platform
  - Confirm no Firebase schema changes were made
  - Confirm UI theme and colors are unchanged
  - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5, 6.6_

## Notes

- All tasks are required for comprehensive implementation
- Each task references specific requirements for traceability
- The search logic fix (task 3.1) is the most critical change
- Category button visibility (task 5) depends on the computed property from task 4
- Checkpoints ensure incremental validation at key milestones
- Property tests validate universal correctness properties with 100+ iterations
- Unit tests validate specific examples and edge cases
- Integration tests verify end-to-end user flows
