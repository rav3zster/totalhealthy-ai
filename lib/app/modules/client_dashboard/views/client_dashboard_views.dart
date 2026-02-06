import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/base/controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/dynamic_profile_header.dart';
import '../../../widgets/dynamic_live_stats_card.dart';
import '../../../widgets/dynamic_day_counter.dart';
import '../../../widgets/real_time_search_bar.dart';
import '../../../widgets/phone_nav_bar.dart';
import '../../../data/models/meal_model.dart';
import '../controllers/client_dashboard_controllers.dart';

class ClientDashboardScreen extends StatefulWidget {
  const ClientDashboardScreen({super.key});

  @override
  State<ClientDashboardScreen> createState() => _ClientDashboardScreenState();
}

class _ClientDashboardScreenState extends State<ClientDashboardScreen> {
  @override
  void initState() {
    super.initState();
    OntapStore.index = 0; // Set to Member/Home tab
  }

  @override
  Widget build(BuildContext context) {
    String id = Get.parameters["id"] ?? "";
    final controller = Get.find<ClientDashboardControllers>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF1A1A1A), Colors.black],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with gradient background
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              // Dynamic Profile Header
                              DynamicProfileHeader(
                                onProfileTap: () =>
                                    Get.toNamed('/profile-settings'),
                                onNotificationTap: () =>
                                    Get.toNamed('/notification?id=$id'),
                              ),

                              const SizedBox(height: 24),

                              // Dynamic Live Stats Card
                              const DynamicLiveStatsCard(),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Real-time Search Bar
                            SimpleRealTimeSearchBar(
                              searchQuery: controller.searchQuery,
                              onSearchChanged: controller.updateSearchQuery,
                              hintText: 'Search here...',
                            ),

                            const SizedBox(height: 24),

                            // Dynamic Day Counter with Add Meal Button
                            DynamicDayCounter(
                              onAddMealTap: () {
                                final userData = Get.find<AuthController>()
                                    .userdataget();
                                Get.toNamed(
                                  "${Routes.CreateMeal}?id=${userData["_id"] ?? ""}",
                                );
                              },
                            ),

                            const SizedBox(height: 20),

                            // Meal Type Tabs
                            Obx(
                              () => Row(
                                children: [
                                  _buildModernMealTab(
                                    '🍳',
                                    'Breakfast',
                                    controller.selectedCategory.value ==
                                        'Breakfast',
                                    () =>
                                        controller.changeCategory('Breakfast'),
                                  ),
                                  const SizedBox(width: 12),
                                  _buildModernMealTab(
                                    '🥗',
                                    'Lunch',
                                    controller.selectedCategory.value ==
                                        'Lunch',
                                    () => controller.changeCategory('Lunch'),
                                  ),
                                  const SizedBox(width: 12),
                                  _buildModernMealTab(
                                    '🍽️',
                                    'Dinner',
                                    controller.selectedCategory.value ==
                                        'Dinner',
                                    () => controller.changeCategory('Dinner'),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Meals List - Firebase-backed with modern styling
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

                                if (meals.isEmpty) {
                                  return Center(
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          'assets/no_diet.png',
                                          height: 250,
                                          width: 250,
                                          fit: BoxFit.cover,
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: meals.length,
                                  itemBuilder: (context, index) {
                                    final meal = meals[index];
                                    return _buildModernMealCard(
                                      meal,
                                      index,
                                      controller,
                                      context,
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildModernBottomNavigationBar(id),
    );
  }

  Widget _buildModernBottomNavigationBar(String id) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
        ),
        border: Border(
          top: BorderSide(
            color: Color(0xFFC2D86A).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.person, 'Member', true, () {
                // Already on member/dashboard screen
              }),
              _buildNavItem(Icons.group, 'Group', false, () {
                Get.toNamed(Routes.GROUP);
              }),
              _buildNavItem(Icons.notifications, 'Notification', false, () {
                Get.toNamed('/notification?id=$id');
              }),
              _buildNavItem(Icons.person, 'Profile', false, () {
                Get.toNamed(Routes.PROFILE_MAIN);
              }),
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
          Icon(
            icon,
            color: isActive ? Color(0xFFC2D86A) : Colors.white54,
            size: 24,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Color(0xFFC2D86A) : Colors.white54,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernMealTab(
    String emoji,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    Color(0xFFC2D86A).withValues(alpha: 0.3),
                    Color(0xFFC2D86A).withValues(alpha: 0.1),
                  ],
                )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? Color(0xFFC2D86A)
                : Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Color(0xFFC2D86A).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: TextStyle(fontSize: 16)),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white54,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernMealCard(
    MealModel meal,
    int index,
    ClientDashboardControllers controller,
    BuildContext context,
  ) {
    // Different gradient combinations for variety
    List<List<Color>> gradients = [
      [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
      [Color(0xFF2D2D2D), Color(0xFF1D1D1D)],
      [Color(0xFF252525), Color(0xFF151515)],
    ];

    List<Color> cardGradient = gradients[index % gradients.length];

    return GestureDetector(
      onTap: () {
        final box = GetStorage();
        box.write("mealdetails", meal.toJson());
        Get.toNamed(
          '/meals-details?id=${Get.find<AuthController>().userdataget()["_id"] ?? ""}',
        );
      },
      onLongPress: () => _showDeleteMealDialog(context, meal, controller),
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: cardGradient,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Color(0xFFC2D86A).withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Subtle pattern overlay
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFFC2D86A).withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  // Meal Image
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFC2D86A).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.restaurant,
                      color: Colors.black,
                      size: 35,
                    ),
                  ),
                  SizedBox(width: 20),

                  // Meal Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.orange.withValues(alpha: 0.2),
                                    Colors.orange.withValues(alpha: 0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.local_fire_department,
                                color: Colors.orange,
                                size: 16,
                              ),
                            ),
                            SizedBox(width: 6),
                            Text(
                              '${meal.kcal} Kcal',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              '• 100g',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),

                        // Nutritional Info
                        Row(
                          children: [
                            _buildModernNutrientBar(
                              '${meal.protein}g',
                              'Protein',
                              Colors.green,
                            ),
                            SizedBox(width: 12),
                            _buildModernNutrientBar(
                              '${meal.fat}g',
                              'Fat',
                              Colors.blue,
                            ),
                            SizedBox(width: 12),
                            _buildModernNutrientBar(
                              '${meal.carbs}g',
                              'Carbs',
                              Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // More Options
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFC2D86A).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.more_horiz,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernNutrientBar(String value, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(label, style: TextStyle(color: Colors.white54, fontSize: 10)),
        ],
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
