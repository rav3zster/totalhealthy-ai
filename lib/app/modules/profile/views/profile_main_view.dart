import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/user_controller.dart';
import '../../../widgets/base_screen_wrapper.dart';
import 'profile_edit_view.dart';

class ProfileMainView extends StatelessWidget {
  const ProfileMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreenWrapper(
      title: 'Profile',
      actions: [
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: () => Get.to(() => const ProfileEditView()),
          ),
        ),
      ],
      child: GetBuilder<UserController>(
        builder: (userController) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
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
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(UserController userController) {
    return Column(
      children: [
        Container(
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
            backgroundImage: userController.profileImage.isNotEmpty
                ? NetworkImage(userController.profileImage)
                : const AssetImage('assets/user_avatar.png') as ImageProvider,
            onBackgroundImageError: (_, _) {
              // Handle image loading error silently
            },
          ),
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
            Get.toNamed('/nutrition-goal');
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
}
