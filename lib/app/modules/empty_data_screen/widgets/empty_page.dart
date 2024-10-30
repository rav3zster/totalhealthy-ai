import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/empty_data_screen/controllers/empty_data_screen_controllers.dart';

import '../../../core/base/apiservice/api_endpoints.dart';
import '../../../core/base/apiservice/api_status.dart';
import '../../../core/base/apiservice/base_methods.dart';
import '../../../core/base/controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';

class EmptyPage extends StatefulWidget {
  final String id;
  final EmptyScreenController controller;
  EmptyPage({super.key, required this.id, required this.controller});

  @override
  State<EmptyPage> createState() => _EmptyPageState();
}

class _EmptyPageState extends State<EmptyPage> {
  @override
  void initState() {
    super.initState();
    submitUser();
  }

  var isLoading = false;
  Future<void> submitUser() async {
    try {
      await APIMethods.get
          .get(
        url: APIEndpoints.group.createGroup,
      )
          .then((value) {
        if (APIStatus.success(value.statusCode)) {
          Get.find<AuthController>().groupId(value.data[0]["group_id"]);
        } else {
          // printError("Auth Controller", "Signup", value.data);
          Get.dialog(Text(
            "erroe",
          ));
        }
      });
      // }
    } catch (e) {
      print(e);
    }
    // if (_formKey.currentState!.validate()) {
  }

