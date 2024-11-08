import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/base/apiservice/api_endpoints.dart';
import '../../../core/base/apiservice/api_status.dart';
import '../../../core/base/apiservice/base_methods.dart';

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
  // var controller = Get.find<UserGroupViewController>();
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
        print(data);

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
