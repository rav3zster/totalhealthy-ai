import 'package:flutter/material.dart';

import '../core/base/constants/appcolor.dart';

class NutritionalCard extends StatelessWidget {
  final String title;
  final int kcal;
  final int weight;
  final int protein;
  final int fat;
  final int carbs;
  final String image;

  NutritionalCard({
    required this.title,
    required this.kcal,
    required this.weight,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardbackground, // Card background color
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
                    image,
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
              Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: AppColors.chineseGreen, shape: BoxShape.circle),
                  child: Icon(Icons.more_horiz, color: Colors.black)),
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
