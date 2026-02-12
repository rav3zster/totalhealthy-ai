import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/meal_model.dart';
import '../controllers/meal_history_controller.dart';

class MealHistoryPage extends GetView<MealHistoryController> {
  const MealHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildNewHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    _buildDietGoalTitle(),
                    const SizedBox(height: 20),
                    _buildCategoryTabs(),
                    const SizedBox(height: 24),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFC2D86A),
                          ),
                        );
                      }
                      if (controller.filteredMeals.isEmpty) {
                        return _buildEmptyState();
                      }
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.filteredMeals.length,
                        itemBuilder: (context, index) {
                          final meal = controller.filteredMeals[index];
                          return _buildCompactMealCard(meal);
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildContinueButton(),
    );
  }

  Widget _buildNewHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Get.back(),
          ),
          Expanded(
            child: Obx(
              () => Text(
                "${controller.userName.value}’s Existing Diet Plan",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 48), // Spacer to balance the leading icon
        ],
      ),
    );
  }

  Widget _buildDietGoalTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(
          () => Text(
            "Diet Plan (${controller.dietGoal.value})",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFC2D86A),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.add, color: Colors.black, size: 18),
              SizedBox(width: 4),
              Text(
                "Add Meal",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    final categories = ['Breakfast', 'Lunch', 'Dinner'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          return Obx(() {
            final isSelected = controller.selectedCategory.value == cat;
            return GestureDetector(
              onTap: () => controller.setCategory(cat),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.transparent
                      : const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFC2D86A)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(
                              0xFFC2D86A,
                            ).withValues(alpha: 0.3),
                            blurRadius: 10,
                            spreadRadius: -2,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      cat == 'Breakfast'
                          ? Icons.restaurant
                          : cat == 'Lunch'
                          ? Icons.lunch_dining
                          : Icons.dinner_dining,
                      color: isSelected
                          ? const Color(0xFFC2D86A)
                          : Colors.white54,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      cat,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white54,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        }).toList(),
      ),
    );
  }

  Widget _buildCompactMealCard(MealModel meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meal Image/Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildMealImage(meal.imageUrl),
                ),
              ),
              const SizedBox(width: 12),

              // Name and Kcal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
                      style: const TextStyle(
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
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "${meal.kcal} Kcal",
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text("•", style: TextStyle(color: Colors.grey)),
                        const SizedBox(width: 8),
                        const Text(
                          "100g", // Placeholder for weight as per screenshot
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Add/Remove circular button
              Obx(() {
                final isSelected = controller.selectedMealIds.contains(meal.id);
                return GestureDetector(
                  onTap: () => controller.toggleMealSelection(meal.id),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC2D86A),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isSelected ? Icons.remove : Icons.add,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 20),

          // Macros segments
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMacroSegment(
                "${meal.protein}g",
                "Protein",
                const Color(0xFF43A047),
              ),
              _buildMacroSegment(
                "${meal.fat}g",
                "Fat",
                const Color(0xFF1E88E5),
              ),
              _buildMacroSegment(
                "${meal.carbs}g",
                "Carbs",
                const Color(0xFFE53935),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroSegment(String value, String label, Color color) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: const TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: controller.continueSelection,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC2D86A),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            elevation: 0,
          ),
          child: const Text(
            "Continue",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.restaurant_menu, color: Colors.white24, size: 48),
          const SizedBox(height: 16),
          Text(
            "No meals available in ${controller.selectedCategory.value}",
            style: const TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildMealImage(String imageUrl) {
    if (imageUrl.isEmpty) {
      return const Icon(Icons.restaurant, color: Color(0xFFC2D86A), size: 24);
    }

    if (imageUrl.startsWith('data:image') || !imageUrl.startsWith('http')) {
      try {
        // Handle potential base64 strings
        String base64String = imageUrl;
        if (base64String.contains(',')) {
          base64String = base64String.split(',').last;
        }
        return Image.memory(
          base64.decode(base64String.trim()),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, color: Colors.redAccent, size: 24),
        );
      } catch (e) {
        return const Icon(
          Icons.broken_image,
          color: Colors.redAccent,
          size: 24,
        );
      }
    }

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.broken_image, color: Colors.white24, size: 24),
    );
  }
}
