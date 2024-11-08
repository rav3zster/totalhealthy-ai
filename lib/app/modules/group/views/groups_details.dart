import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/meal_timing/views/meal_timing_page.dart';

import '../../../core/base/apiservice/api_endpoints.dart';
import '../../../core/base/apiservice/api_status.dart';
import '../../../core/base/apiservice/base_methods.dart';
import '../../../core/base/controllers/auth_controller.dart';
import '../controllers/group_controller.dart';
import 'add_client.dart';

class GroupsViewScreen extends StatefulWidget {
  @override
  State<GroupsViewScreen> createState() => _GroupsViewScreenState();
}

class _GroupsViewScreenState extends State<GroupsViewScreen> {
  var controller = Get.find<GroupController>();
  bool isLoading = false;
  var userData = [];

  Future<void> submitUser() async {
    try {
      setState(() {
        isLoading = true;
      });

      await APIMethods.get
          .get(
        url:
            "${APIEndpoints.group.createGroup}/${controller.group["group_id"]}/members",
      )
          .then((value) {
        if (APIStatus.success(value.statusCode)) {
          setState(() {
            userData = value.data;
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
        isLoading = false;
      });
    }
    // if (_formKey.currentState!.validate()) {
  }

  @override
  void initState() {
    super.initState();
    submitUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color(0XFF0C0C0C),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Color(0XFFD9D9D9),
        ),
        title: Text(
          'Groups',
          style: TextStyle(color: Color(0XFFB3B3B3), fontSize: 24),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group Info Section
            Card(
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
                        controller.group["group_name"],
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0XFFDBDBDB)),
                      ),
                      SizedBox(height: 8),
                      Text(
                        controller.group["description"],
                        style:
                            TextStyle(fontSize: 16, color: Color(0XFF7E7E7E)),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Color(0XFFCDE26D).withOpacity(0.1),
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
                            "${controller.group["created_at"]}",
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
            SizedBox(height: 16),
            // Search Box

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddClient(
                                  id: controller.group["group_id"] ?? '',
                                )),
                      );
                    },
                    label: const Text(
                      "Add Client",
                      style: TextStyle(
                          color: Color(0XFF242522),
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MealTimingPage()
                        ),
                      );
                    },
                    label: const Text(
                      "Add Category",
                      style: TextStyle(
                          color: Color(0XFF242522),
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),
            // Client List Header
            Text(
              'Client List',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            // Client List
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : userData.isEmpty
                    ? Text("No Data Found")
                    : Expanded(
                        child: SingleChildScrollView(
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: userData.length,
                              itemBuilder: (context, index) {
                                var data = userData[index];
                                // data["role"] == "admin"
                                //     ? Get.find<AuthController>()
                                //         .userIdStore(data["user_id"])
                                //     : null;

                                return buildClientCard(
                                  context,
                                  "${data["user_details"]["name"]}",

                                  "${data["role"]}",

                                  "${data["joined_at"]}",
                                  "${data["user_details"]["email"]}",
                                  'assets/ayush.png', // Replace with actual image asset
                                );
                              }),
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  Widget buildClientCard(BuildContext context, String name, String plan,
      String duration, String email, String imageUrl) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    height: 100,
                    width: 90,
                    "https://s3-alpha-sig.figma.com/img/4edc/c0b0/bdaf584c291418ad88b679516504a43c?Expires=1731283200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=UdYv6gXu3HLjJOuTpuslOJFTnTwT2KQcWHHFZ40C3amr6q~lbYYeTeUazXnkhx9iDs7upBBXnrawq4I16CuHiNLRwMENc-qHsuopkkuUTq9D9RrtZOYnziambRB2JZCAvpckWeh012RWmn-ChTAPNsbz5kbXX7FFDDocPVheFsAK0w9e51bxuPMhtUyePaEpJZMR6UprF4wncShleGoLZU9NmCd7s66xHwdFaMB8ndKZqz7E8NYH7Bv2pQjLCZSiAgL7L5DcgVxxwmF82lWoo1xS-7rp4G~JGZ7zDIiuk4oHXYS4gz-mFJE6QUrzqtLcpIYgJlJVeIX2ZQSVK67K4g__",
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Name: $name',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Plan Name: $plan',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        'Plan Duration: $duration',
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        'Email: $email',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0XFFF5D657), shape: BoxShape.circle),
                      child: IconButton(
                        icon: Icon(Icons.phone_outlined,
                            color: Color(0XFF242522)),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0XFFCDE26D), shape: BoxShape.circle),
                      child: IconButton(
                        icon: Icon(Icons.local_post_office_outlined,
                            color: Color(0XFF242522)),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0XFFF5D657), shape: BoxShape.circle),
                      child: IconButton(
                        icon: Icon(Icons.message, color: Color(0XFF242522)),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color(0XFFCDE26D),
                  borderRadius: BorderRadius.circular(30)),
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Remove Client",
                  style: TextStyle(
                    color: Color(0XFF242522),
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
