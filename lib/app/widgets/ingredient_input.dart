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
      margin:
          EdgeInsets.only(bottom: 10), // Add margin at the bottom for spacing
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                controller.ingredientControllers[index]["name"] = value;
              },
              maxLines: 1,
              decoration: InputDecoration(
                labelText: "Describe the recipe",
                labelStyle: TextStyle(color: Color(0XFF7E7E7E)),
                filled: true,
                fillColor: Color(0XFF242522),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                  borderSide: BorderSide(
                      color: Colors
                          .transparent), // Transparent border when focused
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                  borderSide: BorderSide(
                      color: Colors
                          .transparent), // Transparent border when enabled
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 80, // Set width for the quantity field to make it smaller
            child: TextField(
              onChanged: (value) {
                controller.ingredientControllers[index]["amount"] = value;
              },
              maxLines: 1,
              decoration: InputDecoration(
                labelText: "Amount",
                labelStyle: TextStyle(color: Color(0XFF7E7E7E)),
                filled: true,
                fillColor: Color(0XFF242522),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                  borderSide: BorderSide(
                      color: Colors
                          .transparent), // Transparent border when focused
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                  borderSide: BorderSide(
                      color: Colors
                          .transparent), // Transparent border when enabled
                ),
              ),
            ),
          ),
          SizedBox(width: 10), // Space between the two fields
          Container(
            width: 80, // Set width for the quantity field to make it smaller
            child: TextField(
              onChanged: (value) {
                controller.ingredientControllers[index]["unit"] = value;
              },
              maxLines: 1,
              decoration: InputDecoration(
                labelText: "Q-Ty",
                labelStyle: TextStyle(color: Color(0XFF7E7E7E)),
                filled: true,
                fillColor: Color(0XFF242522),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                  borderSide: BorderSide(
                      color: Colors
                          .transparent), // Transparent border when focused
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                  borderSide: BorderSide(
                      color: Colors
                          .transparent), // Transparent border when enabled
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
