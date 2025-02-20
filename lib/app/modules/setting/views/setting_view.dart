import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/widgets/phone_nav_bar.dart';
import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MobileNavBar(),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:
            Icon(Icons.arrow_back_ios_new_outlined, color: Color(0XFFDBDBDB)),
        actions: [
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.search,
                size: 35,
                color: Colors.white,
              ))
        ],
        title: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(right: 35),
            // Adjust this value to control the left shift
            child: Text(
              'Settings',
              style: TextStyle(
                  color: Color(0XFFFFFFFF),
                  fontFamily: 'inter',
                  fontSize: 24,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Option(
              value: "General Setting",
            ),
            Option(
              value: "Notification",
            ),
            Option(
              value: "Account & Password",
            ),

            // log out button
            InkWell(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                width: double.infinity,
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      size: 30,
                      color: Color(0xffA67473),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Log Out",
                      style: TextStyle(fontSize: 20, color: Color(0xffA67473)),
                    )
                  ],
                ),
              ),
              borderRadius: BorderRadius.circular(10),
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}

class Option extends StatelessWidget {
  Option({required this.value});

  String value;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: double.infinity,
        //  color: Colors.greenAccent,
        padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
        child: Text(
          "${value}",
          style: TextStyle(fontSize: 20, color: Colors.white60),
        ),
      ),
      borderRadius: BorderRadius.circular(10),
      onTap: () {},
    );
  }
}
