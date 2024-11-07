import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/widgets/custom_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    slectedValue = "isUser=true";
                    isMaleSelected = true;
                    isFemaleSelected = false; // Deselect female
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 0),
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
                  width: 110,
                  height: 110,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Icon(Icons.person, size: 35),
                      SizedBox(height: 20),
                      Text(
                        "User",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 100,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    slectedValue = "isUser=false";
                    isFemaleSelected = true;
                    isMaleSelected = false; // Deselect male
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 0),
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
                  width: 110,
                  height: 110,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      Icon(Icons.group, size: 35),
                      SizedBox(height: 20),
                      Text(
                        "Group",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 60,
          ),
          CustomButton(
            type: ButtonType.elevated,
            size: ButtonSize.medium,
            onPressed: () {
              slectedValue == ""
                  ? null
                  : Get.toNamed("${Routes.USER_GROUP_VIEW}?$slectedValue");
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
                    "Member Advisor",
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
                slectedValue = Routes.USER_GROUP_VIEW;
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
                  slectedValue == "" ? null : Get.offAllNamed(slectedValue);
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
    );
  }
}
