import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/notification/controllers/notification_controller.dart';
import 'package:totalhealthy/app/widgets/custom_button.dart';

import '../../../core/base/constants/appcolor.dart';
import '../../../core/base/controllers/auth_controller.dart';
import '../../../data/services/mock_api_service.dart';

class NotificationsPage extends StatefulWidget {
  final NotificationController controller;
  final String id;
  const NotificationsPage(
      {super.key, required this.controller, required this.id});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool showAllNotifications = true;
  
  // Mock notification data
  final List<Map<String, dynamic>> todayNotifications = [
    {
      'type': 'New Recipe',
      'title': 'New Recipe',
      'message': 'Try our delicious Quinoa Salad Bowl recipe, packed with protein and fresh veggies for a nutritious meal option.',
      'time': '2 Minutes Ago',
      'icon': Icons.receipt_long,
      'iconColor': Color(0xFFC2D86A),
      'isRead': false,
    },
    {
      'type': 'Meal Reminder',
      'title': 'Meal Reminder',
      'message': 'It\'s lunchtime! Don\'t forget to fuel your body with a balanced meal to keep your energy levels up.',
      'time': '4 Minutes Ago',
      'icon': Icons.access_time,
      'iconColor': Colors.white,
      'isRead': false,
    },
  ];
  
  final List<Map<String, dynamic>> yesterdayNotifications = [
    {
      'type': 'Recommended Recipe',
      'title': 'Recommended Recipe',
      'message': 'Based on your preferences, we suggest trying our Avocado Toast with Poached Egg for a satisfying breakfast option.',
      'time': '9:00 AM',
      'icon': Icons.recommend,
      'iconColor': Color(0xFF9C27B0),
      'isRead': true,
    },
    {
      'type': 'Meal Reminder',
      'title': 'Meal Reminder',
      'message': 'It\'s lunchtime! Don\'t forget to fuel your body with a balanced meal to keep your energy levels up.',
      'time': '9:00 AM',
      'icon': Icons.access_time,
      'iconColor': Colors.white,
      'isRead': true,
    },
  ];

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
        title: Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            
            // Toggle buttons
            Row(
              children: [
                _buildToggleButton('All', showAllNotifications, () {
                  setState(() {
                    showAllNotifications = true;
                  });
                }),
                SizedBox(width: 20),
                _buildToggleButton('Unread', !showAllNotifications, () {
                  setState(() {
                    showAllNotifications = false;
                  });
                }),
              ],
            ),
            
            SizedBox(height: 30),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Today Section
                    if (_shouldShowTodaySection()) ...[
                      Text(
                        'Today',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      ...todayNotifications
                          .where((notification) => showAllNotifications || !notification['isRead'])
                          .map((notification) => _buildNotificationCard(notification))
                          .toList(),
                      
                      SizedBox(height: 30),
                    ],
                    
                    // Yesterday Section
                    if (_shouldShowYesterdaySection()) ...[
                      Text(
                        'Yesterday',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      ...yesterdayNotifications
                          .where((notification) => showAllNotifications || !notification['isRead'])
                          .map((notification) => _buildNotificationCard(notification))
                          .toList(),
                    ],
                    
                    // No notifications message
                    if (!_shouldShowTodaySection() && !_shouldShowYesterdaySection()) ...[
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: Text(
                            'No unread notifications',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  bool _shouldShowTodaySection() {
    if (showAllNotifications) return todayNotifications.isNotEmpty;
    return todayNotifications.any((notification) => !notification['isRead']);
  }
  
  bool _shouldShowYesterdaySection() {
    if (showAllNotifications) return yesterdayNotifications.isNotEmpty;
    return yesterdayNotifications.any((notification) => !notification['isRead']);
  }
  
  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFC2D86A) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: isSelected ? null : Border.all(color: Colors.white54),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
  
  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: notification['iconColor'],
              shape: BoxShape.circle,
            ),
            child: Icon(
              notification['icon'],
              color: notification['iconColor'] == Colors.white ? Colors.black : Colors.black,
              size: 20,
            ),
          ),
          
          SizedBox(width: 12),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notification['title'],
                      style: TextStyle(
                        color: Color(0xFFC2D86A),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      Icons.more_vert,
                      color: Colors.white54,
                      size: 20,
                    ),
                  ],
                ),
                
                SizedBox(height: 8),
                
                Text(
                  notification['message'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                
                SizedBox(height: 8),
                
                Text(
                  notification['time'],
                  style: TextStyle(
                    color: Color(0xFFC2D86A),
                    fontSize: 12,
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
}
