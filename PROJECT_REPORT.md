# TotalHealthy — Project Report
**Date:** April 17, 2026
**Version:** 1.0.0+1
**Branch:** main
**Flutter SDK:** ^3.10.0

---

## 1. Project Overview

TotalHealthy is a cross-platform Flutter mobile application for personalized nutrition and meal planning. It serves two user roles — **clients** (end users) and **trainers/advisors** — and integrates AI-powered meal generation via a Flask backend deployed on Render.

---

## 2. Tech Stack

| Layer | Technology |
|---|---|
| Mobile Framework | Flutter (Dart) |
| State Management | GetX |
| Navigation | GetX routing with middleware |
| Auth & Database | Firebase Auth + Cloud Firestore |
| File Storage | Firebase Storage |
| Push Notifications | Firebase Cloud Messaging (FCM) + flutter_local_notifications |
| AI Backend | Flask + OpenRouter (arcee-ai/trinity-mini:free) |
| Backend Hosting | Render (free tier) |
| Local Storage | GetStorage + SharedPreferences |
| HTTP Client | http ^1.2.2 |

---

## 3. Architecture

```
lib/
├── main.dart                        # Entry point, Firebase init, auth routing
├── firebase_options.dart
└── app/
    ├── bindings/                    # Global app bindings
    ├── controllers/                 # Shared controllers (UserController)
    ├── core/
    │   ├── base/                    # AuthController, middlewares, constants
    │   ├── models/                  # Reminder models
    │   ├── services/                # NotificationService, ReminderStorageService
    │   ├── theme/                   # AppTheme, ThemeHelper, PageTransitions
    │   └── translations/            # i18n (AppTranslations)
    ├── data/
    │   ├── models/                  # MealModel, UserModel, GroupModel, etc.
    │   └── services/                # Firestore services (meals, groups, users)
    ├── modules/                     # 30 feature modules (MVC per module)
    ├── routes/                      # app_pages.dart + app_routes.dart
    ├── services/                    # AiService (HTTP client for Flask)
    └── widgets/                     # Shared UI components
```

Pattern: each module follows `bindings/ controllers/ views/` structure.

---

## 4. Feature Modules (30 total)

### Authentication & Onboarding
| Module | Description |
|---|---|
| `Onboarding_Screen` | 3-page intro carousel |
| `swipe_screen` | Swipe-based intro |
| `welcom_screen` | Welcome with Login/Signup CTAs |
| `login` | Firebase email/password login |
| `signup` | New user signup with gender selection |
| `registration` | Extended registration flow |
| `Registration_Screen` | Alternative registration screen |
| `forget_passowrd_screen` | Password reset via Firebase |

### Core App
| Module | Description |
|---|---|
| `client_dashboard` | Main client screen — meals, categories, search, group mode |
| `trainer_dashboard` | Advisor/admin dashboard |
| `home` | Home screen |
| `user_diet_screen` | User diet preferences |

### Meal Management
| Module | Description |
|---|---|
| `create_meal` | Manual meal creation with image upload |
| `Create_Screen` | Legacy create screen |
| `meal_history` | Past meals with copy functionality |
| `meals_details` | Detailed meal view |
| `meal_timing` | Set daily meal timing schedules |
| `meal_categories` | Browse meal categories |
| `meal_categories_management` | Manage custom categories |
| `generate_ai` | AI meal generation form |

### Groups & Collaboration
| Module | Description |
|---|---|
| `group` | Group management (create, view, details, members) |
| `group_categories` | Group-specific meal categories |
| `planner` | Meal planning interface |

### User & Settings
| Module | Description |
|---|---|
| `profile` | Profile views (main, member, privacy policy) |
| `setting` | Settings hub (general, profile, notifications, password) |
| `nutrition_goal` | 4-step nutrition goal wizard |
| `notification` | Notification center + reminder scheduling |
| `manage_accounts` | Account management |
| `Help_and_support` | Help & support page |
| `splash` | Splash screen |

