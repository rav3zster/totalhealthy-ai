import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/core/utitlity/debug_print.dart';
import 'package:totalhealthy/app/modules/meal_history/controllers/meal_history_controller.dart';
import 'package:totalhealthy/app/modules/meal_timing/controllers/meal_timing_controller.dart';

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

  void _selectTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
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

    if (picked != null) {
      setState(() {
        widget.controller.dataList[index]['time_range'] =
            picked.format(context); // Update UI
      });

      // Convert TimeOfDay to DateTime
      DateTime now = DateTime.now();
      DateTime scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );

      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(Duration(days: 1)); // Set for next day
      }

      // Schedule the notification
      // await NotificationService.scheduleNotification(
      //   index, // Unique ID for each meal notification
      //   "Meal Reminder",
      //   "Did you eat your ${widget.controller.dataList[index]['label_name']}?",
      //   scheduledTime,
      // );

      print("Scheduled Notification for ${picked.format(context)}");
    }
  }


  // Method to show dialog for adding/editing meals
  void _showAddMealDialog(BuildContext context) {
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.cardbackground,
          title: Center(child: Text("Add New Meal")),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10,),
              Text("Meal Title",style: TextStyle(fontSize: 15),),
              SizedBox(height: 10,),
              TextField(
                controller: widget.controller.title,

                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.black12,
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                    hintText: "Meal Title",
                    hintStyle: TextStyle(color: Color(0xff7E7E7E),fontSize: 18)
                  //  labelText: "Meal Title"
                ),
              ),
              SizedBox(height: 16),

              Text("Select Timing",style: TextStyle(fontSize: 15),),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.only(top: 5,bottom: 5),
                alignment: Alignment.centerLeft,
                width: double.infinity,
                decoration: BoxDecoration(

                   color: Colors.black12,
                ),
                 child: TextButton( onPressed: () async {
                   final TimeOfDay? picked = await showTimePicker(
                     context: context,
                     initialTime: selectedTime,
                     builder: (BuildContext context, Widget? child){
                        return Theme( data: ThemeData.dark().copyWith(
                          colorScheme: ColorScheme.dark(
                            primary: Colors.lime, // Header and selected time color
                            onPrimary: Colors.black, // Text color on selected time
                            surface: Colors.black, // Background of the dialog
                            onSurface: Colors.black, // Text color for labels and numbers
                          ),
                          iconTheme: IconThemeData(
                             color: Colors.white,
                          ),

                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white, // Text color for Cancel and OK buttons
                            ),
                          ),

                          timePickerTheme: TimePickerThemeData(
                            dayPeriodColor:  Colors.lime,
                            dialBackgroundColor: Colors.lime[50], // Background color of the clock face
                            dialHandColor: Colors.lime, // Color of the clock hand
                            hourMinuteTextColor: Colors.black, // Text color for hour and minute fields
                            hourMinuteColor: Colors.lime, // Background color for selected hour and minute
                          ),
                        ), child: child!)
                        ;
                     }
                   );
                   if (picked != null) {
                     setState(() {
                       widget.controller.time.text = picked.format(context);
                     });
                   }
                 }, child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Text("Meal Timing",style: TextStyle(fontSize: 18,color: Color(0xff7E7E7E)), ),
                     // Text("Select Time: ${selectedTime.format(context)}",style: TextStyle(fontSize: 18,color: Color(0xff7E7E7E)), ),
                     SizedBox(width: 10,),
                     Icon(Icons.watch_later_outlined,color:Color(0xff7E7E7E) ,)
                   ],
                 )),
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     final TimeOfDay? picked = await showTimePicker(
              //       context: context,
              //       initialTime: selectedTime,
              //     );
              //     if (picked != null) {
              //       setState(() {
              //         widget.controller.time.text = picked.format(context);
              //       });
              //     }
              //   },
              //   child: Text("Select Time: ${selectedTime.format(context)}"),
              // ),
            ],
          ),
          actions: [
            // TextButton(
            //   child: Text("Cancel"),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
            Container(
              width: double.infinity,

              decoration: BoxDecoration(
                  color: Color(0xffCDE26D),
                  borderRadius: BorderRadius.circular(28)
              ),
              child: TextButton( onPressed: () {
                if (widget.controller.title.text.isNotEmpty) {
                  widget.controller.addMeal(context, widget.id);
                  // Navigator.of(context).pop();
                }
              }, child:  Text("Add",style: TextStyle(fontSize: 18,color: Colors.black),),),
            ),
            // ElevatedButton(
            //   child: Text("Add"),
            //   onPressed: () {
            //     if (widget.controller.title.text.isNotEmpty) {
            //       widget.controller.addMeal(context, widget.id);
            //       // Navigator.of(context).pop();
            //     }
            //   },
            // ),
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

                                  title: Text(
                                    "${data['label_name']}",
                                    style: TextStyle(color: Colors.white,fontSize: 20),
                                  ),
                                  subtitle: Padding(
                                    padding: EdgeInsets.only(top:5),
                                    child: Text(
                                      "${data['time_range']}",
                                      style:
                                          TextStyle(color: Color(0xff7E7E7E),fontSize: 15),
                                    ),
                                  ),
                                  // trailing: IconButton(
                                  //   icon: Icon(Icons.access_time,
                                  //       color: Colors.greenAccent),
                                  //   onPressed: () {
                                  //     _selectTime(context, index);
                                  //   },
                                  // ),

                                  trailing: Container(
                                    width: 110,
                                    child: Row(
                                      children: [
                                        Switch(
                                          inactiveTrackColor: Color(0xff7E7E7E),
                                          activeTrackColor: Color(0xffCDE26D),
                                          thumbColor: WidgetStatePropertyAll(Colors.white),
                                          value: widget.controller.dataList[index]['enabled'] ?? false, // ✅ Fix applied
                                          onChanged: (value) {
                                            setState(() {
                                              widget.controller.dataList[index]['enabled'] = value;
                                            });

                                            if (!value) {
                                              // NotificationService.cancelNotification(index);
                                              print("Cancelled Notification for ${widget.controller.dataList[index]['label_name']}");
                                            }
                                          },
                                        ),

                                        IconButton(
                                          icon: Icon(Icons.access_time,
                                              color: Colors.greenAccent),
                                          onPressed: () {
                                            _selectTime(context, index);
                                          },
                                        ),
                                      ],
                                    ),
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
        shape: RoundedRectangleBorder( // Make the FAB rounded
          borderRadius: BorderRadius.circular(30.0), // Adjust the radius for more roundness
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
