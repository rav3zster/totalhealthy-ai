import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:totalhealthy/app/modules/meal_history/controllers/meal_history_controller.dart';
import 'package:totalhealthy/app/widgets/button_selector.dart';

import '../../../core/base/apiservice/api_endpoints.dart';
import '../../../core/base/apiservice/api_status.dart';
import '../../../core/base/apiservice/base_methods.dart';
import '../../../core/base/constants/appcolor.dart';
import '../../../core/base/controllers/auth_controller.dart';
import '../../../widgets/nutritional_history_card.dart';
import '../../../widgets/profile_card.dart';

class MealHistoryPage extends StatefulWidget {
  final MealHistoryController controller;
  final String id;

  const MealHistoryPage(
      {super.key, required this.controller, required this.id});

  @override
  _MealHistoryPageState createState() => _MealHistoryPageState();
}

class _MealHistoryPageState extends State<MealHistoryPage> {
  @override
  void initState() {
    super.initState();
    getMeals();
    // dataList = box.read(
    //   "mealPlan",
    // );
  }

  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> recipesCotegory = [];
  void filterRecipesBySingleCategory(String selectedCategory) {
    setState(() {
      recipesCotegory = filteredRecipes.where((recipe) {
        final categories = recipe["categorys"] as List<dynamic>;

        return categories.contains(selectedCategory);
      }).toList();
    });
    print(filteredRecipes);
  }

