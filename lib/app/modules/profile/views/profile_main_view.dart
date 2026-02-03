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
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: () => Get.to(() => const ProfileEditView()),
        ),
      ],
      child: GetBuilder<UserController>(
        builder: (userController) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                // Profile Image and Name
                _buildProfileHeader(userController),

                const SizedBox(height: 30),

                // Stats Cards
                _buildStatsCards(userController),

                const SizedBox(height: 40),

                // Menu Options
                _buildMenuOptions(),

                const SizedBox(height: 40),

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
        CircleAvatar(
          radius: 50,
          backgroundImage: userController.profileImage.isNotEmpty
              ? NetworkImage(userController.profileImage)
              : const AssetImage('assets/user_avatar.png') as ImageProvider,
          onBackgroundImageError: (_, __) {
            // Handle image loading error silently
          },
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
            style: const TextStyle(color: Colors.white54, fontSize: 14),
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
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('Age', userController.ageDisplay, 'Year'),
        ),
        const SizedBox(width: 12),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progress Overview',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildProgressItem(
                  'Current Day',
                  userController.currentDay.toString(),
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildProgressItem(
                  'Goal Progress',
                  userController.goalAchievedPercent,
                  Colors.green,
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
                  Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    color: Color(0xFFC2D86A),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
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
    );
  }
}
