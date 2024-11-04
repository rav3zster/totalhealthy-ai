import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:totalhealthy/app/modules/meals_details/controllers/meals_details_controller.dart';
import 'package:totalhealthy/app/modules/user_diet_screen/controllers/user_diet_screen_controllers.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import '../../../core/base/apiservice/api_endpoints.dart';
import '../../../core/base/apiservice/api_status.dart';
import '../../../core/base/apiservice/base_methods.dart';
import '../../../core/base/constants/appcolor.dart';
import '../../../core/base/controllers/auth_controller.dart';

import '../../client_dashboard/views/client_dashboard_views.dart';
import 'add_meal_button.dart';
import 'nutritional_card.dart';

class UserDietPage extends StatefulWidget {
  final String id;
  final UserDietScreenController controller;
  UserDietPage({Key? key, required this.id, required this.controller});
  @override
  State<UserDietPage> createState() => _UserDietPageState();
}

class _UserDietPageState extends State<UserDietPage> {
  @override
  void initState() {
    super.initState();
    getMeals();
  }

  var dataList = [];
  var isLoading = false;

  Future<void> getMeals() async {
    try {
      setState(() {
        isLoading = true;
      });
      await APIMethods.get
          .get(
        url: APIEndpoints.meals
            .getadmindMeals(Get.find<AuthController>().groupgetId()),
      )
          .then((value) {
        if (APIStatus.success(value.statusCode)) {
          setState(() {
            dataList = value.data;
          });

          isCheck = {for (int i = 0; i < dataList.length; i++) i: false};
          box.write("mealPlan", dataList);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Group id Not Found'),
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
  }

  Map<String, dynamic> generateJson() {
    return {
      "meal_ids": selectedMealIds,
      "userId": widget.id,
      "groupId": Get.find<AuthController>().groupgetId(),
      "history_on_day": DateTime.now().toIso8601String(),
    };
  }

  GetStorage box = GetStorage();
  var isGetLoading = false;
  Future<void> postHistory() async {
    try {
      setState(() {
        isGetLoading = true;
      });

      var data = generateJson();
      await APIMethods.post
          .post(
        url: APIEndpoints.createData.mealHistory,
        map: data,
      )
          .then((value) {
        if (APIStatus.success(value.statusCode)) {
          setState(() {
            isCheck = {for (int i = 0; i < dataList.length; i++) i: false};
            selectedMealIds.clear();
          });

          Get.toNamed("/meal-history?id=${widget.id}");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfull!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Not Found'),
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
        isGetLoading = false;
      });
    }
  }

  Map<int, bool> isCheck = {};

  List<String> selectedMealIds = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: selectedMealIds.isNotEmpty
          ? isGetLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : FloatingActionButton(
                  backgroundColor: AppColors.chineseGreen,
                  child: Icon(
                    Icons.done,
                    color: AppColors.cardbackground,
                  ),
                  onPressed: () {
                    postHistory();
                  })
          : SizedBox(),
      backgroundColor: Color(0XFF0C0C0C),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  Get.toNamed("/trainerdashboard");
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
              onPressed: () {
                Get.toNamed('/notification?id=${widget.id}');
              },
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          UserCard(),
          SizedBox(height: 20),
          AddMealButton(id: widget.id),
          SizedBox(height: 20),
          MealTypeSelector(),
          SizedBox(height: 20),

          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : dataList.isEmpty
                  ? Center(
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
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        var data = dataList[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: NutritionalCard(
                            isChecked: isCheck[index] ?? false,
                            onChanged: (value) {
                              setState(() {
                                isCheck[index] = value ?? false;

                                if (isCheck[index] == true) {
                                  selectedMealIds.add(data['_id'] ?? '0');
                                } else {
                                  selectedMealIds.remove(data['_id'] ?? '0');
                                }
                                print(selectedMealIds);
                              });
                            },
                            data: data,
                            id: widget.id,
                            title: "${data["name"] ?? "Not Found"}",
                            kcal: "${data["kcal"] ?? "0"}",
                            weight: 80,
                            protein: "${data["protein"] ?? "0"}",
                            fat: "${data["fat"] ?? "0"}",
                            carbs: "${data["carbs"] ?? "0"}",
                          ),
                        );
                      },
                    ),

          // SizedBox(height: 15,),
          // NutritionalCard(
          //   title: "Salad Without Eggs",
          //   kcal: 300,
          //   weight: 150,
          //   protein: 25,
          //   fat: 21,
          //   carbs: 14,
          // ),
          // SizedBox(height: 15,),
          // NutritionalCard(
          //   title: "Vegetables",
          //   kcal: 394,
          //   weight: 200,
          //   protein: 27,
          //   fat: 32,
          //   carbs: 42,
          // ),
          // SizedBox(height: 15,),
          // NutritionalCard(
          //   title: "Fruits",
          //   kcal: 197,
          //   weight: 250,
          //   protein: 8,
          //   fat: 9,
          //   carbs: 72,
          // ),
          // SizedBox(height: 15,),
          // NutritionalCard(
          //   title: "Pancakes",
          //   kcal: 874,
          //   weight: 200,
          //   protein: 90,
          //   fat: 100,
          //   carbs: 80,
          // ),
          // SizedBox(height: 15,)
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
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
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'User Name:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0XFFFFFFFF).withOpacity(0.75),
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
                              color: Color(0XFFFFFFFF).withOpacity(0.75),
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
                              color: Color(0XFFFFFFFF).withOpacity(0.75),
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
                              color: Color(0XFFFFFFFF).withOpacity(0.75),
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
                          color: Color(0XFFCDE26D), shape: BoxShape.circle),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Color(0XFFF5D657), shape: BoxShape.circle),
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
    );
  }
}
