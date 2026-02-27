import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../controllers/user_controller.dart';
import '../../../core/theme/theme_helper.dart';

class MemberProfileView extends StatelessWidget {
  const MemberProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel member = Get.arguments as UserModel;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar with Profile Header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: context.cardColor,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: context.textPrimary),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(gradient: context.headerGradient),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Profile Image
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: context.accentGradient,
                          boxShadow: [
                            BoxShadow(
                              color: context.accent.withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(4),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: UserController.getImageProvider(
                            member.profileImage,
                          ),
                          child:
                              UserController.getImageProvider(
                                    member.profileImage,
                                  ) ==
                                  null
                              ? Icon(
                                  Icons.person,
                                  size: 60,
                                  color: context.textSecondary,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Name
                      Text(
                        member.fullName,
                        style: TextStyle(
                          color: context.textPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Email
                      Text(
                        member.email,
                        style: TextStyle(
                          color: context.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Role Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          gradient: context.accentGradient,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          member.role?.toUpperCase() ?? 'MEMBER',
                          style: TextStyle(
                            color: context.isDark
                                ? const Color(0xFF121212)
                                : Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Profile Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal Information Section
                  _buildSectionTitle(context, 'Personal Information'),
                  const SizedBox(height: 12),
                  _buildInfoCard(context, [
                    _buildInfoRow(
                      context,
                      Icons.person_outline,
                      'Username',
                      member.username,
                    ),
                    _buildInfoRow(
                      context,
                      Icons.phone_outlined,
                      'Phone',
                      member.phone.isEmpty ? 'Not provided' : member.phone,
                    ),
                    _buildInfoRow(
                      context,
                      Icons.cake_outlined,
                      'Age',
                      '${member.age} years',
                    ),
                    _buildInfoRow(
                      context,
                      Icons.wc_outlined,
                      'Gender',
                      member.gender,
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Physical Stats Section
                  _buildSectionTitle(context, 'Physical Stats'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Weight',
                          '${member.weight.toStringAsFixed(1)} kg',
                          Icons.monitor_weight_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Height',
                          '${member.height} cm',
                          Icons.height_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'Target',
                          '${member.targetWeight.toStringAsFixed(1)} kg',
                          Icons.flag_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          context,
                          'BMI',
                          _calculateBMI(member.weight, member.height),
                          Icons.analytics_outlined,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Diet & Lifestyle Section
                  _buildSectionTitle(context, 'Diet & Lifestyle'),
                  const SizedBox(height: 12),
                  _buildInfoCard(context, [
                    _buildInfoRow(
                      context,
                      Icons.restaurant_outlined,
                      'Diet Type',
                      member.dietType,
                    ),
                    _buildInfoRow(
                      context,
                      Icons.schedule_outlined,
                      'Meal Frequency',
                      member.mealFrequency,
                    ),
                    _buildInfoRow(
                      context,
                      Icons.directions_run_outlined,
                      'Activity Level',
                      member.activityLevel,
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Goals Section
                  _buildSectionTitle(context, 'Goals'),
                  const SizedBox(height: 12),
                  _buildGoalsCard(context, member.goals),

                  const SizedBox(height: 24),

                  // Progress Section
                  _buildSectionTitle(context, 'Progress'),
                  const SizedBox(height: 12),
                  _buildProgressCard(context, member),

                  const SizedBox(height: 24),

                  // Allergies Section
                  if (member.allergies.isNotEmpty) ...[
                    _buildSectionTitle(context, 'Allergies'),
                    const SizedBox(height: 12),
                    _buildAllergiesCard(context, member.allergies),
                    const SizedBox(height: 24),
                  ],

                  // Account Info Section
                  _buildSectionTitle(context, 'Account Information'),
                  const SizedBox(height: 12),
                  _buildInfoCard(context, [
                    _buildInfoRow(
                      context,
                      Icons.calendar_today_outlined,
                      'Join Date',
                      _formatDate(member.joinDate),
                    ),
                    _buildInfoRow(
                      context,
                      Icons.event_outlined,
                      'Created',
                      _formatDate(member.createdAt),
                    ),
                    _buildInfoRow(
                      context,
                      Icons.verified_user_outlined,
                      'Profile Status',
                      member.profileCompleted ? 'Completed' : 'Incomplete',
                    ),
                  ]),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        color: context.accent,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        gradient: context.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border, width: 1),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.divider, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.accent.withValues(alpha: 0.2),
                  context.accent.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: context.accent, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: context.textTertiary, fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: context.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: context.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: context.accent, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: context.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: context.textTertiary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsCard(BuildContext context, List<String> goals) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: context.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border, width: 1),
      ),
      child: goals.isEmpty
          ? Center(
              child: Text(
                'No goals set',
                style: TextStyle(color: context.textTertiary, fontSize: 14),
              ),
            )
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: goals.map((goal) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: context.accentGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    goal,
                    style: TextStyle(
                      color: context.isDark
                          ? const Color(0xFF121212)
                          : Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildProgressCard(BuildContext context, UserModel member) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: context.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProgressStat(
                context,
                'Fat Lost',
                member.fatLostDisplay,
                Icons.trending_down,
              ),
              _buildProgressStat(
                context,
                'Muscle Gained',
                member.muscleGainedDisplay,
                Icons.trending_up,
              ),
              _buildProgressStat(
                context,
                'Progress',
                member.goalProgressDisplay,
                Icons.emoji_events_outlined,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: member.goalAchievedPercentage / 100,
              minHeight: 8,
              backgroundColor: context.border,
              valueColor: AlwaysStoppedAnimation<Color>(context.accent),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            member.dayCountDisplay,
            style: TextStyle(color: context.textTertiary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: context.accent, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: context.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: context.textTertiary, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildAllergiesCard(
    BuildContext context,
    Map<String, bool> allergies,
  ) {
    final activeAllergies = allergies.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: context.cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.border, width: 1),
      ),
      child: activeAllergies.isEmpty
          ? Center(
              child: Text(
                'No allergies reported',
                style: TextStyle(color: context.textTertiary, fontSize: 14),
              ),
            )
          : Wrap(
              spacing: 8,
              runSpacing: 8,
              children: activeAllergies.map((allergy) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.red.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.red,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        allergy,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }

  String _calculateBMI(double weight, int height) {
    if (weight == 0 || height == 0) return 'N/A';
    final heightInMeters = height / 100;
    final bmi = weight / (heightInMeters * heightInMeters);
    return bmi.toStringAsFixed(1);
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
