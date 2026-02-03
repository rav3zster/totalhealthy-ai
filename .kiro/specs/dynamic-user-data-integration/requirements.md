# Dynamic User Data Integration - Requirements

## Overview
Transform the Flutter app to dynamically fetch and display authenticated user data from Firebase (Firebase Auth + Firestore) with real-time updates across all UI components. Replace hardcoded values with dynamic data that automatically reflects user progress and statistics.

## User Stories

### 1. Authenticated User Profile Display
**As a user**, I want to see my actual profile information (name, email, profile image) displayed consistently across the app header and profile sections, so that I can verify I'm logged into the correct account.

**Acceptance Criteria:**
- 1.1 User profile data is fetched from Firestore using the authenticated user's UID
- 1.2 Profile information displays in the dashboard header (name, profile image)
- 1.3 Profile information displays in the profile screen (name, email, profile image, stats)
- 1.4 Profile data updates in real-time when changed in Firestore
- 1.5 Fallback to default values when profile data is unavailable
- 1.6 Loading states are shown while fetching profile data

### 2. Dynamic Live Stats Calculation
**As a user**, I want to see my actual progress statistics (Goal Achieved %, Fat Lost, Muscle Gained) calculated from my real data, so that I can track my fitness journey accurately.

**Acceptance Criteria:**
- 2.1 Goal Achieved % is calculated based on user's selected goal and current progress
- 2.2 Fat Lost is calculated from initial weight vs current weight for weight loss goals
- 2.3 Muscle Gained is calculated from historical data and goal type
- 2.4 Stats update automatically when user data or meal logs change
- 2.5 Different calculations apply based on user's primary goal (weight loss, muscle gain, maintenance)
- 2.6 Stats display "0" or appropriate default when insufficient data exists

### 3. Dynamic Day Counter
**As a user**, I want to see my actual day count since starting my fitness journey, so that I can track how long I've been following my plan.

**Acceptance Criteria:**
- 3.1 Day counter starts from user's account creation date (joinDate)
- 3.2 Current day is calculated as the difference between today and joinDate + 1
- 3.3 Day counter displays in format "Day X/Y" where Y is the goal duration
- 3.4 Goal duration is fetched from user's profile data
- 3.5 Date range is calculated and displayed (start date - end date)
- 3.6 Counter updates automatically at midnight

### 4. Real-time Search Functionality
**As a user**, I want to search through my meals in real-time as I type, so that I can quickly find specific meals.

**Acceptance Criteria:**
- 4.1 Search bar filters meals based on meal name as user types
- 4.2 Search is case-insensitive and supports partial matches
- 4.3 Meal list updates immediately without delay
- 4.4 Empty state is shown when no meals match the search query
- 4.5 Search works across all meal categories (Breakfast, Lunch, Dinner)
- 4.6 Search input can be cleared to show all meals again

### 5. Firebase Integration & Real-time Updates
**As a developer**, I want to implement proper Firebase Auth and Firestore integration, so that user data stays synchronized across the app.

**Acceptance Criteria:**
- 5.1 User authentication state is properly managed with Firebase Auth
- 5.2 Firestore streams are used for real-time data updates
- 5.3 User profile data is stored and retrieved from Firestore
- 5.4 Meal data is properly linked to authenticated users
- 5.5 Error handling for network issues and authentication failures
- 5.6 Offline support with cached data when possible

### 6. State Management & UI Responsiveness
**As a user**, I want the app to respond smoothly to data changes without freezing or showing stale information.

**Acceptance Criteria:**
- 6.1 Loading states are shown during data fetching
- 6.2 Error states are handled gracefully with user-friendly messages
- 6.3 Empty states are displayed when no data is available
- 6.4 UI updates smoothly without flickering or jumping
- 6.5 State management ensures data consistency across screens
- 6.6 Memory usage is optimized for real-time streams

## Technical Requirements

### Data Models
- UserModel must include all necessary fields for calculations (joinDate, initialWeight, targetWeight, goals, etc.)
- MealModel must support user-specific filtering and searching
- Models must support real-time updates from Firestore

### Services
- UsersFirestoreService must provide real-time user data streams
- MealsFirestoreService must support user-specific meal filtering
- Authentication service must handle user state changes

### Controllers
- Profile controller must manage user data streams
- Dashboard controller must handle live stats calculations
- Search controller must manage real-time filtering

### UI Components
- Profile header component for consistent user display
- Live stats component with dynamic calculations
- Search bar component with real-time filtering
- Loading, error, and empty state components

## Performance Requirements
- Initial data load should complete within 3 seconds
- Search filtering should respond within 100ms
- Real-time updates should reflect within 2 seconds
- App should remain responsive during data operations

## Security Requirements
- User data access must be restricted to authenticated users only
- Firestore security rules must prevent unauthorized access
- User profile data must be validated before storage
- Sensitive information must not be logged or exposed

## Compatibility Requirements
- Support for offline mode with cached data
- Compatible with existing GetX state management
- Maintains current UI/UX design patterns
- Works across all supported platforms (iOS, Android, Web)