import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:totalhealthy/app/controllers/user_controller.dart';
import 'package:totalhealthy/app/widgets/drawer_menu.dart';
import '../controllers/planner_controller.dart';
import '../../../core/theme/theme_helper.dart';

class PlannerPage extends StatefulWidget {
  const PlannerPage({super.key});

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PlannerController controller = Get.find<PlannerController>();
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const DrawerMenu(),
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: context.accent),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRecipesSection(),
                      const SizedBox(height: 24),
                      _buildCategoryTabs(),
                      const SizedBox(height: 16),
                      _buildWeeklyList(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => _scaffoldKey.currentState?.openDrawer(),
                child: GetBuilder<UserController>(
                  builder: (uController) {
                    return CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey[800],
                      backgroundImage: UserController.getImageProvider(
                        uController.profileImage,
                      ),
                      child: uController.profileImage.isEmpty
                          ? const Icon(
                              Icons.person,
                              color: Colors.white24,
                              size: 22,
                            )
                          : null,
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Planner',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.grey,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('d MMM yyyy').format(DateTime.now()),
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.cardColor,
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                Icon(
                  Icons.notifications_none,
                  color: context.textPrimary,
                  size: 24,
                ),
                Positioned(
                  right: 2,
                  top: 2,
                  child: CircleAvatar(radius: 4, backgroundColor: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Suggested Meals',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 180,
          child: PageView.builder(
            itemCount: controller.recipes.length,
            onPageChanged: (index) =>
                controller.currentRecipeIndex.value = index,
            itemBuilder: (context, index) {
              final recipe = controller.recipes[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: recipe['color'] is int
                      ? Color(recipe['color'])
                      : const Color(0xFFCDE26D),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      bottom: 0,
                      top: 0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: recipe['image'].startsWith('http')
                            ? Image.network(
                                recipe['image'],
                                width: 160,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 160,
                                color: Colors.black.withOpacity(0.1),
                                child: const Icon(
                                  Icons.restaurant,
                                  size: 50,
                                  color: Colors.black26,
                                ),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 180,
                            child: Text(
                              recipe['title'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () => controller.viewRecipe(recipe),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  minimumSize: Size.zero,
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Details',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.recipes.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.currentRecipeIndex.value == index
                        ? const Color(0xFFCDE26D)
                        : Colors.grey[800],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    final tabs = ['Today', 'Week', '15 Days', 'Last Month'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: List.generate(
            tabs.length,
            (index) => Expanded(
              child: GestureDetector(
                onTap: () => controller.setTab(index),
                child: Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: controller.selectedTab.value == index
                          ? const Color(0xFF2A2A2A)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: controller.selectedTab.value == index
                          ? Border.all(color: Colors.white24)
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      tabs[index],
                      style: TextStyle(
                        color: controller.selectedTab.value == index
                            ? Colors.white
                            : Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyList() {
    return Obx(() {
      print(
        '🔄 LIST DEBUG - Rebuilding Weekly List, expanded: ${controller.expandedDays}',
      );
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.weeklyPlan.length,
        itemBuilder: (context, index) {
          final dayPlan = controller.weeklyPlan[index];
          // Use another Obx or ensure this one reacts to expandedDays
          return Obx(() {
            final isExpanded = controller.expandedDays.contains(index);
            return _buildDayCard(index, dayPlan, isExpanded);
          });
        },
      );
    });
  }

  Widget _buildDayCard(int index, Map<String, dynamic> plan, bool isExpanded) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            onTap: () => controller.toggleDay(index),
            title: Text(
              plan['day'],
              style: TextStyle(
                color: context.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.shopping_basket_outlined,
                      color: context.accent,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${plan['dishesCount'].toString().padLeft(2, '0')} Dishes',
                      style: TextStyle(
                        color: context.textPrimary,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  plan['summary'],
                  style: TextStyle(color: context.textSecondary, fontSize: 13),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isExpanded
                        ? const Color(0xFFCDE26D)
                        : Colors.grey[800],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: isExpanded ? Colors.black : Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.more_horiz, color: Colors.grey[400]),
              ],
            ),
          ),
          if (isExpanded && plan['meals'].isNotEmpty)
            _buildExpandedMeals(plan['meals']),
        ],
      ),
    );
  }

  Widget _buildExpandedMeals(Map<String, dynamic> meals) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 0),
      child: Column(
        children: meals.entries.map<Widget>((entry) {
          return _buildMealCategorySection(
            entry.key,
            entry.value as List<String>,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMealCategorySection(String title, List<String> dishes) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFCDE26D).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFCDE26D).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  title.toLowerCase().contains('breakfast')
                      ? Icons.restaurant_menu
                      : title.toLowerCase().contains('lunch')
                      ? Icons.lunch_dining
                      : Icons.dinner_dining,
                  color: const Color(0xFFCDE26D),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
              Text(
                '${dishes.length} items',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...dishes.map(
            (dish) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFFCDE26D),
                    size: 16,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      dish,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white24,
                    size: 12,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
