import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/create_meal/controllers/create_meal_controller.dart';
import '../../../controllers/user_controller.dart';

import '../../../widgets/ingredient_input.dart';

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
        decoration: const BoxDecoration(
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

                            const SizedBox(height: 30),

                            // Meal Name
                            _buildSectionTitle('Meal Name'),
                            const SizedBox(height: 12),
                            _buildModernTextField(
                              controller: widget.controller.fullNameController,
                              hint: 'Enter meal name',
                              icon: Icons.restaurant_menu,
                            ),

                            const SizedBox(height: 24),

                            // Category
                            _buildSectionTitle('Category', required: true),
                            const SizedBox(height: 12),
                            _buildCategorySelector(),

                            const SizedBox(height: 24),

                            // Description
                            _buildSectionTitle('Description'),
                            const SizedBox(height: 12),
                            _buildModernTextField(
                              controller:
                                  widget.controller.descriptionController,
                              hint: 'Describe your meal',
                              icon: Icons.description,
                              maxLines: 3,
                            ),

                            const SizedBox(height: 24),

                            // Ingredients
                            _buildSectionTitle('Ingredients'),
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
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
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
                      gradient: const LinearGradient(
                        colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Create Meal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
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
                  gradient: hasImage
                      ? null
                      : LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF2A2A2A).withValues(alpha: 0.8),
                            const Color(0xFF1A1A1A).withValues(alpha: 0.8),
                          ],
                        ),
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
                    color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFC2D86A).withValues(alpha: 0.1),
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
                          color: Colors.black.withValues(alpha: 0.3),
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
                                  const Color(0xFFC2D86A).withValues(
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
                            gradient: const LinearGradient(
                              colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFC2D86A,
                                ).withValues(alpha: 0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Icon(
                            hasImage ? Icons.edit : Icons.camera_alt,
                            color: Colors.black,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          hasImage ? 'Change Photo' : 'Add Meal Photo',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                blurRadius: 4,
                                offset: Offset(0, 2),
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
          style: const TextStyle(
            color: Colors.white,
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
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFC2D86A).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.4),
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFFC2D86A).withValues(alpha: 0.7),
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Obx(() {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: widget.controller.categoryError.value.isNotEmpty
                ? Colors.red
                : const Color(0xFFC2D86A).withValues(alpha: 0.2),
            width: widget.controller.categoryError.value.isNotEmpty ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: widget.controller.categoryError.value.isNotEmpty
                  ? Colors.red.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            iconColor: const Color(0xFFC2D86A),
            collapsedIconColor: Colors.white54,
            title: Obx(() {
              return Row(
                children: [
                  Icon(
                    Icons.category,
                    color: const Color(0xFFC2D86A).withValues(alpha: 0.7),
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.controller.selectedCategories.isEmpty
                          ? "Select Categories"
                          : widget.controller.selectedCategories.length == 1
                          ? widget.controller.selectedCategories.first
                          : "${widget.controller.selectedCategories.length} categories selected",
                      style: TextStyle(
                        color: widget.controller.categoryError.value.isNotEmpty
                            ? Colors.red
                            : Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              );
            }),
            children: widget.controller.categories.map<Widget>((category) {
              return Obx(() {
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
                              const Color(0xFFC2D86A).withValues(alpha: 0.2),
                              const Color(0xFFC2D86A).withValues(alpha: 0.1),
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
                            ? const Color(0xFFC2D86A)
                            : Colors.white70,
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
                    checkColor: Colors.black,
                    fillColor: WidgetStateProperty.resolveWith<Color?>((
                      states,
                    ) {
                      if (states.contains(WidgetState.selected)) {
                        return const Color(0xFFC2D86A);
                      }
                      return Colors.white24;
                    }),
                  ),
                );
              });
            }).toList(),
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
            const Color(0xFFC2D86A).withValues(alpha: 0.2),
            const Color(0xFFC2D86A).withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
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
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.black, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Add Ingredient',
                  style: TextStyle(
                    color: Color(0xFFC2D86A),
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2A2A2A).withValues(alpha: 0.8),
            const Color(0xFF1A1A1A).withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFC2D86A).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Nutritional Information',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Obx(() {
                return Row(
                  children: [
                    Text(
                      'Auto Calculate',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Switch(
                      value: widget.controller.calculateAutomatically.value,
                      onChanged: (value) {
                        widget.controller.calculateAutomatically.value = value;
                      },
                      activeTrackColor: const Color(0xFFC2D86A),
                      activeThumbColor: Colors.white,
                      inactiveTrackColor: Colors.white24,
                      inactiveThumbColor: Colors.white54,
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
                            label: 'Calories',
                            icon: Icons.local_fire_department,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildNutritionField(
                            controller: widget.controller.carbsController,
                            label: 'Carbs (g)',
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
                            label: 'Protein (g)',
                            icon: Icons.fitness_center,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildNutritionField(
                            controller: widget.controller.fatsController,
                            label: 'Fats (g)',
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
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFC2D86A).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 12,
          ),
          prefixIcon: Icon(
            icon,
            color: const Color(0xFFC2D86A).withValues(alpha: 0.7),
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
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFC2D86A).withValues(alpha: 0.4),
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
                    widget.controller.submitUser(context, widget.id);
                  },
            borderRadius: BorderRadius.circular(28),
            child: Center(
              child: widget.controller.isLoading.value
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, color: Colors.black, size: 24),
                        SizedBox(width: 12),
                        Text(
                          'Create Meal',
                          style: TextStyle(
                            color: Colors.black,
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
