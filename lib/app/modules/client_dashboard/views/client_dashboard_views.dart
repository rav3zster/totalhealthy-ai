import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/base/controllers/auth_controller.dart';
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
        color: Colors.green,
        backgroundColor: Color(0xFF2A2A2A),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dynamic Profile Header
                  DynamicProfileHeader(
                    onProfileTap: () => Get.toNamed('/profile-settings'),
                    onNotificationTap: () =>
                        Get.toNamed('/notification?id=$id'),
                  ),

                  const SizedBox(height: 24),

                  // Dynamic Live Stats Card
                  const DynamicLiveStatsCard(),

                  const SizedBox(height: 24),

                  // Real-time Search Bar
                  SimpleRealTimeSearchBar(
                    searchQuery: controller.searchQuery,
                    onSearchChanged: controller.updateSearchQuery,
                    hintText: 'Search meals...',
                  ),

                  const SizedBox(height: 24),

                  // Dynamic Day Counter with Add Meal Button
                  DynamicDayCounter(
                    onAddMealTap: () {
                      final userData = Get.find<AuthController>().userdataget();
                      Get.toNamed(
                        "${Routes.CreateMeal}?id=${userData["_id"] ?? ""}",
                      );
                    },
                  ),

                  const SizedBox(height: 24),

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
                        const SizedBox(width: 16),
                        _buildMealTab(
                          '🥗',
                          'Lunch',
                          controller.selectedCategory.value == 'Lunch',
                          () => controller.changeCategory('Lunch'),
                        ),
                        const SizedBox(width: 16),
                        _buildMealTab(
                          '🍽️',
                          'Dinner',
                          controller.selectedCategory.value == 'Dinner',
                          () => controller.changeCategory('Dinner'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Meals List - Simplified for now
                  GetBuilder<ClientDashboardControllers>(
                    builder: (controller) {
                      if (controller.shouldShowLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFC2D86A),
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
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              leading: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC2D86A),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.restaurant,
                                  color: Colors.black,
                                ),
                              ),
                              title: Text(
                                meal.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                '${meal.kcal} Kcal',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
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
      decoration: const BoxDecoration(
        color: Color(0xFF2A2A2A),
        border: Border(top: BorderSide(color: Color(0xFF3A3A3A), width: 1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            padding: const EdgeInsets.all(8),
            decoration: isActive
                ? BoxDecoration(
                    color: const Color(0xFFC2D86A),
                    borderRadius: BorderRadius.circular(8),
                  )
                : null,
            child: Icon(
              icon,
              color: isActive ? Colors.black : Colors.white54,
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFFC2D86A) : Colors.white54,
              fontSize: 10,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC2D86A) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: isSelected
              ? null
              : Border.all(color: Colors.white54.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white70,
                fontSize: 14,
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
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Delete Meal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${meal.name}"? This action cannot be undone.',
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  // Show loading indicator
                  Get.dialog(
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(
                              color: Color(0xFFC2D86A),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Deleting meal...',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
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
                      backgroundColor: Colors.green.withValues(alpha: 0.9),
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                      duration: const Duration(seconds: 2),
                    );
                  } else {
                    Get.snackbar(
                      'Error',
                      'Failed to delete meal. Please try again.',
                      backgroundColor: Colors.red.withValues(alpha: 0.9),
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                      duration: const Duration(seconds: 3),
                    );
                  }
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
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
