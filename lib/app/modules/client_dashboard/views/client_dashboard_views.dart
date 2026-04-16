import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../controllers/user_controller.dart';
import '../../../core/base/controllers/auth_controller.dart';
import '../../../core/theme/theme_helper.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/dynamic_profile_header.dart';
import '../../../widgets/dynamic_live_stats_card.dart';
import '../../../widgets/dynamic_day_counter.dart';
import '../../../widgets/real_time_search_bar.dart';
import '../../../widgets/phone_nav_bar.dart';
import '../../../widgets/drawer_menu.dart';
import '../../../data/models/meal_model.dart';
import '../controllers/client_dashboard_controllers.dart';
import '../../generate_ai/views/recommendations_widget.dart';

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
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: context.backgroundColor,
      drawer: const DrawerMenu(), // Add the drawer here
      body: GestureDetector(
        onTap: () {
          // Unfocus search when tapping outside
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(gradient: context.backgroundGradient),
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
                            gradient: context.headerGradient,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                            boxShadow: context.cardShadow,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                // Dynamic Profile Header
                                DynamicProfileHeader(
                                  onProfileTap: () {
                                    // Open the side drawer
                                    scaffoldKey.currentState?.openDrawer();
                                  },
                                ),

                                // Group Mode Header (shown when in group mode)
                                Obx(() {
                                  if (controller.isGroupMode.value) {
                                    return Column(
                                      children: [
                                        const SizedBox(height: 16),
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                context.accentColor.withValues(
                                                  alpha: 0.2,
                                                ),
                                                context.accentColor.withValues(
                                                  alpha: 0.1,
                                                ),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            border: Border.all(
                                              color: context.accentColor
                                                  .withValues(alpha: 0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: context.accentColor
                                                      .withValues(alpha: 0.3),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.group,
                                                  color: context.accentColor,
                                                  size: 20,
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'group_mode'.tr,
                                                      style: TextStyle(
                                                        color:
                                                            context.accentColor,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(height: 2),
                                                    Text(
                                                      controller
                                                          .selectedGroupName
                                                          .value,
                                                      style: TextStyle(
                                                        color:
                                                            context.textPrimary,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                onPressed:
                                                    controller.exitGroupMode,
                                                icon: Icon(
                                                  Icons.close,
                                                  color: context.isLightTheme
                                                      ? context.textSecondary
                                                      : Colors.white70,
                                                ),
                                                tooltip: 'exit_group_mode'.tr,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return SizedBox.shrink();
                                }),

                                const SizedBox(height: 24),

                                // Dynamic Live Stats Card
                                const DynamicLiveStatsCard(),
                                const SizedBox(height: 20),

                                // Weekly Planner Entry Card
                                GestureDetector(
                                  onTap: () {
                                    final userData = Get.find<AuthController>()
                                        .userdataget();
                                    Get.toNamed(
                                      "${Routes.planner}?id=${userData["id"] ?? userData["_id"] ?? ""}",
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: context.accentColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withValues(alpha: 
                                              0.1,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.calendar_month,
                                            color: Colors.black,
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'view_weekly_planner'.tr,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'manage_daily_meal_schedule'.tr,
                                                style: TextStyle(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.6),
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.black,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
                                  debugPrint(
                                    '🎯 VIEW DEBUG - onSearchChanged callback received: "$query"',
                                  );
                                  controller.updateSearchQuery(query);
                                },
                                onSearchFocused: () {
                                  debugPrint(
                                    '🎯 VIEW DEBUG - onSearchFocused callback received',
                                  );
                                  controller.onSearchFocused();
                                },
                                onSearchCleared: () {
                                  debugPrint(
                                    '🎯 VIEW DEBUG - onSearchCleared callback received',
                                  );
                                  controller.clearSearch();
                                },
                                hintText: 'Search here...',
                              ),

                              const SizedBox(height: 24),

                              // AI: Recommended Meals (shown only in personal mode)
                              Obx(() {
                                if (!controller.isGroupMode.value) {
                                  return const RecommendationsWidget();
                                }
                                return const SizedBox.shrink();
                              }),

                              // Dynamic Day Counter with Add Meal Button
                              // Add Meal button visibility based on user role:
                              // - Personal mode: Always visible
                              // - Group mode: Visible only if user is admin
                              Obx(
                                () => DynamicDayCounter(
                                  showAddButton:
                                      controller.shouldShowAddMealButton,
                                  onAddMealTap: () {
                                    final userData = Get.find<AuthController>()
                                        .userdataget();
                                    final userId =
                                        userData["id"] ?? userData["_id"] ?? "";

                                    // Pass group category ID if in group mode
                                    final arguments = <String, dynamic>{};
                                    if (controller.isGroupMode.value &&
                                        controller
                                                .selectedGroupCategoryId
                                                .value !=
                                            null) {
                                      arguments['groupCategoryId'] = controller
                                          .selectedGroupCategoryId
                                          .value;
                                    }

                                    // Show choice bottom sheet instead of navigating directly
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      builder: (_) => _MealCreationSheet(
                                        userId: userId,
                                        groupArguments: arguments.isEmpty
                                            ? null
                                            : arguments,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Meal Type Tabs - Conditionally visible based on search state
                              Obx(() {
                                // Only show category buttons when search is empty
                                if (controller.shouldShowCategoryButtons) {
                                  return Column(
                                    children: [
                                      // Horizontally scrollable category buttons
                                      ScrollConfiguration(
                                        behavior: ScrollConfiguration.of(
                                          context,
                                        ).copyWith(scrollbars: false),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Row(
                                            children: controller.categories.map(
                                              (category) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 12,
                                                      ),
                                                  child: _buildModernMealTab(
                                                    _getCategoryIcon(category),
                                                    category,
                                                    controller
                                                            .selectedCategory
                                                            .value ==
                                                        category,
                                                    () => controller
                                                        .changeCategory(
                                                          category,
                                                        ),
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  );
                                }
                                // Return empty widget when searching
                                return const SizedBox.shrink();
                              }),

                              // Meals List - Firebase-backed with modern styling
                              Obx(() {
                                // DEBUG: Log the state
                                debugPrint(
                                  '🎨 VIEW DEBUG - isGroupMode: ${controller.isGroupMode.value}',
                                );
                                debugPrint(
                                  '🎨 VIEW DEBUG - groupMeals count: ${controller.groupMeals.length}',
                                );
                                debugPrint(
                                  '🎨 VIEW DEBUG - shouldShowLoading: ${controller.shouldShowLoading}',
                                );
                                debugPrint(
                                  '🎨 VIEW DEBUG - shouldShowError: ${controller.shouldShowError}',
                                );
                                debugPrint(
                                  '🎨 VIEW DEBUG - isSearchFocused: ${controller.isSearchFocused.value}',
                                );
                                debugPrint(
                                  '🎨 VIEW DEBUG - searchQuery: "${controller.searchQuery.value}"',
                                );
                                debugPrint(
                                  '🎨 VIEW DEBUG - searchQuery trimmed: "${controller.searchQuery.value.trim()}"',
                                );

                                if (controller.shouldShowLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFC2FF00),
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

                                // Get meals to display
                                final meals = controller.displayMeals;
                                debugPrint(
                                  '🎨 VIEW DEBUG - displayMeals count: ${meals.length}',
                                );

                                if (meals.isEmpty) {
                                  // Show different empty states for search or category

                                  // Search: No results
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
                                              color: context.textSecondary
                                                  .withValues(alpha: 0.5),
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'no_meals_found'.tr,
                                              style: TextStyle(
                                                color: context.textPrimary,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              'try_different_keywords'.tr,
                                              style: TextStyle(
                                                color: context.textSecondary,
                                                fontSize: 14,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 16),
                                            ElevatedButton.icon(
                                              onPressed: controller.clearSearch,
                                              icon: const Icon(
                                                Icons.clear,
                                                size: 18,
                                              ),
                                              label: Text('clear_search'.tr),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    context.accentColor,
                                                foregroundColor: Colors.black,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 12,
                                                    ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
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
                                        const SizedBox(height: 32),

                                        // Action Cards - Only show if user has permission
                                        // Personal Mode: Always show
                                        // Group Mode + Admin: Show
                                        // Group Mode + Member: Hide
                                        if (controller
                                            .isCurrentUserAdminOfSelectedGroup()) ...[
                                          _buildActionCard(
                                            title: 'create_manually'.tr,
                                            buttonText: 'create'.tr,
                                            iconEmoji: '📋',
                                            iconBgColor: Colors.orange
                                                .withValues(alpha: 0.2),
                                            onTap: () {
                                              final userData =
                                                  Get.find<AuthController>()
                                                      .userdataget();

                                              // Pass group category ID if in group mode
                                              final arguments =
                                                  <String, dynamic>{};
                                              if (controller
                                                      .isGroupMode
                                                      .value &&
                                                  controller
                                                          .selectedGroupCategoryId
                                                          .value !=
                                                      null) {
                                                arguments['groupCategoryId'] =
                                                    controller
                                                        .selectedGroupCategoryId
                                                        .value;
                                              }

                                              Get.toNamed(
                                                "${Routes.createMeal}?id=${userData["id"] ?? userData["_id"] ?? ""}",
                                                arguments: arguments.isEmpty
                                                    ? null
                                                    : arguments,
                                              );
                                            },
                                          ),
                                          _buildActionCard(
                                            title: 'generate_using_ai'.tr,
                                            buttonText: 'generate'.tr,
                                            iconEmoji: '✨',
                                            iconBgColor: Colors.purple
                                                .withValues(alpha: 0.2),
                                            onTap: () =>
                                                Get.toNamed(Routes.generateAi),
                                          ),
                                          _buildActionCard(
                                            title: 'copy_from_existing'.tr,
                                            buttonText: 'copy'.tr,
                                            iconEmoji: '📄',
                                            iconBgColor: Colors.blue.withValues(
                                              alpha: 0.2,
                                            ),
                                            onTap: () => Get.toNamed(
                                              Routes.mealHistory,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  );
                                }

                                // Show meals list
                                debugPrint(
                                  '🎨 VIEW DEBUG - Rendering ${meals.length} meals',
                                );

                                // Show flat meal list (same UI for personal and group meals)
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
                              }),
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
        gradient: context.headerGradient,
        border: Border(
          top: BorderSide(
            color: context.isLightTheme
                ? context.borderColor
                : Color(0xFFC2D86A).withValues(alpha: 0.2),
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
              _buildNavItem(Icons.person, 'member'.tr, true, () {
                // Already on member/dashboard screen
              }),
              _buildNavItem(Icons.group, 'group'.tr, false, () {
                Get.toNamed(Routes.group);
              }),
              _buildNavItem(Icons.notifications, 'notification'.tr, false, () {
                Get.toNamed('/notification?id=$id');
              }),
              _buildNavItem(Icons.person, 'profile'.tr, false, () {
                Get.toNamed(Routes.profileMain);
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
            color: isActive ? context.accentColor : context.textSecondary,
            size: 24,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? context.accentColor : context.textSecondary,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get icon for category
  String _getCategoryIcon(String category) {
    final iconMap = {
      'Breakfast': '🍳',
      'Lunch': '🥗',
      'Dinner': '🍽️',
      'Morning Snacks': '🥐',
      'Preworkout': '💪',
      'Post Workout': '🏋️',
      'Snacks': '🍿',
      'Workout': '💪',
      'Medicine': '💊',
      'Supplements': '💊',
    };

    // Return mapped icon or default icon for custom categories
    return iconMap[category] ?? '🍴';
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    context.accentColor.withValues(alpha: 0.3),
                    context.accentColor.withValues(alpha: 0.1),
                  ],
                )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? context.accentColor
                : context.isLightTheme
                ? context.borderColor
                : Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: context.accentColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? context.textPrimary : context.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 13,
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
    return GestureDetector(
      onTap: () {
        final box = GetStorage();
        box.write("mealdetails", meal.toJson());
        Get.toNamed(
          '/meals-details?id=${Get.find<AuthController>().userdataget()["id"] ?? Get.find<AuthController>().userdataget()["_id"] ?? ""}',
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: context.cardGradient,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: context.isLightTheme
                ? context.borderColor
                : Colors.transparent,
            width: 1,
          ),
          boxShadow: context.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Image + Title + Menu
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Square Image with Icons
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: context.accentColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        // Meal Image Background (if image exists, show it without icons)
                        if (meal.imageUrl.isNotEmpty)
                          Positioned.fill(
                            child: Image(
                              image:
                                  UserController.getImageProvider(
                                    meal.imageUrl,
                                  ) ??
                                  const AssetImage(
                                        'assets/meal_placeholder.png',
                                      )
                                      as ImageProvider,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(color: context.accentColor),
                            ),
                          ),

                        // Show icons only when there's NO image
                        if (meal.imageUrl.isEmpty) ...[
                          // Fork Icon (top-left)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.restaurant,
                                color: Colors.black.withValues(alpha: 0.85),
                                size: 18,
                              ),
                            ),
                          ),
                          // Plus Icon (centered)
                          Center(
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Color(0xFF1A1D1F),
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),

                // Title and Tags
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Meal Name
                      Text(
                        meal.name,
                        style: TextStyle(
                          color: context.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Tags (ORGANIC • FRESH)
                      Text(
                        '${'organic'.tr} • ${'fresh'.tr}',
                        style: TextStyle(
                          color: context.textSecondary.withValues(alpha: 0.7),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Three-Dot Menu
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: context.isLightTheme
                        ? context.cardSecondaryColor
                        : const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert_rounded,
                      color: context.textSecondary,
                      size: 20,
                    ),
                    color: context.isLightTheme
                        ? context.cardColor
                        : const Color(0xFF2C2C2E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: context.isLightTheme
                            ? context.borderColor
                            : Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    offset: const Offset(-10, 40),
                    elevation: 8,
                    onSelected: (value) {
                      if (value == 'edit') {
                        final userData = Get.find<AuthController>()
                            .userdataget();

                        // Pass group category ID if in group mode
                        final arguments = <String, dynamic>{'meal': meal};
                        if (controller.isGroupMode.value &&
                            controller.selectedGroupCategoryId.value != null) {
                          arguments['groupCategoryId'] =
                              controller.selectedGroupCategoryId.value;
                        }

                        Get.toNamed(
                          "${Routes.createMeal}?id=${userData["_id"] ?? ""}",
                          arguments: arguments,
                        );
                      } else if (value == 'delete') {
                        _showDeleteMealDialog(context, meal, controller);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: context.accentColor.withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: context.accentColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'edit_meal'.tr,
                              style: TextStyle(
                                color: context.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.delete_outline_rounded,
                                size: 18,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'delete_meal'.tr,
                              style: TextStyle(
                                color: context.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Calories and Weight Row
            Row(
              children: [
                // Calories Badge
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: context.isLightTheme
                          ? Color(0xFFFFF4E6) // Light orange background
                          : const Color(0xFF3A2F1A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🔥', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 10),
                        Text(
                          meal.kcal,
                          style: TextStyle(
                            color: context.isLightTheme
                                ? Color(
                                    0xFFFF8C00,
                                  ) // Darker orange for light theme
                                : Color(0xFFFFB800),
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          ' kcal',
                          style: TextStyle(
                            color: context.isLightTheme
                                ? Color(0xFFFF8C00)
                                : Color(0xFFFFB800),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Weight Badge
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: context.isLightTheme
                          ? context.cardSecondaryColor
                          : const Color(0xFF2C2C2E),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('⚖️', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 10),
                        Text(
                          '100g',
                          style: TextStyle(
                            color: context.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Macros Row
            Row(
              children: [
                _buildMacroBox(
                  '${meal.protein}g',
                  'protein'.tr,
                  const Color(0xFF1A3A2A),
                  const Color(0xFF4CAF50),
                ),
                const SizedBox(width: 12),
                _buildMacroBox(
                  '${meal.fat}g',
                  'fat'.tr,
                  const Color(0xFF1A2A3A),
                  const Color(0xFF2196F3),
                ),
                const SizedBox(width: 12),
                _buildMacroBox(
                  '${meal.carbs}g',
                  'carbs'.tr,
                  const Color(0xFF3A1A1A),
                  const Color(0xFFE53935),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroBox(
    String value,
    String label,
    Color bgColor,
    Color textColor,
  ) {
    // Light theme colors
    final lightBgColors = {
      const Color(0xFF1A3A2A): const Color(0xFFE8F5E9), // Light green
      const Color(0xFF1A2A3A): const Color(0xFFE3F2FD), // Light blue
      const Color(0xFF3A1A1A): const Color(0xFFFFEBEE), // Light red
    };

    final lightTextColors = {
      const Color(0xFF4CAF50): const Color(0xFF2E7D32), // Darker green
      const Color(0xFF2196F3): const Color(0xFF1565C0), // Darker blue
      const Color(0xFFE53935): const Color(0xFFC62828), // Darker red
    };

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
        decoration: BoxDecoration(
          color: context.isLightTheme
              ? (lightBgColors[bgColor] ?? bgColor)
              : bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: context.isLightTheme
                    ? (lightTextColors[textColor] ?? textColor)
                    : textColor,
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: context.isLightTheme
                    ? (lightTextColors[textColor] ?? textColor)
                    : textColor,
                fontSize: 22,
                fontWeight: FontWeight.w700,
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
          backgroundColor: context.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'delete_meal'.tr,
            style: TextStyle(
              color: context.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            '${'delete_meal_confirm'.tr} "${meal.name}"? ${'action_cannot_be_undone'.tr}',
            style: TextStyle(color: context.textSecondary, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'cancel'.tr,
                style: TextStyle(color: context.textSecondary, fontSize: 14),
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
                          color: context.cardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(
                              color: Color(0xFFC2FF00),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'deleting_meal'.tr,
                              style: TextStyle(
                                color: context.textSecondary,
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
                      'success'.tr,
                      'meal_deleted_successfully'.tr,
                      backgroundColor: Colors.green.withValues(alpha: 0.9),
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                      duration: const Duration(seconds: 2),
                    );
                  } else {
                    Get.snackbar(
                      'error'.tr,
                      'failed_to_delete_meal'.tr,
                      backgroundColor: Colors.red.withValues(alpha: 0.9),
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                      duration: const Duration(seconds: 3),
                    );
                  }
                },
                child: Text(
                  'delete_group'.tr,
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
        gradient: context.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.isLightTheme
              ? context.borderColor
              : Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
        boxShadow: context.cardShadow,
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
                style: TextStyle(
                  color: context.textPrimary,
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
                backgroundColor: context.accentColor,
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

// ── Meal Creation Choice Sheet ────────────────────────────────────────────────

class _MealCreationSheet extends StatelessWidget {
  final String userId;
  final Map<String, dynamic>? groupArguments;

  const _MealCreationSheet({required this.userId, this.groupArguments});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F0F0F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 22),

          // header
          const Row(
            children: [
              Icon(
                Icons.restaurant_rounded,
                color: Color(0xFFC2D86A),
                size: 20,
              ),
              SizedBox(width: 10),
              Text(
                'Add a Meal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'How would you like to create this meal?',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
          const SizedBox(height: 24),

          // Option 1 — Create manually
          _SheetOption(
            icon: Icons.edit_note_rounded,
            iconColor: const Color(0xFF4FC3F7),
            title: 'Create Manually',
            subtitle: 'Enter meal name, ingredients and macros yourself',
            onTap: () {
              Navigator.pop(context);
              Get.toNamed(
                '${Routes.createMeal}?id=$userId',
                arguments: groupArguments,
              );
            },
          ),
          const SizedBox(height: 12),

          // Option 2 — Generate with AI
          _SheetOption(
            icon: Icons.auto_awesome_rounded,
            iconColor: const Color(0xFFC2D86A),
            title: 'Generate with AI',
            subtitle: 'Get a personalised meal plan based on your goals',
            badge: 'AI',
            onTap: () {
              Navigator.pop(context);
              Get.toNamed('${Routes.generateAi}?id=$userId');
            },
          ),
        ],
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String? badge;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A2A)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: iconColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badge!,
                            style: TextStyle(
                              color: iconColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white24,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
