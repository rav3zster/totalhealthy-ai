import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:totalhealthy/app/core/base/controllers/auth_controller.dart';

import '../../../core/base/constants/appcolor.dart';
import '../../../data/services/mock_api_service.dart';

import '../../../widgets/baseWidget.dart';
import '../../../widgets/client_card.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/drawer_menu.dart';
import '../../../widgets/notification_services.dart';
import '../../../widgets/phone_nav_bar.dart';
import '../../../widgets/profile_card.dart';
import '../../group/views/add_client.dart';

class TrainerDashboardView extends StatefulWidget {
  @override
  State<TrainerDashboardView> createState() => _TrainerDashboardViewState();
}

class _TrainerDashboardViewState extends State<TrainerDashboardView> {
  var searchController = TextEditingController();
  bool isLoading = false;
  var userData = {};
  Future<void> submitUser() async {
    try {
      setState(() {
        isLoading = true;
      });
      String input = searchController.text.trim();
      var phone = int.tryParse(input);
      
      // Use mock API instead of real API
      final response = phone != null
          ? await MockApiService.searchUserByPhone(input)
          : await MockApiService.searchUserByEmail(input);
      
      if (response['statusCode'] == 200) {
        setState(() {
          groupMemberData = [response['data']];
        });

          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('User  Successful!'),
          //     backgroundColor: Colors.green,
          //   ),
          // );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${response["message"]}'),
              backgroundColor: Colors.red,
            ),
          );
        }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  var isGroupLoading = false;
  var dataList = [];
  var uniqueDataList = [];

  Future<void> getGroup() async {
    try {
      setState(() {
        isGroupLoading = true;
      });
      
      // Use mock API instead of real API
      final response = await MockApiService.getGroups(
        Get.find<AuthController>().roleGet() == "admin" ? "admin" : "user"
      );
      
      if (response['statusCode'] == 200) {
        setState(() {
          dataList = response['data'];
          uniqueDataList = dataList
              .map((item) => item["name"])
              .toSet()
              .map((groupName) => dataList
                  .firstWhere((item) => item["name"] == groupName))
              .toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${response["message"]}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isGroupLoading = false;
      });
    }
  }

  bool isMemberLoading = false;
  var groupMemberData = [];
  NotificationService notificationService = NotificationService();
  
  Future<void> getCategories() async {
    try {
      // Use mock API instead of real API
      final response = await MockApiService.getMealCategories(
        Get.find<AuthController>().groupgetId()
      );
      
      if (response['statusCode'] == 200) {
        Get.find<AuthController>().categoriesAdd(response['data']);
        Get.find<AuthController>().fetchAndScheduleNotifications(response['data']);
      } else {
        print("Categories Not Found");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getMember() async {
    try {
      setState(() {
        isMemberLoading = true;
      });
      await getCategories();
      
      // Use mock API instead of real API
      final response = await MockApiService.getGroupMembers(
        Get.find<AuthController>().groupgetId()
      );
      
      if (response['statusCode'] == 200) {
        setState(() {
          groupMemberData = response['data'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${response["message"]}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isMemberLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getMember();
  }

  String? valueDropDown;
  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // DateTime(dateTime.year, dateTime.month, dateTime.day, 16, 30)

      //   },
      //   child: Icon(Icons.notifications),
      // ),
      // bottomNavigationBar: MobileNavBar(),
      // drawer: DrawerMenu(),
      // backgroundColor: Color(0XFF0C0C0C),
      // appBar: AppBar(
      //   iconTheme: IconThemeData(color: Colors.white),
      //   automaticallyImplyLeading: false,
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   title: ProfileCard(),
      // ),
      title: "${ProfileCard()}",
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF2E2E2E),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  // Live Stats Title
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Live Stats',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Space below the title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            groupMemberData.length.isLowerThan(10)
                                ? "0${groupMemberData.length}"
                                : "${groupMemberData.length}",
                            style: TextStyle(
                                color: Color(0XFFF57552),
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'No. Of Clients',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      // Vertical Divider
                      Container(
                        height: 50,
                        width: 1,
                        color: Colors.grey,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '05',
                            style: TextStyle(
                                color: Color(0XFFF5D657),
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Active Diet Plans',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                      // Vertical Divider
                      Container(
                        height: 50,
                        width: 1,
                        color: Colors.grey,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '07',
                            style: TextStyle(
                                color: Color(0XFFD0B4F9),
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Pending Requests',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          // ElevatedButton(
                          //     onPressed: (){
                          //   notificationService.scheduleNotification(
                          //   title: "title",
                          //   hour: 12,
                          //   id: 12312,
                          //   minute: 59,
                          //   body: 'body',
                          // );
                          //   }, child: Text("Notification Test"))
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),
            // Search Bar
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)),
                      fillColor: Color(0XFF242522),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)),
                      hintText: 'Search here...',
                      hintStyle: TextStyle(color: Color(0XFFDBDBDB)),
                      prefixIcon: Icon(Icons.search, color: Color(0XFFDBDBDB)),
                    ),
                  ),
                ),
                CustomButton(
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Text(
                            "Search",
                            style: TextStyle(color: AppColors.buttonText),
                          ),
                    onPressed: () => submitUser(),
                    size: ButtonSize.medium,
                    type: ButtonType.elevated),
                // SizedBox(width: 10),
                // Icon(Icons.filter_list, color: Colors.white, size: 30),
              ],
            ),

            SizedBox(height: 20),
            // Add Client Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Client List',
                  style: TextStyle(
                      color: Color(0XFFFFFFFF),
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: Color(0XFF242522),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFCDE26D),
                    // Add Client Button Color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddClient(
                              id: Get.find<AuthController>().groupgetId())),
                    );
                  },
                  label: Text('Add Client',
                      style: TextStyle(color: Color(0XFF242522))),
                ),
              ],
            ),
            // SizedBox(height: 10),
            // Client List

            isMemberLoading || isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: groupMemberData.length,
                        itemBuilder: (context, index) {
                          var data = groupMemberData[index];
                          return data["id"] != null
                              ? InkWell(
                                  onTap: () {
                                    // Get.toNamed("/userdiet?id=${data["id"]}");
                                  },
                                  child: ClientCard(
                                    name: "Not Found",
                                    email: "${data["email"]}",
                                    progress: 56,
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    GetStorage().write("clientData", data);
                                    Get.toNamed(
                                        "/userdiet?id=${data["user_id"]}");
                                  },
                                  child: ClientCard(
                                    name: "${data["user_details"]["name"]}",
                                    email: "${data["user_details"]["email"]}",

                                    // "${data["user_details"]["phone_number"] ?? data["phone_number"]}",

                                    progress: 56,
                                  ),
                                );
                        },
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
