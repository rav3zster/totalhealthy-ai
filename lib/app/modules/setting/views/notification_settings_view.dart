import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationSettingsView extends StatefulWidget {
  const NotificationSettingsView({super.key});

  @override
  State<NotificationSettingsView> createState() => _NotificationSettingsViewState();
}

class _NotificationSettingsViewState extends State<NotificationSettingsView> {
  String mealReminderStatus = 'On';
  String waterReminderStatus = 'Off';
  String exerciseReminderStatus = 'On';
  String updateNotificationStatus = 'On';

  final List<String> statusOptions = ['On', 'Off'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              size: 24,
              color: Colors.white,
            ),
          )
        ],
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meal reminder
            _buildNotificationSetting(
              'Meal reminder',
              mealReminderStatus,
              (String? newValue) {
                setState(() {
                  mealReminderStatus = newValue!;
                });
              },
            ),
            
            SizedBox(height: 30),
            
            // Water reminder
            _buildNotificationSetting(
              'Water reminder',
              waterReminderStatus,
              (String? newValue) {
                setState(() {
                  waterReminderStatus = newValue!;
                });
              },
            ),
            
            SizedBox(height: 30),
            
            // Exercise reminder
            _buildNotificationSetting(
              'Exercise reminder',
              exerciseReminderStatus,
              (String? newValue) {
                setState(() {
                  exerciseReminderStatus = newValue!;
                });
              },
            ),
            
            SizedBox(height: 30),
            
            // Update Notification
            _buildNotificationSetting(
              'Update Notification',
              updateNotificationStatus,
              (String? newValue) {
                setState(() {
                  updateNotificationStatus = newValue!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNotificationSetting(String title, String currentValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentValue,
              dropdownColor: Color(0xFF2A2A2A),
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
              style: TextStyle(
                color: Color(0xFFC2D86A),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              items: statusOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}