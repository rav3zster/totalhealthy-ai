import 'package:flutter/material.dart';

class MealTimingPage extends StatefulWidget {
  @override
  _MealTimingPageState createState() => _MealTimingPageState();
}

class _MealTimingPageState extends State<MealTimingPage> {
  // List to hold meals with time and toggle status
  List<Map<String, dynamic>> meals = [
    {
      "title": "Breakfast",
      "time": TimeOfDay(hour: 10, minute: 0),
      "enabled": true
    },
    {
      "title": "Mid-Morning Snack",
      "time": TimeOfDay(hour: 11, minute: 30),
      "enabled": false
    },
    {
      "title": "Lunch",
      "time": TimeOfDay(hour: 14, minute: 0),
      "enabled": false
    },
    {
      "title": "Pre-Workout Meal",
      "time": TimeOfDay(hour: 16, minute: 0),
      "enabled": false
    },
    {
      "title": "Post-Workout Meal",
      "time": TimeOfDay(hour: 18, minute: 0),
      "enabled": false
    },
    {
      "title": "Dinner",
      "time": TimeOfDay(hour: 21, minute: 0),
      "enabled": false
    },
    {
      "title": "Before Bed Meal",
      "time": TimeOfDay(hour: 23, minute: 0),
      "enabled": false
    },
  ];

  // Method to add new meal
  void addMeal(String title, TimeOfDay time) {
    setState(() {
      meals.add({"title": title, "time": time, "enabled": false});
    });
  }

  // Method to show the time picker and update the time
  void _selectTime(BuildContext context, int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: meals[index]['time'],
    );
    if (picked != null) {
      setState(() {
        meals[index]['time'] = picked;
      });
    }
  }

  // Method to show dialog for adding/editing meals
  void _showAddMealDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add New Meal"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
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
                      selectedTime = picked;
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
                if (titleController.text.isNotEmpty) {
                  addMeal(titleController.text, selectedTime);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            Expanded(
              child: ListView.builder(
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.grey[850],
                    child: ListTile(
                      leading: Switch(
                        value: meals[index]['enabled'],
                        onChanged: (value) {
                          setState(() {
                            meals[index]['enabled'] = value;
                          });
                        },
                      ),
                      title: Text(
                        meals[index]['title'],
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        meals[index]['time'].format(context),
                        style: TextStyle(color: Colors.yellowAccent),
                      ),
                      trailing: IconButton(
                        icon:
                            Icon(Icons.access_time, color: Colors.greenAccent),
                        onPressed: () {
                          _selectTime(context, index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
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
