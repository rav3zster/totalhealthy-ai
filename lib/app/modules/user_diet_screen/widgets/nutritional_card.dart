import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/base/constants/appcolor.dart';
import '../../../routes/app_pages.dart';
import '../controllers/user_diet_screen_controllers.dart';

class NutritionalCard extends StatelessWidget {
  final String id;
  final String title;
  final String kcal;
  final int weight;
  final String protein;
  final String fat;
  final String carbs;
  final String? image;

  NutritionalCard({
    required this.title,
    required this.kcal,
    required this.weight,
    required this.protein,
    required this.fat,
    required this.carbs,
    this.image,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0XFF242522), // Card background color
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/salad.png",
                    height: 50,
                    width: 50,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.local_fire_department,
                              color: Colors.red, size: 25),
                          SizedBox(width: 4),
                          Text(
                            "$kcal Kcal",
                            style: TextStyle(
                              color: AppColors.neplesYellow,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 10),
                          Row(
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
                                "$weight g",
                                style: TextStyle(
                                  color: AppColors.neplesYellow,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              PopupMenuButton<String>(
                // foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),

                onSelected: (value) {},
                itemBuilder: (context) => [
                  PopupMenuItem(
                    onTap: () {
                      Get.toNamed('/meals-details?id=$id');
                    },
                    child: Text(
                      "Meal Details",
                      style: TextStyle(color: Colors.black),
                    ),
                    value: "Meal Details",
                  ),
                  PopupMenuItem(
                    value: "Option 2",
                    child:
                        Text("Option 2", style: TextStyle(color: Colors.black)),
                  ),
                  PopupMenuItem(
                    value: "Option 3",
                    child:
                        Text("Option 3", style: TextStyle(color: Colors.black)),
                  ),
                ],
                child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: AppColors.chineseGreen, shape: BoxShape.circle),
                    child: Icon(Icons.more_horiz, color: Colors.black)),
                // Icon that opens the menu
              ),
            ],
          ),
          SizedBox(height: 8),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NutrientIndicator(
                  label: "Protein", amount: "$protein g", color: Colors.green),
              NutrientIndicator(
                  label: "Fat", amount: "$fat g", color: Colors.blue),
              NutrientIndicator(
                  label: "Carbs", amount: "$carbs g", color: Colors.red),
            ],
          ),
        ],
      ),
    );
  }
}

class NutrientIndicator extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;

  NutrientIndicator(
      {required this.label, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            width: 8,
            child: RotatedBox(
              quarterTurns: 3,
              child: LinearProgressIndicator(
                value: 0.5, // value should be a fraction (0.0 to 1.0)
                valueColor: AlwaysStoppedAnimation<Color>(
                    color), // Correctly set the value color
                backgroundColor: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                amount,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                label,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
