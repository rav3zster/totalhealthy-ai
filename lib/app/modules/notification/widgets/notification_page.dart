import 'dart:convert';

import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Example JSON data
  final String jsonData = '''
  {
    "notifications": [
      {
        "title": "New Recipe",
        "content": "Try our delicious Quinoa Salad Bowl recipe, packed with protein and fresh veggies for a nutritious meal option.",
        "time": "2 Minutes Ago",
        "icon": "receipt_long",
        "iconColor": "yellow"
      },
      {
        "title": "Meal Reminder",
        "content": "It’s lunchtime! Don’t forget to fuel your body with a balanced meal to keep your energy levels up.",
        "time": "4 Minutes Ago",
        "icon": "notifications",
        "iconColor": "grey"
      },
      {
        "title": "Recommended Recipe",
        "content": "Based on your preferences, we suggest trying our Avocado Toast with Poached Egg for a satisfying breakfast option.",
        "time": "9:00 AM",
        "icon": "receipt_long",
        "iconColor": "purpleAccent"
      }
    ]
  }
  ''';

  List<dynamic> notifications = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Parsing JSON data
    Map<String, dynamic> parsedData = json.decode(jsonData);
    notifications = parsedData['notifications'];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.white),
        title: Text('Notifications', style: TextStyle(color: Colors.white)),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.greenAccent,
          indicatorWeight: 3,
          tabs: [
            Tab(text: 'All'),
            Tab(text: 'Unread'),
          ],
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.greenAccent,
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All Notifications Tab
          ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return buildNotificationCard(
                notification['title'],
                notification['content'],
                notification['time'],
                getIcon(notification['icon']),
                getColor(notification['iconColor']),
              );
            },
          ),
          // Unread Notifications Tab (You can modify this to load unread notifications)
          ListView(
            children: [
              buildNotificationCard(
                "Recommended Recipe",
                "We suggest trying our Avocado Toast with Poached Egg for a satisfying breakfast.",
                "9:00 AM",
                Icons.receipt_long,
                Colors.purpleAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Function to build notification cards
  Widget buildNotificationCard(String title, String content, String time,
      IconData icon, Color iconColor) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: iconColor,
            child: Icon(icon, color: Colors.black),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  content,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.8), fontSize: 14),
                ),
                SizedBox(height: 5),
                Text(
                  time,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.6), fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Function to map icon name from JSON to IconData
  IconData getIcon(String iconName) {
    switch (iconName) {
      case 'receipt_long':
        return Icons.receipt_long;
      case 'notifications':
        return Icons.notifications;
      default:
        return Icons.notification_important;
    }
  }

  // Function to map color name from JSON to Color
  Color getColor(String colorName) {
    switch (colorName) {
      case 'yellow':
        return Colors.yellow;
      case 'grey':
        return Colors.grey;
      case 'purpleAccent':
        return Colors.purpleAccent;
      default:
        return Colors.grey;
    }
  }
}
