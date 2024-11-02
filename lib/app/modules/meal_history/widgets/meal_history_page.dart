import 'dart:convert';

import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:totalhealthy/app/modules/create_meal/views/create_meal_page.dart';
import 'package:totalhealthy/app/modules/meal_history/controllers/meal_history_controller.dart';

class MealHistoryPage extends StatefulWidget {
  final MealHistoryController controller;
  final String id;

  const MealHistoryPage(
      {super.key, required this.controller, required this.id});

  @override
  _MealHistoryPageState createState() => _MealHistoryPageState();
}

class _MealHistoryPageState extends State<MealHistoryPage> {
  // final String jsonData = '''

  // [

  //   {

  //     "day": "Monday",

  //     "dishesCount": 11,

  //     "meals": [

  //       {

  //         "mealType": "Breakfast",

  //         "dishes": ["Oats Porridge", "Avocado Toast", "Veg Omelette"],

  //         "extraDishes": "+2 Dish"

  //       },

  //       {

  //         "mealType": "Lunch",

  //         "dishes": ["Quinoa Stir Fry", "Chickpea Salad", "Hummus Wrap"],

  //         "extraDishes": "+2 Dish"

  //       }

  //     ]

  //   },

  //   {

  //     "day": "Tuesday",

  //     "dishesCount": 9,

  //     "meals": [

  //       {

  //         "mealType": "Breakfast",

  //         "dishes": ["Smoothie Bowl", "Fruit Salad"],

  //         "extraDishes": "+1 Dish"

  //       },

  //       {

  //         "mealType": "Lunch",

  //         "dishes": ["Lentil Soup", "Grilled Veg Sandwich"],

  //         "extraDishes": "+2 Dish"

  //       }

  //     ]

  //   }

  // ]

  // ''';
  GetStorage box = GetStorage();

  List<bool> isExpandedList = [];
  List<dynamic> mealPlanData = [];
  @override
  void initState() {
    super.initState();

    mealPlanData = box.read('mealPlan');
    isExpandedList = List<bool>.filled(mealPlanData.length, false);
    print(mealPlanData);
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
      body: ListView(
        children: [
          SizedBox(
            height: 200,
            child: EasyDateTimeLine(
              initialDate: DateTime.now(),
              onDateChange: (selectedDate) {},
              headerProps: const EasyHeaderProps(
                monthPickerType: MonthPickerType.switcher,
                dateFormatter: DateFormatter.fullDateDMY(),
              ),
              dayProps: EasyDayProps(
                dayStructure: DayStructure.dayStrDayNum,
                todayNumStyle: TextStyle(
                    color: Colors.grey.shade400, fontWeight: FontWeight.bold),
                inactiveDayNumStyle: TextStyle(
                    color: Colors.grey.shade400, fontWeight: FontWeight.bold),
                disabledDayStyle: DayStyle(
                  dayNumStyle: TextStyle(color: Colors.white),
                ),
                activeDayStyle: DayStyle(
                  // dayNumStyle: TextStyle(color: Colors.white),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xff3371FF),
                        Color(0xff8426D6),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: mealPlanData.length,
            itemBuilder: (context, index) {
              var dayData = mealPlanData[index];

              return buildAccordion(
                day: "Sundey",
                dishesCount: dayData['ingredients'].length,
                ingredients: dayData['ingredients'],
                meals: dayData['categorys'],
                isExpanded: isExpandedList[index],
                onToggle: () {
                  setState(() {
                    isExpandedList[index] = !isExpandedList[index];
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // Function to build accordion

  Widget buildAccordion({
    required String day,
    required int dishesCount,
    required List<dynamic> ingredients,
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
                  meal,
                  ingredients,
                  // meal['unit'],
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  // Function to build a single meal card

  Widget buildMealCard(
    String mealType,
    List<dynamic> ingredients,
  ) {
    print(ingredients);
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
            for (var dish in ingredients)
              Text("• ${dish["name"]}",
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
            SizedBox(height: 8),
            // Text(
            //   extraDishes,
            //   style: TextStyle(
            //       color: Colors.greenAccent, fontWeight: FontWeight.bold),
            // ),
          ],
        ),
      ),
    );
  }
}
