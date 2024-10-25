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
        leading: Icon(Icons.arrow_back_ios_new_outlined, color: Color(0XFFDBDBDB)),
        title: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(right: 35), // Adjust this value to control the left shift
            child: Center(
              child: Text(
                'Notifications',
                style: TextStyle(color: Color(0XFFFFFFFF)),
              ),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(70), // Adjust height if needed
          child: Material(
            elevation: 0, // Remove any elevation that might cause a shadow line
            color: Colors.black, // TabBar background color
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'All'),
                Tab(text: 'Unread'),
              ],
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              dividerColor: Color(0XFF0C0C0C),
              indicator: BoxDecoration(
                color: Color(0XFFCDE26D),  // Background color of selected tab
                borderRadius: BorderRadius.circular(50),  // Rounded indicator
              ),
              indicatorSize: TabBarIndicatorSize.tab,  // Make the indicator cover the entire tab width
              // Remove the line by ensuring no other indicators are present
            ),
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
              // Adding "Today" and "Yesterday" labels
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "Today" label
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      child: Text(
                        "Today",
                        style: TextStyle(
                          fontSize: 20, // Adjusted font size
                          color: Color(0xFFFFFFFF), // Color #FFFFFF
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Build notification card for New Recipe with yellow color
                    buildNotificationCard(
                      notifications[index]['title'],
                      notifications[index]['content'],
                      notifications[index]['time'],
                      getIcon(notifications[index]['icon']),
                      getColor(notifications[index]['iconColor']),
                      Color(0xFFF5D658), // Title color for New Recipe (Yellow)
                      Color(0xFFF5D658),
                      true// Time color for New Recipe (Yellow)
                    ),
                  ],
                );
              } else if (notifications[index]['title'] == "Meal Reminder") {
                return buildNotificationCard(
                  notifications[index]['title'],
                  notifications[index]['content'],
                  notifications[index]['time'],
                  getIcon(notifications[index]['icon']),
                  getColor(notifications[index]['iconColor']),
                  Color(0xFFFFFFFF), // Title color for Meal Reminder (White)
                  Color(0xFFFFFFFF),
                  false// Time color for Meal Reminder (White)
                );
              } else if (notifications[index]['time'] == "9:00 AM") {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // "Yesterday" label
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      child: Text(
                        "Yesterday",
                        style: TextStyle(
                          fontSize: 20, // Adjusted font size
                          color: Color(0xFFFFFFFF), // Color #FFFFFF
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Build notification card for the Recommended Recipe
                    buildNotificationCard(
                      notifications[index]['title'],
                      notifications[index]['content'],
                      notifications[index]['time'],
                      getIcon(notifications[index]['icon']),
                      getColor(notifications[index]['iconColor']),
                      Color(0xFFD2B5F6), // Title color for Recommended Recipe
                      Color(0xFFD2B5F6),
                      false// Time color for Recommended Recipe
                    ),
                  ],
                );
              } else {
                return buildNotificationCard(
                  notifications[index]['title'],
                  notifications[index]['content'],
                  notifications[index]['time'],
                  getIcon(notifications[index]['icon']),
                  getColor(notifications[index]['iconColor']),
                  Color(0xFFFFFFFF), // Title color for other notifications
                  Color(0xFFFFFFFF),
                  false// Time color for other notifications
                );
              }
            },
          ),

        ],
      ),
    );
  }

// Function to build notification cards
  Widget buildNotificationCard(
      String title,
      String content,
      String time,
      IconData icon,
      Color iconColor,
      Color titleColor,
      Color timeColor,
      bool isActive) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isActive ? Color(0XFF333333): Color(0XFF12110D),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: iconColor, // Use provided icon color
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
                      color: titleColor, // Use provided title color
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                SizedBox(height: 5),
                Text(
                  content,
                  style: TextStyle(
                      color: Color(0xFFFFFFFF), // Set content text color to #FFFFFF
                      fontSize: 14),
                ),
                SizedBox(height: 5),
                Text(
                  time,
                  style: TextStyle(
                      color: timeColor, // Use provided time color
                      fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: Color(0XFFECEBE7)),
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