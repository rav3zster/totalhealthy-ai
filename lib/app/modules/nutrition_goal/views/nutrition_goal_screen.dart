import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/widgets/baseWidget.dart';
import '../../../routes/app_pages.dart';

class NutritionGoalsScreen extends StatefulWidget {
  @override
  _NutritionGoalsScreenState createState() => _NutritionGoalsScreenState();
}

class _NutritionGoalsScreenState extends State<NutritionGoalsScreen> {
  final PageController _pageController = PageController();
  int currentPageIndex = 0;

  // Selected options for each screen
  int selectedGoal = -1;
  int selectedMealFrequency = -1;
  int selectedDietaryRestriction = -1;

  // Data for each screen
  final List<String> nutritionGoals = [
    "Weight loss",
    "Muscle gain",
    "Maintaining current weight",
    "Improved overall health",
  ];

  final List<String> mealFrequencies = [
    "3 times a day (breakfast, lunch, dinner)",
    "4-5 times a day (adding snacks)",
    "I don't have a specific schedule",
  ];

  final List<String> dietaryRestrictions = [
    "Vegetarianism",
    "Gluten-free diet",
    "Lactose intolerance",
    "I don't have",
  ];

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
              // Header with back button and skip
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFC2D86A).withValues(alpha: 0.2),
                            const Color(0xFFC2D86A).withValues(alpha: 0.1),
                          ],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (currentPageIndex > 0) {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            Get.back();
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Skip to dashboard
                        Get.offAllNamed(Routes.ClientDashboard);
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),

              // PageView content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentPageIndex = index;
                    });
                  },
                  children: [
                    _buildNutritionGoalScreen(),
                    _buildMealFrequencyScreen(),
                    _buildDietaryRestrictionsScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionGoalScreen() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Text(
            "What goal are you pursuing with your nutrition?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Choose a more suitable option.",
            style: TextStyle(color: Color(0xFFC2D86A), fontSize: 16),
          ),
          SizedBox(height: 40),

          // Goal options
          Expanded(
            child: ListView.builder(
              itemCount: nutritionGoals.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGoal = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
                      border: selectedGoal == index
                          ? Border.all(color: Color(0xFFC2D86A), width: 2)
                          : null,
                    ),
                    child: Text(
                      nutritionGoals[index],
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),

          // Save button
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 30),
            child: ElevatedButton(
              onPressed: selectedGoal != -1
                  ? () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC2D86A),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealFrequencyScreen() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Text(
            "How many times a day do you usually eat?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Choose a more suitable option.",
            style: TextStyle(color: Color(0xFFC2D86A), fontSize: 16),
          ),
          SizedBox(height: 40),

          // Meal frequency options
          Expanded(
            child: ListView.builder(
              itemCount: mealFrequencies.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMealFrequency = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
                      border: selectedMealFrequency == index
                          ? Border.all(color: Color(0xFFC2D86A), width: 2)
                          : null,
                    ),
                    child: Text(
                      mealFrequencies[index],
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),

          // Continue button
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 30),
            child: ElevatedButton(
              onPressed: selectedMealFrequency != -1
                  ? () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC2D86A),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Text(
                'Continue',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDietaryRestrictionsScreen() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Text(
            "Do you have any dietary restrictions?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Choose a more suitable option.",
            style: TextStyle(color: Color(0xFFC2D86A), fontSize: 16),
          ),
          SizedBox(height: 40),

          // Dietary restriction options
          Expanded(
            child: ListView.builder(
              itemCount: dietaryRestrictions.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDietaryRestriction = index;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(12),
                      border: selectedDietaryRestriction == index
                          ? Border.all(color: Color(0xFFC2D86A), width: 2)
                          : null,
                    ),
                    child: Text(
                      dietaryRestrictions[index],
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),

          // Continue button
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 30),
            child: ElevatedButton(
              onPressed: selectedDietaryRestriction != -1
                  ? () {
                      // Navigate to client dashboard after completing all steps
                      Get.offAllNamed(Routes.ClientDashboard);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC2D86A),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Text(
                'Continue',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
