import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/group_controller.dart';
import '../../../data/services/dummy_data_service.dart';
import '../../../routes/app_pages.dart';

class GroupView extends GetView<GroupController> {
  GroupView({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = DummyDataService.getDummyGroups();
    
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
                      Get.offNamed(Routes.ClientDashboard);
                    },
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Groups',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showCreateGroupDialog(context);
                    },
                    icon: Icon(Icons.add, color: Colors.black, size: 20),
                    label: Text(
                      'Add Group',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFC2D86A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ],
              ),
            ),
            
            // Groups List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  final group = groups[index];
                  return _buildGroupCard(group);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildGroupCard(Map<String, dynamic> group) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.GROUP_DETAILS, arguments: group);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
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
              group['name'] ?? 'Group Name',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            
            // Description
            Text(
              group['description'] ?? 'Group description',
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
                  'Created On: ${group['createdDate'] ?? 'Unknown'}',
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
                  'Total Members: ${group['memberCount'] ?? 0} Members',
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
    );
  }
  
  void _showCreateGroupDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF2A2A2A),
        title: Text(
          'Create New Group',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Group Name',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFC2D86A)),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFC2D86A)),
                ),
              ),
              style: TextStyle(color: Colors.white),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Get.snackbar(
                'Success',
                'Group "${nameController.text}" created successfully!',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFC2D86A),
            ),
            child: Text(
              'Create',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
