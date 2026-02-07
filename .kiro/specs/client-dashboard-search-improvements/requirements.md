# Requirements Document

## Introduction

This specification defines the requirements for improving the Client Dashboard screen in a Flutter meal tracking application. The improvements focus on three main areas: removing the notification button from the header, fixing the non-functional meal search feature, and implementing proper category button visibility logic based on search state.

The current implementation has a critical bug where the search filters meals that have already been filtered by category, resulting in incomplete search results. Additionally, the category buttons remain visible during search, which creates a confusing user experience. These issues must be resolved to provide users with a functional and intuitive meal search experience.

## Glossary

- **Client_Dashboard**: The home screen view that displays user profile, stats, and meal lists
- **Meal_Search**: The search functionality that filters meals based on user input
- **Category_Buttons**: UI buttons for filtering meals by meal type (Breakfast, Lunch, Dinner)
- **Master_Meal_List**: The complete unfiltered list of all user meals from Firebase
- **Filtered_Meal_List**: The list of meals after applying category and/or search filters
- **Search_Field**: The text input widget where users type search queries
- **Notification_Button**: The bell icon button in the top-right corner of the profile header
- **Empty_State**: UI displayed when no meals match the current filters or search query
- **Real_Time_Search**: Search that filters results immediately as the user types

## Requirements

### Requirement 1: Remove Notification Button

**User Story:** As a user, I want the notification button removed from the Client Dashboard header, so that the interface is cleaner and I can access notifications through the bottom navigation bar.

#### Acceptance Criteria

1. THE Client_Dashboard SHALL NOT display the notification button in the DynamicProfileHeader widget
2. WHEN the notification button is removed, THE Client_Dashboard SHALL NOT leave empty spacing or placeholder elements in the header
3. THE Notification_Screen SHALL remain accessible through the bottom navigation bar
4. WHEN a user navigates to the Notification screen via bottom navigation, THE System SHALL function identically to the previous notification button behavior

### Requirement 2: Fix Meal Search Functionality

**User Story:** As a user, I want to search for meals across all my meals regardless of category, so that I can quickly find any meal by name, nutritional content, or category.

#### Acceptance Criteria

1. WHEN a user types in the Search_Field, THE Meal_Search SHALL filter meals from the Master_Meal_List, not from an already category-filtered list
2. WHEN a user types in the Search_Field, THE Meal_Search SHALL update the Filtered_Meal_List in real-time without requiring user action
3. THE Meal_Search SHALL match meals based on meal name (case-insensitive partial match)
4. THE Meal_Search SHALL match meals based on calorie values (kcal field)
5. THE Meal_Search SHALL match meals based on protein content
6. THE Meal_Search SHALL match meals based on fat content
7. THE Meal_Search SHALL match meals based on carbohydrate content
8. THE Meal_Search SHALL match meals based on meal category (Breakfast, Lunch, Dinner)
9. THE Meal_Search SHALL NOT execute Firebase queries during search operations
10. THE Meal_Search SHALL perform all filtering operations locally on cached meal data

### Requirement 3: Category Button Visibility Logic

**User Story:** As a user, I want category buttons to hide when I'm searching, so that I understand the search applies to all meals and the interface is less cluttered.

#### Acceptance Criteria

1. WHEN the Search_Field is empty, THE Client_Dashboard SHALL display all Category_Buttons
2. WHEN a user types any character in the Search_Field, THE Client_Dashboard SHALL hide all Category_Buttons completely
3. WHEN the Search_Field is cleared, THE Client_Dashboard SHALL restore the Category_Buttons to visible state
4. WHEN Category_Buttons are hidden, THE Meal_Search SHALL search across all meal categories simultaneously

### Requirement 4: Search Results User Experience

**User Story:** As a user, I want clear feedback when my search returns results or finds nothing, so that I understand whether meals exist matching my query.

#### Acceptance Criteria

1. WHEN the Meal_Search finds matching meals, THE Client_Dashboard SHALL display the Filtered_Meal_List immediately
2. WHEN the Meal_Search finds no matching meals, THE Client_Dashboard SHALL display an Empty_State message "No meals found"
3. THE Empty_State SHALL replace the meal list display area, not overlap it
4. THE Empty_State SHALL include a visual icon indicating no results
5. THE Empty_State SHALL include a "Clear Search" button that resets the Search_Field
6. WHEN a user clicks the "Clear Search" button in the Empty_State, THE System SHALL clear the Search_Field and restore the full meal list

### Requirement 5: Search Clearing Behavior

**User Story:** As a user, I want to easily clear my search and return to the categorized meal view, so that I can browse meals by meal type again.

#### Acceptance Criteria

1. WHEN a user clears the Search_Field, THE Client_Dashboard SHALL restore the full Master_Meal_List filtered by the currently selected category
2. WHEN a user clears the Search_Field, THE Client_Dashboard SHALL restore the Category_Buttons to visible state
3. WHEN a user clears the Search_Field, THE System SHALL maintain the previously selected category filter
4. THE System SHALL provide a clear affordance (X button or similar) within the Search_Field for clearing search text

### Requirement 6: Implementation Constraints

**User Story:** As a developer, I want to implement these changes without modifying the Firebase schema or existing UI theme, so that the changes are isolated and low-risk.

#### Acceptance Criteria

1. THE System SHALL NOT modify the Firebase database schema
2. THE System SHALL NOT modify the existing color scheme or UI theme
3. THE System SHALL NOT introduce new navigation patterns or screen transitions
4. THE System SHALL NOT require data refresh or page reload for search functionality
5. THE System SHALL maintain compatibility with both web and mobile platforms
6. THE System SHALL maintain the existing meal card design and layout
