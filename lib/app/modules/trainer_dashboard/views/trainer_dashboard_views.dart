import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:totalhealthy/app/core/base/controllers/auth_controller.dart';

import '../../../core/base/apiservice/api_endpoints.dart';
import '../../../core/base/apiservice/api_status.dart';
import '../../../core/base/apiservice/base_methods.dart';
import '../../../core/base/constants/appcolor.dart';

import '../../../widgets/client_card.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/drawer_menu.dart';
import '../../../widgets/phone_nav_bar.dart';
import '../../../widgets/profile_card.dart';
import '../../group/views/add_client.dart';
import '../../user_diet_screen/controllers/user_diet_screen_controllers.dart';

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
      // print(data);  String input = searchController.text.trim();
      String input = searchController.text.trim();
      var phone = int.tryParse(input);
      await APIMethods.get
          .get(
        url: phone != null
            ? APIEndpoints.createData.searchUserByPhone(input)
            : APIEndpoints.createData.searchUserByemail(input),
      )
          .then((value) {
        if (APIStatus.success(value.statusCode)) {
          setState(() {
            groupMemberData = [value.data];
          });

          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('User  Successful!'),
          //     backgroundColor: Colors.green,
          //   ),
          // );
        } else {
          // printError("Auth Controller", "Signup", value.data);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${value.data["detail"]}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
      // }new
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    // if (_formKey.currentState!.validate()) {
  }

  var isGroupLoading = false;
  var dataList = [];
  var uniqueDataList = [];

  Future<void> getGroup() async {
    try {
      setState(() {
        isGroupLoading = true;
      });
      // print(data);  String input = searchController.text.trim();

      await APIMethods.get
          .get(
        url: APIEndpoints.group.getGroup(
            Get.find<AuthController>().roleGet() == "admin" ? "admin" : "user"),
      )
          .then((value) {
        if (APIStatus.success(value.statusCode)) {
          setState(() {
            dataList = value.data;
            uniqueDataList = dataList
                .map((item) => item["group_name"])
                .toSet()
                .map((groupName) => dataList
                    .firstWhere((item) => item["group_name"] == groupName))
                .toList();
          });

          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('User  Successful!'),
          //     backgroundColor: Colors.green,
          //   ),
          // );
        } else {
          // printError("Auth Controller", "Signup", value.data);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${value.data["detail"]}'),
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
        isGroupLoading = false;
      });
    }
    // if (_formKey.currentState!.validate()) {
  }

  bool isMemberLoading = false;
  var groupMemberData = [];
  Future<void> getMember(id) async {
    try {
      setState(() {
        isMemberLoading = true;
      });

      await APIMethods.get
          .get(
        url: "${APIEndpoints.group.getGroup}/$id/members",
      )
          .then((value) {
        if (APIStatus.success(value.statusCode)) {
          setState(() {
            groupMemberData = value.data;
          });
        } else {
          // printError("Auth Controller", "Signup", value.data);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${value.data["detail"]}'),
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
        isMemberLoading = false;
      });
    }
    // if (_formKey.currentState!.validate()) {
  }

  @override
  void initState() {
    super.initState();
    getMember(Get.find<AuthController>().groupgetId());
  }

  String? valueDropDown;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MobileNavBar(),
      drawer: DrawerMenu(),
      backgroundColor: Color(0XFF0C0C0C),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ProfileCard(),
      ),
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

            isGroupLoading || isLoading
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
                                    Get.toNamed(
                                        "/userdiet?id=${data["user_id"]}");
                                    GetStorage().write("userData", data);
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
