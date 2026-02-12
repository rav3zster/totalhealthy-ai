import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/generate_ai_controller.dart';

class GenerateAiScreen extends GetView<GenerateAiController> {
  const GenerateAiScreen({super.key});

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
          'Creating A Meal',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dietary Goals Section
            _buildSection(
              title: 'Dietary Goals',
              children: [
                _buildLabel('Goal'),
                _buildGridSelector(
                  options: controller.goals,
                  selectedOption: controller.selectedGoal,
                  onSelect: controller.selectGoal,
                  crossAxisCount: 2,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildInput(
                        controller: controller.currentWeightController,
                        label: 'Current Weight',
                        hint: 'Weight',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInput(
                        controller: controller.targetWeightController,
                        label: 'Target Weight',
                        hint: 'Weight',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildLabel('Nutritional Breakdown'),
                Row(
                  children: [
                    Expanded(
                      child: _buildInput(
                        controller: controller.kcalController,
                        hint: 'kcal',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInput(
                        controller: controller.carbsController,
                        hint: 'Carbs (grams)',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInput(
                        controller: controller.proteinController,
                        hint: 'Protein (grams)',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInput(
                        controller: controller.fatsController,
                        hint: 'Fats (grams)',
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Diet Preference And Restriction Section
            _buildSection(
              title: 'Diet Preference And Restriction',
              children: [
                _buildLabel('Diet Type'),
                _buildGridSelector(
                  options: controller.dietTypes,
                  selectedOption: controller.dietType,
                  onSelect: controller.selectDietType,
                  crossAxisCount: 2,
                ),
                const SizedBox(height: 16),
                _buildLabel('Food Allergies'),
                _buildMultiSelectGrid(
                  options: controller.allergies,
                  selectedOptions: controller.selectedAllergies,
                  onToggle: controller.toggleAllergy,
                ),
                const SizedBox(height: 16),
                _buildLabel('Preferred Cuisine'),
                _buildGridSelector(
                  options: controller.cuisines,
                  selectedOption: controller.preferredCuisine,
                  onSelect: controller.selectCuisine,
                  crossAxisCount: 2,
                ),
              ],
            ),

            // Meal Preference Section
            _buildSection(
              title: 'Meal Preference',
              children: [
                _buildLabel('Number Of Meals Per Day'),
                _buildCounter(),
                const SizedBox(height: 16),
                _buildLabel('Meal Types'),
                _buildMultiSelectGrid(
                  options: controller.mealTypesList,
                  selectedOptions: controller.selectedMealTypes,
                  onToggle: controller.toggleMealType,
                ),
                const SizedBox(height: 16),
                _buildLabel('Specific Foods To Include'),
                _buildInput(
                  controller: controller.specificFoodsController,
                  hint: 'Note',
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                _buildLabel('Foods To Avoid'),
                _buildInput(
                  controller: controller.foodsToAvoidController,
                  hint: 'Note',
                  maxLines: 3,
                ),
              ],
            ),

            // Physical Activity Section
            _buildSection(
              title: 'Physical Activity',
              children: [
                _buildLabel('Exercise Frequency'),
                _buildGridSelector(
                  options: controller.exerciseFrequencies,
                  selectedOption: controller.exerciseFrequency,
                  onSelect: controller.selectFrequency,
                  crossAxisCount: 2,
                ),
                const SizedBox(height: 16),
                _buildLabel('Types Of Exercise'),
                _buildGridSelector(
                  options: controller.exerciseTypes,
                  selectedOption: controller.exerciseType,
                  onSelect: controller.selectExerciseType,
                  crossAxisCount: 2,
                ),
                const SizedBox(height: 16),
                _buildLabel('Pre/Post Workout Nutrition'),
                Row(
                  children: [
                    Expanded(
                      child: _buildRadioButton(
                        'Yes',
                        controller.prePostWorkoutNutrition,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildRadioButton(
                        'No',
                        controller.prePostWorkoutNutrition,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Additional Info Section
            _buildSection(
              title: 'Additional Info',
              children: [
                _buildLabel('Any Medical Condition'),
                _buildInput(
                  controller: controller.medicalConditionController,
                  hint: 'Text',
                  maxLines: 2, // Slightly taller
                ),
                const SizedBox(height: 16),
                _buildLabel('Preferred Start Date'),
                _buildDatePicker(context),
                const SizedBox(height: 16),
                _buildLabel('Special Instructions'),
                _buildInput(
                  controller: controller.specialInstructionsController,
                  hint: 'Note',
                  maxLines: 4,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Generate Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: controller.generatePlan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC2D86A), // Lime Green
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Generate Using AI',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Theme(
      data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFFC2D86A), // Lime Green
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconColor: const Color(0xFFC2D86A),
        collapsedIconColor: const Color(0xFFC2D86A),
        childrenPadding: EdgeInsets.zero,
        tilePadding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    String? label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) _buildLabel(label),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E), // Dark Grey
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 14,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridSelector({
    required List<String> options,
    required RxString selectedOption,
    required Function(String) onSelect,
    int crossAxisCount = 2,
  }) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 3.5, // Wide buttons
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        return Obx(() {
          final isSelected = selectedOption.value == option;
          return GestureDetector(
            onTap: () => onSelect(option),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: const Color(0xFFC2D86A), width: 1.5)
                    : null,
              ),
              child: Text(
                option,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: isSelected ? 1.0 : 0.6),
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildMultiSelectGrid({
    required List<String> options,
    required RxList<String> selectedOptions,
    required Function(String) onToggle,
  }) {
    return GridView.builder(
      physics:
          const NeverScrollableScrollPhysics(), // Important inside ScrollView
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        return Obx(() {
          final isSelected = selectedOptions.contains(option);
          return GestureDetector(
            onTap: () => onToggle(option),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: const Color(0xFFC2D86A), width: 1.5)
                    : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFC2D86A)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFC2D86A)
                            : Colors.grey,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 16, color: Colors.black)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        color: Colors.white.withValues(
                          alpha: isSelected ? 1.0 : 0.6,
                        ),
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _buildCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Decrement
            IconButton(
              onPressed: controller.decrementMeals,
              icon: const Icon(
                Icons.arrow_downward,
                color: Colors.white,
              ), // Using arrow icon as in screenshot
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),

            // Value
            Text(
              controller.mealsPerDay.value.toString().padLeft(2, '0'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Increment
            IconButton(
              onPressed: controller.incrementMeals,
              icon: const Icon(Icons.arrow_upward, color: Color(0xFFC2D86A)),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioButton(String label, RxString groupValue) {
    return Obx(() {
      final isSelected = groupValue.value == label;
      return GestureDetector(
        onTap: () => controller.selectPrePostNutrition(label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: const Color(0xFFC2D86A), width: 1.5)
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: isSelected ? 1.0 : 0.6),
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDatePicker(BuildContext context) {
    return Obx(() {
      final date = controller.preferredStartDate.value;
      final dateString = date != null
          ? DateFormat('MM/dd/yyyy').format(date)
          : 'Date';

      return GestureDetector(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: Color(0xFFC2D86A),
                    onPrimary: Colors.black,
                    surface: Color(0xFF1E1E1E),
                    onSurface: Colors.white,
                  ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null) controller.selectDate(picked);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateString,
                style: TextStyle(
                  color: Colors.white.withValues(
                    alpha: date != null ? 1.0 : 0.4,
                  ),
                  fontSize: 14,
                ),
              ),
              Icon(
                Icons.calendar_today,
                size: 18,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      );
    });
  }
}
