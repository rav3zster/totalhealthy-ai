import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileMainView extends StatelessWidget {
  const ProfileMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            // Profile Image and Name
            Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/user_avatar.png'),
                ),
                SizedBox(height: 16),
                Text(
                  'Jacob Jones',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 30),
            
            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Weight', '56', 'kg'),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('age', '23', 'Year'),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('height', '164', 'cm'),
                ),
              ],
            ),
            
            SizedBox(height: 40),
            
            // Menu Options
            _buildMenuOption(
              icon: Icons.person_outline,
              title: 'Profile',
              onTap: () {
                Get.toNamed('/profile-settings');
              },
            ),
            
            SizedBox(height: 16),
            
            _buildMenuOption(
              icon: Icons.track_changes_outlined,
              title: 'Goal Setting',
              onTap: () {
                Get.toNamed('/nutrition-goal');
              },
            ),
            
            SizedBox(height: 16),
            
            _buildMenuOption(
              icon: Icons.settings_outlined,
              title: 'Setting',
              onTap: () {
                Get.toNamed('/setting');
              },
            ),
            
            SizedBox(height: 16),
            
            _buildMenuOption(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {
                Get.toNamed('/help-support');
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatCard(String label, String value, String unit) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF3A3A3A)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: Color(0xFFC2D86A),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: TextStyle(
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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
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