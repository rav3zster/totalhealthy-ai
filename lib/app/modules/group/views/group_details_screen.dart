import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/dummy_data_service.dart';

class GroupDetailsScreen extends StatelessWidget {
  const GroupDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get group data from arguments
    final Map<String, dynamic> group = Get.arguments ?? {};
    final List<Map<String, dynamic>> members = _getDummyMembers();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Groups Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            
            // Group Info Card
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Group Name
                  Text(
                    group['name'] ?? 'Weekly Meal Planning Group',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  // Description
                  Text(
                    group['description'] ?? 'A support group for planning and tracking weekly meal prep, ideal for maintaining a balanced diet.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Created Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Color(0xFFC2D86A),
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Created On: ${group['createdDate'] ?? 'August 1, 2024'}',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  
                  // Total Members
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        color: Color(0xFFC2D86A),
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Total Members: ${group['memberCount'] ?? members.length} Members',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Members List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return _buildMemberCard(member);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMemberCard(Map<String, dynamic> member) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Profile Image
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(member['profileImage'] ?? 'https://via.placeholder.com/150'),
              ),
              SizedBox(width: 16),
              
              // Member Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Name: ${member['name']}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Plan Name: ${member['planName']}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Plan Duration: ${member['planDuration']}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Email: ${member['email']}',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Action Buttons
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFFC2D86A),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.phone, color: Colors.black, size: 20),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFFC2D86A),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.email, color: Colors.black, size: 20),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFFC2D86A),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.chat, color: Colors.black, size: 20),
                  ),
                ],
              ),
            ],
          ),
          
          // Add Client Button
          SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.CLIENT_LIST);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFC2D86A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                'Add Client',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  List<Map<String, dynamic>> _getDummyMembers() {
    return [
      {
        'name': 'Ayush Shukla',
        'planName': 'Keto Plan',
        'planDuration': 'Oct 1 - Nov 1',
        'email': 'ayush@gmail.com',
        'profileImage': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
      },
      {
        'name': 'Rahul Sharma',
        'planName': 'Vegan Balanced Diet',
        'planDuration': 'Oct 1 - Nov 1',
        'email': 'rahul@gmail.com',
        'profileImage': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
      },
      {
        'name': 'Pankaj Singh',
        'planName': 'High Protein Diet',
        'planDuration': 'Oct 1 - Nov 1',
        'email': 'pankaj@gmail.com',
        'profileImage': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face',
      },
      {
        'name': 'Manoj Tiwari',
        'planName': 'Mediterranean Plan',
        'planDuration': 'Oct 1 - Nov 1',
        'email': 'manoj@gmail.com',
        'profileImage': 'https://images.unsplash.com/photo-1519244703995-f4e0f30006d5?w=150&h=150&fit=crop&crop=face',
      },
    ];
  }
}