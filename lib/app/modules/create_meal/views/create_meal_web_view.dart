import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_helper.dart';
import '../../../widgets/web/web_scaffold.dart';
import '../controllers/create_meal_controller.dart';
import '../../../data/models/meal_model.dart';

class CreateMealWebView extends StatefulWidget {
  final CreateMealController controller;
  final String id;
  const CreateMealWebView({
    super.key,
    required this.controller,
    required this.id,
  });

  @override
  State<CreateMealWebView> createState() => _CreateMealWebViewState();
}

class _CreateMealWebViewState extends State<CreateMealWebView> {
  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args is MealModel) {
      widget.controller.populateForEdit(args);
    } else if (args is Map &&
        args['mode'] == 'copy' &&
        args['meal'] is MealModel) {
      widget.controller.populateForCopy(args['meal']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      title: 'Create Meal',
      maxContentWidth: 900,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: widget.controller.key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left column — meal details + nutrition
                  Expanded(
                    child: Column(
                      children: [
                        _WebCard(
                          title: 'Meal Details',
                          child: Column(
                            children: [
                              _WebField(
                                label: 'Meal Name',
                                controller:
                                    widget.controller.fullNameController,
                                hint: 'e.g. Grilled Chicken Salad',
                              ),
                              const SizedBox(height: 16),
                              _WebField(
                                label: 'Description',
                                controller:
                                    widget.controller.descriptionController,
                                hint: 'Brief description of the meal',
                                maxLines: 3,
                              ),
                              const SizedBox(height: 16),
                              _CategorySelector(controller: widget.controller),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        _WebCard(
                          title: 'Nutrition Info',
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _WebField(
                                      label: 'Calories (kcal)',
                                      controller:
                                          widget.controller.kcalController,
                                      hint: '0',
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _WebField(
                                      label: 'Protein (g)',
                                      controller:
                                          widget.controller.proteinController,
                                      hint: '0',
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _WebField(
                                      label: 'Carbs (g)',
                                      controller:
                                          widget.controller.carbsController,
                                      hint: '0',
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _WebField(
                                      label: 'Fat (g)',
                                      controller:
                                          widget.controller.fatsController,
                                      hint: '0',
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Right column — ingredients
                  Expanded(
                    child: _WebCard(
                      title: 'Ingredients',
                      child: _IngredientsSection(controller: widget.controller),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Save button
              Align(
                alignment: Alignment.centerRight,
                child: Obx(() {
                  final saving = widget.controller.isLoading.value;
                  return ElevatedButton.icon(
                    onPressed: saving
                        ? null
                        : () => widget.controller.submitUser(widget.id),
                    icon: saving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : const Icon(Icons.save_rounded, size: 18),
                    label: Text(saving ? 'Saving...' : 'Save Meal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC2D86A),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reusable web card ─────────────────────────────────────────────────────────

class _WebCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _WebCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: context.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: context.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// ── Web text field ────────────────────────────────────────────────────────────

class _WebField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType keyboardType;

  const _WebField({
    required this.label,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: context.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(color: context.textPrimary, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: context.textTertiary),
            filled: true,
            fillColor: context.backgroundColor.withValues(alpha: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.accentColor),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Category selector ─────────────────────────────────────────────────────────

class _CategorySelector extends StatelessWidget {
  final CreateMealController controller;
  const _CategorySelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: TextStyle(
            color: context.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          final cats = controller.availableCategories;
          final selected = controller.selectedCategories;
          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: cats.map((cat) {
              final active = selected.contains(cat);
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => controller.onCategoryChanged(cat, !active),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: active
                          ? context.accentColor.withValues(alpha: 0.15)
                          : context.backgroundColor.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
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
                            ? context.accentColor
                            : context.textSecondary,
                        fontSize: 12,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}

// ── Ingredients section ───────────────────────────────────────────────────────

class _IngredientsSection extends StatelessWidget {
  final CreateMealController controller;
  const _IngredientsSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final rows = controller.ingredientControllers;
      return Column(
        children: [
          ...List.generate(rows.length, (i) {
            final row = rows[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _IngredientField(
                      ctrl: row['name'] as TextEditingController,
                      hint: 'Name',
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _IngredientField(
                      ctrl: row['amount'] as TextEditingController,
                      hint: 'Amt',
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _IngredientField(
                      ctrl: row['unit'] as TextEditingController,
                      hint: 'Unit',
                    ),
                  ),
                  const SizedBox(width: 6),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => controller.removeIngredientRow(i),
                      child: Icon(
                        Icons.remove_circle_outline,
                        color: Colors.red.withValues(alpha: 0.7),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: controller.addIngredientRow,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.accentColor.withValues(alpha: 0.4),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: context.accentColor, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Add Ingredient',
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
        ],
      );
    });
  }
}

class _IngredientField extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  const _IngredientField({required this.ctrl, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      style: TextStyle(color: context.textPrimary, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: context.textTertiary, fontSize: 12),
        filled: true,
        fillColor: context.backgroundColor.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: context.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: context.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: context.accentColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
    );
  }
}
