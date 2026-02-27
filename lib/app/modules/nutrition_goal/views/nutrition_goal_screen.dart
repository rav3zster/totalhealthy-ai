import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/user_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../core/theme/theme_helper.dart';

class NutritionGoalsScreen extends StatefulWidget {
  const NutritionGoalsScreen({super.key});

  @override
  State<NutritionGoalsScreen> createState() => _NutritionGoalsScreenState();
}

class _NutritionGoalsScreenState extends State<NutritionGoalsScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int currentPageIndex = 0;

  // Check if coming from signup flow
  late final bool fromSignup;

  // Selected options for each screen
  int selectedGoal = -1;
  int selectedActivityLevel = -1;
  int selectedMealFrequency = -1;
  int selectedDietaryRestriction = -1;

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Data for each screen
  final List<String> nutritionGoals = [
    'Weight Loss',
    'Muscle Gain',
    'Maintenance',
    'Endurance',
    'Strength',
    'Flexibility',
    'Improved Overall Health',
  ];

  final List<String> activityLevels = [
    'Sedentary',
    'Light',
    'Moderate',
    'Active',
    'Very Active',
  ];

  final List<String> mealFrequencies = [
    "3 times a day (breakfast, lunch, dinner)",
    "4-5 times a day (adding snacks)",
    "I don't have a specific schedule",
  ];

  final List<String> dietaryRestrictions = [
    'Vegetarian',
    'Vegan',
    'Keto',
    'Paleo',
    'Mediterranean',
    'Gluten-free',
    'Lactose-free',
    'Not Specific',
  ];

  @override
  void initState() {
    super.initState();

    // Get the argument to determine where we came from
    final args = Get.arguments as Map<String, dynamic>?;
    fromSignup =
        args?['fromSignup'] ??
        true; // Default to true for backward compatibility

    // Fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Slide animation
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    // Start animations
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });

    // Initialize selections from current user data
    _initializeFromUserData();
  }

  void _initializeFromUserData() {
    try {
      final userController = Get.find<UserController>();
      final user = userController.currentUser;
      if (user != null) {
        // Goal
        if (user.goals.isNotEmpty) {
          selectedGoal = nutritionGoals.indexOf(user.goals.first);
        }

        // Activity Level
        selectedActivityLevel = activityLevels.indexOf(user.activityLevel);

        // Meal Frequency
        selectedMealFrequency = mealFrequencies.indexOf(user.mealFrequency);

        // Dietary Restrictions
        selectedDietaryRestriction = dietaryRestrictions.indexOf(user.dietType);

        setState(() {});
      }
    } catch (e) {
      print('Error initializing goal settings: $e');
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _restartAnimations() {
    _fadeController.reset();
    _slideController.reset();
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _slideController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: context.backgroundGradient),
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
                    // Back button with gradient background
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            context.accent.withValues(alpha: 0.2),
                            context.accent.withValues(alpha: 0.1),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: context.accent.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (currentPageIndex > 0) {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            // Navigate based on where we came from
                            if (fromSignup) {
                              // Coming from signup, go back to switch role with flag
                              Get.offAllNamed(
                                Routes.SWITCHROLE,
                                arguments: {'fromGoalScreen': true},
                              );
                            } else {
                              // Coming from profile, just go back
                              Get.back();
                            }
                          }
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: context.accent,
                          size: 20,
                        ),
                      ),
                    ),

                    // Skip button
                    TextButton(
                      onPressed: () {
                        // Skip to dashboard
                        Get.offAllNamed(Routes.ClientDashboard);
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: context.accent,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Progress indicator
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  children: List.generate(4, (index) {
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: EdgeInsets.only(right: index < 3 ? 8 : 0),
                        decoration: BoxDecoration(
                          gradient: currentPageIndex >= index
                              ? context.accentGradient
                              : null,
                          color: currentPageIndex < index
                              ? context.border
                              : null,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
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
                    _restartAnimations();
                  },
                  children: [
                    _buildNutritionGoalScreen(),
                    _buildActivityLevelScreen(),
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
    return Builder(
      builder: (context) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Decorative icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          context.accent.withValues(alpha: 0.3),
                          context.accent.withValues(alpha: 0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: context.accent.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.track_changes_rounded,
                      size: 40,
                      color: context.accent,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "What goal are you pursuing with your nutrition?",
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Choose a more suitable option.",
                    style: TextStyle(
                      color: context.accent.withValues(alpha: 0.8),
                      fontSize: 16,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Goal options
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: nutritionGoals.length,
                      itemBuilder: (context, index) {
                        final isSelected = selectedGoal == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedGoal = index;
                                });
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? context.cardGradient
                                      : context.cardGradient,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? context.accent
                                        : context.border,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: context.accent.withValues(
                                              alpha: 0.3,
                                            ),
                                            blurRadius: 15,
                                            offset: const Offset(0, 5),
                                          ),
                                        ]
                                      : context.cardShadow,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        nutritionGoals[index],
                                        style: TextStyle(
                                          color: isSelected
                                              ? context.textPrimary
                                              : context.textSecondary,
                                          fontSize: 16,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? context.accent
                                            : Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? context.accent
                                              : context.textTertiary,
                                          width: 2,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.black,
                                              size: 16,
                                            )
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Save button
                  Container(
                    width: double.infinity,
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 20, top: 10),
                    decoration: BoxDecoration(
                      gradient: selectedGoal != -1
                          ? context.accentGradient
                          : LinearGradient(
                              colors: [
                                context.cardSecondary,
                                context.cardSecondary,
                              ],
                            ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: selectedGoal != -1
                          ? [
                              BoxShadow(
                                color: context.accent.withValues(alpha: 0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ]
                          : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: selectedGoal != -1
                            ? () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                        borderRadius: BorderRadius.circular(30),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Save',
                                style: TextStyle(
                                  color: selectedGoal != -1
                                      ? Colors.black
                                      : context.textTertiary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: selectedGoal != -1
                                    ? Colors.black
                                    : context.textTertiary,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ), // Closes Column
            ), // Closes Padding
          ), // Closes SlideTransition
        ); // Closes FadeTransition and return statement
      }, // Closes builder function
    ); // Closes Builder
  }

  Widget _buildActivityLevelScreen() {
    return Builder(
      builder: (context) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Decorative icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          context.accent.withValues(alpha: 0.3),
                          context.accent.withValues(alpha: 0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: context.accent.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.directions_run_rounded,
                      size: 40,
                      color: context.accent,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "How active is your lifestyle?",
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Choose a more suitable option.",
                    style: TextStyle(
                      color: context.accent.withValues(alpha: 0.8),
                      fontSize: 16,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Activity Level options
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: activityLevels.length,
                      itemBuilder: (context, index) {
                        final isSelected = selectedActivityLevel == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedActivityLevel = index;
                                });
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? context.cardGradient
                                      : context.cardGradient,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? context.accent
                                        : context.border,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: context.accent.withValues(
                                              alpha: 0.3,
                                            ),
                                            blurRadius: 15,
                                            offset: const Offset(0, 5),
                                          ),
                                        ]
                                      : context.cardShadow,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        activityLevels[index],
                                        style: TextStyle(
                                          color: isSelected
                                              ? context.textPrimary
                                              : context.textSecondary,
                                          fontSize: 16,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? context.accent
                                            : Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? context.accent
                                              : context.textTertiary,
                                          width: 2,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.black,
                                              size: 16,
                                            )
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Save button
                  Container(
                    width: double.infinity,
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 20, top: 10),
                    decoration: BoxDecoration(
                      gradient: selectedActivityLevel != -1
                          ? context.accentGradient
                          : LinearGradient(
                              colors: [
                                context.cardSecondary,
                                context.cardSecondary,
                              ],
                            ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: selectedActivityLevel != -1
                          ? [
                              BoxShadow(
                                color: context.accent.withValues(alpha: 0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ]
                          : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: selectedActivityLevel != -1
                            ? () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                        borderRadius: BorderRadius.circular(30),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Save',
                                style: TextStyle(
                                  color: selectedActivityLevel != -1
                                      ? Colors.black
                                      : context.textTertiary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: selectedActivityLevel != -1
                                    ? Colors.black
                                    : context.textTertiary,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ), // Closes Column
            ), // Closes Padding
          ), // Closes SlideTransition
        ); // Closes FadeTransition and return statement
      }, // Closes builder function
    ); // Closes Builder
  }

  Widget _buildMealFrequencyScreen() {
    return Builder(
      builder: (context) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Decorative icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          context.accent.withValues(alpha: 0.3),
                          context.accent.withValues(alpha: 0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: context.accent.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.restaurant_menu_rounded,
                      size: 40,
                      color: context.accent,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "How many times a day do you usually eat?",
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Choose a more suitable option.",
                    style: TextStyle(
                      color: context.accent.withValues(alpha: 0.8),
                      fontSize: 16,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Meal frequency options
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: mealFrequencies.length,
                      itemBuilder: (context, index) {
                        final isSelected = selectedMealFrequency == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedMealFrequency = index;
                                });
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? context.cardGradient
                                      : context.cardGradient,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? context.accent
                                        : context.border,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: context.accent.withValues(
                                              alpha: 0.3,
                                            ),
                                            blurRadius: 15,
                                            offset: const Offset(0, 5),
                                          ),
                                        ]
                                      : context.cardShadow,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        mealFrequencies[index],
                                        style: TextStyle(
                                          color: isSelected
                                              ? context.textPrimary
                                              : context.textSecondary,
                                          fontSize: 16,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? context.accent
                                            : Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? context.accent
                                              : context.textTertiary,
                                          width: 2,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.black,
                                              size: 16,
                                            )
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Continue button
                  Container(
                    width: double.infinity,
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 20, top: 10),
                    decoration: BoxDecoration(
                      gradient: selectedMealFrequency != -1
                          ? context.accentGradient
                          : LinearGradient(
                              colors: [
                                context.cardSecondary,
                                context.cardSecondary,
                              ],
                            ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: selectedMealFrequency != -1
                          ? [
                              BoxShadow(
                                color: context.accent.withValues(alpha: 0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ]
                          : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: selectedMealFrequency != -1
                            ? () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                        borderRadius: BorderRadius.circular(30),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Continue',
                                style: TextStyle(
                                  color: selectedMealFrequency != -1
                                      ? Colors.black
                                      : context.textTertiary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: selectedMealFrequency != -1
                                    ? Colors.black
                                    : context.textTertiary,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ), // Closes Column
            ), // Closes Padding
          ), // Closes SlideTransition
        ); // Closes FadeTransition and return statement
      }, // Closes builder function
    ); // Closes Builder
  }

  Widget _buildDietaryRestrictionsScreen() {
    return Builder(
      builder: (context) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Decorative icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          context.accent.withValues(alpha: 0.3),
                          context.accent.withValues(alpha: 0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: context.accent.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.health_and_safety_rounded,
                      size: 40,
                      color: context.accent,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "Do you have any dietary restrictions?",
                    style: TextStyle(
                      color: context.textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Choose a more suitable option.",
                    style: TextStyle(
                      color: context.accent.withValues(alpha: 0.8),
                      fontSize: 16,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Dietary restriction options
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: dietaryRestrictions.length,
                      itemBuilder: (context, index) {
                        final isSelected = selectedDietaryRestriction == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedDietaryRestriction = index;
                                });
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? context.cardGradient
                                      : context.cardGradient,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? context.accent
                                        : context.border,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: context.accent.withValues(
                                              alpha: 0.3,
                                            ),
                                            blurRadius: 15,
                                            offset: const Offset(0, 5),
                                          ),
                                        ]
                                      : context.cardShadow,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        dietaryRestrictions[index],
                                        style: TextStyle(
                                          color: isSelected
                                              ? context.textPrimary
                                              : context.textSecondary,
                                          fontSize: 16,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ),
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? context.accent
                                            : Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected
                                              ? context.accent
                                              : context.textTertiary,
                                          width: 2,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.black,
                                              size: 16,
                                            )
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Continue button
                  Container(
                    width: double.infinity,
                    height: 60,
                    margin: const EdgeInsets.only(bottom: 20, top: 10),
                    decoration: BoxDecoration(
                      gradient: selectedDietaryRestriction != -1
                          ? context.accentGradient
                          : LinearGradient(
                              colors: [
                                context.cardSecondary,
                                context.cardSecondary,
                              ],
                            ),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: selectedDietaryRestriction != -1
                          ? [
                              BoxShadow(
                                color: context.accent.withValues(alpha: 0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ]
                          : null,
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: selectedDietaryRestriction != -1
                            ? () async {
                                try {
                                  final userController =
                                      Get.find<UserController>();
                                  await userController.updateUserProfile(
                                    goals: [nutritionGoals[selectedGoal]],
                                    activityLevel:
                                        activityLevels[selectedActivityLevel],
                                    mealFrequency:
                                        mealFrequencies[selectedMealFrequency],
                                    dietType:
                                        dietaryRestrictions[selectedDietaryRestriction],
                                  );

                                  Get.snackbar(
                                    'Success',
                                    'Nutrition goals updated successfully',
                                    backgroundColor: context.accent,
                                    colorText: Colors.black,
                                    snackPosition: SnackPosition.BOTTOM,
                                    margin: const EdgeInsets.all(20),
                                  );

                                  // Navigate to client dashboard after completing nutrition goals
                                  Get.offAllNamed(Routes.ClientDashboard);
                                } catch (e) {
                                  Get.snackbar(
                                    'Error',
                                    'Failed to update goals: $e',
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    snackPosition: SnackPosition.BOTTOM,
                                    margin: const EdgeInsets.all(20),
                                  );
                                }
                              }
                            : null,
                        borderRadius: BorderRadius.circular(30),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Complete',
                                style: TextStyle(
                                  color: selectedDietaryRestriction != -1
                                      ? Colors.black
                                      : context.textTertiary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.check_circle_rounded,
                                color: selectedDietaryRestriction != -1
                                    ? Colors.black
                                    : context.textTertiary,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ), // Closes Column
            ), // Closes Padding
          ), // Closes SlideTransition
        ); // Closes FadeTransition and return statement
      }, // Closes builder function
    ); // Closes Builder
  }
}
