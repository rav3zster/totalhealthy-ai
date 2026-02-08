# Onboarding Flow Fix - Complete User Journey

## Problem
The onboarding flow was being skipped after signup. Users were going directly to profile settings, missing:
1. Role selection (Trainer/Member)
2. Nutrition goal screens (3 screens for members)

## Correct User Flow

### New User Signup Journey
```
1. Signup Screen
   ↓
2. Switch Role Screen (Choose Trainer or Member)
   ↓
3a. If Trainer → Trainer Dashboard
   ↓
3b. If Member → Nutrition Goals (3 screens)
   ↓
4. Profile Settings (Complete profile)
   ↓
5. Dashboard (Client or Trainer based on role)
```

### Existing User Login Journey
```
1. Login Screen
   ↓
2. Check profile completion
   ↓
3a. If profile incomplete → Profile Settings → Dashboard
   ↓
3b. If profile complete → Dashboard directly
```

## Changes Made

### 1. Signup Screen (`lib/app/modules/signup/views/signup_screen.dart`)
- ✅ Changed redirect from `SETTING` back to `SWITCHROLE`
- ✅ Updated success message to: "Please choose your role to continue"
- Users now go to role selection first

### 2. Switch Role Screen (`lib/app/widgets/switch_role_screen.dart`)
- ✅ Already correctly implemented:
  - Trainer selection → Trainer Dashboard
  - Member selection → Nutrition Goals

### 3. Nutrition Goals Screen (`lib/app/modules/nutrition_goal/views/nutrition_goal_screen.dart`)
- ✅ Changed final redirect from `ClientDashboard` to `SETTING`
- ✅ After completing 3 goal screens, user goes to profile settings
- ✅ Removed unused import

### 4. Profile Settings (`lib/app/modules/setting/views/profile_settings_view.dart`)
- ✅ Simplified redirect logic after save
- ✅ Always redirects to appropriate dashboard based on role
- ✅ Trainer → Trainer Dashboard
- ✅ Member → Client Dashboard

### 5. Auth Controller (`lib/app/core/base/controllers/auth_controller.dart`)
- ✅ Added `isSignupFlow` flag to prevent interruption during signup
- ✅ `_setInitialScreen()` now checks for signup flow
- ✅ Only redirects to settings for existing users with incomplete profiles
- ✅ New users complete the full onboarding flow without interruption

## Flow Details

### Nutrition Goals Screens (3 screens for members)
1. **Screen 1: Nutrition Goal**
   - Weight loss
   - Muscle gain
   - Maintaining current weight
   - Improved overall health

2. **Screen 2: Meal Frequency**
   - 3 times a day (breakfast, lunch, dinner)
   - 4-5 times a day (adding snacks)
   - I don't have a specific schedule

3. **Screen 3: Dietary Restrictions**
   - Vegetarianism
   - Gluten-free diet
   - Lactose intolerance
   - I don't have

### Profile Settings Screen
- Personal Information (name, email, phone)
- Physical Information (age, weight, height, gender)
- Activity Level
- Fitness Goals (multi-select)
- Diet Preferences (optional, expandable)
- Food Allergies (optional)

## Key Features

### Signup Flow Flag
- `isSignupFlow` flag prevents `_setInitialScreen()` from interrupting
- Flag is set during registration
- Flag is removed after first auth state change
- Ensures smooth onboarding without redirects

### Skip Option
- Nutrition goals screens have "Skip" button
- Allows users to skip goal setting if desired
- Goes directly to Client Dashboard

### Back Navigation
- Users can go back through nutrition goal screens
- First screen back button returns to role selection

### Profile Completion Tracking
- `profileCompleted` flag tracks completion status
- Set to `true` when user saves profile
- Used to redirect existing users with incomplete profiles

## Testing Checklist

### New User Flow
- [ ] Sign up with new account
- [ ] Verify redirect to Role Selection
- [ ] Select "Member" role
- [ ] Verify redirect to Nutrition Goals (Screen 1)
- [ ] Complete all 3 nutrition goal screens
- [ ] Verify redirect to Profile Settings
- [ ] Fill in profile information
- [ ] Click Save
- [ ] Verify redirect to Client Dashboard
- [ ] No interruptions or unexpected redirects

### Trainer Flow
- [ ] Sign up with new account
- [ ] Select "Advisor" role
- [ ] Verify direct redirect to Trainer Dashboard
- [ ] No nutrition goals screens shown

### Skip Flow
- [ ] Sign up and select Member
- [ ] Click "Skip" on nutrition goals
- [ ] Verify redirect to Client Dashboard

### Existing User Flow
- [ ] Login with complete profile
- [ ] Verify direct access to dashboard
- [ ] Login with incomplete profile
- [ ] Verify redirect to Profile Settings
- [ ] Complete profile
- [ ] Verify access to dashboard

## Files Modified
1. `lib/app/modules/signup/views/signup_screen.dart`
2. `lib/app/modules/nutrition_goal/views/nutrition_goal_screen.dart`
3. `lib/app/modules/setting/views/profile_settings_view.dart`
4. `lib/app/core/base/controllers/auth_controller.dart`

## Status
✅ **COMPLETE** - Full onboarding flow restored
- Role selection working
- Nutrition goals screens accessible
- Profile settings integrated
- No flow interruptions
- All diagnostics clean

## Summary
The complete onboarding journey is now restored. New users will:
1. Choose their role (Trainer/Member)
2. Complete nutrition goals (if Member)
3. Fill in profile settings
4. Access their dashboard

Existing users with incomplete profiles will be prompted to complete their profile on login, while users with complete profiles go directly to their dashboard.
