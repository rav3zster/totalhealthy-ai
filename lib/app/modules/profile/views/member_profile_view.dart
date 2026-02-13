import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../controllers/user_controller.dart';

class MemberProfileView extends StatelessWidget {
  const MemberProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel member = Get.arguments as UserModel;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(
        slivers: [
          // App Bar with Profile Header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: const Color(0xFF1A1A1A),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF2A2A2A),
                      const Color(0xFF1A1A1A).withValues(alpha: 0.9),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Profile Image
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFC2D86A), Color(0xFFD4E87C)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFC2D86A,
                              ).withValues(alpha: 0.4),
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
                              ? const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.white54,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Name
                      Text(
                        member.fullName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Email
                      Text(
                        member.email,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
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
                          gradient: const LinearGradient(
                            colors: [Color(0xFFC2D86A), Color(0xFFD4E87C)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          member.role?.toUpperCase() ?? 'MEMBER',
                          style: const TextStyle(
                            color: Color(0xFF121212),
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
                  _buildSectionTitle('Personal Information'),
                  const SizedBox(height: 12),
                  _buildInfoCard([
                    _buildInfoRow(
                      Icons.person_outline,
                      'Username',
                      member.username,
                    ),
                    _buildInfoRow(
                      Icons.phone_outlined,
                      'Phone',
                      member.phone.isEmpty ? 'Not provided' : member.phone,
                    ),
                    _buildInfoRow(
                      Icons.cake_outlined,
                      'Age',
                      '${member.age} years',
                    ),
                    _buildInfoRow(Icons.wc_outlined, 'Gender', member.gender),
                  ]),

                  const SizedBox(height: 24),

                  // Physical Stats Section
                  _buildSectionTitle('Physical Stats'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Weight',
                          '${member.weight.toStringAsFixed(1)} kg',
                          Icons.monitor_weight_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
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
                          'Target',
                          '${member.targetWeight.toStringAsFixed(1)} kg',
                          Icons.flag_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'BMI',
                          _calculateBMI(member.weight, member.height),
                          Icons.analytics_outlined,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Diet & Lifestyle Section
                  _buildSectionTitle('Diet & Lifestyle'),
                  const SizedBox(height: 12),
                  _buildInfoCard([
                    _buildInfoRow(
                      Icons.restaurant_outlined,
                      'Diet Type',
                      member.dietType,
                    ),
                    _buildInfoRow(
                      Icons.schedule_outlined,
                      'Meal Frequency',
                      member.mealFrequency,
                    ),
                    _buildInfoRow(
                      Icons.directions_run_outlined,
                      'Activity Level',
                      member.activityLevel,
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Goals Section
                  _buildSectionTitle('Goals'),
                  const SizedBox(height: 12),
                  _buildGoalsCard(member.goals),

                  const SizedBox(height: 24),

                  // Progress Section
                  _buildSectionTitle('Progress'),
                  const SizedBox(height: 12),
                  _buildProgressCard(member),

                  const SizedBox(height: 24),

                  // Allergies Section
                  if (member.allergies.isNotEmpty) ...[
                    _buildSectionTitle('Allergies'),
                    const SizedBox(height: 12),
                    _buildAllergiesCard(member.allergies),
                    const SizedBox(height: 24),
                  ],

                  // Account Info Section
                  _buildSectionTitle('Account Information'),
                  const SizedBox(height: 12),
                  _buildInfoCard([
                    _buildInfoRow(
                      Icons.calendar_today_outlined,
                      'Join Date',
                      _formatDate(member.joinDate),
                    ),
                    _buildInfoRow(
                      Icons.event_outlined,
                      'Created',
                      _formatDate(member.createdAt),
                    ),
                    _buildInfoRow(
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFFC2D86A),
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2A2A2A).withValues(alpha: 0.8),
            const Color(0xFF1A1A1A).withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFC2D86A).withValues(alpha: 0.2),
                  const Color(0xFFC2D86A).withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFFC2D86A), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
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

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2A2A2A).withValues(alpha: 0.8),
            const Color(0xFF1A1A1A).withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFC2D86A), size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsCard(List<String> goals) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2A2A2A).withValues(alpha: 0.8),
            const Color(0xFF1A1A1A).withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: goals.isEmpty
          ? Center(
              child: Text(
                'No goals set',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
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
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC2D86A), Color(0xFFD4E87C)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    goal,
                    style: const TextStyle(
                      color: Color(0xFF121212),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildProgressCard(UserModel member) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2A2A2A).withValues(alpha: 0.8),
            const Color(0xFF1A1A1A).withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProgressStat(
                'Fat Lost',
                member.fatLostDisplay,
                Icons.trending_down,
              ),
              _buildProgressStat(
                'Muscle Gained',
                member.muscleGainedDisplay,
                Icons.trending_up,
              ),
              _buildProgressStat(
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
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFC2D86A),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            member.dayCountDisplay,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFC2D86A), size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildAllergiesCard(Map<String, bool> allergies) {
    final activeAllergies = allergies.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF2A2A2A).withValues(alpha: 0.8),
            const Color(0xFF1A1A1A).withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: activeAllergies.isEmpty
          ? Center(
              child: Text(
                'No allergies reported',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 14,
                ),
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
