import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/generate_ai_controller.dart';
import '../../../services/ai_service.dart';

class AiResultsScreen extends StatelessWidget {
  final GenerateAiController controller;
  const AiResultsScreen({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Your AI Meal Plan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Obx(
            () => controller.hasResult.value
                ? IconButton(
                    icon: const Icon(Icons.refresh, color: Color(0xFFC2D86A)),
                    tooltip: 'Regenerate',
                    onPressed: controller.generatePlan,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isGenerating.value) return const _ShimmerLoading();

        if (!controller.hasResult.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value.isEmpty
                      ? 'No results yet'
                      : controller.errorMessage.value,
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: controller.generatePlan,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC2D86A),
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            // AI badge
            Container(
              margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFC2D86A).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFC2D86A).withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    color: Color(0xFFC2D86A),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AI generated based on your fitness profile',
                    style: TextStyle(
                      color: const Color(0xFFC2D86A).withValues(alpha: 0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Meal cards
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.generatedMeals.length,
                itemBuilder: (context, i) {
                  return _MealCard(
                    meal: controller.generatedMeals[i],
                    index: i,
                  );
                },
              ),
            ),

            // Bottom action bar
            _BottomBar(controller: controller),
          ],
        );
      }),
    );
  }
}

// ── Meal Card ─────────────────────────────────────────────────────────────────

class _MealCard extends StatefulWidget {
  final AiGeneratedMeal meal;
  final int index;
  const _MealCard({required this.meal, required this.index});

  @override
  State<_MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<_MealCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _fade;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400 + widget.index * 80),
    );
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meal = widget.meal;
    return FadeTransition(
      opacity: _fade,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFC2D86A).withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC2D86A).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      meal.category,
                      style: const TextStyle(
                        color: Color(0xFFC2D86A),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      meal.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (meal.bestTime.isNotEmpty)
                    Text(
                      meal.bestTime,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),

            // Nutrition row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NutrientBadge(
                    label: 'Cal',
                    value: '${meal.calories.toStringAsFixed(0)}',
                    color: Colors.orange,
                  ),
                  _NutrientBadge(
                    label: 'Protein',
                    value: '${meal.protein.toStringAsFixed(1)}g',
                    color: const Color(0xFFC2D86A),
                  ),
                  _NutrientBadge(
                    label: 'Carbs',
                    value: '${meal.carbs.toStringAsFixed(1)}g',
                    color: Colors.blue,
                  ),
                  _NutrientBadge(
                    label: 'Fat',
                    value: '${meal.fat.toStringAsFixed(1)}g',
                    color: Colors.purple,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Description
            if (meal.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  meal.description,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),

            // Ingredients toggle
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.restaurant_menu,
                      color: Colors.white38,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${meal.ingredients.length} ingredients',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.white38,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),

            if (_expanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: meal.ingredients
                      .map(
                        (ing) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            ing,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NutrientBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _NutrientBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 11),
        ),
      ],
    );
  }
}

// ── Bottom action bar ─────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final GenerateAiController controller;
  const _BottomBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        children: [
          // Regenerate
          Expanded(
            child: OutlinedButton.icon(
              onPressed: controller.generatePlan,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Regenerate'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFC2D86A),
                side: const BorderSide(color: Color(0xFFC2D86A)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Save
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: controller.saveAllMeals,
              icon: const Icon(Icons.save_alt, size: 18),
              label: const Text(
                'Save Meals',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC2D86A),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shimmer loading ───────────────────────────────────────────────────────────

class _ShimmerLoading extends StatefulWidget {
  const _ShimmerLoading();

  @override
  State<_ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<_ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _shimmer = Tween<double>(
      begin: -1,
      end: 2,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        const _AiThinkingBadge(),
        const SizedBox(height: 20),
        Expanded(
          child: AnimatedBuilder(
            animation: _shimmer,
            builder: (context, _) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 3,
                itemBuilder: (_, i) =>
                    _ShimmerCard(shimmerValue: _shimmer.value),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AiThinkingBadge extends StatelessWidget {
  const _AiThinkingBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFC2D86A).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFFC2D86A),
            ),
          ),
          SizedBox(width: 10),
          Text(
            'AI is crafting your personalised meal plan...',
            style: TextStyle(color: Color(0xFFC2D86A), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  final double shimmerValue;
  const _ShimmerCard({required this.shimmerValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment(shimmerValue - 1, 0),
          end: Alignment(shimmerValue, 0),
          colors: const [
            Color(0xFF1A1A1A),
            Color(0xFF2A2A2A),
            Color(0xFF1A1A1A),
          ],
        ),
      ),
    );
  }
}
