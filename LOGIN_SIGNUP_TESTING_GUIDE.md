# Login & Signup Testing Guide

## Current Status
✅ App is running on Chrome
✅ User is logged out
✅ Login screen should be visible
✅ No compilation errors

## What to Test

### 1. Login Screen Visual Check
**Expected Appearance:**
- Dark gradient background (black to dark gray)
- Lime green (#C2D86A) animated logo at top with glow effect
- "Welcome to TotalHealthy" title (TotalHealthy in lime green)
- "Sign in to continue your journey" subtitle
- Modern card-style email input field
- Modern card-style password input field with visibility toggle
- "Forgot Password?" link in lime green
- Large "Sign In" button with lime green gradient
- "OR" divider
- "Don't have an account? Sign Up" link at bottom

**Animations to Verify:**
- Logo should fade in smoothly
- Form should slide up from bottom
- All elements should appear with smooth transitions

### 2. Login Functionality Test
**Test Steps:**
1. Try logging in with existing credentials
2. Verify form validation works (empty fields, invalid email)
3. Check password visibility toggle works
4. Verify "Forgot Password" link navigates correctly
5. After successful login, should navigate to correct dashboard based on role
6. Should NOT show Switch Role screen for existing users

### 3. Signup Screen Visual Check
**Access:** Click "Sign Up" link on login screen

**Expected Appearance:**
- Same dark gradient background
- Animated logo with glow
- "Create Your Account" title
- Modern card-style input fields:
  - Full Name
  - Email Address
  - Password (with visibility toggle)
  - Phone Number
- Gender selection cards (optional)
- Large "Create Account" button with lime green gradient
- "Already have an account? Sign In" link

**Animations to Verify:**
- Same smooth fade-in and slide-up animations
- Gender cards should have hover/selection states

### 4. Signup Functionality Test
**Test Steps:**
1. Fill in all required fields
2. Verify form validation works
3. Try creating a new account
4. After successful signup, should navigate to Switch Role screen
5. After selecting role, should navigate to appropriate dashboard

### 5. Navigation Flow Test
**Signup Flow:**
```
Signup → Switch Role → (Nutrition Goals for members) → Dashboard
```

**Login Flow:**
```
Login → Dashboard (direct, no Switch Role)
```

## Expected Behavior

### ✅ Correct Behavior
- Login screen appears when logged out
- Smooth animations on page load
- Form validation prevents invalid submissions
- Loading spinner shows during authentication
- Success/error messages appear as snackbars
- Existing users go directly to dashboard after login
- New users see Switch Role screen after signup

### ❌ Incorrect Behavior
- Screen flickers or shows intermediate pages
- Animations are choppy or don't play
- Form submits with invalid data
- No loading indicator during authentication
- Switch Role appears after login (should only be after signup)
- Multiple navigation calls causing screen jumps

## Quick Test Commands

### Test Login with Existing Account
1. Open browser to the running app
2. Should see new modern login screen
3. Enter credentials and test

### Test Signup Flow
1. Click "Sign Up" link
2. Fill in form
3. Submit and verify navigation

## Troubleshooting

### If Login Screen Doesn't Appear
- Check browser console for errors
- Verify app is running: `flutter run -d chrome`
- Try hot reload: Press 'r' in terminal

### If Animations Don't Play
- Check browser performance
- Verify AnimationController initialization
- Check console for animation errors

### If Navigation Fails
- Check auth controller bootstrap function
- Verify Firestore connection
- Check console for navigation errors

## Browser Testing
Open Chrome and navigate to: `http://localhost:<port>`
(Port number shown in Flutter terminal output)

The new modern login screen should be visible with smooth animations!
