import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:totalhealthy/app/modules/meals_details/controllers/meals_details_controller.dart';
import '../../../controllers/user_controller.dart';

class MealsDetailsPage extends StatefulWidget {
  final String id;
  final MealsDetailsController controller;

  const MealsDetailsPage({
    super.key,
    required this.id,
    required this.controller,
  });

  @override
  State<MealsDetailsPage> createState() => _MealsDetailsPageState();
}

class _MealsDetailsPageState extends State<MealsDetailsPage> {
  Map<String, dynamic> recipeData = {};
  final GetStorage box = GetStorage();

  @override
  void initState() {
    super.initState();
    recipeData = box.read('mealdetails') ?? {};
  }

  @override
  Widget build(BuildContext context) {
    if (recipeData.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Color(0xFF1A1A1A), Colors.black],
              stops: [0.0, 0.3, 1.0],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Color(0xFFC2D86A)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
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
              // Header with back button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFC2D86A,
                            ).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                          size: 20,
                        ),
                        onPressed: () => Get.back(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Meal Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Meal Image and Basic Info Card
                        _buildMealCard(),

                        const SizedBox(height: 24),

                        // Nutritional Information Card
                        _buildNutritionCard(),

                        const SizedBox(height: 24),

                        // Ingredients Section
                        _buildIngredientsCard(),

                        const SizedBox(height: 24),

                        // Description Section (if available)
                        if (recipeData['description'] != null &&
                            recipeData['description'].toString().isNotEmpty)
                          _buildDescriptionCard(),

                        const SizedBox(height: 50),
                      ],
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

  Widget _buildMealCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
        ),
        borderRadius: BorderRadius.circular(24),
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
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Meal Image
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFC2D86A).withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image(
                  image:
                      UserController.getImageProvider(
                        recipeData['imageUrl']?.toString() ?? '',
                      ) ??
                      const AssetImage('assets/meal_placeholder.png')
                          as ImageProvider,
                  width: 180,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.restaurant_menu,
                        color: Color(0xFFC2D86A),
                        size: 60,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Meal Name
            Text(
              "${recipeData['name'] ?? 'Meal Name'}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Category Tags
            if (recipeData['categories'] != null &&
                (recipeData['categories'] as List).isNotEmpty)
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: (recipeData['categories'] as List)
                    .map(
                      (category) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFC2D86A).withValues(alpha: 0.2),
                              const Color(0xFFC2D86A).withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(
                              0xFFC2D86A,
                            ).withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          category.toString(),
                          style: const TextStyle(
                            color: Color(0xFFC2D86A),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

            const SizedBox(height: 24),

            // Quick Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(
                  Icons.local_fire_department,
                  "${recipeData['kcal'] ?? '0'}",
                  "Kcal",
                  Colors.orange,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                _buildStatItem(
                  Icons.access_time_filled,
                  "30",
                  "min",
                  const Color(0xFFC2D86A),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                _buildStatItem(
                  Icons.restaurant_menu,
                  "${(recipeData['ingredients'] as List?)?.length ?? 0}",
                  "Items",
                  const Color(0xFFC2D86A),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
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
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.analytics_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Nutrition Facts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildNutrientCard(
                    "Protein",
                    "${recipeData['protein'] ?? '0'}g",
                    const Color(0xFFC2D86A), // Theme Lime
                    Icons.fitness_center,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNutrientCard(
                    "Fat",
                    "${recipeData['fat'] ?? '0'}g",
                    const Color(0xFF4FC3F7), // Sky Blue
                    Icons.water_drop,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildNutrientCard(
                    "Carbs",
                    "${recipeData['carbs'] ?? '0'}g",
                    const Color(0xFFFFB74D), // Soft Orange
                    Icons.grain,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientsCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
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
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.restaurant,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Ingredients',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (recipeData['ingredients'] != null &&
                (recipeData['ingredients'] as List).isNotEmpty)
              ...List.generate((recipeData['ingredients'] as List).length, (
                index,
              ) {
                var ingredient = recipeData['ingredients'][index];
                return _buildIngredientItem(
                  "${ingredient['name'] ?? 'Ingredient'}",
                  "${ingredient['amount'] ?? '0'}",
                );
              })
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text(
                    'No ingredients listed',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
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
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Description',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              "${recipeData['description']}",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 15,
                height: 1.6,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildNutrientCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientItem(String name, String amount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF333333).withValues(alpha: 0.5),
            const Color(0xFF2A2A2A).withValues(alpha: 0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFC2D86A).withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
              ),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.3,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              "${amount}g",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
