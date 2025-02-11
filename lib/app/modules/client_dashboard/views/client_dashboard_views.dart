import 'package:carousel_slider/carousel_slider.dart';
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
    userData = Get.find<AuthController>().userdataget();

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
      await APIMethods.get
          .get(
        url: APIEndpoints.meals
            .getMeals(Get.find<AuthController>().groupgetId(), "user"),
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

  Future<void> getCategories() async {
    try {
      await APIMethods.get
          .get(
        url: APIEndpoints.meals
            .getMealCategories(Get.find<AuthController>().groupgetId()),
      )
          .then((value) {
        if (APIStatus.success(value.statusCode)) {
          Get.find<AuthController>().categoriesAdd(value.data);
          Future.delayed(const Duration(milliseconds: 100), () {
            categories = Get.find<AuthController>().categoriesGet();
          });
        } else {
          print("Categories Not Found");
        }
      });
      // }
    } catch (e) {
      print(e);
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
        final createdAt = DateTime.parse(recipe["created_at"]);
        // Check if the year, month, and day match
        return createdAt.year == selectedDate.year &&
            createdAt.month == selectedDate.month &&
            createdAt.day == selectedDate.day;
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
    return Scaffold(
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
      drawer: const DrawerMenu(),
      bottomNavigationBar: const MobileNavBar(),
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
        title: const ProfileCard(),
        actions: [
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
          const SizedBox(
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
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Today plan",
                      style: TextStyle(fontSize: 15),
                    ),
                    Spacer(),
                    Text(
                      "View details",
                      style: TextStyle(fontSize: 13),
                    )
                  ],
                ),
              ),
              Container(
                child: SizedBox(
                  height: 80,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(10), // Rounded corners
                              child: Image.network(
                                images[index],
                                width: 180, // Set width for each image
                                fit: BoxFit.cover, // Adjust image fit as needed
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    width: 150,
                                    child: const Center(
                                      child: Icon(Icons.broken_image,
                                          color: Colors.red),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              // SizedBox(child: Image.asset("assets/men.jpg")),
                              Positioned(
                                // left: ,
                                right: 0,
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "data",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              // CarouselSlider.builder(
              //   itemCount: images.length,
              //   options: CarouselOptions(
              //     autoPlay: true,
              //     // enlargeFactor: 0,
              //     aspectRatio: 2.0,
              //     // enlargeCenterPage: true,
              //   ),
              //   itemBuilder: (context, index, realIdx) {
              //     return Center(
              //         child: Image.network(images[index],
              //             fit: BoxFit.cover, width: 2000));
              //   },
              // ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 35,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        summery(),
                        summery(),
                      ],
                    ),
                  )
                ],
              ),

              // SizedBox(height: 16),
              // DailySummeryCard(),

              const SizedBox(height: 16),
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

  Container summery() {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10), // Rounded corners (optional)
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 5, // Shadow width spread
            blurRadius: 7, // Shadow blur amount
            offset: Offset(0, 3), // Shadow position (x, y)
          ),
        ],
        color: AppColors.white.withOpacity(.1), // Replace if needed
      ),
      padding: const EdgeInsets.all(10), // Padding for inner content
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Daily Calories Intake',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ), // Title styling
          ),
          const SizedBox(height: 10), // Space after title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIndicatorCard('Eaten', '1258 Kcal', 0.60),
              _buildIndicatorCard('Burn', '558 Kcal', 0.60),
            ],
          ),
          const SizedBox(height: 20), // Space before the nutrient row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNutrientColumn(
                  '35', '/75', 'Proteins', const Color(0XFFFF5122)),
              _buildVerticalDivider(),
              _buildNutrientColumn('120', '/200', 'Carbs', Colors.yellow),
              _buildVerticalDivider(),
              _buildNutrientColumn(
                  '35', '/75', 'Fats', const Color(0XFF8B3BFF)),
            ],
          ),
        ],
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

  // Helper function to build the vertical divider
  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey, // Light color for the divider
    );
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

// Helper method to create indicator card
Widget _buildIndicatorCard(String title, String value, double progress) {
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color.fromRGBO(193, 223, 59, 1),
        ),
        width: 80,
        height: 80,
        child: CircularProgressIndicator(
          value: progress,
          color: AppColors.chineseGreen, // Replace if needed
          backgroundColor: Colors.white,
          strokeWidth: 10,
        ),
      ),
      const SizedBox(width: 5),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ],
  );
}

// Helper method to create nutrient column
Widget _buildNutrientColumn(
    String mainValue, String subValue, String title, Color color) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text.rich(
        TextSpan(
          text: mainValue,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          children: [
            TextSpan(
              text: subValue,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 5),
      Text(
        title,
        style: const TextStyle(fontSize: 14),
      ),
    ],
  );
}

// Helper method to create vertical divider
Widget _buildVerticalDivider() {
  return Container(
    width: 1,
    height: 40,
    color: Colors.grey,
  );
}
