import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/widgets/custom_button.dart';

import '../core/base/controllers/auth_controller.dart';
import '../routes/app_pages.dart';

class SwitchRoleScreen extends StatefulWidget {
  const SwitchRoleScreen({super.key});

  @override
  State<SwitchRoleScreen> createState() => _SwitchRoleScreenState();
}

class _SwitchRoleScreenState extends State<SwitchRoleScreen> {
  bool isMaleSelected = false; // Track Male selection
  bool isFemaleSelected = false;
  String slectedValue = "";
  String role = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 150,
            ),
            Text(
              "Choose As Who You Want",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0XFFFFFFFF)),
            ),
            Text(
              "To Continue!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0XFFFFFFFF),
              ),
            ),
            Text(
              "How Do You Identify Yourself?",
              style: TextStyle(color: Color(0XFF7B7B7A), fontSize: 16),
            ),
            SizedBox(
              height: 60,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  slectedValue = "isUser=false";
                  role = "admin";
                  isMaleSelected = true;
                  isFemaleSelected = false; // Deselect female
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 36, 36, 36),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isMaleSelected
                        ? const Color.fromARGB(255, 146, 159, 83)
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      "assets/advisor.png",
                      fit: BoxFit.cover,
                      height: 55,
                      width: 50,
                    ),
                    SizedBox(width: 18),
                    Text(
                      "Advisor",
                      style: TextStyle(
                        color: Color(0XFF8C8C8C),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  slectedValue = "isUser=true";
                  role = "user";
                  // Get.find<AuthController>().roleStore("user");
                  isFemaleSelected = true;
                  isMaleSelected = false; // Deselect male
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 36, 36, 36),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isFemaleSelected
                        ? Colors.amberAccent
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      "assets/member.png",
                      fit: BoxFit.cover,
                      height: 55,
                      width: 50,
                    ),
                    SizedBox(width: 18),
                    Text(
                      "Member",
                      style: TextStyle(
                        color: Color(0XFF8C8C8C),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 200,
            ),
            SizedBox(
              width: 410,
              height: 60,
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0XFFCDE26D),
                    borderRadius: BorderRadius.circular(30)),
                child: ElevatedButton(
                  onPressed: () {
                    slectedValue == ""
                        ? null
                        : Get.offAllNamed(
                            "${Routes.USER_GROUP_VIEW}?$slectedValue");
                    role == ""
                        ? null
                        : Get.find<AuthController>().roleStore(role);
                  },
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                        color: Color(0XFF242522),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
