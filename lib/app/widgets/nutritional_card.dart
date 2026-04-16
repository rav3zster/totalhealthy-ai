import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../core/base/constants/appcolor.dart';

class NutritionalCard extends StatefulWidget {
  final dynamic data;
  final String id;
  final String title;
  final String kcal;
  final int weight;
  final String protein;
  final String fat;
  final String carbs;
  final String? image;

  final bool isChecked;
  final String? role;
  final ValueChanged<bool?> onChanged;

  const NutritionalCard({
    super.key,
    required this.title,
    required this.kcal,
    required this.weight,
    required this.protein,
    required this.fat,
    required this.carbs,
    this.image,
    required this.id,
    this.data,
    required this.isChecked,
    required this.onChanged,
    this.role,
  });

  @override
  State<NutritionalCard> createState() => _NutritionalCardState();
}

class _NutritionalCardState extends State<NutritionalCard> {
  final GetStorage box = GetStorage();
  Map<int, bool> isCheck = {};

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
                  Image.asset("assets/salad.png", height: 50, width: 50),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            color: Colors.red,
                            size: 20,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "${widget.kcal} Kcal",
                            style: TextStyle(
                              color: AppColors.neplesYellow,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
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
                              SizedBox(width: 10),
                              Text(
                                "${widget.weight} g",
                                style: TextStyle(
                                  color: AppColors.neplesYellow,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
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
              Row(
                children: [
                  PopupMenuButton<String>(
                    // foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    onSelected: (value) {},
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () {
                          box.write("mealdetails", widget.data);
                          Get.toNamed('/meals-details?id=${widget.id}');
                        },
                        value: "Meal Details",
                        child: Text(
                          "Meal Details",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                        value: "Option 2",
                        child: Text(
                          "Option 2",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      PopupMenuItem(
                        value: "Option 3",
                        child: Text(
                          "Option 3",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: AppColors.chineseGreen,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.more_horiz, color: Colors.black),
                    ),
                    // Icon that opens the menu
                  ),
                  SizedBox(width: 10),
                  widget.role == "admin"
                      ? SizedBox()
                      : Checkbox(
                          checkColor: Colors.white,
                          side: BorderSide(
                            width: 2,
                            color: AppColors.chineseGreen,
                          ),
                          value: widget.isChecked,
                          onChanged: widget.onChanged,
                        ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NutrientIndicator(
                label: "Protein",
                amount: widget.protein,
                color: Colors.green,
                // textcolor: Colors.black,
              ),
              NutrientIndicator(
                label: "Fat",
                amount: widget.fat,
                color: Colors.blue,
                // textcolor: Colors.black,
              ),
              NutrientIndicator(
                label: "Carbs",
                amount: widget.carbs,
                color: Colors.red,
              ),
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
  final bool isPadding;
  final Color? textcolor;
  const NutrientIndicator({
    super.key,
    required this.label,
    required this.amount,
    required this.color,
    this.textcolor,
    this.isPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isPadding
          ? EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10)
          : EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40,
            width: 6,
            child: RotatedBox(
              quarterTurns: 3,
              child: LinearProgressIndicator(
                value: 0.5, // value should be a fraction (0.0 to 1.0)
                valueColor: AlwaysStoppedAnimation<Color>(
                  color,
                ), // Correctly set the value color
                backgroundColor: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$amount g",
                style: TextStyle(
                  color: textcolor ?? Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: textcolor ?? Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