---

## 5. Navigation & Routing

All routes are defined in `app_routes.dart` / `app_pages.dart` using GetX.

**Initial route logic:**
```
App Start
├── User authenticated?
│   ├── YES → Check role
│   │   ├── advisor/admin → /trainerdashboard
│   │   └── client/member → /clientdashboard
│   └── NO → /onboarding
```

**Route constants** (all `lowerCamelCase` as of latest update):
`home`, `onboarding`, `swipeScreen`, `welcomeScreen`, `login`, `signup`, `registration`, `clientDashboard`, `trainerDashboard`, `generateAi`, `createMeal`, `mealHistory`, `mealsDetails`, `mealTiming`, `mealCategories`, `mealCategoriesManagement`, `group`, `createGroup`, `groupDetails`, `memberManagement`, `groupCategories`, `groupMealCalendar`, `weeklyMealPlanner`, `planner`, `setting`, `generalSettings`, `profileSettings`, `notificationSettings`, `accountPasswordSettings`, `profileMain`, `nutritionGoal`, `notification`, `switchRole`, `clientList`, `privacyPolicy`, `forgetPassword`, `userDiet`

**Middleware:** `AuthCheckMiddleware` protects all authenticated routes.

---

## 6. Backend (Flask)

**URL:** `https://totalhealthy-ai.onrender.com`
**File:** `flask_backend/app.py`
**Runtime:** Python 3 on Render free tier (cold start ~30s)

### Endpoints

| Method | Route | Description |
|---|---|---|
| GET | `/` | Health check |
| GET | `/test` | Returns static sample meal |
| POST | `/generate_meal` | Main AI meal generation |
| POST | `/classify_diet` | BMI/TDEE calculator + diet type recommendation |
| POST | `/explain_meal` | AI explanation of a meal choice |
| POST | `/scan_food` | Food image analysis (vision AI) |

### AI Models
- Primary: `arcee-ai/trinity-mini:free`
- Fallback: `liquid/lfm-2.5-1.2b-instruct:free`
- Vision (scan_food): `google/gemma-3-4b-it:free`
- Provider: OpenRouter API

### Key Features
- Detailed prompt engineering with hard constraints (goal, cuisine, diet type, allergies, macros)
- Variety seeding to avoid repeated meals across generations
- `previousMeals` parameter to prevent duplicates across sessions
- Truncated JSON recovery — salvages partial AI responses
- Retry logic with model fallback on failure
- Fallback meal returned when all AI calls fail

---

## 7. Firebase Integration

| Service | Usage |
|---|---|
| Firebase Auth | Email/password authentication |
| Cloud Firestore | Users, meals, groups, group_categories collections |
| Firebase Storage | Meal images, profile photos |
| FCM | Push notifications |

**Firestore collections:**
- `users/{uid}` — profile, role, health data, goals
- `meals/` — meal documents linked to userId or groupId
- `groups/` — group data with members array
- `group_categories/` — custom meal categories per group

---

## 8. Key Dependencies

```yaml
get: ^4.7.3                        # State management + routing
firebase_core: ^4.4.0
firebase_auth: ^6.1.4
cloud_firestore: ^6.1.2
firebase_storage: ^13.0.6
flutter_local_notifications: ^20.0.0
get_storage: ^2.1.1
shared_preferences: ^2.3.4
http: ^1.2.2
image_picker: ^1.2.1
intl: ^0.20.2
permission_handler: ^12.0.1
carousel_slider: ^5.1.1
easy_date_timeline: ^2.0.9
flutter_native_splash: ^2.4.7
flutter_launcher_icons: ^0.14.4
```

---

## 9. Code Quality — Current Status

**`flutter analyze` result: ✅ No issues found**

### Fixes Applied (April 17, 2026)

The following lint issues were resolved in this session:

