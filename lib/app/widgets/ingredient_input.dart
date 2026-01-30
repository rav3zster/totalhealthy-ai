import 'package:flutter/material.dart';

import '../modules/create_meal/controllers/create_meal_controller.dart';

class IngredientInput extends StatelessWidget {
  final int index;
  final CreateMealController controller;
  final VoidCallback onRemove;

  IngredientInput({
    required this.onRemove,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 10,
      ), // Add margin at the bottom for spacing
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller:
                  controller.ingredientControllers[index]["name"]
                      is TextEditingController
                  ? controller.ingredientControllers[index]["name"]
                        as TextEditingController
                  : null,
              onChanged: (value) {
                if (controller.ingredientControllers[index]["name"]
                    is! TextEditingController) {
                  controller.ingredientControllers[index]["name"] = value;
                }
              },
              maxLines: 1,
              decoration: InputDecoration(
                labelText: "Name",
                labelStyle: TextStyle(color: Color(0XFF7E7E7E)),
                filled: true,
                fillColor: Color(0XFF242522),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 80,
            child: TextField(
              controller:
                  controller.ingredientControllers[index]["amount"]
                      is TextEditingController
                  ? controller.ingredientControllers[index]["amount"]
                        as TextEditingController
                  : null,
              onChanged: (value) {
                if (controller.ingredientControllers[index]["amount"]
                    is! TextEditingController) {
                  controller.ingredientControllers[index]["amount"] = value;
                }
              },
              maxLines: 1,
              decoration: InputDecoration(
                labelText: "Amount",
                labelStyle: TextStyle(color: Color(0XFF7E7E7E)),
                filled: true,
                fillColor: Color(0XFF242522),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 80,
            child: TextField(
              controller:
                  controller.ingredientControllers[index]["unit"]
                      is TextEditingController
                  ? controller.ingredientControllers[index]["unit"]
                        as TextEditingController
                  : null,
              onChanged: (value) {
                if (controller.ingredientControllers[index]["unit"]
                    is! TextEditingController) {
                  controller.ingredientControllers[index]["unit"] = value;
                }
              },
              maxLines: 1,
              decoration: InputDecoration(
                labelText: "Unit",
                labelStyle: TextStyle(color: Color(0XFF7E7E7E)),
                filled: true,
                fillColor: Color(0XFF242522),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),

          IconButton(
            icon: Icon(Icons.remove_circle_outline, color: Colors.red),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
