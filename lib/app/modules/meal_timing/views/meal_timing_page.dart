import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/core/utitlity/debug_print.dart';
import 'package:totalhealthy/app/modules/meal_history/controllers/meal_history_controller.dart';
import 'package:totalhealthy/app/modules/meal_timing/controllers/meal_timing_controller.dart';
import 'package:totalhealthy/app/widgets/baseWidget.dart';

import '../../../core/base/constants/appcolor.dart';
import '../../../widgets/notification_services.dart';
import '../../notification/views/local_notification.dart';

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

  //
  // void _selectTime(BuildContext context, int index) async {
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //     builder: (BuildContext context, Widget? child) {
  //       return Theme(
  //         data: ThemeData.dark().copyWith(
  //           colorScheme: ColorScheme.dark(
  //             primary: Colors.lime,
  //             onPrimary: Colors.black,
  //             surface: Colors.black,
  //             onSurface: Colors.black,
  //           ),
  //           iconTheme: IconThemeData(color: Colors.white),
  //           textButtonTheme: TextButtonThemeData(
  //             style: TextButton.styleFrom(foregroundColor: Colors.white),
  //           ),
  //           timePickerTheme: TimePickerThemeData(
  //             dayPeriodColor: Colors.lime,
  //             dialBackgroundColor: Colors.lime[50],
  //             dialHandColor: Colors.lime,
  //             hourMinuteTextColor: Colors.black,
  //             hourMinuteColor: Colors.lime,
  //           ),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );
  //
  //   if (picked != null) {
  //     setState(() {
  //       widget.controller.dataList[index]['time_range'] =
  //           picked.format(context); // Update UI
  //     });
  //
  //     // Convert TimeOfDay to DateTime
  //     DateTime now = DateTime.now();
  //     DateTime scheduledTime = DateTime(
  //       now.year,
  //       now.month,
  //       now.day,
  //       picked.hour,
  //       picked.minute,
  //     );
  //
  //     if (scheduledTime.isBefore(now)) {
  //       scheduledTime = scheduledTime.add(Duration(days: 1)); // Set for next day
  //     }
  //
  //     // Schedule the notification
  //     // await NotificationService.scheduleNotification(
  //     //   index, // Unique ID for each meal notification
  //     //   "Meal Reminder",
  //     //   "Did you eat your ${widget.controller.dataList[index]['label_name']}?",
  //     //   scheduledTime,
  //     // );
  //
  //     print("Scheduled Notification for ${picked.format(context)}");
  //   }
  // }

  // Method to show dialog for adding/editing meals
  void _showAddMealDialog(BuildContext context) {
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.cardbackground,
              title: Center(child: Text("Add New Meal")),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  Text("Meal Title", style: TextStyle(fontSize: 15)),
                  SizedBox(height: 10),
                  TextField(
                    controller: widget.controller.title,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent)),
                      hintText: "Meal Title",
                      hintStyle:
                          TextStyle(color: Color(0xff7E7E7E), fontSize: 18),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text("Start Time", style: TextStyle(fontSize: 15)),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      final TimeOfDay? pickedStartTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: ColorScheme.dark(
                                primary: Colors.lime,
                                onPrimary: Colors.black,
                                surface: Colors.black,
                                onSurface: Colors.black,
                              ),
                              iconTheme: IconThemeData(color: Colors.white),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                    foregroundColor: Colors.white),
                              ),
                              timePickerTheme: TimePickerThemeData(
                                dayPeriodColor: Colors.lime,
                                dialBackgroundColor: Colors.lime[50],
                                dialHandColor: Colors.lime,
                                hourMinuteTextColor: Colors.black,
                                hourMinuteColor: Colors.lime,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (pickedStartTime != null) {
                        setState(() {
                          startTime = pickedStartTime;
                          widget.controller.startTime.text =
                              startTime!.format(context);
                        });
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            startTime == null
                                ? "Select Start Time"
                                : startTime!.format(context),
                            style: TextStyle(
                                fontSize: 18, color: Color(0xff7E7E7E)),
                          ),
                          Icon(Icons.watch_later_outlined,
                              color: Color(0xff7E7E7E)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text("End Time", style: TextStyle(fontSize: 15)),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      final TimeOfDay? pickedEndTime = await showTimePicker(
                        context: context,
                        initialTime: startTime ?? TimeOfDay.now(),
            builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: ThemeData.dark().copyWith(
                      colorScheme: ColorScheme.dark(
                        primary: Colors.lime,
                        onPrimary: Colors.black,
                        surface: Colors.black,
                        onSurface: Colors.black,
                      ),
                      iconTheme: IconThemeData(color: Colors.white),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(foregroundColor: Colors.white),
                      ),
                      timePickerTheme: TimePickerThemeData(
                        dayPeriodColor: Colors.lime,
                        dialBackgroundColor: Colors.lime[50],
                        dialHandColor: Colors.lime,
                        hourMinuteTextColor: Colors.black,
                        hourMinuteColor: Colors.lime,
                      ),
                    ),
                    child: child!,
                  );
                },
                      );
                      if (pickedEndTime != null) {
                        setState(() {
                          endTime = pickedEndTime;
                          widget.controller.endTime.text =
                              endTime!.format(context);
                        });
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            endTime == null
                                ? "Select End Time"
                                : endTime!.format(context),
                            style: TextStyle(
                                fontSize: 18, color: Color(0xff7E7E7E)),
                          ),
                          Icon(Icons.watch_later_outlined,
                              color: Color(0xff7E7E7E)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xffCDE26D),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (widget.controller.title.text.isNotEmpty &&
                          startTime != null &&
                          endTime != null) {
                        widget.controller.addMeal(context, widget.id);
                      }
                    },
                    child: Text("Add",
                        style: TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                ),
              ],
            );
          },
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
    return BaseWidget(
      // appBar: AppBar(
      //   leading: IconButton(
      //       onPressed: () {
      //         Get.back();
      //       },
      //       icon: Icon(Icons.arrow_back_ios)),
      //   title: Text("Set Your Daily Meal & Snack Timings"),
      //   backgroundColor: Colors.black,
      // ),
      title: "Set Your Daily Meal & Snack Timings",
      backButton: true,
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
                                  title: Text(
                                    "${data['label_name']}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "${data['time_range']}",
                                      style: TextStyle(
                                          color: Color(0xff7E7E7E),
                                          fontSize: 15),
                                    ),
                                  ),
                                  // trailing: IconButton(
                                  //   icon: Icon(Icons.access_time,
                                  //       color: Colors.greenAccent),
                                  //   onPressed: () {
                                  //     _selectTime(context, index);
                                  //   },
                                  // ),

                                  // trailing: Container(
                                  //   width: 110,
                                  //   child: Row(
                                  //     children: [
                                  //       Switch(
                                  //         inactiveTrackColor: Color(0xff7E7E7E),
                                  //         activeTrackColor: Color(0xffCDE26D),
                                  //         thumbColor: WidgetStatePropertyAll(Colors.white),
                                  //         value: widget.controller.dataList[index]['enabled'] ?? false, // ✅ Fix applied
                                  //         onChanged: (value) {
                                  //           setState(() {
                                  //             widget.controller.dataList[index]['enabled'] = value;
                                  //           });
                                  //
                                  //           if (!value) {
                                  //             // NotificationService.cancelNotification(index);
                                  //             print("Cancelled Notification for ${widget.controller.dataList[index]['label_name']}");
                                  //           }
                                  //         },
                                  //       ),
                                  //
                                  //       IconButton(
                                  //         icon: Icon(Icons.access_time,
                                  //             color: Colors.greenAccent),
                                  //         onPressed: () {
                                  //           _selectTime(context, index);
                                  //         },
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
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
        shape: RoundedRectangleBorder(
          // Make the FAB rounded
          borderRadius: BorderRadius.circular(
              30.0), // Adjust the radius for more roundness
        ),
        onPressed: () {
          _showAddMealDialog(context);
        },
        backgroundColor: Color(0xffCDE26D),
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
