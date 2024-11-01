import 'package:get/get.dart';

import '../core/middlewares/global_middleware.dart';
import '../modules/Onboarding_Screen/Onboarding_view.dart';
import '../modules/client_dashboard/bindings/client_dashboard_bindings.dart';
import '../modules/client_dashboard/views/client_dashboard_views.dart';
import '../modules/create_meal/bindings/create_meal_binding.dart';
import '../modules/create_meal/views/create_meal_view.dart';
import '../modules/empty_data_screen/bindings/empty_data_screen_bindings.dart';
import '../modules/empty_data_screen/views/empty_data_screen_views.dart';
import '../modules/forget_passowrd_screen/bindings/forget_passowrd_screen_bindings.dart';
import '../modules/forget_passowrd_screen/views/forget_password_screen_views.dart';
import '../modules/generate_ai/bindings/generate_ai_binding.dart';
import '../modules/generate_ai/views/generate_ai_view.dart';
import '../modules/group/bindings/group_binding.dart';
import '../modules/group/views/group_view.dart';
import '../modules/home/bindings/home_binding.dart';
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

import '../modules/swipe_screen/bindings/swipe_screen_bindings.dart';
import '../modules/swipe_screen/views/swipe_screen_views.dart';
import '../modules/welcom_screen/bindings/welcome-screen-bindings.dart';
import '../modules/welcom_screen/views/welcome-screen-views.dart';
import '../modules/trainer_dashboard/bindings/trainer_dashboard_bindings.dart';
import '../modules/trainer_dashboard/views/trainer_dashboard_views.dart';
import '../modules/user_diet_screen/bindings/user_diet_screen_bindings.dart';
import '../modules/user_diet_screen/views/user_diet_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.MEAL_TIMING;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => OnboardingView(),
      binding: HomeBinding(),
    ),
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
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.NUTRITION_GOAL,
      page: () => NutritionGoalView(),
      binding: NutritionGoalBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.GENERATE_AI,
      page: () => GenerateAiView(),
      binding: GenerateAiBinding(),
    ),
    GetPage(
      name: _Paths.MEAL_HISTORY,
      page: () => MealHistoryView(),
      binding: MealHistoryBinding(),
    ),
    GetPage(
      name: _Paths.MEALS_DETAILS,
      page: () => MealsDetailsView(),
      binding: MealsDetailsBinding(),
    ),
    GetPage(
      name: _Paths.MEAL_TIMING,
      page: () => MealTimingView(),
      binding: MealTimingBinding(),
    ),
    GetPage(
      name: _Paths.TrainerDashboard,
      page: () => TrainerDashboardView(),
      binding: TrainerDashboardBindings(),
    ),
    GetPage(
      name: _Paths.UserDiet,
      page: () => UserDietScreen(),
      binding: UserDietScreenBindings(),
    ),
    GetPage(
      name: _Paths.EmptyScreen,
      page: () => EmptyScreenView(),
      binding: EmptyScreenBindings(),
    ),
    GetPage(
      name: _Paths.ClientDashboard,
      page: () => ClientDashboardScreen(),
      binding: ClientDashboardBindings(),
    ),
    GetPage(
      name: _Paths.FORGETPASSWORD,
      binding: ForgetPasswordScreenBindings(),
      page: () => ForgetPasswordScreenViews(),
    ),
    GetPage(
        name: _Paths.CreateMeal,
        binding: CreateMealBinding(),
        page: () => CreateMealScreen(),
        middlewares: [AuthCheckMiddleware()]),
    GetPage(
        name: _Paths.GROUP,
        page: () => GroupView(),
        binding: GroupBinding(),
        middlewares: [AuthCheckMiddleware()]),
  ];
}
