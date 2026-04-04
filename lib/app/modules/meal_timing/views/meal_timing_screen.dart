import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/meal_timing/controllers/meal_timing_controller.dart';

import 'meal_timing_page.dart';

class MealTimingScreen extends GetView<MealTimingController> {
  const MealTimingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var id = Get.parameters["id"] ?? "";
    return MealTimingPage(
      controller: controller,
      id: id,
    );
  }
}

class MealTiminWidget extends StatelessWidget {
  const MealTiminWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://s3-alpha-sig.figma.com/img/519d/a5b3/5dd7c94081b46b1030716f9a99bda058?Expires=1731283200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=jTYvbuaMCOB69TyxSYBPqQSqZVGJPcCLiWstuMjoP6ne0nGyBRSQ1zIoecwKalqm1yrS-gtxRnHuzI4luMQM1FMaOWfcWLAtrKQl8nwk~r907DuV~ImZGpKqMWCF~6fMvZEegUjMUbezxVBdYrUu4sIMF3uDR46vtkFKQXIVzOGeBZ2Tn4~x~DUFrhRWF3p3MbN9uQM3MVn3rTA8fUaHYWJbff70AxWMsyNenWERKEEpwJ~rJ9XfMiMk1sXrhTuDHhOrkkqUNrQjNuhXWv~s1Rrn~1y5rCE5EvaD9-7aMmuSEceeLC6vLJjZTtdIQi1TXkh3s9S7b1kBpLadM76M4Q__',
                    ),
                    radius: 30,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome!',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          'Ayush Shukla',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications, color: Colors.white),
                    onPressed: () {
                      // Notification button action
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Set Your Daily Meal & Snack Timings',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                'Choose Suitable Times For Your Meals, Snacks, And Workout Nutrition.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _buildMealItem('Breakfast', '10:03 PM', true),
                  _buildMealItem('Mid-Morning Snack', '11:30 AM', false),
                  _buildMealItem('Lunch', '02:00 PM', false),
                  _buildMealItem('Pre-Workout Meal', '04:00 PM', false),
                  _buildMealItem('Post-Workout Meal', '06:00 PM', false),
                  _buildMealItem('Dinner', '08:00 PM', false),
                  _buildBeforeBedMeal(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealItem(String mealName, String time, bool isEnabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Color(0XFF222222),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ListTile(
            title: Text(
              mealName,
              style: TextStyle(color: Color(0XFFFFFFFF), fontSize: 20),
            ),
            subtitle: Text(
              time,
              style: TextStyle(
                color: mealName == 'Breakfast'
                    ? Color(0xFFCDE26D)
                    : Color(0xFF7E7E7E),
                fontSize: 14,
              ),
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: isEnabled,
                  onChanged: (value) {},
                  activeThumbColor:
                      Color(0XFFFFFFFF), // Keep active color for breakfast
                  inactiveThumbColor:
                      Color(0xFFFFFFFF), // Set inactive thumb color to white
                  inactiveTrackColor:
                      Color(0xFF7E7E7E), // Set inactive track color
                  activeTrackColor:
                      Color(0XFFCDE26D), // Set active thumb color to white
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBeforeBedMeal() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Color(0XFF222222),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Before Bed Meal',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    '11:00 PM',
                    style: TextStyle(color: Color(0XFF7E7E7E), fontSize: 14),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFCDE26D), // Changed to white
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: IconButton(
                    icon: Icon(Icons.add,
                        color: Color(0xFF1D1B20)), // Keep icon color
                    onPressed: () {
                      // Action for adding a meal
                    },
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
