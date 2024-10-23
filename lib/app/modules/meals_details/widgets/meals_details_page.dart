import 'dart:convert';

import 'package:flutter/material.dart';

class MealsDetailsPage extends StatefulWidget {
  @override
  _MealsDetailsPageState createState() => _MealsDetailsPageState();
}

class _MealsDetailsPageState extends State<MealsDetailsPage> {
  // Sample JSON data for the recipe
  final String jsonData = '''
  {
    "image": "https://via.placeholder.com/100",
    "name": "Salad Without Eggs",
    "calories": "294 Kcal",
    "time": "30 Min",
    "dishes": "9 Dishes",
    "nutrition": {
      "protein": "20g",
      "fat": "21g",
      "carbs": "30g"
    },
    "ingredients": [
      {"name": "Eggplant", "quantity": "300 G"},
      {"name": "Potato", "quantity": "200 G"},
      {"name": "Tomatoes", "quantity": "200 G"},
      {"name": "Bulb Onions", "quantity": "100 G"},
      {"name": "Spinach", "quantity": "300 G"},
      {"name": "Baby Corns", "quantity": "200 G"},
      {"name": "Mushrooms", "quantity": "200 G"}
    ]
  }
  ''';

  Map<String, dynamic>? recipeData;

  @override
  void initState() {
    super.initState();
    // Parse the JSON data
    recipeData = json.decode(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    if (recipeData == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.greenAccent),
          onPressed: () {
            // Back button logic
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border, color: Colors.greenAccent),
            onPressed: () {
              // Favorite button logic
            },
          ),
          IconButton(
            icon: Icon(Icons.share, color: Colors.greenAccent),
            onPressed: () {
              // Share button logic
            },
          ),
        ],
      ),
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
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Recipe Image (from JSON)
                      Image.network(
                        recipeData!['image'],
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(height: 16),
                      // Recipe Name (from JSON)
                      Text(
                        recipeData!['name'],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Recipe Info (Kcal, Time, Dishes from JSON)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            recipeData!['calories'],
                            style: TextStyle(
                                color: Colors.redAccent, fontSize: 16),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.access_time, color: Colors.white),
                          Text(
                            recipeData!['time'],
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.restaurant_menu, color: Colors.white),
                          Text(
                            recipeData!['dishes'],
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Nutritional Information (from JSON)
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.lightGreenAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            buildNutritionInfo(
                                recipeData!['nutrition']['protein'], 'Protein'),
                            buildNutritionInfo(
                                recipeData!['nutrition']['fat'], 'Fat'),
                            buildNutritionInfo(
                                recipeData!['nutrition']['carbs'], 'Carbs'),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                children: [
                  Icon(Icons.access_time, color: Colors.yellowAccent),
                  SizedBox(width: 4),
                  Text(recipeData!['time'],
                      style: TextStyle(color: Colors.white)),
                  SizedBox(width: 16),
                  Icon(Icons.restaurant_menu, color: Colors.yellowAccent),
                  SizedBox(width: 4),
                  Text(recipeData!['dishes'],
                      style: TextStyle(color: Colors.white)),
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
                          Icon(Icons.notifications, color: Colors.yellowAccent),
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
                      ...List.generate(recipeData!['ingredients'].length,
                          (index) {
                        var ingredient = recipeData!['ingredients'][index];
                        return buildIngredientItem(
                            ingredient['name'], ingredient['quantity']);
                      }),
                    ],
                  ),
                ),
              ),
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
  Widget buildIngredientItem(String ingredient, String amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            ingredient,
            style: TextStyle(color: Colors.white),
          ),
          Text(
            amount,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
