import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:totalhealthy/app/modules/meals_details/controllers/meals_details_controller.dart';

import '../../../core/base/constants/appcolor.dart';

import '../../../widgets/nutritional_card.dart';

class MealsDetailsPage extends StatefulWidget {
  final String id;
  final MealsDetailsController controller;
  MealsDetailsPage({Key? key, required this.id, required this.controller});
  @override
  _MealsDetailsPageState createState() => _MealsDetailsPageState();
}

class _MealsDetailsPageState extends State<MealsDetailsPage> {
  Map<String, dynamic> recipeData = {};
  final GetStorage box = GetStorage();
  @override
  void initState() {
    super.initState();

    recipeData = box.read('mealdetails');
    print(recipeData);
  }

  @override
  Widget build(BuildContext context) {
    if (recipeData.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe Card Section
              Card(
                color: Colors.grey[900],
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: CircleAvatar(
                                backgroundColor: AppColors.chineseGreen,
                                child:
                                    Icon(Icons.arrow_back, color: Colors.black),
                              ),
                              onPressed: () {
                                Get.toNamed('/userdiet?id=${widget.id}');
                              },
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: CircleAvatar(
                                    backgroundColor: AppColors.chineseGreen,
                                    child: Icon(Icons.favorite_border,
                                        color: Colors.black),
                                  ),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: CircleAvatar(
                                    backgroundColor: AppColors.chineseGreen,
                                    child:
                                        Icon(Icons.share, color: Colors.black),
                                  ),
                                  onPressed: () {
                                    // Share button logic
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Recipe Image (from JSON)
                        Image.network(
                          "${recipeData['imageUrl']} ",
                          width: 150,
                          height: 150,
                          errorBuilder: (context, error, stackTrace) {
                            // Display a fallback image in case of an error
                            return Image.asset(
                              "assets/burger.png",
                              width: 150,
                              height: 150,
                            );
                          },
                        ),

                        SizedBox(height: 10),
                        // Recipe Name (from JSON)
                        Text(
                          " ${recipeData['name'] ?? "Not Found"}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        // Recipe Info (Kcal, Time, Dishes from JSON)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(Icons.local_fire_department,
                                    color: Colors.red, size: 25),
                                SizedBox(width: 4),
                                Text(
                                  "${recipeData['kcal'] ?? "0"} Kcal",
                                  style: TextStyle(
                                    color: AppColors.neplesYellow,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Icon(
                                    Icons.circle,
                                    size: 5,
                                    color: AppColors.neplesYellow,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.access_time_filled,
                                  color: AppColors.neplesYellow,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "30 min",
                                  style: TextStyle(
                                    color: AppColors.neplesYellow,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Icon(
                                    Icons.circle,
                                    size: 5,
                                    color: AppColors.neplesYellow,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  Icons.restaurant_menu,
                                  color: AppColors.neplesYellow,
                                ),
                                Text(
                                  "${recipeData['ingredients'].length} Dishes",
                                  style: TextStyle(
                                      color: AppColors.neplesYellow,
                                      fontSize: 14),
                                ),
                              ],
                            ),

                            // Nutritional Information (from JSON)
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.chineseGreen,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              NutrientIndicator(
                                amount: "${recipeData['protein'] ?? "0"}",
                                color: Colors.green,
                                label: "Protein",
                                textcolor: Colors.black,
                              ),
                              NutrientIndicator(
                                amount: "${recipeData['fat'] ?? "0"}",
                                color: Colors.blue,
                                label: "Protein",
                                textcolor: Colors.black,
                              ),
                              NutrientIndicator(
                                amount: "${recipeData['carbs'] ?? "0"}",
                                color: Colors.red,
                                label: 'Carbs',
                                textcolor: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                      ]),
                ),
              ),

              SizedBox(height: 16),

              // Details Section
              Text(
                'Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.access_time_filled,
                    color: AppColors.neplesYellow,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "30 min",
                    style: TextStyle(
                      color: AppColors.neplesYellow,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Icon(
                      Icons.circle,
                      size: 5,
                      color: AppColors.neplesYellow,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.restaurant_menu,
                    color: AppColors.neplesYellow,
                  ),
                  Text(
                    "${recipeData['ingredients'].length} Dishes",
                    style:
                        TextStyle(color: AppColors.neplesYellow, fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Ingredients Section (from JSON)
              Card(
                color: Colors.grey[800],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.notifications,
                              color: AppColors.chineseGreen),
                          SizedBox(width: 8),
                          Text(
                            'Ingredients',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      // Build ingredient list dynamically
                      ...List.generate(recipeData['ingredients'].length,
                          (index) {
                        var ingredient = recipeData['ingredients'][index];
                        return buildIngredientItem(
                            "${ingredient['name']}", "${ingredient['amount']}");
                      }),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }

  // Reusable widget for nutritional info
  Widget buildNutritionInfo(String amount, String type) {
    return Column(
      children: [
        Text(
          amount,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          type,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  // Reusable widget for ingredient item
  Widget buildIngredientItem(
    String name,
    String amount,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: AppColors.neplesYellow,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                name,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Text(
            "${amount} G",
            style: TextStyle(color: Colors.white),
          ),
          // Text(
          //   unit,
          //   style: TextStyle(color: Colors.white),
          // ),
        ],
      ),
    );
  }
}
