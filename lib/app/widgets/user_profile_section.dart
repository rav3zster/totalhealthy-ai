import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../core/base/constants/appcolor.dart';

class UserProfileSection extends StatelessWidget {
  const UserProfileSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final userController = Get.find<UserController>();
      final user = userController.currentUser;
      final userData = user?.toJson() ?? {};

      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardbackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // User Info Row
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.chineseGreen,
                  radius: 30,
                  backgroundImage: UserController.getImageProvider(
                    userController.profileImage,
                  ),
                  child: userController.profileImage.isEmpty
                      ? const Icon(Icons.person, color: Colors.black, size: 30)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow(
                        'User Name: ',
                        userData["username"]?.toString() ?? "Ayush Shukla",
                      ),
                      const SizedBox(height: 4),
                      _buildInfoRow(
                        'Plan Name: ',
                        userData["planName"]?.toString() ?? "Keto Plan",
                      ),
                      const SizedBox(height: 4),
                      _buildInfoRow(
                        'Plan Duration: ',
                        userData["planDuration"]?.toString() ?? "Oct 1 - Nov 1",
                      ),
                      const SizedBox(height: 4),
                      _buildInfoRow(
                        'Email: ',
                        userData["email"]?.toString() ?? "ayush@gmail.com",
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    _buildActionButton(Icons.message),
                    const SizedBox(height: 8),
                    _buildActionButton(Icons.call),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Progress Bar
            _buildProgressBar(userData),
            const SizedBox(height: 20),
            // Calories Intake Card
            _buildCaloriesIntakeCard(),
          ],
        ),
      );
    });
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 14)),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.chineseGreen,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.black, size: 20),
    );
  }

  Widget _buildProgressBar(Map<String, dynamic> userData) {
    final progress = userData["progressPercentage"] ?? 85;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$progress% Progress',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress / 100.0,
          backgroundColor: Colors.grey[700],
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.chineseGreen),
          minHeight: 6,
        ),
      ],
    );
  }

  Widget _buildCaloriesIntakeCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
        color: AppColors.white.withValues(alpha: .1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Daily Calories Intake',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIndicatorCard('Eaten', '1258 Kcal', 0.60),
              _buildIndicatorCard('Burn', '558 Kcal', 0.60),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNutrientColumn(
                '35',
                '/75',
                'Proteins',
                const Color(0XFFFF5122),
              ),
              _buildVerticalDivider(),
              _buildNutrientColumn('120', '/200', 'Carbs', Colors.yellow),
              _buildVerticalDivider(),
              _buildNutrientColumn(
                '35',
                '/75',
                'Fats',
                const Color(0XFF8B3BFF),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorCard(String title, String value, double progress) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color.fromRGBO(193, 223, 59, 1),
          ),
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            value: progress,
            color: AppColors.chineseGreen,
            backgroundColor: Colors.white,
            strokeWidth: 6,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNutrientColumn(
    String mainValue,
    String subValue,
    String title,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text.rich(
          TextSpan(
            text: mainValue,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            children: [
              TextSpan(
                text: subValue,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.white)),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 30, width: 1, color: Colors.grey);
  }
}
