import 'dart:io';
import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/core/base/controllers/auth_controller.dart';
import '../../../controllers/user_controller.dart';
import '../../../widgets/base_screen_wrapper.dart';
import '../../../widgets/phone_nav_bar.dart';
import '../../../routes/app_pages.dart';

class ProfileMainView extends StatefulWidget {
  const ProfileMainView({super.key});

  @override
  State<ProfileMainView> createState() => _ProfileMainViewState();
}

class _ProfileMainViewState extends State<ProfileMainView> {
  @override
  void initState() {
    super.initState();
    OntapStore.index = 3; // Set to Profile tab
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenWrapper(
      title: 'Profile',
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Remove back button
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
            ),
          ),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: const MobileNavBar(),
      child: GetBuilder<UserController>(
        builder: (userController) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    // Profile Image and Name
                    _buildProfileHeader(userController),

                    const SizedBox(height: 32),

                    // Stats Cards
                    _buildStatsCards(userController),

                    const SizedBox(height: 48),

                    // Menu Options
                    _buildMenuOptions(),

                    const SizedBox(height: 48),

                    // Additional Profile Stats
                    _buildProgressSection(userController),
                  ],
                ),
              ),
              if (userController.isLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: const Center(
                    child: CircularProgressIndicator(color: Color(0xFFC2D86A)),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(UserController userController) {
    return Column(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: () => _pickAndUploadImage(userController),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFC2D86A).withValues(alpha: 0.3),
                      const Color(0xFFC2D86A).withValues(alpha: 0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(3),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF2A2A2A),
                  backgroundImage: UserController.getImageProvider(
                    userController.profileImage,
                  ),
                  child: userController.profileImage.isEmpty
                      ? const Icon(
                          Icons.person,
                          color: Colors.white24,
                          size: 50,
                        )
                      : null,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _pickAndUploadImage(userController),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFC2D86A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          userController.fullName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (userController.email.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            userController.email,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ],
    );
  }

  Widget _buildStatsCards(UserController userController) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard('Weight', userController.weightDisplay, 'kg'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard('Age', userController.ageDisplay, 'Year'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard('Height', userController.heightDisplay, 'cm'),
        ),
      ],
    );
  }

  Widget _buildMenuOptions() {
    return Column(
      children: [
        _buildMenuOption(
          icon: Icons.person_outline,
          title: 'Profile',
          onTap: () {
            Get.toNamed('/profile-settings');
          },
        ),
        const SizedBox(height: 16),
        _buildMenuOption(
          icon: Icons.track_changes_outlined,
          title: 'Goal Setting',
          onTap: () {
            Get.toNamed('/nutrition-goal', arguments: {'fromSignup': false});
          },
        ),
        const SizedBox(height: 16),
        _buildMenuOption(
          icon: Icons.access_time_outlined,
          title: 'Meal Timing',
          onTap: () {
            final userController = Get.find<UserController>();
            final userId = userController.currentUser?.id ?? "";
            Get.toNamed('/meal-timing?id=$userId');
          },
        ),
        const SizedBox(height: 16),
        _buildMenuOption(
          icon: Icons.settings_outlined,
          title: 'Setting',
          onTap: () {
            Get.toNamed('/setting');
          },
        ),
        const SizedBox(height: 16),
        _buildMenuOption(
          icon: Icons.help_outline,
          title: 'Help & Support',
          onTap: () {
            Get.toNamed('/help-support');
          },
        ),
        const SizedBox(height: 16),
        _buildMenuOption(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          onTap: () {
            Get.toNamed(Routes.PRIVACY_POLICY);
          },
        ),
        const SizedBox(height: 16),
        _buildLogoutOption(),
      ],
    );
  }

  Widget _buildProgressSection(UserController userController) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progress Overview',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildProgressItem(
                    'Current Day',
                    userController.currentDay.toString(),
                    const Color(0xFF2196F3),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProgressItem(
                    'Goal Progress',
                    userController.goalAchievedPercent,
                    const Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildProgressItem(
                    'Primary Goal',
                    userController.primaryGoal,
                    const Color(0xFFFF9800),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, String unit) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
        ),
        borderRadius: BorderRadius.circular(12),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      color: Color(0xFFC2D86A),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: ' $unit',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
          ),
          borderRadius: BorderRadius.circular(12),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
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
                child: Icon(icon, color: Colors.black, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white54,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutOption() {
    return GestureDetector(
      onTap: _showLogoutDialog,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.red.withValues(alpha: 0.2),
              Colors.red.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                      const Color(0xFFFF6B6B).withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B6B).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.logout,
                  color: Color(0xFFFF6B6B),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Log Out',
                  style: TextStyle(
                    color: Color(0xFFFF6B6B),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFFFF6B6B),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 340),
          decoration: BoxDecoration(
            // Glassmorphism with dark theme and lime green tint
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF2A2A2A).withValues(alpha: 0.95),
                const Color(0xFF1A1A1A).withValues(alpha: 0.95),
                const Color(0xFF1A1A1A).withValues(alpha: 0.98),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFC2D86A).withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
              BoxShadow(
                color: const Color(0xFFC2D86A).withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon with lime green accent
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFC2D86A).withValues(alpha: 0.15),
                            const Color(0xFFC2D86A).withValues(alpha: 0.08),
                          ],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFC2D86A,
                            ).withValues(alpha: 0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.logout_rounded,
                        color: Color(0xFFC2D86A),
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    const Text(
                      'Log Out',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Message
                    Text(
                      'Are you sure you want to\nlog out of your account?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 15,
                        height: 1.4,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Buttons
                    Column(
                      children: [
                        // Cancel Button with lime green gradient
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Get.back(),
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(
                                      0xFFC2D86A,
                                    ).withValues(alpha: 0.25),
                                    const Color(
                                      0xFFB8CC5A,
                                    ).withValues(alpha: 0.2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(
                                    0xFFC2D86A,
                                  ).withValues(alpha: 0.4),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFC2D86A,
                                    ).withValues(alpha: 0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'Cancel',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Logout Button
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Get.back();
                              Get.find<AuthController>().logOut();
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(
                                      0xFF2A2A2A,
                                    ).withValues(alpha: 0.8),
                                    const Color(
                                      0xFF1E1E1E,
                                    ).withValues(alpha: 0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'Log Out',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.75),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.6),
    );
  }

  Future<void> _pickAndUploadImage(UserController userController) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image != null) {
        await userController.uploadProfileImage(File(image.path));
        Get.snackbar(
          'Success',
          'Profile picture updated',
          backgroundColor: const Color(0xFFC2D86A),
          colorText: Colors.black,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
