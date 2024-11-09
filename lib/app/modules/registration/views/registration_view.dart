import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/core/base/controllers/auth_controller.dart';
import 'package:totalhealthy/app/modules/generate_ai/views/generate_ai_screen.dart';
import 'package:totalhealthy/app/modules/manage_accounts/views/manage_accounts_views.dart';
import 'package:totalhealthy/app/widgets/phone_nav_bar.dart';

import '../../generate_ai/widgets/generate_ai_page.dart';
import '../../nutrition_goal/views/nutrition_goal_screen.dart';

class RegistrationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MobileNavBar(),
      body: Container(
        color: Color(0xFF0C0C0C),
        child: Column(
          children: [
            // App Bar
            PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: AppBar(
                backgroundColor: Color(0XFF000000).withOpacity(0.1),
                elevation: 0,
                centerTitle: true,
                title: Text('Profile',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile Picture
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            'https://example.com/profile-picture.jpg'),
                      ),
                    ),

                    // Name
                    Text(
                      Get.find<AuthController>()
                          .userdataget()["name"]
                          .toString(),
                      style: TextStyle(
                          fontSize: 22,
                          color: Color(0XFFB2B2B2),
                          fontWeight: FontWeight.bold),
                    ),

                    SizedBox(height: 16),

                    // Weight, Age, Height in rounded corner boxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInfoCard('Weight', '56 kg'),
                        _buildInfoCard('Age', '23 Year'),
                        _buildInfoCard('Height', '164 cm'),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Menu Options in separate containers with back arrow
                    _buildMenuOptionContainer(
                      title: 'Manage Account',
                      icon: Icons.manage_accounts,
                      onTap: () {
                        // Placeholder for future navigation
                      },
                    ),
                    _buildMenuOptionContainer(
                      title: 'Goal Setting',
                      icon: Icons.flag,
                      onTap: () {
                        // Navigate to NutritionGoalsScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NutritionGoalsScreen()),
                        );
                      },
                    ),
                    _buildMenuOptionContainer(
                      title: 'Linked Accounts',
                      icon: Icons.link,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ManageAccountScreen()),
                        );
                      },
                    ),
                    _buildMenuOptionContainer(
                      title: 'Diet Preference',
                      icon: Icons.next_plan,
                      onTap: () {
                        // Navigate to NutritionGoalsScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GenerateAiPage(
                                    id: '',
                                  )),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOptionContainer({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 30),
                SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
