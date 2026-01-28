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
    final user = Get.find<AuthController>().getCurrentUser();
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Welcome message and notification
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(user.profileImage ?? 'https://via.placeholder.com/150'),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user.username ?? 'Ayush Shukla',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF242424),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.notifications_none, color: Colors.white),
                        onPressed: () {
                          Get.toNamed('/notification?id=$id');
                        },
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 24),
                
                // Live Stats Card
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Live Stats',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem('55%', 'Goal Achieved', Colors.orange),
                          _buildStatItem('4kg', 'Fat Lost', Colors.yellow),
                          _buildStatItem('0.8Gm', 'Muscle Gained', Colors.purple),
                        ],
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Search Bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.white54),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Search here...',
                          style: TextStyle(color: Colors.white54, fontSize: 16),
                        ),
                      ),
                      Icon(Icons.tune, color: Colors.white54),
                    ],
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Day Progress and Add Meal Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Day 1/55 (Weight Loss)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '23 Oct - 17 Dec',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.toNamed(Routes.CreateMeal);
                      },
                      icon: Icon(Icons.add, color: Colors.black),
                      label: Text(
                        'Add Meal',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC2D86A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 20),
                
                // Meal Type Tabs
                Row(
                  children: [
                    _buildMealTab('🍳', 'Breakfast', selectedIndex == 0, () {
                      setState(() {
                        selectedIndex = 0;
                        filterRecipesBySingleCategory('Breakfast');
                      });
                    }),
                    SizedBox(width: 12),
                    _buildMealTab('🥗', 'Lunch', selectedIndex == 1, () {
                      setState(() {
                        selectedIndex = 1;
                        filterRecipesBySingleCategory('Lunch');
                      });
                    }),
                    SizedBox(width: 12),
                    _buildMealTab('🍽️', 'Dinner', selectedIndex == 2, () {
                      setState(() {
                        selectedIndex = 2;
                        filterRecipesBySingleCategory('Dinner');
                      });
                    }),
                  ],
                ),
                
                SizedBox(height: 20),
                
                // Meals List
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : filteredRecipes.isEmpty
                        ? Center(
                            child: Column(
                              children: [
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
                              return _buildMealCard(data, index);
                            },
                          ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1A1A1A),
          border: Border(
            top: BorderSide(color: Color(0xFF2A2A2A), width: 1),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.person, 'Member', true, () {
                  // Already on member/dashboard screen
                }),
                _buildNavItem(Icons.group, 'Group', false, () {
                  Get.toNamed(Routes.GROUP);
                }),
                _buildNavItem(Icons.notifications, 'Notification', false, () {
                  Get.toNamed('/notification?id=$id');
                }),
                _buildNavItem(Icons.settings, 'Setting', false, () {
                  Get.toNamed(Routes.SETTING);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildNavItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? Color(0xFFC2D86A) : Colors.white54,
            size: 24,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Color(0xFFC2D86A) : Colors.white54,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  
  Widget _buildMealTab(String emoji, String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF2A2A2A) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: Color(0xFFC2D86A)) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: TextStyle(fontSize: 16)),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white54,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMealCard(Map<String, dynamic> data, int index) {
    return GestureDetector(
      onTap: () {
        // Store meal data and navigate to details page
        final box = GetStorage();
        box.write("mealdetails", data);
        Get.toNamed('/meals-details?id=${Get.find<AuthController>().userdataget()["_id"] ?? ""}');
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Meal Image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xFFC2D86A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.restaurant, color: Colors.black, size: 30),
            ),
            SizedBox(width: 16),
            
            // Meal Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['meal_name'] ?? data['name'] ?? 'Scrambled Eggs With Spinach',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department, color: Colors.orange, size: 16),
                      SizedBox(width: 4),
                      Text(
                        '${data['calories'] ?? data['kcal'] ?? '500'} Kcal',
                        style: TextStyle(color: Colors.orange, fontSize: 14),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '• ${data['weight'] ?? '100'}g',
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  
                  // Nutritional Info
                  Row(
                    children: [
                      _buildNutrientBar('${data['protein'] ?? '20'}g', 'Protein', Colors.green),
                      SizedBox(width: 12),
                      _buildNutrientBar('${data['fat'] ?? '21'}g', 'Fat', Colors.blue),
                      SizedBox(width: 12),
                      _buildNutrientBar('${data['carbs'] ?? '30'}g', 'Carbs', Colors.red),
                    ],
                  ),
                ],
              ),
            ),
            
            // More Options
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFC2D86A),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.more_horiz, color: Colors.black, size: 20),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNutrientBar(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 3,
          height: 20,
          color: color,
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white54, fontSize: 10),
        ),
      ],
    );
  }
}
