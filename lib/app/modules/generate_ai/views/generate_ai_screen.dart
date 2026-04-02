import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/generate_ai_controller.dart';
import 'ai_results_screen.dart';
import 'diet_classifier_view.dart';

// ── Colour constants ──────────────────────────────────────────────────────────
const _lime = Color(0xFFC2D86A);
const _bg = Color(0xFF0A0A0A);
const _card = Color(0xFF141414);
const _input = Color(0xFF1A1A1A);
const _border = Color(0xFF2A2A2A);

class GenerateAiScreen extends GetView<GenerateAiController> {
  const GenerateAiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 17,
            ),
          ),
        ),
        title: const Text(
          'AI Meal Planner',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // subtle top glow
          Positioned(
            top: -60,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [_lime.withValues(alpha: 0.08), Colors.transparent],
                  radius: 0.8,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 70,
              left: 16,
              right: 16,
              bottom: 110,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── AI Analyser banner ──────────────────────────────────
                _AnalyserBanner(),
                const SizedBox(height: 20),

                // ── Sections ────────────────────────────────────────────
                _Section(
                  icon: Icons.flag_rounded,
                  title: 'Dietary Goals',
                  children: [
                    _SectionLabel('Goal'),
                    _GridSelector(
                      options: controller.goals,
                      selected: controller.selectedGoal,
                      onSelect: controller.selectGoal,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _InputField(
                            ctrl: controller.currentWeightController,
                            hint: 'Current weight',
                            suffix: 'kg',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _InputField(
                            ctrl: controller.targetWeightController,
                            hint: 'Target weight',
                            suffix: 'kg',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _SectionLabel('Daily Nutrition Targets'),
                    Row(
                      children: [
                        Expanded(
                          child: _InputField(
                            ctrl: controller.kcalController,
                            hint: 'Calories',
                            suffix: 'kcal',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _InputField(
                            ctrl: controller.carbsController,
                            hint: 'Carbs',
                            suffix: 'g',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _InputField(
                            ctrl: controller.proteinController,
                            hint: 'Protein',
                            suffix: 'g',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _InputField(
                            ctrl: controller.fatsController,
                            hint: 'Fats',
                            suffix: 'g',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                _Section(
                  icon: Icons.restaurant_rounded,
                  title: 'Diet & Restrictions',
                  children: [
                    _SectionLabel('Diet Type'),
                    _GridSelector(
                      options: controller.dietTypes,
                      selected: controller.dietType,
                      onSelect: controller.selectDietType,
                    ),
                    const SizedBox(height: 16),
                    _SectionLabel('Food Allergies'),
                    _MultiSelectGrid(
                      options: controller.allergies,
                      selected: controller.selectedAllergies,
                      onToggle: controller.toggleAllergy,
                    ),
                    const SizedBox(height: 16),
                    _SectionLabel('Preferred Cuisine'),
                    _GridSelector(
                      options: controller.cuisines,
                      selected: controller.preferredCuisine,
                      onSelect: controller.selectCuisine,
                    ),
                  ],
                ),

                _Section(
                  icon: Icons.dinner_dining_rounded,
                  title: 'Meal Preferences',
                  children: [
                    _SectionLabel('Meals Per Day'),
                    _MealCounter(controller: controller),
                    const SizedBox(height: 16),
                    _SectionLabel('Meal Types'),
                    _MultiSelectGrid(
                      options: controller.mealTypesList,
                      selected: controller.selectedMealTypes,
                      onToggle: controller.toggleMealType,
                    ),
                    const SizedBox(height: 16),
                    _InputField(
                      ctrl: controller.specificFoodsController,
                      hint: 'Foods to include (e.g. chicken, oats)',
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    _InputField(
                      ctrl: controller.foodsToAvoidController,
                      hint: 'Foods to avoid',
                      maxLines: 2,
                    ),
                  ],
                ),

                _Section(
                  icon: Icons.fitness_center_rounded,
                  title: 'Physical Activity',
                  children: [
                    _SectionLabel('Exercise Frequency'),
                    _GridSelector(
                      options: controller.exerciseFrequencies,
                      selected: controller.exerciseFrequency,
                      onSelect: controller.selectFrequency,
                    ),
                    const SizedBox(height: 16),
                    _SectionLabel('Exercise Type'),
                    _GridSelector(
                      options: controller.exerciseTypes,
                      selected: controller.exerciseType,
                      onSelect: controller.selectExerciseType,
                    ),
                    const SizedBox(height: 16),
                    _SectionLabel('Pre/Post Workout Nutrition'),
                    Row(
                      children: [
                        Expanded(
                          child: _RadioTile(
                            label: 'Yes',
                            groupValue: controller.prePostWorkoutNutrition,
                            onTap: () =>
                                controller.selectPrePostNutrition('Yes'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _RadioTile(
                            label: 'No',
                            groupValue: controller.prePostWorkoutNutrition,
                            onTap: () =>
                                controller.selectPrePostNutrition('No'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                _Section(
                  icon: Icons.info_outline_rounded,
                  title: 'Additional Info',
                  children: [
                    _InputField(
                      ctrl: controller.medicalConditionController,
                      hint: 'Medical conditions (optional)',
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    _DatePickerField(controller: controller),
                    const SizedBox(height: 10),
                    _InputField(
                      ctrl: controller.specialInstructionsController,
                      hint: 'Special instructions (optional)',
                      maxLines: 3,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Sticky generate button ──────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _GenerateButton(controller: controller),
          ),
        ],
      ),
    );
  }
}

// ── AI Analyser Banner ────────────────────────────────────────────────────────

class _AnalyserBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => const DietClassifierView()),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _lime.withValues(alpha: 0.12),
              _lime.withValues(alpha: 0.04),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _lime.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _lime.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.analytics_rounded,
                color: _lime,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Diet Analyser',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Get your BMI, TDEE & personalised diet type',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _lime.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: _lime,
                size: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section card ──────────────────────────────────────────────────────────────

class _Section extends StatefulWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;
  const _Section({
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  State<_Section> createState() => _SectionState();
}

class _SectionState extends State<_Section> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _lime.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(widget.icon, color: _lime, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Colors.white38,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: Colors.white.withValues(alpha: 0.06),
                    height: 1,
                  ),
                  const SizedBox(height: 14),
                  ...widget.children,
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.6),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── Input field ───────────────────────────────────────────────────────────────

class _InputField extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final String? suffix;
  final int maxLines;
  final TextInputType keyboardType;

  const _InputField({
    required this.ctrl,
    required this.hint,
    this.suffix,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _input,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: TextField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.3),
            fontSize: 14,
          ),
          suffixText: suffix,
          suffixStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 13,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
        ),
      ),
    );
  }
}

// ── Grid selector (single select) ────────────────────────────────────────────

class _GridSelector extends StatelessWidget {
  final List<String> options;
  final RxString selected;
  final Function(String) onSelect;

  const _GridSelector({
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        return Obx(() {
          final isSelected = selected.value == opt;
          return GestureDetector(
            onTap: () => onSelect(opt),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: isSelected ? _lime.withValues(alpha: 0.15) : _input,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? _lime.withValues(alpha: 0.6) : _border,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Text(
                opt,
                style: TextStyle(
                  color: isSelected ? _lime : Colors.white54,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        });
      }).toList(),
    );
  }
}

// ── Multi-select grid ─────────────────────────────────────────────────────────

class _MultiSelectGrid extends StatelessWidget {
  final List<String> options;
  final RxList<String> selected;
  final Function(String) onToggle;

  const _MultiSelectGrid({
    required this.options,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        return Obx(() {
          final isSelected = selected.contains(opt);
          return GestureDetector(
            onTap: () => onToggle(opt),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: isSelected ? _lime.withValues(alpha: 0.15) : _input,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? _lime.withValues(alpha: 0.6) : _border,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: isSelected ? _lime : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isSelected ? _lime : Colors.white30,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check_rounded,
                            size: 11,
                            color: Colors.black,
                          )
                        : null,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    opt,
                    style: TextStyle(
                      color: isSelected ? _lime : Colors.white54,
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      }).toList(),
    );
  }
}

// ── Meal counter ──────────────────────────────────────────────────────────────

class _MealCounter extends StatelessWidget {
  final GenerateAiController controller;
  const _MealCounter({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: _input,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _border),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: controller.decrementMeals,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _border),
                ),
                child: const Icon(
                  Icons.remove_rounded,
                  color: Colors.white70,
                  size: 18,
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    controller.mealsPerDay.value.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'meals per day',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: controller.incrementMeals,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: _lime.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _lime.withValues(alpha: 0.4)),
                ),
                child: const Icon(Icons.add_rounded, color: _lime, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Radio tile ────────────────────────────────────────────────────────────────

class _RadioTile extends StatelessWidget {
  final String label;
  final RxString groupValue;
  final VoidCallback onTap;
  const _RadioTile({
    required this.label,
    required this.groupValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = groupValue.value == label;
      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: isSelected ? _lime.withValues(alpha: 0.12) : _input,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? _lime.withValues(alpha: 0.5) : _border,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? _lime : Colors.white54,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
      );
    });
  }
}

// ── Date picker ───────────────────────────────────────────────────────────────

class _DatePickerField extends StatelessWidget {
  final GenerateAiController controller;
  const _DatePickerField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final date = controller.preferredStartDate.value;
      return GestureDetector(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            builder: (ctx, child) => Theme(
              data: Theme.of(ctx).copyWith(
                colorScheme: const ColorScheme.dark(
                  primary: _lime,
                  onPrimary: Colors.black,
                  surface: Color(0xFF1E1E1E),
                  onSurface: Colors.white,
                ),
              ),
              child: child!,
            ),
          );
          if (picked != null) controller.selectDate(picked);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: _input,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: date != null ? _lime.withValues(alpha: 0.4) : _border,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                color: date != null ? _lime : Colors.white38,
                size: 18,
              ),
              const SizedBox(width: 10),
              Text(
                date != null
                    ? DateFormat('MMM dd, yyyy').format(date)
                    : 'Preferred start date (optional)',
                style: TextStyle(
                  color: date != null
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.3),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

// ── Generate button ───────────────────────────────────────────────────────────

class _GenerateButton extends StatelessWidget {
  final GenerateAiController controller;
  const _GenerateButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: _bg,
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: Obx(() {
        final generating = controller.isGenerating.value;
        return GestureDetector(
          onTap: generating
              ? null
              : () {
                  Get.to(
                    () => AiResultsScreen(controller: controller),
                    transition: Transition.fadeIn,
                    preventDuplicates: true,
                  );
                  Future.microtask(controller.generatePlan);
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 54,
            decoration: BoxDecoration(
              gradient: generating
                  ? null
                  : const LinearGradient(
                      colors: [Color(0xFFD4EF7A), _lime],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              color: generating ? _lime.withValues(alpha: 0.3) : null,
              borderRadius: BorderRadius.circular(16),
              boxShadow: generating
                  ? null
                  : [
                      BoxShadow(
                        color: _lime.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Center(
              child: generating
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.black,
                      ),
                    )
                  : const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.auto_awesome_rounded,
                          color: Colors.black,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Generate My Meal Plan',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      }),
    );
  }
}
