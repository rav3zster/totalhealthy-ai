import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:totalhealthy/app/modules/group/controllers/group_controller.dart';
import 'package:totalhealthy/app/modules/group/views/groups_details.dart';
import 'package:totalhealthy/app/widgets/phone_nav_bar.dart';

import '../../../core/base/apiservice/api_endpoints.dart';
import '../../../core/base/apiservice/api_status.dart';
import '../../../core/base/apiservice/base_methods.dart';
import '../../../core/base/controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/drawer_menu.dart';
import '../../registration/views/registration_view.dart';

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
      drawer: DrawerMenu(),
      appBar: AppBar(
        backgroundColor: Color(0XFF0C0C0C),

        // leading: IconButton(
        //   onPressed: () {
        //     Get.back();
        //   },
        //   icon: Icon(Icons.arrow_back_ios),
        //   color: Color(0XFFD9D9D9),
        // ),
        title: Text(
          'Groups',
          style: TextStyle(color: Color(0XFFB3B3B3), fontSize: 24),
        ),
        // actions: [
        //   Container(
        //     decoration: BoxDecoration(
        //         color: Color(0XFFCDE26D),
        //         borderRadius: BorderRadius.circular(30)),
        //     child: ElevatedButton.icon(
        //       icon: Icon(
        //         Icons.add,
        //         color: Color(0XFF242522),
        //         size: 28,
        //       ),
        //       onPressed: () {
        //         showDialog(
        //             context: context,
        //             builder: (context) {
        //               return CreateGroup();
        //             });
        //       },
        //       label: const Text(
        //         "Add group",
        //         style: TextStyle(
        //             color: Color(0XFF242522),
        //             fontWeight: FontWeight.bold,
        //             fontSize: 18),
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: Obx(() {
        return controller.isLoading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: controller.groupData.length,
                itemBuilder: (context, index) {
                  final group = controller.groupData[index];
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.TrainerDashboard);
                      Get.find<AuthController>()
                          .groupIdStore(group["group_id"]);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => GroupsViewScreen()),
                      // );

                      controller.group(group);
                    },
                    child: Card(
                      margin: EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(0XFF242522),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                group["group_name"],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0XFFDBDBDB)),
                              ),
                              SizedBox(height: 8),
                              Text(
                                group["description"],
                                style: TextStyle(
                                    fontSize: 16, color: Color(0XFF7E7E7E)),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Color(0XFFCDE26D)
                                              .withOpacity(0.1),
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        Icons.calendar_today_outlined,
                                        color: Color(0XFFCDE26D),
                                        size: 18,
                                      )),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Created On:"),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${group["created_at"]}",
                                    style: TextStyle(
                                        fontSize: 14, color: Color(0XFFFFFFFF)),
                                  ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Container(
                              //         padding: EdgeInsets.all(8),
                              //         decoration: BoxDecoration(
                              //             color:
                              //                 Color(0XFFCDE26D).withOpacity(0.1),
                              //             shape: BoxShape.circle),
                              //         child: Icon(
                              //           Icons.people_outline,
                              //           color: Color(0XFFCDE26D),
                              //           size: 18,
                              //         )),
                              //     SizedBox(
                              //       width: 5,
                              //     ),
                              //     // Text("Total Members:"),
                              //     // SizedBox(
                              //     //   width: 10,
                              //     // ),
                              //     // Text(
                              //     //   "12 Members",
                              //     //   style: TextStyle(
                              //     //       fontSize: 14, color: Color(0XFFFFFFFF)),
                              //     // ),
                              //   ],
                              // ),
                              //
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
      }),
    );
  }
}
