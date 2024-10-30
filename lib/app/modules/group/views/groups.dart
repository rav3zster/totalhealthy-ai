import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/widgets/custom_button.dart';

import '../../../core/base/apiservice/api_endpoints.dart';
import '../../../core/base/apiservice/api_status.dart';
import '../../../core/base/apiservice/base_methods.dart';

class GroupsViewScreen extends StatelessWidget {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Group Info Section
            Card(
              color: Color(0XFF242424),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weekly Meal Planning Group',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'A support group for planning and tracking weekly meal prep, ideal for maintaining a balanced diet.',
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 16),
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
                        SizedBox(width: 8),
                        Text(
                          'Created On: August 1, 2024',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
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
                              Icons.people,
                              color: Color(0XFFCDE26D),
                              size: 18,
                            )),
                        SizedBox(width: 8),
                        Text(
                          'Total Members: 12 Members',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Search Box
            Container(
              decoration: BoxDecoration(
                color: Color(0XFF242522),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  hintText: 'Search here by email id...',
                  hintStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.search, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
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
            Expanded(
              child: ListView(
                children: [
                  buildClientCard(
                    context,
                    'Ayush Shukla',
                    'Keto Plan',
                    'Oct 1 - Nov 1',
                    'ayush@gmail.com',
                    'assets/ayush.png', // Replace with actual image asset
                  ),
                  buildClientCard(
                    context,
                    'Rahul Sharma',
                    'Vegan Balanced Diet',
                    'Oct 1 - Nov 1',
                    'rahul@gmail.com',
                    'assets/rahul.png', // Replace with actual image asset
                  ),
                  buildClientCard(
                    context,
                    'Pankaj Singh',
                    'High Protein Diet',
                    'Oct 1 - Nov 1',
                    'pankaj@gmail.com',
                    'assets/pankaj.png', // Replace with actual image asset
                  ),
                ],
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
                borderRadius: BorderRadius.circular(30)
              ),
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Add Client",
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
