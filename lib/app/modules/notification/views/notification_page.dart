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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Color(0xFF1A1A1A),
              Colors.black,
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with gradient background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2A2A2A),
                      Color(0xFF1A1A1A),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // App Bar
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFC2D86A).withOpacity(0.2),
                                  Color(0xFFC2D86A).withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                              onPressed: () => Get.back(),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 4,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFC2D86A),
                                        Color(0xFFB8CC5A),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Notifications',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFC2D86A).withOpacity(0.2),
                                  Color(0xFFC2D86A).withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: Icon(Icons.search, color: Colors.white),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Toggle buttons
                      Row(
                        children: [
                          _buildModernToggleButton('All', showAllNotifications, () {
                            setState(() {
                              showAllNotifications = true;
                            });
                          }),
                          SizedBox(width: 20),
                          _buildModernToggleButton('Unread', !showAllNotifications, () {
                            setState(() {
                              showAllNotifications = false;
                            });
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Today Section
                        if (_shouldShowTodaySection()) ...[
                          _buildSectionHeader('Today'),
                          SizedBox(height: 16),
                          
                          ...todayNotifications
                              .where((notification) => showAllNotifications || !notification['isRead'])
                              .map((notification) => _buildModernNotificationCard(notification))
                              .toList(),
                          
                          SizedBox(height: 30),
                        ],
                        
                        // Yesterday Section
                        if (_shouldShowYesterdaySection()) ...[
                          _buildSectionHeader('Yesterday'),
                          SizedBox(height: 16),
                          
                          ...yesterdayNotifications
                              .where((notification) => showAllNotifications || !notification['isRead'])
                              .map((notification) => _buildModernNotificationCard(notification))
                              .toList(),
                        ],
                        
                        // No notifications message
                        if (!_shouldShowTodaySection() && !_shouldShowYesterdaySection()) ...[
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 100),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFC2D86A).withOpacity(0.2),
                                          Color(0xFFC2D86A).withOpacity(0.1),
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.notifications_off_outlined,
                                      color: Color(0xFFC2D86A),
                                      size: 40,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No unread notifications',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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
  
  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFC2D86A),
                Color(0xFFB8CC5A),
              ],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
  
  Widget _buildModernToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFC2D86A),
              Color(0xFFB8CC5A),
            ],
          ) : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: isSelected ? null : Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Color(0xFFC2D86A).withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ] : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
  
  Widget _buildModernNotificationCard(Map<String, dynamic> notification) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2A2A2A),
            Color(0xFF1A1A1A),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFFC2D86A).withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle pattern overlay
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color(0xFFC2D86A).withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        notification['iconColor'].withOpacity(0.3),
                        notification['iconColor'].withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: notification['iconColor'].withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    notification['icon'],
                    color: notification['iconColor'],
                    size: 24,
                  ),
                ),
                
                SizedBox(width: 16),
                
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
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFC2D86A).withOpacity(0.2),
                                  Color(0xFFC2D86A).withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.more_vert,
                              color: Colors.white54,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 12),
                      
                      Text(
                        notification['message'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.5,
                          letterSpacing: 0.2,
                        ),
                      ),
                      
                      SizedBox(height: 12),
                      
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFC2D86A).withOpacity(0.2),
                              Color(0xFFC2D86A).withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          notification['time'],
                          style: TextStyle(
                            color: Color(0xFFC2D86A),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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
