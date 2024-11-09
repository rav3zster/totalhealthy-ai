import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:totalhealthy/app/modules/meals_details/controllers/meals_details_controller.dart';
import 'package:totalhealthy/app/modules/user_diet_screen/controllers/user_diet_screen_controllers.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:totalhealthy/app/widgets/phone_nav_bar.dart';
import 'package:totalhealthy/app/widgets/profile_card.dart';
import '../core/base/apiservice/api_endpoints.dart';
import '../core/base/apiservice/api_status.dart';
import '../core/base/apiservice/base_methods.dart';
import '../core/base/constants/appcolor.dart';
import '../core/base/controllers/auth_controller.dart';

import '../routes/app_pages.dart';
import 'client_card.dart';

import 'button_selector.dart';
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
  var userData = {};

  @override
  void initState() {
    super.initState();
    userData = GetStorage().read("clientData");
    categories = Get.find<AuthController>().categoriesGet();

    getMeals();
  }

  List<Map<String, dynamic>> dataList = [];
  var isLoading = false;

  Future<void> getMeals() async {
    try {
      setState(() {
        isLoading = true;
      });

      await APIMethods.get
          .get(
        url: APIEndpoints.meals.getadminMeals(
          Get.find<AuthController>().groupgetId(),
          widget.id,
        ),
      )
          .then((value) {
        if (APIStatus.success(value.statusCode)) {
          setState(() {
            dataList = List<Map<String, dynamic>>.from(value.data);
          });
          filterRecipesBySingleCategory("Breakfast");

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

  var categories = [];

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

  List<Map<String, dynamic>> filteredRecipes = [];
  void filterRecipesBySingleCategory(String selectedCategory) {
    setState(() {
      filteredRecipes = dataList.where((recipe) {
        final categories = recipe["categorys"] as List<dynamic>;

        return categories.contains(selectedCategory);
      }).toList();
    });
    print(filteredRecipes);
  }

  int selectedIndex = 0;
  var userController = Get.find<UserDietScreenController>();
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
                  Get.toNamed(Routes.TrainerDashboard);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                )),
            ProfileCard(),
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
          ClientCard(
            progress: 56,
            email: "${userData["user_details"]["email"]}",
            name: "${userData["user_details"]["name"]}",
          ),
          SizedBox(height: 20),
          AddMealButton(id: widget.id),
          SizedBox(height: 20),
          SizedBox(
            height: 40,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                var data = categories[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    filterRecipesBySingleCategory(
                        data["label_name"].toString());
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: ButtonSelector(
                      title: data["label_name"].toString(),
                      icon: index == 0
                          ? Icons.breakfast_dining
                          : index == 1
                              ? Icons.lunch_dining
                              : index == 2
                                  ? Icons.dinner_dining
                                  : Icons.food_bank,
                      active: index == selectedIndex,
                    ),
                  ),
                );
              },
              itemCount: categories.length,
            ),
          ),
          SizedBox(height: 20),

          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : filteredRecipes.isEmpty
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
                      itemCount: filteredRecipes.length,
                      itemBuilder: (context, index) {
                        var data = filteredRecipes[index];

                        return Padding(
                          padding: EdgeInsets.only(bottom: 15),
                          child: NutritionalCard(
                            role: Get.find<AuthController>().roleGet(),
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
