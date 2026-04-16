import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/base/constants/appcolor.dart';
import '../../../widgets/custom_button.dart';
import '../../../data/services/mock_api_service.dart';

class AddClient extends StatefulWidget {
  final String id;

  const AddClient({super.key, required this.id});
  @override
  State<AddClient> createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {
  // var controller = Get.find<GroupController>();
  var searchController = TextEditingController();
  bool isLoading = false;
  var userData = [];
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

      if (!mounted) return;
      if (response['statusCode'] == 200) {
        setState(() {
          userData = [response['data']];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${response["message"]}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      // }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    // if (_formKey.currentState!.validate()) {
  }

  var isAddLoading = false;
  //  {"name": "string", "amount": "string", "unit": "string"}
  Future<void> addMember(String userId) async {
    try {
      setState(() {
        isAddLoading = true;
      });
      Map<String, dynamic> data = {};

      debugPrint(data.toString());

      // Use mock API instead of real API
      final response = await MockApiService.addGroupMember(widget.id, userId);

      if (!mounted) return;
      if (response['statusCode'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request Send Successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${response["message"]}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isAddLoading = false;
      });
    }
    // if (_formKey.currentState!.validate()) {
  }

  @override
  void initState() {
    super.initState();
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
          color: Colors.white,
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
            // Card(
            //   margin: EdgeInsets.all(8.0),
            //   child: Container(
            //     decoration: BoxDecoration(
            //         color: Color(0XFF242522),
            //         borderRadius: BorderRadius.circular(10)),
            //     child: Padding(
            //       padding: EdgeInsets.all(16.0),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             controller.group["group_name"],
            //             style: TextStyle(
            //                 fontSize: 18,
            //                 fontWeight: FontWeight.bold,
            //                 color: Color(0XFFDBDBDB)),
            //           ),
            //           SizedBox(height: 8),
            //           Text(
            //             controller.group["description"],
            //             style:
            //                 TextStyle(fontSize: 16, color: Color(0XFF7E7E7E)),
            //           ),
            //           SizedBox(height: 8),
            //           Row(
            //             children: [
            //               Container(
            //                   padding: EdgeInsets.all(8),
            //                   decoration: BoxDecoration(
            //                       color: Color(0XFFCDE26D).withValues(alpha: 0.1),
            //                       shape: BoxShape.circle),
            //                   child: Icon(
            //                     Icons.calendar_today_outlined,
            //                     color: Color(0XFFCDE26D),
            //                     size: 18,
            //                   )),
            //               SizedBox(
            //                 width: 5,
            //               ),
            //               Text("Created On:"),
            //               SizedBox(
            //                 width: 10,
            //               ),
            //               Text(
            //                 "${controller.group["created_at"]}",
            //                 style: TextStyle(
            //                     fontSize: 14, color: Color(0XFFFFFFFF)),
            //               ),
            //             ],
            //           ),
            //           // Row(
            //           //   children: [
            //           //     Container(
            //           //         padding: EdgeInsets.all(8),
            //           //         decoration: BoxDecoration(
            //           //             color:
            //           //                 Color(0XFFCDE26D).withValues(alpha: 0.1),
            //           //             shape: BoxShape.circle),
            //           //         child: Icon(
            //           //           Icons.people_outline,
            //           //           color: Color(0XFFCDE26D),
            //           //           size: 18,
            //           //         )),
            //           //     SizedBox(
            //           //       width: 5,
            //           //     ),
            //           //     // Text("Total Members:"),
            //           //     // SizedBox(
            //           //     //   width: 10,
            //           //     // ),
            //           //     // Text(
            //           //     //   "12 Members",
            //           //     //   style: TextStyle(
            //           //     //       fontSize: 14, color: Color(0XFFFFFFFF)),
            //           //     // ),
            //           //   ],
            //           // ),
            //           //
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 16),
            // Search Box
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: searchController,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      fillColor: Color(0XFF242522),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      hintText: 'Search here...',
                      hintStyle: TextStyle(color: Color(0XFFDBDBDB)),
                      prefixIcon: Icon(Icons.search, color: Color(0XFFDBDBDB)),
                    ),
                  ),
                ),
                CustomButton(
                  onPressed: () => submitUser(),
                  size: ButtonSize.medium,
                  type: ButtonType.elevated,
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Text(
                          "Search",
                          style: TextStyle(color: AppColors.buttonText),
                        ),
                ),
                // SizedBox(width: 10),
                // Icon(Icons.filter_list, color: Colors.white, size: 30),
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
                ? Center(child: CircularProgressIndicator())
                : userData.isEmpty
                ? Text("No Data Found")
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: userData.length,
                    itemBuilder: (context, index) {
                      var data = userData[index];
                      return buildClientCard(
                        context,
                        "${data["phone_number"]}",
                        "${data["email"]}",
                        "${data["id"]}",

                        // Replace with actual image asset
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildClientCard(
    BuildContext context,
    String phone,
    String email,
    String id,
  ) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    height: 100,
                    width: 90,
                    "assets/advisor.png",
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PhoneNumber: $phone',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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
                        color: Color(0XFFF5D657),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.phone_outlined,
                          color: Color(0XFF242522),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0XFFCDE26D),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.local_post_office_outlined,
                          color: Color(0XFF242522),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0XFFF5D657),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.message, color: Color(0XFF242522)),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
            CustomButton(
              size: ButtonSize.medium,
              type: ButtonType.elevated,
              onPressed: () {
                addMember(id);
              },
              child: isAddLoading
                  ? CircularProgressIndicator()
                  : Text(
                      "Add Client",
                      style: TextStyle(color: Color(0XFF242522)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
