import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/base/controllers/auth_controller.dart';
import '../routes/app_pages.dart';
import '../data/services/users_firestore_service.dart';
import '../data/models/user_model.dart';

class SwitchRoleScreen extends StatefulWidget {
  const SwitchRoleScreen({super.key});

  @override
  State<SwitchRoleScreen> createState() => _SwitchRoleScreenState();
}

class _SwitchRoleScreenState extends State<SwitchRoleScreen>
    with TickerProviderStateMixin {
  bool isAdvisorSelected = false;
  bool isMemberSelected = false;
  String role = "";

  // Track if user has already proceeded to goal screen
  bool hasProceededToGoals = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Check if coming back from goal screen
    final args = Get.arguments as Map<String, dynamic>?;
    hasProceededToGoals = args?['fromGoalScreen'] ?? false;

    // If coming back from goal screen, restore the member selection
    if (hasProceededToGoals) {
      isMemberSelected = true;
      role = "user";
    }

    // Fade animation for text
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    // Slide animation for cards
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
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
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
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),

                        // Animated Header
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              // Decorative icon
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(
                                        0xFFC2D86A,
                                      ).withValues(alpha: 0.3),
                                      const Color(
                                        0xFFC2D86A,
                                      ).withValues(alpha: 0.1),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFC2D86A,
                                      ).withValues(alpha: 0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.person_outline,
                                  size: 50,
                                  color: Color(0xFFC2D86A),
                                ),
                              ),

                              const SizedBox(height: 32),

                              // Title
                              const Text(
                                "Choose Your Role",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Subtitle
                              Text(
                                "Select how you want to use the app",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 16,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 60),

                        // Animated Role Cards
                        SlideTransition(
                          position: _slideAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Column(
                              children: [
                                // Advisor Card
                                _buildModernRoleCard(
                                  title: "Advisor",
                                  subtitle:
                                      "Manage clients and create meal plans",
                                  icon: Icons.psychology_outlined,
                                  imagePath: "assets/advisor.png",
                                  isSelected: isAdvisorSelected,
                                  accentColor: const Color(0xFFC2D86A),
                                  onTap: () {
                                    setState(() {
                                      isAdvisorSelected = true;
                                      isMemberSelected = false;
                                      role = "admin";
                                    });
                                  },
                                ),

                                const SizedBox(height: 24),

                                // Member Card
                                _buildModernRoleCard(
                                  title: "Member",
                                  subtitle:
                                      "Track your nutrition and fitness goals",
                                  icon: Icons.fitness_center_outlined,
                                  imagePath: "assets/member.png",
                                  isSelected: isMemberSelected,
                                  accentColor: const Color(0xFFFFD700),
                                  onTap: () {
                                    setState(() {
                                      isMemberSelected = true;
                                      isAdvisorSelected = false;
                                      role = "user";
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ),

              // Continue Button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: AnimatedOpacity(
                  opacity: role.isNotEmpty ? 1.0 : 0.5,
                  duration: const Duration(milliseconds: 300),
                  child: AnimatedScale(
                    scale: role.isNotEmpty ? 1.0 : 0.95,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: role.isNotEmpty
                            ? const LinearGradient(
                                colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
                              )
                            : LinearGradient(
                                colors: [
                                  Colors.grey.shade800,
                                  Colors.grey.shade700,
                                ],
                              ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: role.isNotEmpty
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFFC2D86A,
                                  ).withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ]
                            : null,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: role.isNotEmpty
                              ? () async {
                                  try {
                                    final authController =
                                        Get.find<AuthController>();
                                    final user =
                                        FirebaseAuth.instance.currentUser;

                                    if (user == null) {
                                      Get.snackbar(
                                        "Error",
                                        "No user logged in",
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                      return;
                                    }

                                    final usersService =
                                        UsersFirestoreService();
                                    final profile = await usersService
                                        .getUserProfile(user.uid);

                                    if (profile == null) {
                                      Get.snackbar(
                                        "Error",
                                        "User profile not found",
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                      return;
                                    }

                                    // CRITICAL: Check if role is already locked
                                    // BUT allow going back to goals if user came from goal screen
                                    if (profile.isRoleLocked &&
                                        !hasProceededToGoals) {
                                      Get.snackbar(
                                        "Role Already Set",
                                        "Your role has already been set and cannot be changed",
                                        backgroundColor: Colors.orange,
                                        colorText: Colors.white,
                                      );

                                      // Navigate to appropriate dashboard
                                      if (profile.isAdvisor) {
                                        Get.offAllNamed(
                                          Routes.trainerDashboard,
                                        );
                                      } else {
                                        Get.offAllNamed(Routes.clientDashboard);
                                      }
                                      return;
                                    }

                                    // Set role (update if coming back from goals, or set for first time)
                                    final updatedProfile = UserModel(
                                      id: profile.id,
                                      email: profile.email,
                                      username: profile.username,
                                      phone: profile.phone,
                                      firstName: profile.firstName,
                                      lastName: profile.lastName,
                                      profileImage: profile.profileImage,
                                      age: profile.age,
                                      weight: profile.weight,
                                      height: profile.height,
                                      activityLevel: profile.activityLevel,
                                      goals: profile.goals,
                                      joinDate: profile.joinDate,
                                      targetWeight: profile.targetWeight,
                                      initialWeight: profile.initialWeight,
                                      fatLost: profile.fatLost,
                                      muscleGained: profile.muscleGained,
                                      profileCompleted:
                                          profile.profileCompleted,
                                      role:
                                          role, // Update role (may have changed)
                                      roleSetAt:
                                          profile.roleSetAt ??
                                          DateTime.now(), // Keep existing or set new
                                      createdAt: profile.createdAt,
                                    );

                                    await usersService.updateUserProfile(
                                      updatedProfile,
                                    );
                                    await authController.userdataStore(
                                      updatedProfile.toJson(),
                                    );
                                    authController.roleStore(role);

                                    // Navigate based on role
                                    if (role == "admin") {
                                      Get.offAllNamed(Routes.trainerDashboard);
                                    } else {
                                      // If user already proceeded to goals before, go back to goals
                                      // Otherwise, this is first time, so proceed normally
                                      Get.offAllNamed(
                                        Routes.nutritionGoal,
                                        arguments: {'fromSignup': true},
                                      );
                                    }
                                  } catch (e) {
                                    Get.snackbar(
                                      "Error",
                                      "Failed to set role: $e",
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                }
                              : null,
                          borderRadius: BorderRadius.circular(30),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Continue",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
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

  Widget _buildModernRoleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String imagePath,
    required bool isSelected,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isSelected
                    ? [const Color(0xFF2D2D2D), const Color(0xFF1D1D1D)]
                    : [const Color(0xFF2A2A2A), const Color(0xFF1A1A1A)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? accentColor
                    : Colors.white.withValues(alpha: 0.1),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
            ),
            child: Row(
              children: [
                // Image/Icon Container
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isSelected
                          ? [accentColor, accentColor.withValues(alpha: 0.7)]
                          : [
                              Colors.white.withValues(alpha: 0.1),
                              Colors.white.withValues(alpha: 0.05),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: accentColor.withValues(alpha: 0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ]
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          icon,
                          size: 40,
                          color: isSelected ? Colors.black : Colors.white54,
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.7)
                              : Colors.white.withValues(alpha: 0.5),
                          fontSize: 14,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),

                // Selection Indicator
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isSelected ? accentColor : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? accentColor
                          : Colors.white.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.black, size: 18)
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
