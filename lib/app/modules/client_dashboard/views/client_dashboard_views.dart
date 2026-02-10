import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../controllers/user_controller.dart';
import '../../../core/base/controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/dynamic_profile_header.dart';
import '../../../widgets/dynamic_live_stats_card.dart';
import '../../../widgets/dynamic_day_counter.dart';
import '../../../widgets/real_time_search_bar.dart';
import '../../../widgets/phone_nav_bar.dart';
import '../../../widgets/drawer_menu.dart';
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
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      drawer: const DrawerMenu(), // Add the drawer here
      body: GestureDetector(
        onTap: () {
          // Unfocus search when tapping outside
          FocusScope.of(context).unfocus();
        },
        child: Container(
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
                                  onProfileTap: () {
                                    // Open the side drawer
                                    _scaffoldKey.currentState?.openDrawer();
                                  },
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
                                onSearchChanged: (query) {
                                  print(
                                    '🎯 VIEW DEBUG - onSearchChanged callback received: "$query"',
                                  );
                                  controller.updateSearchQuery(query);
                                },
                                onSearchFocused: () {
                                  print(
                                    '🎯 VIEW DEBUG - onSearchFocused callback received',
                                  );
                                  controller.onSearchFocused();
                                },
                                onSearchCleared: () {
                                  print(
                                    '🎯 VIEW DEBUG - onSearchCleared callback received',
                                  );
                                  controller.clearSearch();
                                },
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

                              // Meal Type Tabs - Conditionally visible based on search state
                              Obx(() {
                                // Only show category buttons when search is empty
                                if (controller.shouldShowCategoryButtons) {
                                  return Column(
                                    children: [
                                      // First Row
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildModernMealTab(
                                              '🍳',
                                              'Breakfast',
                                              controller
                                                      .selectedCategory
                                                      .value ==
                                                  'Breakfast',
                                              () => controller.changeCategory(
                                                'Breakfast',
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _buildModernMealTab(
                                              '🥗',
                                              'Lunch',
                                              controller
                                                      .selectedCategory
                                                      .value ==
                                                  'Lunch',
                                              () => controller.changeCategory(
                                                'Lunch',
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _buildModernMealTab(
                                              '🍽️',
                                              'Dinner',
                                              controller
                                                      .selectedCategory
                                                      .value ==
                                                  'Dinner',
                                              () => controller.changeCategory(
                                                'Dinner',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      // Second Row
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildModernMealTab(
                                              '🥐',
                                              'Morning Snacks',
                                              controller
                                                      .selectedCategory
                                                      .value ==
                                                  'Morning Snacks',
                                              () => controller.changeCategory(
                                                'Morning Snacks',
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _buildModernMealTab(
                                              '💪',
                                              'Preworkout',
                                              controller
                                                      .selectedCategory
                                                      .value ==
                                                  'Preworkout',
                                              () => controller.changeCategory(
                                                'Preworkout',
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _buildModernMealTab(
                                              '🏋️',
                                              'Post Workout',
                                              controller
                                                      .selectedCategory
                                                      .value ==
                                                  'Post Workout',
                                              () => controller.changeCategory(
                                                'Post Workout',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  );
                                }
                                // Return empty widget when searching
                                return const SizedBox.shrink();
                              }),

                              // Meals List - Firebase-backed with modern styling
                              GetBuilder<ClientDashboardControllers>(
                                builder: (controller) {
                                  // DEBUG: Log the state
                                  print(
                                    '🎨 VIEW DEBUG - shouldShowLoading: ${controller.shouldShowLoading}',
                                  );
                                  print(
                                    '🎨 VIEW DEBUG - shouldShowError: ${controller.shouldShowError}',
                                  );
                                  print(
                                    '🎨 VIEW DEBUG - isSearchFocused: ${controller.isSearchFocused.value}',
                                  );
                                  print(
                                    '🎨 VIEW DEBUG - searchQuery: "${controller.searchQuery.value}"',
                                  );
                                  print(
                                    '🎨 VIEW DEBUG - searchQuery trimmed: "${controller.searchQuery.value.trim()}"',
                                  );

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

                                  // CRITICAL: When search is focused but empty, show blank/prompt state
                                  if (controller.isSearchFocused.value &&
                                      controller.searchQuery.value
                                          .trim()
                                          .isEmpty) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(32.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.search,
                                              size: 80,
                                              color: Colors.white.withValues(
                                                alpha: 0.3,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'Start typing to search',
                                              style: TextStyle(
                                                color: Colors.white.withValues(
                                                  alpha: 0.8,
                                                ),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'Search by meal name, ingredients, or nutrition info',
                                              style: TextStyle(
                                                color: Colors.white.withValues(
                                                  alpha: 0.5,
                                                ),
                                                fontSize: 14,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }

                                  // Get meals to display
                                  final meals = controller.displayMeals;
                                  print(
                                    '🎨 VIEW DEBUG - displayMeals count: ${meals.length}',
                                  );

                                  if (meals.isEmpty) {
                                    // Show different empty states for search vs category
                                    if (controller.searchQuery.value
                                        .trim()
                                        .isNotEmpty) {
                                      return Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(32.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.search_off_rounded,
                                                size: 80,
                                                color: Colors.white.withValues(
                                                  alpha: 0.3,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                'No meals found',
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.8),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Try searching with different keywords',
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.5),
                                                  fontSize: 14,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 16),
                                              ElevatedButton.icon(
                                                onPressed:
                                                    controller.clearSearch,
                                                icon: const Icon(
                                                  Icons.clear,
                                                  size: 18,
                                                ),
                                                label: const Text(
                                                  'Clear Search',
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: const Color(
                                                    0xFFC2D86A,
                                                  ),
                                                  foregroundColor: Colors.black,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 24,
                                                        vertical: 12,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }

                                    // Empty state for category with no meals
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/no_diet.png',
                                            height: 180,
                                            width: 180,
                                            fit: BoxFit.cover,
                                          ),
                                          // const SizedBox(height: 12),
                                          // Text(
                                          //   'No Diet Plan\nFound!',
                                          //   style: TextStyle(
                                          //     color: const Color(0xFFC2D86A),
                                          //     fontSize: 24,
                                          //     fontWeight: FontWeight.bold,
                                          //     letterSpacing: 0.5,
                                          //     height: 1.2,
                                          //   ),
                                          //   textAlign: TextAlign.center,
                                          // ),
                                          const SizedBox(height: 32),

                                          // Action Cards
                                          _buildActionCard(
                                            title: 'Create Manually',
                                            buttonText: 'Create',
                                            iconEmoji: '📋',
                                            iconBgColor: Colors.orange
                                                .withValues(alpha: 0.2),
                                            onTap: () {
                                              final userData =
                                                  Get.find<AuthController>()
                                                      .userdataget();
                                              Get.toNamed(
                                                "${Routes.CreateMeal}?id=${userData["_id"] ?? ""}",
                                              );
                                            },
                                          ),
                                          _buildActionCard(
                                            title: 'Generate Using AI',
                                            buttonText: 'Generate',
                                            iconEmoji: '✨',
                                            iconBgColor: Colors.purple
                                                .withValues(alpha: 0.2),
                                            onTap: () =>
                                                Get.toNamed(Routes.GENERATE_AI),
                                          ),
                                          _buildActionCard(
                                            title: 'Copy From Existing',
                                            buttonText: 'Copy',
                                            iconEmoji: '📄',
                                            iconBgColor: Colors.blue.withValues(
                                              alpha: 0.2,
                                            ),
                                            onTap: () => Get.toNamed(
                                              Routes.MEAL_HISTORY,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  // Show meals list
                                  print(
                                    '🎨 VIEW DEBUG - Rendering ${meals.length} meals',
                                  );
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
            ), // Close Column
          ), // Close SafeArea
        ), // Close Container
      ), // Close GestureDetector
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    const Color(0xFFC2D86A).withValues(alpha: 0.3),
                    const Color(0xFFC2D86A).withValues(alpha: 0.1),
                  ],
                )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFC2D86A)
                : Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white54,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image(
                        image:
                            UserController.getImageProvider(meal.imageUrl) ??
                            const AssetImage('assets/meal_placeholder.png')
                                as ImageProvider,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.restaurant,
                              color: Colors.black,
                              size: 35,
                            ),
                      ),
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

  Widget _buildActionCard({
    required String title,
    required String buttonText,
    required String iconEmoji,
    required Color iconBgColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(iconEmoji, style: const TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 16),
            // Title
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            // Action Button
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC2D86A),
                foregroundColor: Colors.black,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                minimumSize: const Size(90, 40),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
