import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/create_meal/controllers/create_meal_controller.dart';
import '../../../controllers/user_controller.dart';
import '../../../core/theme/theme_helper.dart';

import '../../../widgets/ingredient_input.dart';
import '../../../widgets/food_scan_button.dart';
import '../../../data/models/meal_model.dart';
import '../../generate_ai/views/nutrition_autofill_widget.dart';

class CreateMealPage extends StatefulWidget {
  final CreateMealController controller;
  final String id;
  const CreateMealPage({super.key, required this.controller, required this.id});

  @override
  State<CreateMealPage> createState() => _CreateMealPageState();
}

class _CreateMealPageState extends State<CreateMealPage>
    with SingleTickerProviderStateMixin {
  List<int> ingredients = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Check if we are editing or copying an existing meal
    final args = Get.arguments;
    debugPrint("CreateMealPage initialized with args: $args");
    if (args is MealModel) {
      debugPrint("Mode: Edit Normal");
      widget.controller.populateForEdit(args);
    } else if (args is Map &&
        args['mode'] == 'copy' &&
        args['meal'] is MealModel) {
      debugPrint("Mode: Copy");
      widget.controller.populateForCopy(args['meal']);
    } else {
      debugPrint("Mode: Create New (No args)");
    }

    ingredients = List.generate(
      widget.controller.ingredientControllers.length,
      (index) => index,
    );

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: context.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Modern Header
              _buildModernHeader(),

              // Content
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: widget.controller.key,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),

                            // Image Upload Section
                            _buildImageUploadSection(),

                            const SizedBox(height: 20),

                            // AI Food Scan (shown when launched in scan mode or always available)
                            _FoodScanSection(controller: widget.controller),

                            const SizedBox(height: 20),

                            // Meal Name
                            _buildSectionTitle('meal_name'.tr),
                            const SizedBox(height: 12),
                            _buildModernTextField(
                              controller: widget.controller.fullNameController,
                              hint: 'enter_meal_name'.tr,
                              icon: Icons.restaurant_menu,
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                  ? 'meal_name_required'.tr
                                  : null,
                            ),

                            const SizedBox(height: 24),

                            // Category
                            _buildSectionTitle('category'.tr, required: true),
                            const SizedBox(height: 12),
                            _buildCategorySelector(),

                            const SizedBox(height: 24),

                            // Description
                            _buildSectionTitle('description'.tr),
                            const SizedBox(height: 12),
                            _buildModernTextField(
                              controller:
                                  widget.controller.descriptionController,
                              hint: 'describe_your_meal'.tr,
                              icon: Icons.description,
                              maxLines: 3,
                            ),

                            // AI Nutrition Autofill
                            NutritionAutofillWidget(
                              descriptionController:
                                  widget.controller.descriptionController,
                              onNutritionFilled: (result) {
                                widget.controller.kcalController.text = result
                                    .calories
                                    .toStringAsFixed(0);
                                widget.controller.proteinController.text =
                                    result.protein.toStringAsFixed(1);
                                widget.controller.carbsController.text = result
                                    .carbs
                                    .toStringAsFixed(1);
                                widget.controller.fatsController.text = result
                                    .fat
                                    .toStringAsFixed(1);
                                // Disable auto-calculate so manual fields show
                                widget.controller.calculateAutomatically.value =
                                    false;
                              },
                            ),

                            const SizedBox(height: 24),

                            // Ingredients
                            _buildSectionTitle('ingredients'.tr),
                            const SizedBox(height: 12),
                            _buildIngredientsSection(),

                            const SizedBox(height: 24),

                            // Nutritional Info
                            _buildNutritionalInfoSection(),

                            const SizedBox(height: 30),

                            // Create Button
                            _buildCreateButton(),

                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: context.headerGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: context.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFC2D86A).withValues(alpha: 0.2),
                    const Color(0xFFC2D86A).withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      gradient: context.accentGradient,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Obx(
                    () => Text(
                      widget.controller.isEditing.value
                          ? 'edit_meal'.tr
                          : 'create_meal'.tr,
                      style: TextStyle(
                        color: context.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Obx(() {
      final hasImage = widget.controller.mealImage.value.isNotEmpty;
      return GestureDetector(
        onTap: widget.controller.pickAndUploadMealImage,
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 600),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: hasImage ? null : context.cardGradient,
                  image: hasImage
                      ? DecorationImage(
                          image:
                              UserController.getImageProvider(
                                widget.controller.mealImage.value,
                              ) ??
                              const AssetImage('assets/meal_placeholder.png')
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        )
                      : null,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: context.accent.withValues(alpha: 0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: context.accent.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (hasImage)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: context.isDark
                              ? Colors.black.withValues(alpha: 0.3)
                              : Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                    // Animated gradient overlay (only if no image)
                    if (!hasImage)
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  context.accent.withValues(
                                    alpha: 0.1 * _animationController.value,
                                  ),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    // Camera icon
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: context.accentGradient,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: context.accent.withValues(alpha: 0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Icon(
                            hasImage ? Icons.edit : Icons.camera_alt,
                            color: context.isDark ? Colors.black : Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          hasImage ? 'change_photo'.tr : 'add_meal_photo'.tr,
                          style: TextStyle(
                            color: context.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            shadows: [
                              Shadow(
                                color: context.isDark
                                    ? Colors.black
                                    : Colors.white.withValues(alpha: 0.5),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildSectionTitle(String title, {bool required = false}) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: context.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        if (required) ...[
          const SizedBox(width: 4),
          const Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
        ],
      ],
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: context.cardGradient,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: context.accent.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: context.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 18),
            child: Icon(
              icon,
              color: context.accent.withValues(alpha: 0.7),
              size: 22,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: controller,
              maxLines: maxLines,
              validator: validator,
              style: TextStyle(color: context.textPrimary, fontSize: 16),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: context.textTertiary, fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Obx(() {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: context.cardGradient,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: widget.controller.categoryError.value.isNotEmpty
                ? Colors.red
                : context.accent.withValues(alpha: 0.2),
            width: widget.controller.categoryError.value.isNotEmpty ? 2 : 1,
          ),
          boxShadow: widget.controller.categoryError.value.isNotEmpty
              ? [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ]
              : context.cardShadow,
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            iconColor: context.accent,
            collapsedIconColor: context.textSecondary,
            title: Obx(() {
              return Row(
                children: [
                  Icon(
                    Icons.category,
                    color: context.accent.withValues(alpha: 0.7),
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.controller.selectedCategories.isEmpty
                          ? "select_categories".tr
                          : widget.controller.selectedCategories.length == 1
                          ? widget.controller.selectedCategories.first
                          : "${widget.controller.selectedCategories.length} ${'categories_selected'.tr}",
                      style: TextStyle(
                        color: widget.controller.categoryError.value.isNotEmpty
                            ? Colors.red
                            : context.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              );
            }),
            children: [
              // Show loading indicator while group categories are loading
              // CRITICAL: Wrap entire category list in Obx for reactivity
              Obx(() {
                if (widget.controller.isLoadingCategories.value) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Color(0xFFC2D86A),
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'loading_custom_categories'.tr,
                            style: TextStyle(
                              color: context.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // Show category list (reactive to changes)
                // This Column rebuilds when availableCategories changes
                return Column(
                  children: widget.controller.availableCategories.map<Widget>((
                    category,
                  ) {
                    // Calculate selection state inside the map
                    final isSelected = widget.controller.selectedCategories
                        .contains(category);

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? LinearGradient(
                                colors: [
                                  context.accent.withValues(alpha: 0.2),
                                  context.accent.withValues(alpha: 0.1),
                                ],
                              )
                            : null,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CheckboxListTile(
                        title: Text(
                          category,
                          style: TextStyle(
                            color: isSelected
                                ? context.accent
                                : context.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        value: isSelected,
                        onChanged: (selected) {
                          widget.controller.onCategoryChanged(
                            category,
                            selected ?? false,
                          );
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        checkColor: context.isDark
                            ? Colors.black
                            : Colors.white,
                        fillColor: WidgetStateProperty.resolveWith<Color?>((
                          states,
                        ) {
                          if (states.contains(WidgetState.selected)) {
                            return context.accent;
                          }
                          return context.textTertiary;
                        }),
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildIngredientsSection() {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: ingredients.length,
          itemBuilder: (context, index) {
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 300 + (index * 100)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value,
                    child: IngredientInput(
                      index: index,
                      controller: widget.controller,
                      onRemove: () {
                        setState(() {
                          ingredients.removeAt(index);
                        });
                        widget.controller.removeIngredientRow(index);
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 16),
        _buildAddIngredientButton(),
      ],
    );
  }

  Widget _buildAddIngredientButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.accent.withValues(alpha: 0.2),
            context.accent.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: context.accent.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              ingredients.isEmpty
                  ? ingredients.insert(0, 0)
                  : ingredients.add(ingredients.length);
            });
            widget.controller.addIngredientRow();
          },
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: context.accentGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: context.isDark ? Colors.black : Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'add_ingredient'.tr,
                  style: TextStyle(
                    color: context.accent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionalInfoSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: context.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.accent.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: context.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'nutritional_information'.tr,
                  style: TextStyle(
                    color: context.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Obx(() {
                return Row(
                  children: [
                    Text(
                      'auto_calculate'.tr,
                      style: TextStyle(
                        color: context.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: widget.controller.calculateAutomatically.value,
                      onChanged: (value) {
                        widget.controller.calculateAutomatically.value = value;
                      },
                      activeTrackColor: context.accent,
                      activeThumbColor: context.textPrimary,
                      inactiveTrackColor: context.textTertiary,
                      inactiveThumbColor: context.textSecondary,
                    ),
                  ],
                );
              }),
            ],
          ),
          const SizedBox(height: 20),
          Obx(() {
            if (!widget.controller.calculateAutomatically.value) {
              return AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildNutritionField(
                            controller: widget.controller.kcalController,
                            label: 'calories'.tr,
                            icon: Icons.local_fire_department,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildNutritionField(
                            controller: widget.controller.carbsController,
                            label: 'carbs_g'.tr,
                            icon: Icons.grain,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildNutritionField(
                            controller: widget.controller.proteinController,
                            label: 'protein_g'.tr,
                            icon: Icons.fitness_center,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildNutritionField(
                            controller: widget.controller.fatsController,
                            label: 'fats_g'.tr,
                            icon: Icons.water_drop,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildNutritionField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.accent.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(color: context.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: context.textTertiary, fontSize: 12),
          prefixIcon: Icon(
            icon,
            color: context.accent.withValues(alpha: 0.7),
            size: 18,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return Obx(() {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: context.accentGradient,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: context.accent.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.controller.isLoading.value
                ? null
                : () {
                    widget.controller.submitUser(widget.id);
                  },
            borderRadius: BorderRadius.circular(28),
            child: Center(
              child: widget.controller.isLoading.value
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          context.isDark ? Colors.black : Colors.white,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: context.isDark ? Colors.black : Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          widget.controller.isEditing.value
                              ? 'update_meal'.tr
                              : 'create_meal'.tr,
                          style: TextStyle(
                            color: context.isDark ? Colors.black : Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      );
    });
  }
}

// ── Food Scan Section ─────────────────────────────────────────────────────────

class _FoodScanSection extends StatelessWidget {
  final CreateMealController controller;
  const _FoodScanSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FoodScanButton(
          onResult: (data) {
            // Auto-fill form fields from scan result
            if (data['name'] != null) {
              controller.fullNameController.text = data['name'].toString();
            }
            if (data['calories'] != null) {
              controller.kcalController.text = data['calories']
                  .toString()
                  .split('.')
                  .first;
            }
            if (data['protein'] != null) {
              controller.proteinController.text = data['protein'].toString();
            }
            if (data['carbs'] != null) {
              controller.carbsController.text = data['carbs'].toString();
            }
            if (data['fat'] != null) {
              controller.fatsController.text = data['fat'].toString();
            }
            if (data['description'] != null) {
              controller.descriptionController.text = data['description']
                  .toString();
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ ${data['name']} detected — fields filled'),
                backgroundColor: const Color(0xFF1A1A1A),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
        const SizedBox(height: 6),
        const Text(
          'Scan a food photo to auto-fill nutrition data',
          style: TextStyle(color: Colors.white38, fontSize: 11),
        ),
      ],
    );
  }
}
