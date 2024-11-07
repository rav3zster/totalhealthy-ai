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
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("Switch Role Screen"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    slectedValue = Routes.ClientDashboard;
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
                    slectedValue = Routes.USER_GROUP_VIEW;
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
            height: 20,
          ),
          CustomButton(
            onPressed: () {
              slectedValue == "" ? null : Get.offAllNamed(slectedValue);
            },
            child: Text("Submit"),
            size: ButtonSize.medium,
            type: ButtonType.elevated,
          ),
        ],
      ),
    );
  }
}