**File naming (`file_names`)**
All files renamed to `lower_case_with_underscores`:
- `Create_binding.dart` → `create_binding.dart`
- `Create_controller.dart` → `create_controller.dart`
- `Create_view.dart` → `create_view.dart`
- `Onboarding_binding.dart` → `onboarding_binding.dart`
- `Onboarding_controller.dart` → `onboarding_controller.dart`
- `Onboarding_view.dart` → `onboarding_view.dart`
- `Registration_binding.dart` → `registration_binding.dart`
- `Registration_controller.dart` → `registration_controller.dart`
- `Registration_view.dart` → `registration_view.dart`
- `helpAndSuportPage.dart` → `help_and_support_page.dart`
- `schduleMealreminders.dart` → `schedule_meal_reminders.dart`
- `welcome-screen-bindings.dart` → `welcome_screen_bindings.dart`
- `welcome-screen-controllers.dart` → `welcome_screen_controllers.dart`
- `welcome-screen-views.dart` → `welcome_screen_views.dart`
- `backButton.dart` → `back_button.dart`
- `baseWidget.dart` → `base_widget.dart`
- `customDrawer.dart` → `custom_drawer.dart`
- `sideMenu.dart` → `side_menu.dart`

**Route constants (`constant_identifier_names`)**
All `Routes.*` and `_Paths.*` constants renamed from `UPPER_CASE` / `PascalCase` to `lowerCamelCase`. Updated across all 20+ files that referenced them.

**Naming conventions**
- `notification_SettingsScreen` → `NotificationSettingsScreen`
- `selected_meal`, `selected_water`, `selected_expercise`, `selected_notification` → camelCase
- `AppPages.INITIAL` → `AppPages.initial`

**Async safety (`use_build_context_synchronously`)**
- `reminder_dialogs.dart` — 9 instances fixed (capture context values before `await`)
- `nutrition_goal_screen.dart` — 1 instance fixed

**Widget issues (`avoid_unnecessary_containers`)**
- `create_view.dart` — 3 unnecessary `Container` wrappers removed
- `onboarding_view.dart` — 4 unnecessary `Container` wrappers removed
- `registration_view.dart` — 1 unnecessary `Container` wrapper removed

**Deprecated API (`deprecated_member_use`)**
- `Matrix4..scale(x, y)` → `Transform.scale(scaleX:, scaleY:)` in `create_view.dart`

**Private type in public API (`library_private_types_in_public_api`)**
- `general_setting_page.dart` — `createState()` return type fixed
- `meal_timing_page.dart` — `createState()` return type fixed
- `notification_setting_page.dart` — `createState()` return type fixed

**TODO stubs removed**
Stub controllers cleaned up: `ForgetPasswordScreenControllers`, `HelpController`, `HomeController`, `MealsDetailsController`, `NutritionGoalController`, `SignupController`, `SwipeScreenController`, `TrainerDashboardControllers`, `UserDietScreenController`, `WelcomeScreenController`

**Broken imports fixed**
- `welcome_screen_bindings.dart` — import updated to `welcome_screen_controllers.dart`
- `welcome_screen_views.dart` — import updated to `welcome_screen_controllers.dart`
- `base_widget.dart` — import updated from `backButton.dart` to `back_button.dart`

---

## 10. Known Limitations

| Area | Issue |
|---|---|
| GCP Cloud Functions | `_gcpUrl` is empty — meal recommendations and nutrition prediction features are disabled |
| Backend cold start | Render free tier has ~30s cold start delay on first request |
| Offline support | App requires internet — no local caching for offline use |
| No tests | Zero unit or widget tests in the project |
| No CI/CD | No automated pipeline configured |
| Duplicate modules | `registration/` and `Registration_Screen/` both exist |
| Error tracking | No Sentry or crash reporting integrated |

---

## 11. Commit History (this session)

| Commit | Description |
|---|---|
| `8a31060` | fix: resolve all lint warnings — file renames, route constants, async gaps, TODO stubs, unnecessary containers, deprecated API |
| `b52bcc3` | fix: remove remaining unnecessary containers and deprecated scale in create_view.dart |
