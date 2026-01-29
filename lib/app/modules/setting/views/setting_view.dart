import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});
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
          'Settings',
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
          children: [
            SettingOption(
              title: "General Settings",
              onTap: () {
                Get.toNamed('/general-settings');
              },
            ),
            SizedBox(height: 20),
            SettingOption(
              title: "Notifications",
              onTap: () {
                Get.toNamed('/notification-settings');
              },
            ),
            SizedBox(height: 20),
            SettingOption(
              title: "Account And Password",
              onTap: () {
                Get.toNamed('/account-password-settings');
              },
            ),
            SizedBox(height: 40),
            // Log out button
            InkWell(
              onTap: () {
                // Handle logout
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                width: double.infinity,
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      size: 24,
                      color: Color(0xffFF6B6B),
                    ),
                    SizedBox(width: 15),
                    Text(
                      "Log Out",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xffFF6B6B),
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SettingOption extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SettingOption({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }
}
