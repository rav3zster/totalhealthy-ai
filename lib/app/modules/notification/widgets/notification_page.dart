import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/notification/controllers/notification_controller.dart';
import 'package:totalhealthy/app/widgets/custom_button.dart';

import '../../../core/base/apiservice/api_endpoints.dart';
import '../../../core/base/apiservice/api_status.dart';
import '../../../core/base/apiservice/base_methods.dart';
import '../../../core/base/constants/appcolor.dart';
import '../../../core/base/controllers/auth_controller.dart';

class NotificationsPage extends StatefulWidget {
  final NotificationController controller;
  final String id;
  const NotificationsPage(
      {super.key, required this.controller, required this.id});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var dataList = [];
  var isLoading = false;
  var isGetLoading = {};
  Future<void> postnotification(id, action, index) async {
    try {
      setState(() {
        isGetLoading[index] = true;
      });

      var data = {};
      await APIMethods.post
          .post(
        url: APIEndpoints.notification.postNotification(id, action),
        map: data,
      )
          .then((value) {
        if (APIStatus.success(value.statusCode)) {
          // setState(() {
          //   isCheck = {for (int i = 0; i < dataList.length; i++) i: false};
          //   selectedMealIds.clear();
          // });
          getNotification();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfull!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Not Found'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
      // }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isGetLoading[index] = false;
      });
    }
  }

  Future<void> getNotification() async {
    try {
      setState(() {
        isLoading = true;
      });
      await APIMethods.get
          .get(
        url: APIEndpoints.notification.getNotification,
      )
          .then((value) {
        if (APIStatus.success(value.statusCode)) {
          setState(() {
            dataList = value.data;
          });
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text("$".toString()),
          //     backgroundColor: Colors.green,
          //   ),
          // );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("No Data Found"),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
      // }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Example JSON data

  List<dynamic> notifications = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Parsing JSON data

    getNotification();
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
        leading: IconButton(
            onPressed: () {
              Get.toNamed("/userdiet?=id${widget.id}");
            },
            icon: Icon(Icons.arrow_back_ios_new_outlined),
            color: Color(0XFFDBDBDB)),
        title: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(
                right: 35), // Adjust this value to control the left shift
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
                color: Color(0XFFCDE26D), // Background color of selected tab
                borderRadius: BorderRadius.circular(50), // Rounded indicator
              ),
              indicatorSize: TabBarIndicatorSize
                  .tab, // Make the indicator cover the entire tab width
              // Remove the line by ensuring no other indicators are present
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : dataList.isEmpty
                  ? Center(
                      child: Text(
                        "Notificaion Not Found",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        var data = dataList[index];
                        return buildNotificationCard(
                            title: "Join Request",
                            message: " ${data["message"]}",
                            id: "${data["notification_id"]}",
                            icon: Icons.person);
                      },
                    ),
        ],
      ),
    );
  }

// Function to build notification cards
  Widget buildNotificationCard({
    String? title,
    String? id,
    String? content,
    String? time,
    IconData? icon,
    Color? iconColor,
    Color? titleColor,
    Color? timeColor,
    String? message,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0XFF12110D),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
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
                      title ?? '',
                      style: TextStyle(
                          color: titleColor, // Use provided title color
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      content ?? "",
                      style: TextStyle(
                          color: Color(
                              0xFFFFFFFF), // Set content text color to #FFFFFF
                          fontSize: 14),
                    ),
                    SizedBox(height: 5),
                    // Text(
                    //   time??"Not Found",
                    //   style: TextStyle(
                    //       color: timeColor, // Use provided time color
                    //       fontSize: 12),
                    // ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert, color: Color(0XFFECEBE7)),
              ),
            ],
          ),
          Text(
            message ?? 'Not Found',
            style: TextStyle(
                color: titleColor, // Use provided title color
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton(
                  child: isGetLoading[1] == true
                      ? Center(child: CircularProgressIndicator())
                      : Text(
                          "Reject",
                          style: TextStyle(color: Colors.black),
                        ),
                  color: AppColors.mandarin,
                  onPressed: () {
                    postnotification(id, "decline", 1);
                  },
                  size: ButtonSize.medium,
                  type: ButtonType.elevated),
              CustomButton(
                  child: isGetLoading[2] == true
                      ? Center(child: CircularProgressIndicator())
                      : Text(
                          "Accept",
                          style: TextStyle(color: Colors.black),
                        ),
                  color: AppColors.chineseGreen,
                  onPressed: () {
                    postnotification(id, "accept", 2);
                  },
                  size: ButtonSize.medium,
                  type: ButtonType.elevated)
            ],
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
