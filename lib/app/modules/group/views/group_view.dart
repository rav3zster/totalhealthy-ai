import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/group_controller.dart';
import '../../../data/services/dummy_data_service.dart';
import '../../../widgets/group_card.dart';
import '../../../routes/app_pages.dart';

class GroupView extends GetView<GroupController> {
  GroupView({super.key});

  @override
  Widget build(BuildContext context) {
    final groups = DummyDataService.getDummyGroups();
    
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(Routes.ClientDashboard);
        return false; // Block browser back
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            'Groups',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              // Navigate directly to client dashboard instead of going back to splash
              Get.offNamed(Routes.ClientDashboard);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                _showCreateGroupDialog(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF242522),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search groups...',
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIcon: Icon(Icons.search, color: Colors.white54),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Categories
              Text(
                'Categories',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('All', true),
                    _buildCategoryChip('Fitness', false),
                    _buildCategoryChip('Weight Loss', false),
                    _buildCategoryChip('Yoga', false),
                    _buildCategoryChip('Nutrition', false),
                    _buildCategoryChip('Running', false),
                  ],
                ),
              ),
              
              SizedBox(height: 20),
              
              // Groups List
              Text(
                'Your Groups',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              
              Expanded(
                child: ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: GroupCard(
                        group: {
                          'group_name': group['name'],
                          'description': group['description'],
                          'created_at': group['createdDate'],
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
          ),
        ),
        selected: isSelected,
        onSelected: (bool selected) {
          // Handle category selection
        },
        backgroundColor: Color(0xFF242522),
        selectedColor: Color(0xFFF5D657),
        checkmarkColor: Colors.black,
      ),
    );
  }
  
  void _showCreateGroupDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF242522),
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
                  borderSide: BorderSide(color: Color(0xFFF5D657)),
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
                  borderSide: BorderSide(color: Color(0xFFF5D657)),
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
              backgroundColor: Color(0xFFF5D657),
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
