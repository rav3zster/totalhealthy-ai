import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/generate_ai_controller.dart';
import '../../../data/services/dummy_data_service.dart';

class GenerateAiScreen extends GetView<GenerateAiController> {
  const GenerateAiScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'AI Diet Generator',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF242522),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.smart_toy,
                    size: 60,
                    color: Color(0xFFF5D657),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'AI-Powered Diet Planning',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Get personalized meal recommendations based on your goals and preferences',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Preferences Section
            Text(
              'Your Preferences',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            
            // Goal Selection
            _buildPreferenceCard(
              'Primary Goal',
              ['Weight Loss', 'Muscle Gain', 'Maintenance', 'Endurance'],
              'Weight Loss',
            ),
            
            SizedBox(height: 16),
            
            // Diet Type
            _buildPreferenceCard(
              'Diet Type',
              ['Balanced', 'Low Carb', 'High Protein', 'Vegetarian', 'Vegan'],
              'Balanced',
            ),
            
            SizedBox(height: 16),
            
            // Activity Level
            _buildPreferenceCard(
              'Activity Level',
              ['Sedentary', 'Light', 'Moderate', 'Active', 'Very Active'],
              'Moderate',
            ),
            
            SizedBox(height: 24),
            
            // Generate Button
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _generateDietPlan(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF5D657),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      'Generate AI Diet Plan',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Sample Recommendations
            Text(
              'Sample Recommendations',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            
            ...DummyDataService.getDummyMeals().take(3).map((meal) => 
              _buildMealCard(meal)
            ).toList(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPreferenceCard(String title, List<String> options, String selected) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF242522),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) => 
              FilterChip(
                label: Text(
                  option,
                  style: TextStyle(
                    color: option == selected ? Colors.black : Colors.white,
                  ),
                ),
                selected: option == selected,
                onSelected: (bool selected) {
                  // Handle selection
                },
                backgroundColor: Color(0xFF1A1A1A),
                selectedColor: Color(0xFFF5D657),
                checkmarkColor: Colors.black,
              )
            ).toList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMealCard(Map<String, dynamic> meal) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF242522),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Color(0xFFF5D657),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.restaurant,
              color: Colors.black,
              size: 30,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal['name'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  meal['description'],
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _buildNutrientChip('${meal['kcal']} kcal', Colors.orange),
                    SizedBox(width: 8),
                    _buildNutrientChip('${meal['protein']}g protein', Colors.blue),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNutrientChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  void _generateDietPlan(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF242522),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Color(0xFFF5D657),
            ),
            SizedBox(height: 16),
            Text(
              'Generating your personalized diet plan...',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
    
    // Simulate AI processing
    Future.delayed(Duration(seconds: 3), () {
      Get.back(); // Close loading dialog
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Color(0xFF242522),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text(
                'Diet Plan Ready!',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          content: Text(
            'Your personalized diet plan has been generated based on your preferences. The plan includes balanced meals optimized for your weight loss goals.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'View Plan',
                style: TextStyle(color: Color(0xFFF5D657)),
              ),
            ),
          ],
        ),
      );
    });
  }
}
