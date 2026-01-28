import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:totalhealthy/app/widgets/baseWidget.dart';
import 'package:totalhealthy/app/widgets/phone_nav_bar.dart';
import 'package:totalhealthy/app/widgets/user_profile_section.dart';

import '../../../data/services/mock_api_service.dart';
import '../../../data/services/dummy_data_service.dart';
import '../../../core/base/constants/appcolor.dart';
import '../../../core/base/controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';
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
    userData = Get.find<AuthController>().userdataget() ?? {};

    getMeals();
  }

  List<Map<String, dynamic>> dataList = [];
  var isLoading = false;

  Future<void> getMeals() async {
    try {
      setState(() {
        isLoading = true;
      });
      await getCategories();
      
      // Use mock API instead of real API
      final response = await MockApiService.getMeals(
        Get.find<AuthController>().groupgetId(), 
        "user"
      );
      
      if (response['statusCode'] == 200) {
        setState(() {
          dataList = List<Map<String, dynamic>>.from(response['data']);
        });
        _filterRecipesByDate(selectedDate);
      } else {
        // Load dummy data as fallback
        setState(() {
          dataList = DummyDataService.getDummyMeals();
        });
        _filterRecipesByDate(selectedDate);
      }
    } catch (e) {
      print("Error loading meals: $e");
      // Load dummy data as fallback
      setState(() {
        dataList = DummyDataService.getDummyMeals();
      });
      _filterRecipesByDate(selectedDate);
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
      "history_on_day": DateTime(2024, 10, 15).toIso8601String(), // Static date
    };
  }

  var isGetLoading = false;

  Future<void> postHistory() async {
    try {
      setState(() {
        isGetLoading = true;
      });

      var data = generateJson();
      
      // Use mock API instead of real API
      final response = await MockApiService.createMeal(data);
      
      if (response['statusCode'] == 200) {
        setState(() {
          isCheck = {for (int i = 0; i < dataList.length; i++) i: false};
          selectedMealIds.clear();
        });

        Get.toNamed("/meal-history?id=${userData["_id"]}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Meal history saved successfully!'),
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
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isGetLoading = false;
      });
    }
  }

  DateTime selectedDate = DateTime(2024, 10, 15); // Static date: October 15, 2024
  List<Map<String, dynamic>> filteredRecipes = [];

  void filterRecipesBySingleCategory(String selectedCategory) {
    setState(() {
      filteredRecipes = filtered.where((recipe) {
        try {
          final categories = recipe["categorys"] as List<dynamic>? ?? [];
          return categories.contains(selectedCategory);
        } catch (e) {
          print("Error filtering by category: $e");
          return false;
        }
      }).toList();
    });
    print(filteredRecipes);
  }

  Future<void> getCategories() async {
    try {
      // Use mock API instead of real API
      final response = await MockApiService.getMealCategories(
        Get.find<AuthController>().groupgetId()
      );
      
      if (response['statusCode'] == 200) {
        Get.find<AuthController>().categoriesAdd(response['data']);
        Get.find<AuthController>().fetchAndScheduleNotifications(response['data']);
        Future.delayed(const Duration(milliseconds: 100), () {
          categories = Get.find<AuthController>().categoriesGet();
        });
      } else {
        print("Categories Not Found - using dummy data");
        // Load dummy data as fallback
        final dummyCategories = DummyDataService.getDummyMealCategories();
        Get.find<AuthController>().categoriesAdd(dummyCategories);
        Get.find<AuthController>().fetchAndScheduleNotifications(dummyCategories);
        Future.delayed(const Duration(milliseconds: 100), () {
          categories = Get.find<AuthController>().categoriesGet();
        });
      }
    } catch (e) {
      print("Error loading categories: $e");
      // Load dummy data as fallback
      final dummyCategories = DummyDataService.getDummyMealCategories();
      Get.find<AuthController>().categoriesAdd(dummyCategories);
      categories = dummyCategories;
    }
  }

  var categories = [];

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
        try {
          final createdAt = DateTime.parse(recipe["created_at"] ?? "2024-10-15T00:00:00Z");
          // Check if the year, month, and day match
          return createdAt.year == selectedDate.year &&
              createdAt.month == selectedDate.month &&
              createdAt.day == selectedDate.day;
        } catch (e) {
          print("Error parsing date: $e");
          return false;
        }
      }).toList();
    });
    filterRecipesBySingleCategory("Breakfast");
  }

  Map<int, bool> isCheck = {};

  List<String> selectedMealIds = [];
  bool isCalender = false;
  final List<String> images = [
    'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
    'https://images.unsplash.com/photo-1586871608370-4adee64d1794?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2862&q=80',
    'https://images.unsplash.com/photo-1586901533048-0e856dff2c0d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
    'https://images.unsplash.com/photo-1586902279476-3244d8d18285?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
    'https://images.unsplash.com/photo-1586943101559-4cdcf86a6f87?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1556&q=80',
    'https://images.unsplash.com/photo-1586951144438-26d4e072b891?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
    'https://images.unsplash.com/photo-1586953983027-d7508a64f4bb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
  ];

  @override
  Widget build(BuildContext context) {
    String id = Get.parameters["id"] ?? "";
    return BaseWidget(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: selectedMealIds.isNotEmpty
          ? isGetLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : FloatingActionButton(
                  backgroundColor: AppColors.chineseGreen,
                  child: const Icon(
                    Icons.done,
                    color: AppColors.cardbackground,
                  ),
                  onPressed: () {
                    postHistory();
                  })
          : const SizedBox(),
      // drawer: const DrawerMenu(),
      // bottomNavigationBar: const MobileNavBar(),
      // backgroundColor: Colors.black,
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   // leading: IconButton(
      //   //     onPressed: () {
      //   //       Get.toNamed('/userdiet?id=$id');
      //   //     },
      //   //     icon: Icon(
      //   //       Icons.arrow_back_ios,
      //   //       color: Colors.white,
      //   //     )),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   // title: const ProfileCard(),
      //   // actions: [
      //   //   const SizedBox(
      //   //     width: 10,
      //   //   ),
      //   // ],
      // ),
      title:  "${ProfileCard()}",
      appBarAction: [
        Container(
          decoration: const BoxDecoration(
              color: Color(0XFF242424), shape: BoxShape.circle),
          child: IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.white,
            ),
            onPressed: () {
              Get.toNamed('/notification?id=$id');
            },
          ),
        ),
      ],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Section with Calories Intake Card
              const UserProfileSection(),
              
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Today's Diet Plan",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Spacer(),
                  ],
                ),
              ),
              
              // Add Meal Button - Made functional
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to Create Meal screen
                        Get.toNamed(Routes.CreateMeal);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.chineseGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.chineseGreen, width: 1),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Add Meal",
                              style: TextStyle(
                                fontSize: 14, 
                                color: AppColors.chineseGreen,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.add, color: AppColors.chineseGreen, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Diet Plan Filter Buttons
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
                        padding: const EdgeInsets.only(left: 10),
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
              const SizedBox(
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
                          initialDate: DateTime(2024, 10, 15), // Static date
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
                  : const SizedBox(),

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
              Divider(
                color: Colors.grey.shade600,
                endIndent: 20,
                indent: 20,
                height: 2,
              ),
              const SizedBox(
                height: 10,
              ),
              //          Get.find<AuthController>().roleGet()   AddMealButton(
              //   id: userData["_id"] ?? "",
              // ),

              SizedBox(
                height: 40,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    var data = categories[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                        filterRecipesBySingleCategory(
                            data["label_name"].toString());
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: ButtonSelector(
                          title: data["label_name"].toString(),
                          icon: index == 0
                              ? Icons.breakfast_dining
                              : index == 1
                                  ? Icons.lunch_dining
                                  : index == 2
                                      ? Icons.dinner_dining
                                      : Icons.food_bank,
                          active: index == selectedIndex,
                        ),
                      ),
                    );
                  },
                  itemCount: categories.length,
                ),
              ),
              const SizedBox(height: 20),

              isLoading
                  ? const Center(
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
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredRecipes.length,
                          itemBuilder: (context, index) {
                            var data = filteredRecipes[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 15),
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
                                id: userData["_id"] ?? "",
                                title: "${data["name"] ?? "Unknown Meal"}",
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color(0XFF242522).withOpacity(0.50),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(kcal,
                            style: const TextStyle(
                                color: Color(0XFFF5D657), fontSize: 18)),
                        const SizedBox(height: 4),
                        Text(nutrients,
                            style: const TextStyle(
                                color: Color(0XFFDBDBDB), fontSize: 16)),
                      ],
                    )
                  ],
                ),
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
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0XFFCDE26D)),
            borderRadius: BorderRadius.circular(40),
            color: const Color(0XFF242522),
          ),
          child: TextButton.icon(
              icon: const Icon(
                Icons.set_meal,
                color: Color(0XFFDBDBDB),
              ),
              onPressed: () {},
              label: const Text(
                "Brekfast",
                style: TextStyle(color: Color(0XFFDBDBDB)),
              )),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: const Color(0XFF242522),
          ),
          child: TextButton.icon(
              icon: const Icon(
                Icons.lunch_dining,
                color: Color(0XFFDBDBDB),
              ),
              onPressed: () {},
              label: const Text(
                "Lunch",
                style: TextStyle(color: Color(0XFFDBDBDB)),
              )),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: const Color(0XFF242522),
          ),
          child: TextButton.icon(
              icon: const Icon(
                Icons.dinner_dining,
                color: Color(0XFFDBDBDB),
              ),
              onPressed: () {},
              label: const Text(
                "Dinner",
                style: TextStyle(color: Color(0XFFDBDBDB)),
              )),
        ),
      ],
    );
  }
}
