import 'package:get/get.dart';

import '../core/middlewares/global_middleware.dart';
import '../modules/Onboarding_Screen/Onboarding_binding.dart';
import '../modules/Onboarding_Screen/Onboarding_view.dart';
import '../modules/client_dashboard/bindings/client_dashboard_bindings.dart';
import '../modules/client_dashboard/views/client_dashboard_views.dart';
import '../modules/create_meal/bindings/create_meal_binding.dart';
import '../modules/create_meal/views/create_meal_view.dart';
import '../modules/forget_passowrd_screen/bindings/forget_passowrd_screen_bindings.dart';
import '../modules/forget_passowrd_screen/views/forget_password_screen_views.dart';
import '../modules/generate_ai/bindings/generate_ai_binding.dart';
import '../modules/generate_ai/views/generate_ai_view.dart';
import '../modules/group/bindings/group_binding.dart';
import '../modules/group/views/group_view.dart';
import '../modules/group/views/create_group_screen.dart';
import '../modules/group/views/group_details_screen.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/meal_history/bindings/meal_history_binding.dart';
import '../modules/meal_history/views/meal_history_view.dart';
import '../modules/meal_timing/bindings/meal_timing_binding.dart';
import '../modules/meal_timing/views/meal_timing_view.dart';
import '../modules/meals_details/bindings/meals_details_binding.dart';
import '../modules/meals_details/views/meals_details_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/nutrition_goal/bindings/nutrition_goal_binding.dart';
import '../modules/nutrition_goal/views/nutrition_goal_view.dart';
import '../modules/registration/bindings/registration_binding.dart';
import '../modules/registration/views/registration_view.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../modules/setting/views/setting_view.dart';
import '../modules/setting/views/general_settings_view.dart';
import '../modules/setting/views/profile_settings_view.dart';
import '../modules/setting/views/notification_settings_view.dart';
import '../modules/setting/views/account_password_settings_view.dart';
import '../modules/profile/views/profile_main_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/swipe_screen/bindings/swipe_screen_bindings.dart';
import '../modules/swipe_screen/views/swipe_screen_views.dart';
import '../modules/trainer_dashboard/bindings/trainer_dashboard_bindings.dart';
import '../modules/trainer_dashboard/views/trainer_dashboard_views.dart';
import '../modules/user_diet_screen/bindings/user_diet_screen_bindings.dart';
import '../modules/user_diet_screen/views/user_diet_view.dart';
import '../modules/welcom_screen/bindings/welcome-screen-bindings.dart';
import '../modules/welcom_screen/views/welcome-screen-views.dart';
import '../modules/manage_accounts/views/manage_accounts_views.dart';
import '../modules/Help_and_support/views/helpAndSuportPage.dart';
import '../widgets/switch_role_screen.dart';
import '../widgets/base_screen_wrapper.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ONBOARDING;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
      middlewares: [AuthCheckMiddleware()],
    ),
    GetPage(name: _Paths.ONBOARDING, page: () => OnboardingView()),
    GetPage(
      name: _Paths.SwipeScreen,
      page: () => SwipeScreenView(),
      binding: SwipeScreenBindings(),
    ),
    GetPage(
      name: _Paths.WelcomeScreen,
      page: () => WelcomeScreenView(),
      binding: WelcomeScreenBindings(),
    ),
    GetPage(
      name: _Paths.Registration,
      page: () => RegistrationView(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: _Paths.Login,
      page: () => LoginView(),
      transition: Transition.rightToLeft,
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.NUTRITION_GOAL,
      page: () => NutritionGoalView(),
      binding: NutritionGoalBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => NotificationView(),
      binding: NotificationBinding(),
      transition: Transition.fadeIn,
      middlewares: [AuthCheckMiddleware()],
    ),
    GetPage(
      name: _Paths.GENERATE_AI,
      page: () => GenerateAiView(),
      binding: GenerateAiBinding(),
      transition: Transition.fadeIn,
      middlewares: [AuthCheckMiddleware()],
    ),
    GetPage(
      name: _Paths.MEAL_HISTORY,
      page: () => MealHistoryView(),
      binding: MealHistoryBinding(),
      transition: Transition.fadeIn,
      middlewares: [AuthCheckMiddleware()],
    ),
    GetPage(
      name: _Paths.MEALS_DETAILS,
      page: () => MealsDetailsView(),
      binding: MealsDetailsBinding(),
      transition: Transition.fadeIn,
      middlewares: [AuthCheckMiddleware()],
    ),
    GetPage(
      name: _Paths.MEAL_TIMING,
      page: () => MealTimingView(),
      transition: Transition.fadeIn,
      binding: MealTimingBinding(),
      middlewares: [AuthCheckMiddleware()],
    ),
    GetPage(
      name: _Paths.TrainerDashboard,
      page: () => TrainerDashboardView(),
      binding: TrainerDashboardBindings(),
      transition: Transition.fadeIn,
      middlewares: [AuthCheckMiddleware()],
    ),
    GetPage(name: _Paths.SWITCHROLE, page: () => SwitchRoleScreen()),
    GetPage(
      name: _Paths.UserDiet,
      page: () => UserDietView(),
      transition: Transition.fadeIn,
      binding: UserDietScreenBindings(),
      middlewares: [AuthCheckMiddleware()],
    ),
    GetPage(
      name: _Paths.ClientDashboard,
      page: () => ClientDashboardScreen(),
      binding: ClientDashboardBindings(),
      middlewares: <GetMiddleware>[AuthCheckMiddleware()],
    ),
    GetPage(
      name: _Paths.FORGETPASSWORD,
      binding: ForgetPasswordScreenBindings(),
      page: () => ForgetPasswordScreenViews(),
    ),
    GetPage(
      name: _Paths.CreateMeal,
      transition: Transition.fadeIn,
      binding: CreateMealBinding(),
      page: () => CreateMealScreen(),
      middlewares: [AuthCheckMiddleware()],
    ),
    GetPage(
      name: _Paths.GROUP,
      page: () => GroupView(),
      binding: GroupBinding(),
      middlewares: [AuthCheckMiddleware()],
    ),
    GetPage(
      name: _Paths.CREATE_GROUP,
      page: () => CreateGroupScreen(),
      binding: GroupBinding(),
    ),
    GetPage(
      name: _Paths.GROUP_DETAILS,
      page: () => GroupDetailsScreen(),
      binding: GroupBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      transition: Transition.leftToRight,
      page: () => SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => const SettingView(),
      binding: SettingBinding(),
      middlewares: [AuthCheckMiddleware()],
    ),
    GetPage(
      name: _Paths.GENERAL_SETTINGS,
      page: () => const GeneralSettingsView(),
      binding: SettingBinding(),
      middlewares: [AuthCheckMiddleware()],
    ),
    GetPage(
      name: _Paths.PROFILE_SETTINGS,
      page: () => const ProfileSettingsView(),
      binding: SettingBinding(),
      middlewares: [AuthCheckMiddleware()],
    ),
    GetPage(
      name: _Paths.NOTIFICATION_SETTINGS,
      page: () => const NotificationSettingsView(),
      binding: SettingBinding(),
      middlewares: [AuthCheckMiddleware()],
    ),
    GetPage(
      name: _Paths.ACCOUNT_PASSWORD_SETTINGS,
      page: () => const AccountPasswordSettingsView(),
      binding: SettingBinding(),
      middlewares: [AuthCheckMiddleware()],
    ),
    GetPage(
      name: _Paths.PROFILE_MAIN,
      page: () => const ProfileMainView(),
      binding: ProfileBinding(),
      middlewares: [AuthCheckMiddleware()],
    ),
    GetPage(
      name: '/manage-accounts',
      page: () => ManageAccountScreen(),
      middlewares: [AuthCheckMiddleware()],
    ),
    GetPage(
      name: '/help-support',
      page: () => HelpPage(),
      middlewares: [AuthCheckMiddleware()],
    ),
  ];
}
