import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:totalhealthy/app/modules/group/controllers/group_controller.dart';
import 'package:totalhealthy/app/modules/group/views/groups_details.dart';
import 'package:totalhealthy/app/widgets/phone_nav_bar.dart';

import '../../../core/base/controllers/auth_controller.dart';

import '../../../widgets/group_card.dart';

import 'create_group.dart';

class GroupListPage extends StatefulWidget {
  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  var controller = Get.find<GroupController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MobileNavBar(),
      backgroundColor: const Color(0XFF0C0C0C),
      // drawer: DrawerMenu(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0XFF0C0C0C),
        title: Text(
          'Groups',
          style: TextStyle(color: Color(0XFFB3B3B3), fontSize: 24),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
                color: Color(0XFFCDE26D),
                borderRadius: BorderRadius.circular(30)),
            child: ElevatedButton.icon(
              icon: Icon(
                Icons.add,
                color: Color(0XFF242522),
                size: 28,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return CreateGroup(
                        isGroup: true,
                      );
                    });
              },

              
              label: const Text(
                "Add group",
                style: TextStyle(
                    color: Color(0XFF242522),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        return controller.isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : controller.groupData.isEmpty
                ? Center(child: Text("No data found"))
                : ListView.builder(
                    itemCount: controller.groupData.length,
                    itemBuilder: (context, index) {
                      final group = controller.groupData[index];
                      return GestureDetector(
                        onTap: () {
                          Get.find<AuthController>().roleGet() == "user"
                              ? null
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GroupsViewScreen()),
                                );

                          controller.group(group);
                        },
                        child: GroupCard(group: group),
                      );
                    },
                  );
      }),
    );
  }
}
