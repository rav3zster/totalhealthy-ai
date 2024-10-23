import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MealHistoryPage extends StatefulWidget {
  @override
  _MealHistoryPageState createState() => _MealHistoryPageState();
}

class _MealHistoryPageState extends State<MealHistoryPage> {
  // Sample JSON data for meal plans

  final String jsonData = '''

  [

    {

      "day": "Monday",

      "dishesCount": 11,

      "meals": [

        {

          "mealType": "Breakfast",

          "dishes": ["Oats Porridge", "Avocado Toast", "Veg Omelette"],

          "extraDishes": "+2 Dish"

        },

        {

          "mealType": "Lunch",

          "dishes": ["Quinoa Stir Fry", "Chickpea Salad", "Hummus Wrap"],

          "extraDishes": "+2 Dish"

        }

      ]

    },

    {

      "day": "Tuesday",

      "dishesCount": 9,

      "meals": [

        {

          "mealType": "Breakfast",

          "dishes": ["Smoothie Bowl", "Fruit Salad"],

          "extraDishes": "+1 Dish"

        },

        {

          "mealType": "Lunch",

          "dishes": ["Lentil Soup", "Grilled Veg Sandwich"],

          "extraDishes": "+2 Dish"

        }

      ]

    }

  ]

  ''';

  List<dynamic> mealPlanData = [];

  List<bool> isExpandedList = [];

  @override
  void initState() {
    super.initState();

    // Parse the JSON data

    mealPlanData = json.decode(jsonData);

    // Initialize the isExpandedList with false values

    isExpandedList = List<bool>.filled(mealPlanData.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Meal Plan', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        itemCount: mealPlanData.length,
        itemBuilder: (context, index) {
          var dayData = mealPlanData[index];

          return buildAccordion(
            day: dayData['day'],
            dishesCount: dayData['dishesCount'],
            meals: dayData['meals'],
            isExpanded: isExpandedList[index],
            onToggle: () {
              setState(() {
                isExpandedList[index] = !isExpandedList[index];
              });
            },
          );
        },
      ),
    );
  }

  // Function to build accordion

  Widget buildAccordion({
    required String day,
    required int dishesCount,
    required List<dynamic> meals,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Card(
            color: Colors.grey[900],
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        day,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.local_dining, color: Colors.greenAccent),
                          SizedBox(width: 4),
                          Text(
                            "$dishesCount Dishes",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.greenAccent,
                  ),
                ],
              ),
            ),
          ),
        ),

        // Show meals only if expanded

        if (isExpanded)
          Container(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: meals.map<Widget>((meal) {
                return buildMealCard(
                  meal['mealType'],
                  List<String>.from(meal['dishes']),
                  meal['extraDishes'],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  // Function to build a single meal card

  Widget buildMealCard(
      String mealType, List<String> dishes, String extraDishes) {
    return Card(
      color: Colors.grey[850],
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        width: 150,
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  mealType == "Breakfast"
                      ? Icons.breakfast_dining
                      : mealType == "Lunch"
                          ? Icons.lunch_dining
                          : Icons.dinner_dining,
                  color: Colors.yellowAccent,
                ),
                SizedBox(width: 8),
                Text(
                  mealType,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            for (var dish in dishes)
              Text("• $dish",
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
            SizedBox(height: 8),
            Text(
              extraDishes,
              style: TextStyle(
                  color: Colors.greenAccent, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