  Future<void> copyExisting(context) async {
    try {
      setState(() {
        isLoading = true;
      });
      var data = {
        "userId": widget.id,
        "groupId": Get.find<AuthController>().groupId.value,
        "meal_ids": ["string"],
        "from_date": "2024-10-30",
        "to_date": "2024-10-30T10:40:19.067Z"
      };
      print(data);
      await APIMethods.post
          .post(
        url: APIEndpoints.createData.copyMeals,
        map: data,
      )
          .then((value) {
        print(value.data);
        if (APIStatus.success(value.statusCode)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Existing Meals Copy Successful!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // printError("Auth Controller", "Signup", value.data);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Meals not copy'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF0C0C0C),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  // Navigator.pop(context);
                  Get.toNamed(Routes.TrainerDashboard);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                )),
            CircleAvatar(
              maxRadius: 28,
              backgroundImage: NetworkImage(
                  'https://s3-alpha-sig.figma.com/img/519d/a5b3/5dd7c94081b46b1030716f9a99bda058?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=jenxaaauev~xejor2UuGg8xXNQB-ugvjmHoiV6RcNYBQnj-hr1VQ20Pbprvw3fWQXO15QJFXc0Y3th0TAjya4d2TDqRdQBfcw171WpKTXMLmNMY0JHYemzsMAxDhHBEj-YGN~mHOiegyTMzi0~RjHZygBWfR4QbwdmR1ec3ITjoqefk8JaSfq4fbIXemlAvJsTO4-vTxp0ZGSZ2U24NawVgj0FP9BkCADm41VTdZg7bQLe0quP~0-~oUARPGRnm83vvDLQSjdFNn3sKVNMMXsbNSYLKtZOyA6OdcroUS8lEZvrKXyLjLYffXv~3IGOH1yVMMFdwyNId06kR32T468g__'), // Profile image
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome!',
                    style: TextStyle(fontSize: 20, color: Color(0XFFFFFFFF))),
                SizedBox(
                  height: 5,
                ),
                Text('Ayush Shukla',
                    style: TextStyle(fontSize: 16, color: Color(0XFF7B7B7A))),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            decoration:
                BoxDecoration(color: Color(0XFF242424), shape: BoxShape.circle),
            child: IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Plan Info Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Color(0XFF242424),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 70,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    fit: BoxFit.cover,
                                    height: 90,
                                    'https://s3-alpha-sig.figma.com/img/4edc/c0b0/bdaf584c291418ad88b679516504a43c?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=IbcOURmNXhwmkM99WKqGORFkJ7KSTt0pp1OmymlK631~CIyf1SmXCL1KpE48OQ-5lUnzil5KzGReYJzSCncgs5qVicHLfvqkeM0ZeVv8dxIoaRluWoWbtDIq~8o~rFf5dObR7~UjhQpLyoNdgm8McqhDSxuRwT-oaTTV5ytgkQD3z0Nx75TsIBf~CgAgnxoDPMa-VLnkFrYU8n-wqj5sZW2VF8GFLzywTbLHjCst79zdudCa-1ZUMKV3jaMnCKcsDONFeJtfUFUZMAgTXV7RbQ7~5UAxyWeTgjeEDwN5K7wBOJOtLKAtyA7lbf019miLdNDr~xAzxDgZidpkm~9Rbg__',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'User Name:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          Color(0XFFFFFFFF).withOpacity(0.75),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Ayush Shukla',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0XFFFFFFFF),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Plan Name:',
                                    style: TextStyle(
                                      color:
                                          Color(0XFFFFFFFF).withOpacity(0.75),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Keto Plan',
                                    style: TextStyle(
                                      color: Color(0XFFFFFFFF),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Plan Duration:',
                                    style: TextStyle(
                                      color:
                                          Color(0XFFFFFFFF).withOpacity(0.75),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Oct 1 - Nov 1',
                                    style: TextStyle(
                                      color: Color(0XFFFFFFFF),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Email:',
                                    style: TextStyle(
                                      color:
                                          Color(0XFFFFFFFF).withOpacity(0.75),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'ayush@gmail.com',
                                    style: TextStyle(
                                      color: Color(0XFFFFFFFF),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(4),
                                child: Icon(
                                  Icons.local_post_office_outlined,
                                  color: Color(0XFF242522),
                                ),
                                decoration: BoxDecoration(
                                    color: Color(0XFFCDE26D),
                                    shape: BoxShape.circle),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: Color(0XFFF5D657),
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.call_outlined,
                                  color: Color(0XFF242522),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        '85% Progress',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0XFFFFFFFF),
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      LinearProgressIndicator(
                        value: 0.85,
                        backgroundColor: Colors.grey,
                        color: Color(0XFFF57552),
                        minHeight: 8, // Thickness of the progress bar
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // No Diet Plan Found Illustration with Black Background
              Center(
                child: Column(
                  children: [
                    // Add the image asset with black background
                    Image.asset(
                      'assets/no_diet.png',
                      height: 250,
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 108),
              // Action Buttons
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // Align items at the start
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/createmeal?id=${widget.id}');
                    },
                    child: buildActionButton(
                        'Create Manually',
                        'Create',
                        Color(0XFF242522),
                        'https://s3-alpha-sig.figma.com/img/ac61/7d63/d22e2690d5c8624e35deda268d9a1882?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=XFUtIQ3nAmRJphMKbKyRb4uUMVXSUm12t~TjF3-FuA7neNw247D0sNXvuRk8AZJDWkaZuwAcwPu8-oR15RKSmYL6XLwaGLFufXdn0MddabVgqGUDQgAt~GmeKQi~ZMa3a4OiyeQAMPVcXc1S8ootksf-bEy3LnlnyUv2ZmN9j-czUQb4cJvHeSVPjYGTGUoowEMvoBWSM3d8CCG9MaJw~JGdlpsx4X3Sz6T7YJ5yS4GoaIp3XIfRkjCR1vbEOB5DtCtREsdeBoIfwxcnGRVnJDcmvJ2SlrL6b5vhS-QxySZdgOTvoJxJ5MBCVme580VB~EEvSLVMpE8EN9aC5vw-aQ__'),
                  ),
                  SizedBox(height: 16), // Add vertical space between buttons
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('/generate-ai?id=${widget.id}');
                    },
                    child: buildActionButton(
                        'Generate Using AI',
                        'Generate',
                        Color(0XFF242522),
                        'https://s3-alpha-sig.figma.com/img/3718/a52e/756040d7214bbf9e6ae7af5e14c47433?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Zk8lTcJxC4TlPWWWLW0o7wZKpnRwN9xYWVA~pgvtHM6YR3uYzvCeAKH5ObA6LV~6ki2KqNdmr1KZTygBEtSRIrNlbjCksJhNI8XKnxYYdov4jzWY~xp0YGoHIoUR5m4UQ4OjlipIUO-MjLDU3wvUuQHD778m2cCuICcSmIOEDqlu0s~NGm0xKInmiUGzq69xZPy5-R13kata0ULjUtiavaIdUa~qXV5-ydr-Ipy0svPt1iMuw4pLT7ajRt8jI0XXyX7LrqpYD1agrtf3Wuaob4vBPI0Z-faC0OeNNu75e9J86OmqT7lKTEWZqSSvNt7uXWYSmiD~Y8bZL8JDDZLRAw__'),
                  ),
                  SizedBox(height: 16), // Add vertical space between buttons
                  GestureDetector(
                    onTap: () {
                      copyExisting(context);
                    },
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : buildActionButton(
                            'Copy From Existing',
                            'Copy',
                            Color(0XFF242522),
                            'https://s3-alpha-sig.figma.com/img/998d/f5b8/588e18036288fef4fd3d5749d955121d?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Id~jUYUwpPe51lSz5m4r2vLfzLlG2a-aTByInwPUOumEZTNXxO4Z7qyMtvwRdxbIJvPSaGjh1X2zwS7tP7GKcWgLdRhbmm6mcZxTYEyvnqNBfva3E87xRqeVJoLBPhvlj~GGVtWdF7Ey-m7zU9G9FIiq5R9zoLPKMoD5mE0zNaYuQFMJtOZF7drJDjfUDjAXRXZXvJprIv06wYzocMALMV~FDm98XdWj1x752zbXhHTkwSLy9jRUZYK9yA5SOmQ~E0BpvYjsYJVbL6oV96SVS0PZfuhjDnlUoNze72kE9udAVqaBJB9Ow1Tqs-y~m0lFlmkbvaF1-qZR42pAdAmr5Q__'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildActionButton(
      String label, String label2, Color color, String imageUrl) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Color(0XFF242522)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.network(
            imageUrl, // Load image from the network
            width: 50, // Set the width of the image
            height: 50, // Set the height of the image
          ),
          SizedBox(width: 8), // Add some space between the image and text
          Text(
            label,
            style: TextStyle(
              color: Colors.white, // Change text color to white
            ),
            textAlign: TextAlign.left, // Align text to the left
          ),
          SizedBox(
            width: 30,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
                color: Color(0XFFCDE26D),
                borderRadius: BorderRadius.circular(30)),
            child: Text(
              label2,
              style: TextStyle(color: Color(0XFF242522)),
            ),
          )
        ],
      ),
    );
  }
}
