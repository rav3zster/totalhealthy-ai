import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/core/base/constants/appcolor.dart';
import 'package:totalhealthy/app/core/utitlity/appvalidator.dart';

import '../../../core/base/apiservice/api_endpoints.dart';
import '../../../core/base/apiservice/api_status.dart';
import '../../../core/base/apiservice/base_methods.dart';

import '../../user_group_view/controllers/user_group_view_controller.dart';
import '../controllers/group_controller.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({
    super.key,
    this.isGroup = false,
  });
  final bool isGroup;

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  var groupName = TextEditingController();
  var description = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> submitUser(context) async {
    try {
      if (key.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        Map<String, dynamic> data = {
          "group_name": groupName.text.trim(),
          "description": description.text.trim(),
        };

        await APIMethods.post
            .post(url: APIEndpoints.group.addGroup, map: data)
            .then((value) {
          if (APIStatus.success(value.statusCode)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Create Group Successful!'),
                backgroundColor: Colors.green,
              ),
            );
            widget.isGroup
                ? Get.find<GroupController>().submitUser()
                : Get.find<UserGroupViewController>().submitUser();
            Get.back();
          } else {
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
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(color: Color(0XFF242522)),
        height: 450,
        padding: EdgeInsets.all(10),
        child: Form(
          key: key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back_ios, color: Color(0XFFD9D9D9)),
                  ),
                  Text(
                    "Create New group",
                    style: TextStyle(
                      color: Color(0XFFD9D9D9),
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.close, color: Color(0XFFD9D9D9)), // Close icon
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text("Group Name", style: TextStyle(color: Color(0XFFDBDBDB))),
              SizedBox(height: 10),
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
                ),
                style: TextStyle(color: Colors.white),
                validator: AppValidator().validateUsername,
              ),
              SizedBox(height: 30),
              Text("Description", style: TextStyle(color: Color(0XFFDBDBDB))),
              SizedBox(height: 10),
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
                ),
                style: TextStyle(color: Colors.white),
                validator: AppValidator().validateField,
              ),
              SizedBox(height: 60),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 18),
                      child: ElevatedButton(
                        onPressed: () => submitUser(context),
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
