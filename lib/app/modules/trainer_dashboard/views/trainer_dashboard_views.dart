import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/base/apiservice/api_endpoints.dart';
import '../../../core/base/apiservice/api_status.dart';
import '../../../core/base/apiservice/base_methods.dart';
import '../../../core/base/constants/appcolor.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_button.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF0C0C0C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Live Stats Section
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
                            '08',
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
                    size: ButtonSize.small,
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
                  onPressed: () {},
                  label: Text('Add Client',
                      style: TextStyle(color: Color(0XFF242522))),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Client List

            userData.isNotEmpty
                ? Expanded(
                    child: ListView(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.toNamed("/emptyscreen?id=${userData["id"]}");
                          },
                          child: clientCard(
                              userData["id"],
                              "${userData["email"]}",
                              "${userData["phone_number"]}",
                              56,
                              context),
                        ),
                        // clientCard('Rahul Sharma', 'Vegan Balanced Diet',
                        //     'Oct 1 - Nov 1', 55, context),
                        // clientCard('Pankaj Singh', 'High Protein Diet',
                        //     'Oct 1 - Nov 1', 85, context),
                        // clientCard('Manoj Tiwari', 'Mediterranean Plan',
                        //     'Oct 1 - Nov 1', 55, context),
                      ],
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget clientCard(String name, String plan, String duration, int progress,
      BuildContext context) {
    return Container(
      height: 160,
      // Increased height to make space for progress text
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF2E2E2E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          // Content for client card
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 60, // Set the width for the square
                  height: 60, // Set the height for the square
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://s3-alpha-sig.figma.com/img/4edc/c0b0/bdaf584c291418ad88b679516504a43c?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=IbcOURmNXhwmkM99WKqGORFkJ7KSTt0pp1OmymlK631~CIyf1SmXCL1KpE48OQ-5lUnzil5KzGReYJzSCncgs5qVicHLfvqkeM0ZeVv8dxIoaRluWoWbtDIq~8o~rFf5dObR7~UjhQpLyoNdgm8McqhDSxuRwT-oaTTV5ytgkQD3z0Nx75TsIBf~CgAgnxoDPMa-VLnkFrYU8n-wqj5sZW2VF8GFLzywTbLHjCst79zdudCa-1ZUMKV3jaMnCKcsDONFeJtfUFUZMAgTXV7RbQ7~5UAxyWeTgjeEDwN5K7wBOJOtLKAtyA7lbf019miLdNDr~xAzxDgZidpkm~9Rbg__'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                ),
                title: Text(
                  'Client Name: $name',
                  style: TextStyle(color: Color(0XFFFFFFFF), fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plan Name: $plan',
                      style: TextStyle(color: Color(0XFFFFFFFF), fontSize: 14),
                    ),
                    Text(
                      'Plan Duration: $duration',
                      style: TextStyle(color: Color(0XFFFFFFFF), fontSize: 14),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              // Progress bar

              // Progress Text below the progress bar

              Text(
                '$progress%', // Display progress percentage
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: Colors.grey,
                color: progress > 55 ? Colors.green : Colors.yellow,
              ),
            ],
          ),
          // Positioned Icons inside a circle at the top-right corner
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 0.2, right: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Space between the two icons
                  GestureDetector(
                    child: Container(
                        padding: EdgeInsets.all(8), // Padding inside the circle
                        decoration: BoxDecoration(
                          color: Color(0XFFCDE26D), // Circle color for message
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.local_post_office_outlined,
                          color: Color(0XFF242522),
                        )),
                    onTap: () {},
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                        padding: EdgeInsets.all(8), // Padding inside the circle
                        decoration: BoxDecoration(
                          color: Color(0XFFF5D657), // Circle color for phone
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.call_outlined,
                          color: Color(0XFF242522),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
