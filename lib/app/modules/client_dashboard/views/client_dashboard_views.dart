import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:totalhealthy/app/widgets/phone_nav_bar.dart';

import '../../../core/base/apiservice/api_endpoints.dart';
import '../../../core/base/apiservice/api_status.dart';
import '../../../core/base/apiservice/base_methods.dart';
import '../../../core/base/constants/appcolor.dart';
import '../../../core/base/controllers/auth_controller.dart';
import '../../../widgets/daily_summery_card.dart';
import '../../../widgets/drawer_menu.dart';
import '../../../widgets/button_selector.dart';
import '../../../widgets/nutritional_card.dart';

import '../../../widgets/add_meal_button.dart';
import '../../../widgets/profile_card.dart';

class ClientDashboardScreen extends StatefulWidget {
  ClientDashboardScreen({
    super.key,
  });

//
  // final String id;
  @override
  State<ClientDashboardScreen> createState() => _ClientDashboardScreenState();
}

class _ClientDashboardScreenState extends State<ClientDashboardScreen> {
  int selectedIndex = 0;
  int selectedIndex1 = 0;
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
  var userData = {};
  @override
  void initState() {
    super.initState();
    GetStorage().hasData("userdata")
        ? userData = GetStorage().read("userdata")
        : null;
    getMeals();
  }

  List<Map<String, dynamic>> dataList = [];
  var isLoading = false;

