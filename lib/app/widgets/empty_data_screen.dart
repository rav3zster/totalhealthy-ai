import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/core/base/controllers/auth_controller.dart';
import '../core/base/constants/appcolor.dart';
import 'profile_card.dart';

class EmptyDataScreen extends StatelessWidget {
  const EmptyDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userData = Get.find<AuthController>().userdataget() ?? {};

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              // Header
              const ProfileCard(title: "Welcome!"),
              const SizedBox(height: 20),

              // User Detail Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardbackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/images/user_placeholder.png',
                              ), // Use placeholder or network image
                              fit: BoxFit.cover,
                            ),
                            color: Colors.grey[800],
                          ),
                          child:
                              userData["profileImage"] == null ||
                                  userData["profileImage"].isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow(
                                'User Name: ',
                                userData["username"]?.toString() ??
                                    "Ayush Shukla",
                              ),
                              const SizedBox(height: 4),
                              _buildInfoRow(
                                'Plan Name: ',
                                userData["planName"]?.toString() ?? "Keto Plan",
                              ),
                              const SizedBox(height: 4),
                              _buildInfoRow(
                                'Plan Duration: ',
                                userData["planDuration"]?.toString() ??
                                    "Oct 1 - Nov 1",
                              ),
                              const SizedBox(height: 4),
                              _buildInfoRow(
                                'Email: ',
                                userData["email"]?.toString() ??
                                    "ayush@gmail.com",
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            _buildActionButton(Icons.email_outlined),
                            const SizedBox(height: 8),
                            _buildActionButton(Icons.call_outlined),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildProgressBar(userData),
                  ],
                ),
              ),

              const Spacer(),

              // No Data Illustration
              Column(
                children: [
                  // Placeholder for illustration - using Icon or Text for now as I don't have the asset path
                  Icon(
                    Icons.question_mark_rounded,
                    size: 80,
                    color: Colors.lightGreenAccent.withOpacity(0.5),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "No Diet Plan\nFound!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.chineseGreen,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Action Buttons
              _buildActionButtonRow(
                "Create Manually",
                "Create",
                Icons.edit_note,
                () {},
              ),
              const SizedBox(height: 15),
              _buildActionButtonRow(
                "Generate Using AI",
                "Generate",
                Icons.auto_awesome,
                () {},
              ),
              const SizedBox(height: 15),
              _buildActionButtonRow(
                "Copy From Existing",
                "Copy",
                Icons.copy,
                () {},
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 12),
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(color: Colors.white70),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.chineseGreen,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.black, size: 16),
    );
  }

  Widget _buildProgressBar(Map<String, dynamic> userData) {
    final progress = userData["progressPercentage"] ?? 85;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$progress% Progress',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: progress / 100.0,
          backgroundColor: Colors.grey[700],
          valueColor: AlwaysStoppedAnimation<Color>(
            const Color(0xFFFF7F50),
          ), // Orange color from image
          minHeight: 4,
          borderRadius: BorderRadius.circular(2),
        ),
      ],
    );
  }

  Widget _buildActionButtonRow(
    String label,
    String buttonText,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF242522), // Dark card color
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.blueAccent,
              size: 24,
            ), // Placeholder icon color
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.chineseGreen,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
