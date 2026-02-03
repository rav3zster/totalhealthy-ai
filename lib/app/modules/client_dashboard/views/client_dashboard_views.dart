import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/models/meal_model.dart';
import '../../../core/base/controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/drawer_menu.dart';
import '../../../widgets/dynamic_profile_header.dart';
import '../../../widgets/dynamic_live_stats_card.dart';
import '../../../widgets/dynamic_day_counter.dart';
import '../../../widgets/real_time_search_bar.dart';
import '../../../widgets/base_screen_wrapper.dart';
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
        color: const Color(0xFFC2D86A),
        backgroundColor: const Color(0xFF2A2A2A),
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

                  const SizedBox(height: 20),

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
                        const SizedBox(width: 12),
                        _buildMealTab(
                          '🥗',
                          'Lunch',
                          controller.selectedCategory.value == 'Lunch',
                          () => controller.changeCategory('Lunch'),
                        ),
                        const SizedBox(width: 12),
                        _buildMealTab(
                          '🍽️',
                          'Dinner',
                          controller.selectedCategory.value == 'Dinner',
                          () => controller.changeCategory('Dinner'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Meals List with Enhanced States
                  _buildMealsList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealsList() {
    return GetBuilder<ClientDashboardControllers>(
      builder: (controller) {
        final meals = controller.displayMeals;
        final debugInfo = controller.debugInfo;

        // Show loading ONLY during initial fetch when no data exists
        if (controller.shouldShowLoading) {
          return _buildMealsLoadingSkeleton();
        }

        // Show error ONLY if we have no data and there's an error
        if (controller.shouldShowError) {
          return _buildMealsErrorState(controller);
        }

        // Show search empty state when search is active but no results
        if (controller.shouldShowSearchEmpty) {
          return _buildSearchEmptyState(controller, debugInfo);
        }

        // Show category empty state when category has no meals
        if (controller.shouldShowCategoryEmpty) {
          return _buildCategoryEmptyState(controller, debugInfo);
        }

        // Show meals list with results
        return _buildMealsContent(controller, meals, debugInfo);
      },
    );
  }

  Widget _buildSearchEmptyState(
    ClientDashboardControllers controller,
    Map<String, dynamic> debugInfo,
  ) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Icon(Icons.search_off, color: Colors.white54, size: 64),
          const SizedBox(height: 16),
          Text(
            'No meals found for "${controller.searchQuery.value}"',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'in ${controller.selectedCategory.value} category',
            style: const TextStyle(color: Colors.white54, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '${debugInfo['categoryMeals']} total ${controller.selectedCategory.value.toLowerCase()} meals available',
            style: const TextStyle(color: Colors.white38, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: controller.clearSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC2D86A),
                  foregroundColor: Colors.black,
                ),
                child: const Text('Clear Search'),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {
                  controller.clearSearch();
                  // Cycle through categories to find meals
                  final categories = ['Breakfast', 'Lunch', 'Dinner'];
                  final currentIndex = categories.indexOf(
                    controller.selectedCategory.value,
                  );
                  final nextCategory =
                      categories[(currentIndex + 1) % categories.length];
                  controller.changeCategory(nextCategory);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFC2D86A)),
                  foregroundColor: const Color(0xFFC2D86A),
                ),
                child: const Text('Try Other Categories'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryEmptyState(
    ClientDashboardControllers controller,
    Map<String, dynamic> debugInfo,
  ) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Image.asset(
            'assets/no_diet.png',
            width: 120,
            height: 120,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.restaurant_menu,
                color: Colors.white54,
                size: 64,
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            'No ${controller.selectedCategory.value.toLowerCase()} meals found',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Total meals available: ${debugInfo['totalMeals']}',
            style: const TextStyle(color: Colors.white54, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Try switching to a different meal category or add new meals',
            style: const TextStyle(color: Colors.white38, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // Category switching buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: ['Breakfast', 'Lunch', 'Dinner'].map((category) {
              final isSelected = controller.selectedCategory.value == category;
              final categoryCount = controller.meals
                  .where((meal) => meal.categories.contains(category))
                  .length;

              return ElevatedButton(
                onPressed: isSelected
                    ? null
                    : () => controller.changeCategory(category),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected
                      ? Colors.grey[600]
                      : categoryCount > 0
                      ? const Color(0xFFC2D86A)
                      : Colors.grey[700],
                  foregroundColor: isSelected ? Colors.white54 : Colors.black,
                  disabledBackgroundColor: Colors.grey[600],
                  disabledForegroundColor: Colors.white54,
                ),
                child: Text('$category ($categoryCount)'),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              final userData = Get.find<AuthController>().userdataget();
              Get.toNamed("${Routes.CreateMeal}?id=${userData["_id"] ?? ""}");
            },
            icon: const Icon(Icons.add, color: Color(0xFFC2D86A)),
            label: const Text('Add New Meal'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFC2D86A)),
              foregroundColor: const Color(0xFFC2D86A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealsContent(
    ClientDashboardControllers controller,
    List<MealModel> meals,
    Map<String, dynamic> debugInfo,
  ) {
    return Column(
      children: [
        // Show refresh indicator if refreshing
        if (controller.isRefreshing.value)
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFFC2D86A),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Refreshing meals...',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

        // Search results info
        if (controller.isSearchActive)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFC2D86A), width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Color(0xFFC2D86A), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${meals.length} result${meals.length == 1 ? '' : 's'} for "${controller.searchQuery.value}" in ${controller.selectedCategory.value}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                GestureDetector(
                  onTap: controller.clearSearch,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC2D86A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Clear',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Category info (when not searching)
        if (!controller.isSearchActive)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  _getCategoryEmoji(controller.selectedCategory.value),
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${meals.length} ${controller.selectedCategory.value.toLowerCase()} meal${meals.length == 1 ? '' : 's'}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
                Text(
                  'Total: ${debugInfo['totalMeals']}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),

        // Meals list
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: meals.length,
          itemBuilder: (context, index) {
            return _buildMealCard(
              meals[index],
              controller.isSearchActive,
              controller.searchQuery.value,
            );
          },
        ),
      ],
    );
  }

  String _getCategoryEmoji(String category) {
    switch (category) {
      case 'Breakfast':
        return '🍳';
      case 'Lunch':
        return '🥗';
      case 'Dinner':
        return '🍽️';
      default:
        return '🍽️';
    }
  }

  Widget _buildMealsLoadingSkeleton() {
    return Column(
      children: List.generate(3, (index) => _buildMealCardSkeleton()),
    );
  }

  Widget _buildMealCardSkeleton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Skeleton image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF3A3A3A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFC2D86A),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Skeleton title
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                // Skeleton subtitle
                Container(
                  width: 120,
                  height: 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3A),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                // Skeleton nutrients
                Row(
                  children: List.generate(
                    3,
                    (index) => Padding(
                      padding: EdgeInsets.only(right: index < 2 ? 12 : 0),
                      child: Column(
                        children: [
                          Container(
                            width: 3,
                            height: 20,
                            color: const Color(0xFF3A3A3A),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 20,
                            height: 12,
                            decoration: BoxDecoration(
                              color: const Color(0xFF3A3A3A),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Skeleton action button
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFF3A3A3A),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealsErrorState(ClientDashboardControllers controller) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Text(
            controller.error.value,
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.forceRefresh,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC2D86A),
              foregroundColor: Colors.black,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(String id) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(top: BorderSide(color: Color(0xFF2A2A2A), width: 1)),
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
          Icon(
            icon,
            color: isActive ? const Color(0xFFC2D86A) : Colors.white54,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFFC2D86A) : Colors.white54,
              fontSize: 12,
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
          color: isSelected ? const Color(0xFF2A2A2A) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: const Color(0xFFC2D86A))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
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

  Widget _buildMealCard(
    MealModel meal, [
    bool isSearching = false,
    String searchTerm = '',
  ]) {
    return GestureDetector(
      onTap: () {
        final box = GetStorage();
        box.write("mealdetails", meal.toJson());
        Get.toNamed(
          '/meals-details?id=${Get.find<AuthController>().userdataget()["_id"] ?? ""}',
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
          border: isSearching && searchTerm.isNotEmpty
              ? Border.all(
                  color: const Color(0xFFC2D86A).withOpacity(0.3),
                  width: 1,
                )
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFC2D86A),
                borderRadius: BorderRadius.circular(12),
                image: meal.imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(meal.imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: meal.imageUrl.isEmpty
                  ? const Icon(Icons.restaurant, color: Colors.black, size: 30)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meal name with search highlighting
                  _buildHighlightedText(
                    meal.name,
                    searchTerm,
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      _buildHighlightedText(
                        '${meal.kcal} Kcal',
                        searchTerm,
                        const TextStyle(color: Colors.orange, fontSize: 14),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '• 100g',
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildNutrientBar(
                        '${meal.protein}g',
                        'Protein',
                        Colors.green,
                        searchTerm,
                      ),
                      const SizedBox(width: 12),
                      _buildNutrientBar(
                        '${meal.fat}g',
                        'Fat',
                        Colors.blue,
                        searchTerm,
                      ),
                      const SizedBox(width: 12),
                      _buildNutrientBar(
                        '${meal.carbs}g',
                        'Carbs',
                        Colors.red,
                        searchTerm,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFC2D86A),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.more_horiz,
                color: Colors.black,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightedText(
    String text,
    String searchTerm,
    TextStyle style,
  ) {
    if (searchTerm.isEmpty ||
        !text.toLowerCase().contains(searchTerm.toLowerCase())) {
      return Text(text, style: style);
    }

    final lowerText = text.toLowerCase();
    final lowerSearchTerm = searchTerm.toLowerCase();
    final startIndex = lowerText.indexOf(lowerSearchTerm);

    if (startIndex == -1) {
      return Text(text, style: style);
    }

    final beforeMatch = text.substring(0, startIndex);
    final match = text.substring(startIndex, startIndex + searchTerm.length);
    final afterMatch = text.substring(startIndex + searchTerm.length);

    return RichText(
      text: TextSpan(
        style: style,
        children: [
          TextSpan(text: beforeMatch),
          TextSpan(
            text: match,
            style: style.copyWith(
              backgroundColor: const Color(0xFFC2D86A).withOpacity(0.3),
              color: const Color(0xFFC2D86A),
            ),
          ),
          TextSpan(text: afterMatch),
        ],
      ),
    );
  }

  Widget _buildNutrientBar(
    String value,
    String label,
    Color color, [
    String searchTerm = '',
  ]) {
    return Column(
      children: [
        Container(width: 3, height: 20, color: color),
        const SizedBox(height: 4),
        _buildHighlightedText(
          value,
          searchTerm,
          const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 10),
        ),
      ],
    );
  }
}
