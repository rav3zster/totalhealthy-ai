import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_helper.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/web/web_scaffold.dart';
import '../../../data/models/meal_model.dart';
import '../controllers/client_dashboard_controllers.dart';

class ClientDashboardWebView extends StatelessWidget {
  const ClientDashboardWebView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientDashboardControllers>();

    return WebScaffold(
      title: 'Dashboard',
      topbarActions: [_AddMealButton(controller: controller)],
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats row
              _StatsRow(controller: controller),
              const SizedBox(height: 24),

              // Group mode banner
              if (controller.isGroupMode.value)
                _GroupBanner(controller: controller),

              // Category tabs + search row
              _CategoryAndSearch(controller: controller),
              const SizedBox(height: 16),

              // Meals grid
              _MealsGrid(controller: controller),
            ],
          ),
        );
      }),
    );
  }
}

// ── Stats Row ─────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final ClientDashboardControllers controller;
  const _StatsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final stats = controller.isGroupMode.value ? controller.groupStats : {};
      final totalMeals = controller.displayMeals.length;

      return Row(
        children: [
          _StatCard(
            icon: Icons.restaurant_rounded,
            label: 'Total Meals',
            value: totalMeals.toString(),
            color: context.accentColor,
          ),
          const SizedBox(width: 16),
          _StatCard(
            icon: Icons.local_fire_department_rounded,
            label: 'Calories',
            value: stats['totalCalories'] ?? '—',
            color: Colors.orange,
          ),
          const SizedBox(width: 16),
          _StatCard(
            icon: Icons.fitness_center_rounded,
            label: 'Protein',
            value: stats['totalProtein'] ?? '—',
            color: const Color(0xFF4FC3F7),
          ),
          const SizedBox(width: 16),
          _StatCard(
            icon: Icons.auto_awesome_rounded,
            label: 'Goal',
            value: stats['goalAchieved'] ?? '—',
            color: const Color(0xFFCE93D8),
          ),
        ],
      );
    });
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: context.cardGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
          boxShadow: context.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: context.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(color: context.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Group Banner ──────────────────────────────────────────────────────────────

class _GroupBanner extends StatelessWidget {
  final ClientDashboardControllers controller;
  const _GroupBanner({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.accentColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.group_rounded, color: context.accentColor, size: 18),
          const SizedBox(width: 10),
          Text(
            'Group Mode: ${controller.selectedGroupName.value}',
            style: TextStyle(
              color: context.accentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: controller.exitGroupMode,
              child: Icon(Icons.close, color: context.textSecondary, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Category + Search ─────────────────────────────────────────────────────────

class _CategoryAndSearch extends StatelessWidget {
  final ClientDashboardControllers controller;
  const _CategoryAndSearch({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final cats = controller.categories;
      return Row(
        children: [
          // Category chips
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: cats.map((cat) {
                  final active = controller.selectedCategory.value == cat;
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => controller.changeCategory(cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: active
                              ? context.accentColor
                              : context.cardColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: active
                                ? context.accentColor
                                : context.borderColor,
                          ),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: active
                                ? Colors.black
                                : context.textSecondary,
                            fontWeight: active
                                ? FontWeight.w700
                                : FontWeight.w400,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Search
          SizedBox(
            width: 260,
            child: TextField(
              onChanged: controller.updateSearchQuery,
              style: TextStyle(color: context.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search meals...',
                hintStyle: TextStyle(color: context.textTertiary),
                prefixIcon: Icon(
                  Icons.search,
                  color: context.textSecondary,
                  size: 18,
                ),
                filled: true,
                fillColor: context.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: context.borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: context.borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: context.accentColor),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

// ── Meals Grid ────────────────────────────────────────────────────────────────

class _MealsGrid extends StatelessWidget {
  final ClientDashboardControllers controller;
  const _MealsGrid({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final meals = controller.displayMeals;

      if (controller.isLoading.value && meals.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(60),
            child: CircularProgressIndicator(color: Color(0xFFC2D86A)),
          ),
        );
      }

      if (meals.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(60),
            child: Column(
              children: [
                Icon(
                  Icons.no_meals_rounded,
                  size: 64,
                  color: context.textTertiary,
                ),
                const SizedBox(height: 16),
                Text(
                  'No meals in this category',
                  style: TextStyle(color: context.textSecondary, fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => Get.toNamed(Routes.generateAi),
                  icon: const Icon(Icons.auto_awesome_rounded, size: 16),
                  label: const Text('Generate with AI'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC2D86A),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final cols = constraints.maxWidth > 900
              ? 4
              : constraints.maxWidth > 600
              ? 3
              : 2;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: meals.length,
            itemBuilder: (context, i) => _MealCard(meal: meals[i]),
          );
        },
      );
    });
  }
}

class _MealCard extends StatefulWidget {
  final MealModel meal;
  const _MealCard({required this.meal});

  @override
  State<_MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<_MealCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => Get.toNamed(Routes.mealsDetails, arguments: widget.meal),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            gradient: context.cardGradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? context.accentColor.withValues(alpha: 0.5)
                  : context.borderColor,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: context.accentColor.withValues(alpha: 0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : context.cardShadow,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: context.accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    widget.meal.categories.isNotEmpty
                        ? widget.meal.categories.first
                        : 'Meal',
                    style: TextStyle(
                      color: context.accentColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.meal.name,
                  style: TextStyle(
                    color: context.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  widget.meal.description,
                  style: TextStyle(
                    color: context.textSecondary,
                    fontSize: 12,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                // Macros
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _Macro(
                      label: 'Cal',
                      value: widget.meal.kcal,
                      color: Colors.orange,
                    ),
                    _Macro(
                      label: 'P',
                      value: '${widget.meal.protein}g',
                      color: const Color(0xFFC2D86A),
                    ),
                    _Macro(
                      label: 'C',
                      value: '${widget.meal.carbs}g',
                      color: const Color(0xFF4FC3F7),
                    ),
                    _Macro(
                      label: 'F',
                      value: '${widget.meal.fat}g',
                      color: const Color(0xFFCE93D8),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Macro extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _Macro({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: context.textTertiary, fontSize: 10),
        ),
      ],
    );
  }
}

// ── Add Meal Button ───────────────────────────────────────────────────────────

class _AddMealButton extends StatelessWidget {
  final ClientDashboardControllers controller;
  const _AddMealButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.shouldShowAddMealButton) return const SizedBox.shrink();
      return Row(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => Get.toNamed(Routes.createMeal),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: context.accentColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add, color: context.accentColor, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Create Meal',
                      style: TextStyle(
                        color: context.accentColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => Get.toNamed(Routes.generateAi),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  gradient: context.accentGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.black,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'AI Generate',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
