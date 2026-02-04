import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/base/controllers/auth_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/drawer_menu.dart';
import '../../../widgets/dynamic_profile_header.dart';
import '../../../widgets/dynamic_live_stats_card.dart';
import '../../../widgets/dynamic_day_counter.dart';
import '../../../widgets/real_time_search_bar.dart';
import '../../../widgets/base_screen_wrapper.dart';
import '../../../data/models/meal_model.dart';
import '../controllers/client_dashboard_controllers.dart';

class ClientDashboardScreen extends StatelessWidget {
  const ClientDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String id = Get.parameters["id"] ?? "";
    final controller = Get.find<ClientDashboardControllers>();

    return BaseScreenWrapper(
      requiresAuth: true,
      drawer: DrawerMenu(),
      bottomNavigationBar: _buildBottomNavigationBar(id),
      child: RefreshIndicator(
        onRefresh: () async {
          final controller = Get.find<ClientDashboardControllers>();
          await controller.refreshMeals();
        },
        color: AppTheme.primaryBase,
        backgroundColor: AppTheme.surfaceDark,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dynamic Profile Header
                  DynamicProfileHeader(
                    onProfileTap: () => Get.toNamed('/profile-settings'),
                    onNotificationTap: () =>
                        Get.toNamed('/notification?id=$id'),
                  ),

                  const SizedBox(height: AppTheme.spacingL),

                  // Dynamic Live Stats Card
                  const DynamicLiveStatsCard(),

                  const SizedBox(height: AppTheme.spacingL),

                  // Real-time Search Bar
                  SimpleRealTimeSearchBar(
                    searchQuery: controller.searchQuery,
                    onSearchChanged: controller.updateSearchQuery,
                    hintText: 'Search meals...',
                  ),

                  const SizedBox(height: AppTheme.spacingL),

                  // Dynamic Day Counter with Add Meal Button
                  DynamicDayCounter(
                    onAddMealTap: () {
                      final userData = Get.find<AuthController>().userdataget();
                      Get.toNamed(
                        "${Routes.CreateMeal}?id=${userData["_id"] ?? ""}",
                      );
                    },
                  ),

                  const SizedBox(height: AppTheme.spacingL),

                  // Meal Type Tabs
                  Obx(
                    () => Row(
                      children: [
                        _buildMealTab(
                          '🍳',
                          'Breakfast',
                          controller.selectedCategory.value == 'Breakfast',
                          () => controller.changeCategory('Breakfast'),
                        ),
                        const SizedBox(width: AppTheme.spacingM),
                        _buildMealTab(
                          '🥗',
                          'Lunch',
                          controller.selectedCategory.value == 'Lunch',
                          () => controller.changeCategory('Lunch'),
                        ),
                        const SizedBox(width: AppTheme.spacingM),
                        _buildMealTab(
                          '🍽️',
                          'Dinner',
                          controller.selectedCategory.value == 'Dinner',
                          () => controller.changeCategory('Dinner'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppTheme.spacingL),

                  // Meals List - Simplified for now
                  GetBuilder<ClientDashboardControllers>(
                    builder: (controller) {
                      if (controller.shouldShowLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryBase,
                          ),
                        );
                      }

                      if (controller.shouldShowError) {
                        return Container(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                controller.error.value,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }

                      final meals = controller.displayMeals;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: meals.length,
                        itemBuilder: (context, index) {
                          final meal = meals[index];
                          return Container(
                            margin: const EdgeInsets.only(
                              bottom: AppTheme.spacingM,
                            ),
                            decoration: AppTheme.cardDecoration,
                            child: ListTile(
                              leading: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: AppTheme.primaryGradient,
                                  borderRadius: BorderRadius.circular(
                                    AppTheme.radiusM,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.restaurant,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              title: Text(meal.name, style: AppTheme.bodyLarge),
                              subtitle: Text(
                                '${meal.kcal} Kcal',
                                style: AppTheme.bodyMedium,
                              ),
                              onTap: () {
                                final box = GetStorage();
                                box.write("mealdetails", meal.toJson());
                                Get.toNamed(
                                  '/meals-details?id=${Get.find<AuthController>().userdataget()["_id"] ?? ""}',
                                );
                              },
                              onLongPress: () => _showDeleteMealDialog(
                                context,
                                meal,
                                controller,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(String id) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.subtleGradient,
        border: Border(
          top: BorderSide(
            color: AppTheme.primaryBase.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingM,
            vertical: AppTheme.spacingS,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.person, 'Member', true, () {}),
              _buildNavItem(
                Icons.group,
                'Group',
                false,
                () => Get.toNamed(Routes.GROUP),
              ),
              _buildNavItem(
                Icons.notifications,
                'Notification',
                false,
                () => Get.toNamed('/notification?id=$id'),
              ),
              _buildNavItem(
                Icons.person,
                'Profile',
                false,
                () => Get.toNamed(Routes.PROFILE_MAIN),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingS),
            decoration: isActive
                ? BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  )
                : null,
            child: Icon(
              icon,
              color: isActive ? AppTheme.textPrimary : AppTheme.textTertiary,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTheme.caption.copyWith(
              color: isActive ? AppTheme.primaryLight : AppTheme.textTertiary,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealTab(
    String emoji,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingS,
        ),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
          border: isSelected
              ? null
              : Border.all(color: AppTheme.textTertiary.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTheme.bodyMedium.copyWith(
                color: isSelected
                    ? AppTheme.textPrimary
                    : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteMealDialog(
    BuildContext context,
    MealModel meal,
    ClientDashboardControllers controller,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
          ),
          title: Text('Delete Meal', style: AppTheme.headingSmall),
          content: Text(
            'Are you sure you want to delete "${meal.name}"? This action cannot be undone.',
            style: AppTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.error.withValues(alpha: 0.8),
                    AppTheme.error,
                  ],
                ),
                borderRadius: BorderRadius.circular(AppTheme.radiusS),
              ),
              child: TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  // Show loading indicator
                  Get.dialog(
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(AppTheme.spacingL),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(AppTheme.radiusM),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(
                              color: AppTheme.primaryBase,
                            ),
                            const SizedBox(height: AppTheme.spacingM),
                            Text(
                              'Deleting meal...',
                              style: AppTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    barrierDismissible: false,
                  );

                  // Delete the meal
                  final success = await controller.deleteMeal(meal);

                  // Close loading dialog
                  Get.back();

                  // Show result message
                  if (success) {
                    Get.snackbar(
                      'Success',
                      'Meal deleted successfully',
                      backgroundColor: AppTheme.success.withValues(alpha: 0.9),
                      colorText: AppTheme.textPrimary,
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(AppTheme.spacingM),
                      borderRadius: AppTheme.radiusM,
                      duration: const Duration(seconds: 2),
                    );
                  } else {
                    Get.snackbar(
                      'Error',
                      'Failed to delete meal. Please try again.',
                      backgroundColor: AppTheme.error.withValues(alpha: 0.9),
                      colorText: AppTheme.textPrimary,
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(AppTheme.spacingM),
                      borderRadius: AppTheme.radiusM,
                      duration: const Duration(seconds: 3),
                    );
                  }
                },
                child: Text(
                  'Delete',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
