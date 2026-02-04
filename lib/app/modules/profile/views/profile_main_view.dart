import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/user_controller.dart';
import '../../../widgets/base_screen_wrapper.dart';
import '../../../core/theme/app_theme.dart';
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
            gradient: AppTheme.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.edit, color: AppTheme.textPrimary),
            onPressed: () => Get.to(() => const ProfileEditView()),
          ),
        ),
      ],
      child: GetBuilder<UserController>(
        builder: (userController) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingL,
              vertical: AppTheme.spacingL,
            ),
            child: Column(
              children: [
                // Profile Image and Name
                _buildProfileHeader(userController),

                const SizedBox(height: AppTheme.spacingXL),

                // Stats Cards
                _buildStatsCards(userController),

                const SizedBox(height: AppTheme.spacingXXL),

                // Menu Options
                _buildMenuOptions(),

                const SizedBox(height: AppTheme.spacingXXL),

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
          onBackgroundImageError: (_, _) {
            // Handle image loading error silently
          },
        ),
        const SizedBox(height: AppTheme.spacingM),
        Text(userController.fullName, style: AppTheme.headingSmall),
        if (userController.email.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(userController.email, style: AppTheme.bodyMedium),
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
        const SizedBox(width: AppTheme.spacingM),
        Expanded(
          child: _buildStatCard('Age', userController.ageDisplay, 'Year'),
        ),
        const SizedBox(width: AppTheme.spacingM),
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
        const SizedBox(height: AppTheme.spacingM),
        _buildMenuOption(
          icon: Icons.track_changes_outlined,
          title: 'Goal Setting',
          onTap: () {
            Get.toNamed('/nutrition-goal');
          },
        ),
        const SizedBox(height: AppTheme.spacingM),
        _buildMenuOption(
          icon: Icons.settings_outlined,
          title: 'Setting',
          onTap: () {
            Get.toNamed('/setting');
          },
        ),
        const SizedBox(height: AppTheme.spacingM),
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
      decoration: AppTheme.highlightCardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Progress Overview', style: AppTheme.headingSmall),
            const SizedBox(height: AppTheme.spacingM),
            Row(
              children: [
                Expanded(
                  child: _buildProgressItem(
                    'Current Day',
                    userController.currentDay.toString(),
                    AppTheme.info,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: _buildProgressItem(
                    'Goal Progress',
                    userController.goalAchievedPercent,
                    AppTheme.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            Row(
              children: [
                Expanded(
                  child: _buildProgressItem(
                    'Primary Goal',
                    userController.primaryGoal,
                    AppTheme.warning,
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
        Text(label, style: AppTheme.bodySmall),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTheme.bodyLarge.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, String unit) {
    return Container(
      decoration: AppTheme.cardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          children: [
            Text(label, style: AppTheme.bodySmall),
            const SizedBox(height: AppTheme.spacingS),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: AppTheme.headingSmall.copyWith(
                      color: AppTheme.primaryLight,
                    ),
                  ),
                  TextSpan(
                    text: ' $unit',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textPrimary,
                    ),
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
        decoration: AppTheme.cardDecoration,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingL,
            vertical: AppTheme.spacingM,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingS),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(AppTheme.radiusS),
                ),
                child: Icon(icon, color: AppTheme.textPrimary, size: 20),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(child: Text(title, style: AppTheme.bodyLarge)),
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.textTertiary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