  Future<void> getMeals() async {
    try {
      setState(() {
        isLoading = true;
      });
      await APIMethods.get
          .get(
        url: APIEndpoints.meals
            .getadmindMeals(Get.find<AuthController>().groupgetId(), "user"),
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

  Map<String, dynamic> generateJson() {
    return {
      "meal_ids": selectedMealIds,
      "userId": userData["_id"],
      "groupId": Get.find<AuthController>().groupgetId(),
      "history_on_day": DateTime.now().toIso8601String(),
    };
  }

  var isGetLoading = false;
  Future<void> postHistory() async {
    try {
      setState(() {
        isGetLoading = true;
      });

      var data = generateJson();
      await APIMethods.post
          .post(
        url: APIEndpoints.createData.mealHistory,
        map: data,
      )
          .then((value) {
        if (APIStatus.success(value.statusCode)) {
          setState(() {
            isCheck = {for (int i = 0; i < dataList.length; i++) i: false};
            selectedMealIds.clear();
          });

          Get.toNamed("/meal-history?id=${userData["_id"]}");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfull!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Not Found'),
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
        isGetLoading = false;
      });
    }
  }

  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> filteredRecipes = [];
  void filterRecipesBySingleCategory(String selectedCategory) {
    setState(() {
      filteredRecipes = filtered.where((recipe) {
        final categories = recipe["categorys"] as List<dynamic>;

        return categories.contains(selectedCategory);
      }).toList();
    });
    print(filteredRecipes);
  }

  var category = "Breakfast";

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
  List<Map<String, dynamic>> filtered = [];
  void _filterRecipesByDate(DateTime selectedDate) {
    setState(() {
      filtered = dataList.where((recipe) {
        final createdAt = DateTime.parse(recipe["created_at"]);
        // Check if the year, month, and day match
        return createdAt.year == selectedDate.year &&
            createdAt.month == selectedDate.month &&
            createdAt.day == selectedDate.day;
      }).toList();
    });
    filterRecipesBySingleCategory(category);
  }

  Map<int, bool> isCheck = {};

  List<String> selectedMealIds = [];
  bool isCalender = false;
  @override
  Widget build(BuildContext context) {
    String id = Get.parameters["id"] ?? "";
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: selectedMealIds.isNotEmpty
          ? isGetLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : FloatingActionButton(
                  backgroundColor: AppColors.chineseGreen,
                  child: Icon(
                    Icons.done,
                    color: AppColors.cardbackground,
                  ),
                  onPressed: () {
                    postHistory();
                  })
          : SizedBox(),
      drawer: DrawerMenu(),
      bottomNavigationBar: MobileNavBar(),
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //     onPressed: () {
        //       Get.toNamed('/userdiet?id=$id');
        //     },
        //     icon: Icon(
        //       Icons.arrow_back_ios,
        //       color: Colors.white,
        //     )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: ProfileCard(),
        actions: [
          Container(
            decoration:
                BoxDecoration(color: Color(0XFF242424), shape: BoxShape.circle),
            child: IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: Colors.white,
              ),
              onPressed: () {
                Get.toNamed('/notification?id=$id');
              },
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 35,
                      ),
                      Container(
                        height: 250, // Increase the height of the container
                        decoration: BoxDecoration(
                          color: Color(0XFFCDE26D),
                          borderRadius: BorderRadius.circular(
                              16), // Increase the border radius for smoother edges
                        ),
                        padding: EdgeInsets.all(10), // Increase padding
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // Align items to the far ends
                          children: [
                            // Text content on the left
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Track \nYour Daily \nCalories',
                                  style: TextStyle(
                                      color: Color(0XFF000000),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30), // Increase font size
                                ),
                                SizedBox(height: 10),
                                // More space between the title and summary
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.circle_outlined,
                                          color: Color(0XFFFFFFFF),
                                        ),
                                        Text(
                                          'Gain',
                                          style: TextStyle(
                                              color: Color(0XFF000000),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        // Slightly bigger text
                                        Text(
                                          '1258 Kcal',
                                          style: TextStyle(
                                              color: Color(0XFF000000),
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 24),
                                    // More space between 'Gain' and 'Burn'
                                    Column(
                                      children: [
                                        Icon(
                                          Icons.circle_outlined,
                                          color: Color(0XFFFFFFFF),
                                        ),
                                        Text(
                                          'Burn',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0XFF000000),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '658 Kcal',
                                          style: TextStyle(
                                            color: Color(0XFF000000),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Image on the right
                          ],
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ClipRRect(
                      // Match the container's border radius
                      child: Image.asset(
                        "assets/clientimage.png",
                        height: 285,
                        fit: BoxFit
                            .cover, // Image will cover the entire container
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),
              DailySummeryCard(),

              SizedBox(height: 16),
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
                          selectedIndex1 = index;
                          data["name"] == "Today" ? isCalender = false : null;
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
                          active: index == selectedIndex1,
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
              // Search bar, Filter button, Today's Diet Plan, and Add Meal button
              // Row(
              //   children: [
              //     Expanded(
              //       child: Container(
              //         decoration: BoxDecoration(
              //             color: Color(0XFF242522),
              //             borderRadius: BorderRadius.circular(50)),
              //         child: TextField(
              //           decoration: InputDecoration(
              //             enabledBorder: InputBorder.none,
              //             hintText: 'Search here...',
              //             hintStyle: TextStyle(color: Color(0XFFDBDBDB)),
              //             prefixIcon:
              //                 Icon(Icons.search, color: Color(0XFFDBDBDB)),
              //           ),
              //         ),
              //       ),
              //     ),
              //     SizedBox(width: 10),
              //     Icon(Icons.filter_list, color: Colors.white, size: 30),
              //   ],
              // ),
              SizedBox(height: 16),

              //          Get.find<AuthController>().roleGet()   AddMealButton(
              //   id: userData["_id"] ?? "",
              // ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                              selectedIndex = index;
                              filterRecipesBySingleCategory(
                                  data["name"].toString());
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
                      itemCount: shedule.length,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : filteredRecipes.isEmpty
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
                          itemCount: filteredRecipes.length,
                          itemBuilder: (context, index) {
                            var data = filteredRecipes[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 15),
                              child: NutritionalCard(
                                // role: Get.find<AuthController>().roleGet(),
                                isChecked: isCheck[index] ?? false,
                                onChanged: (value) {
                                  setState(() {
                                    isCheck[index] = value ?? false;

                                    if (isCheck[index] == true) {
                                      selectedMealIds.add(data['_id'] ?? '0');
                                    } else {
                                      selectedMealIds
                                          .remove(data['_id'] ?? '0');
                                    }
                                    print(selectedMealIds);
                                  });
                                },
                                data: data,
                                id: userData["_id"],
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
      ),
    );
  }

  Widget _buildMealItem(
      String title, String kcal, String nutrients, String imageUrl) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: Stack(
          children: [
            Image.network(
                'https://s3-alpha-sig.figma.com/img/42a5/0ea7/5b8574861966061d01ca70419a885f64?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=TNP2-OtEW8U7dcWblP4c7AMYU6zc0888Du5vY8Djd7sIsZOlBM6mmzO1nejuXhQp~XT~qIrnwQ~NDuf13jw~VImXOMCRrA6q~on5D7piCoMGv-97~gybVs2~iR0e5q6yoBNJfDKrmZE4Pow8cTwyDk~J0y-Bn702hR6X-dI7tEDtOYt1rfo2QWbVUkRLumS1PtGYfpViAZG-9Pkvo6IiU9DcY0O4utrk2LF~Igl2ci~wU-e0f9TX-fMDUp1sRhvOZ9qbn1YWU9JcOafLjRLzFXPRrplp385UktkybQrUxxhW0CwYE-0X1VmHa1pEe8mtTV0g3Zp9W5GNIJYTLfYAFA__',
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.only(top: 190),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(kcal,
                            style: TextStyle(
                                color: Color(0XFFF5D657), fontSize: 18)),
                        SizedBox(height: 4),
                        Text(nutrients,
                            style: TextStyle(
                                color: Color(0XFFDBDBDB), fontSize: 16)),
                      ],
                    )
                  ],
                ),
                decoration: BoxDecoration(
                    color: Color(0XFF242522).withOpacity(0.50),
                    borderRadius: BorderRadius.circular(10)),
              ),
            )
          ],
        ));
  }
}

class MealTypeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0XFFCDE26D)),
            borderRadius: BorderRadius.circular(40),
            color: Color(0XFF242522),
          ),
          child: TextButton.icon(
              icon: Icon(
                Icons.set_meal,
                color: Color(0XFFDBDBDB),
              ),
              onPressed: () {},
              label: Text(
                "Brekfast",
                style: TextStyle(color: Color(0XFFDBDBDB)),
              )),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Color(0XFF242522),
          ),
          child: TextButton.icon(
              icon: Icon(
                Icons.lunch_dining,
                color: Color(0XFFDBDBDB),
              ),
              onPressed: () {},
              label: Text(
                "Lunch",
                style: TextStyle(color: Color(0XFFDBDBDB)),
              )),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Color(0XFF242522),
          ),
          child: TextButton.icon(
              icon: Icon(
                Icons.dinner_dining,
                color: Color(0XFFDBDBDB),
              ),
              onPressed: () {},
              label: Text(
                "Dinner",
                style: TextStyle(color: Color(0XFFDBDBDB)),
              )),
        ),
      ],
    );
  }
}