  List<Map<String, dynamic>> dataList = [];
  var isLoading = false;
  var category = "Breakfast";
  Future<void> getMeals() async {
    try {
      setState(() {
        isLoading = true;
      });
      await APIMethods.get
          .get(
        url: APIEndpoints.meals.getuserdHistory(
          Get.find<AuthController>().groupgetId(),
        ),
      )
          .then((value) {
        if (APIStatus.success(value.statusCode)) {
          setState(() {
            dataList = List<Map<String, dynamic>>.from(value.data);
          });
          _filterRecipesByDate(selectedDate);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Group id Not Found'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
      // }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  GetStorage box = GetStorage();

  List<bool> isExpandedList = [];
  List<dynamic> mealPlanData = [];

  var buttonName = [
    {
      "name": "Today",
      "icon": Icons.today,
    },
    {
      "name": "Week",
      "icon": Icons.calendar_view_week,
    },
    {
      "name": "15 Days",
      "icon": Icons.calendar_view_day,
    },
    {
      "name": "Calender",
      "icon": Icons.calendar_month,
    },
  ];
  //  List<dynamic> mealPlanData = [];

  var shedule = [
    {
      "name": "Breakfast",
      "icon": Icons.breakfast_dining,
    },
    {
      "name": "Lunch",
      "icon": Icons.lunch_dining,
    },
    {
      "name": "Dinner",
      "icon": Icons.dinner_dining,
    },
  ];
  int selectedIndex = 0;
  int selectedIndex1 = 0;
  List<Map<String, dynamic>> filteredRecipes = [];
  void _filterRecipesByDate(DateTime selectedDate) {
    setState(() {
      filteredRecipes = dataList.where((recipe) {
        final createdAt = DateTime.parse(recipe["created_at"]);
        // Check if the year, month, and day match
        return createdAt.year == selectedDate.year &&
            createdAt.month == selectedDate.month &&
            createdAt.day == selectedDate.day;
      }).toList();
    });
    filterRecipesBySingleCategory(category);
  }

  bool isCalender = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ProfileCard(
          isDrawer: false,
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      var data = buttonName[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            data["name"] == "Today"
                                ? _filterRecipesByDate(selectedDate)
                                : data["name"] == "Calender"
                                    ? isCalender = true
                                    : isCalender = false;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: ButtonSelector(
                            title: data["name"].toString(),
                            icon: data["icon"] as IconData,
                            active: index == selectedIndex,
                          ),
                        ),
                      );
                    },
                    itemCount: buttonName.length,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                isCalender
                    ? Card(
                        color: AppColors.cardbackground,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 0, bottom: 15, left: 10, right: 10),
                          child: EasyDateTimeLine(
                            activeColor: AppColors.chineseGreen,
                            initialDate: DateTime.now(),
                            onDateChange: (selectedDate) {
                              print(selectedDate);
                              setState(() {
                                _filterRecipesByDate(selectedDate);
                              });
                              //
                            },
                            headerProps: const EasyHeaderProps(
                                monthPickerType: MonthPickerType.switcher,
                                dateFormatter: DateFormatter.monthOnly(),
                                selectedDateStyle:
                                    TextStyle(color: Colors.white)),
                            dayProps: const EasyDayProps(
                              height: 70,

                              dayStructure: DayStructure.dayStrDayNum,
                              todayNumStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              inactiveDayNumStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              disabledDayStyle: DayStyle(
                                dayNumStyle: TextStyle(color: Colors.white),
                              ),
                              // todayHighlightColor: Colors.white,
                              borderColor: AppColors.chineseGreen,
                              activeDayNumStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                              activeDayStyle: DayStyle(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: AppColors.chineseGreen),
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF2E2E2E),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      // Live Stats Title
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Body Status And Goal',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ), // Space below the title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Target Weight',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '75 kg',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              SizedBox(height: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        "assets/weight.png",
                                        height: 50,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        "94 kg",
                                        style: TextStyle(
                                            color: AppColors.mandarin,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Body Weight",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // Vertical Divider
                          Container(
                            height: 100,
                            width: 1,
                            color: Colors.grey,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Target Fat%',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '30%',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/fat.png",
                                    height: 50,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '44%',
                                    style: TextStyle(
                                        color: Color(0XFFF5D657),
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Fat Percentage',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                          // Vertical Divider

                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Text(
                          //       '07',
                          //       style: TextStyle(
                          //           color: Color(0XFFD0B4F9),
                          //           fontSize: 22,
                          //           fontWeight: FontWeight.bold),
                          //     ),
                          //     SizedBox(height: 5),
                          //     Text(
                          //       'Pending Requests',
                          //       style: TextStyle(color: Colors.white, fontSize: 14),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Color(0xFF2E2E2E),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      // Live Stats Title
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Live Stats',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10), // Space below the title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '60',
                                    style: TextStyle(
                                        color: Color(0XFFF57552),
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '/150',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Proteins',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                          // Vertical Divider
                          Container(
                            height: 50,
                            width: 1,
                            color: Colors.grey,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '120',
                                    style: TextStyle(
                                        color: Color(0XFFF5D657),
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '/200',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Carbs',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                          // Vertical Divider
                          Container(
                            height: 50,
                            width: 1,
                            color: Colors.grey,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '35',
                                    style: TextStyle(
                                        color: Color(0XFFD0B4F9),
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '/65',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Fats',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      var data = shedule[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex1 = index;
                            print("press");
                          });
                          filterRecipesBySingleCategory(
                              data["name"].toString());
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: ButtonSelector(
                            title: data["name"].toString(),
                            icon: data["icon"] as IconData,
                            active: index == selectedIndex1,
                          ),
                        ),
                      );
                    },
                    itemCount: shedule.length,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : recipesCotegory.isEmpty
                        ? Center(
                            child: Column(
                              children: [
                                // Add the image asset with black background
                                Image.asset(
                                  'assets/no_diet.png',
                                  height: 250,
                                  width: 250,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: recipesCotegory.length,
                            itemBuilder: (context, index) {
                              var data = recipesCotegory[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: 15),
                                child: NutritionalHistoryCard(
                                  data: data,
                                  id: widget.id,
                                  title: "${data["name"] ?? "Not Found"}",
                                  kcal: "${data["kcal"] ?? "0"}",
                                  weight: 80,
                                  protein: "${data["protein"] ?? "0"}",
                                  fat: "${data["fat"] ?? "0"}",
                                  carbs: "${data["carbs"] ?? "0"}",
                                ),
                              );
                            },
                          ),
              ],
            ),
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
