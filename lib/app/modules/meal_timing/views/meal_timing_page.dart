import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/meal_history/controllers/meal_history_controller.dart';
import 'package:totalhealthy/app/modules/meal_timing/controllers/meal_timing_controller.dart';

import '../../../core/base/constants/appcolor.dart';

class MealTimingPage extends StatefulWidget {
  const MealTimingPage({super.key, required this.id, required this.controller});
  final MealTimingController controller;
  final String id;

  @override
  _MealTimingPageState createState() => _MealTimingPageState();
}

class _MealTimingPageState extends State<MealTimingPage> {
  // List to hold meals with time and toggle status
  List<Map<String, dynamic>> meals = [];

  void _selectTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {}
  }

  // Method to show dialog for adding/editing meals
  void _showAddMealDialog(BuildContext context) {
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.cardbackground,
          title: Text("Add New Meal"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: widget.controller.title,
                decoration: InputDecoration(labelText: "Meal Title"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (picked != null) {
                    setState(() {
                      widget.controller.time.text = picked.format(context);
                    });
                  }
                },
                child: Text("Select Time: ${selectedTime.format(context)}"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Add"),
              onPressed: () {
                if (widget.controller.title.text.isNotEmpty) {
                  widget.controller.addMeal(context, widget.id);
                  // Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    widget.controller.getMeal(context, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Text("Set Your Daily Meal & Snack Timings"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Choose Suitable Times For Your Meals, Snacks, And Workout Nutrition.",
              style: TextStyle(color: Colors.white54),
            ),
            SizedBox(height: 20),
            Obx(() {
              return widget.controller.getLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                      color: Colors.white,
                    ))
                  : widget.controller.dataList.isEmpty
                      ? Center(
                          child: Text("Not Found"),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: widget.controller.dataList.length,
                            itemBuilder: (context, index) {
                              var data = widget.controller.dataList[index];
                              return Card(
                                color: Colors.grey[850],
                                child: ListTile(
                                  leading: Switch(
                                    value: true,
                                    onChanged: (value) {
                                      // setState(() {
                                      //   meals[index]['enabled'] = value;
                                      // });
                                    },
                                  ),
                                  title: Text(
                                    "${data['label_name']}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    "${data['time_range']}",
                                    style:
                                        TextStyle(color: Colors.yellowAccent),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.access_time,
                                        color: Colors.greenAccent),
                                    onPressed: () {
                                      _selectTime(context, index);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddMealDialog(context);
        },
        backgroundColor: Colors.greenAccent,
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
