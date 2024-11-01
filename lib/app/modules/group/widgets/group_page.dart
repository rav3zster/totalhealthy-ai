import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:totalhealthy/app/modules/group/controllers/group_controller.dart';
import 'package:totalhealthy/app/modules/group/views/groups_details.dart';

import '../../../core/base/apiservice/api_endpoints.dart';
import '../../../core/base/apiservice/api_status.dart';
import '../../../core/base/apiservice/base_methods.dart';

class GroupListPage extends StatefulWidget {
  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  var controller = Get.find<GroupController>();
  bool isLoading = false;
  var groupData = [];

  Future<void> submitUser() async {
    try {
      setState(() {
        isLoading = true;
      });
      // print(data);  String input = searchController.text.trim();
      // String input = searchController.text.trim();
      // var phone = int.tryParse(input);
      await APIMethods.get
          .get(
        url: APIEndpoints.group.createGroup,
      )
          .then((value) {
        if (APIStatus.success(value.statusCode)) {
          setState(() {
            groupData = value.data;
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
    // TODO: implement initState
    super.initState();
    submitUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF0C0C0C),
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
                      return CreateGroup();
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: groupData.length,
              itemBuilder: (context, index) {
                final group = groupData[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GroupsViewScreen()),
                    );

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
                                        color:
                                            Color(0XFFCDE26D).withOpacity(0.1),
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
            ),
    );
  }
}

class CreateGroup extends StatefulWidget {
  const CreateGroup({
    super.key,
  });

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  var groupName = TextEditingController();
  var description = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> submitUser() async {
    try {
      if (key.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        Map<String, dynamic> data = {
          "group_name": groupName.text.trim(),
          "description": description.text.trim(),
        };
        print(data);

        await APIMethods.post
            .post(url: APIEndpoints.group.createGroup, map: data)
            .then((value) {
          if (APIStatus.success(value.statusCode)) {
            // clearDetails();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Create Group Successful!'),
                backgroundColor: Colors.green,
              ),
            );
            Get.back();
          } else {
            // printError("Auth Controller", "Signup", value.data);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Group is not created.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
      }
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
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(color: Color(0XFF0C0C0C)),
        height: 450,
        padding: EdgeInsets.all(10),
        child: Form(
          key: key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_back_ios),
                    color: Color(0XFFD9D9D9),
                  ),
                  Text(
                    "Create New group",
                    style: TextStyle(
                      color: Color(0XFFD9D9D9),
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Group Name",
                style: TextStyle(color: Color(0XFFDBDBDB)),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: groupName,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0XFF242522),
                  hintText: 'Enter your Group Name',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  // Custom Border Properties
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Description",
                style: TextStyle(
                  color: Color(0XFFDBDBDB),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: description,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0XFF242522),
                  hintText: 'Describe the recipe',

                  hintStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  // Custom Border Properties
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 60,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 18),
                      child: ElevatedButton(
                        onPressed: () => submitUser(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0XFFCDE26D),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : const Text(
                                'Save Group',
                                style: TextStyle(
                                    color: Color(0XFF242522), fontSize: 18),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
