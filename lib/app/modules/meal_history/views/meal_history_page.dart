import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:totalhealthy/app/modules/meal_history/controllers/meal_history_controller.dart';

import '../../../core/base/controllers/auth_controller.dart';
import '../../../widgets/drawer_menu.dart';
import '../../../data/services/mock_api_service.dart';

class MealHistoryPage extends StatefulWidget {
  final MealHistoryController controller;
  final String id;

  const MealHistoryPage({
    super.key,
    required this.controller,
    required this.id,
  });

  @override
  State<MealHistoryPage> createState() => _MealHistoryPageState();
}

class _MealHistoryPageState extends State<MealHistoryPage>
    with SingleTickerProviderStateMixin {
  DateTime selectedDate = DateTime(2024, 10, 15);
  List<Map<String, dynamic>> recipesCotegory = [];
  List<Map<String, dynamic>> dataList = [];
  List<Map<String, dynamic>> filteredRecipes = [];
  var isLoading = false;
  var category = "Breakfast";
  int selectedTimeIndex = 0;
  int selectedCategoryIndex = 0;
  bool isCalender = false;
  var categories = [];
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var timeFilters = [
    {"name": "Today", "icon": Icons.today},
    {"name": "Week", "icon": Icons.calendar_view_week},
    {"name": "15 Days", "icon": Icons.calendar_view_day},
    {"name": "Calendar", "icon": Icons.calendar_month},
  ];

  @override
  void initState() {
    super.initState();
    categories = Get.find<AuthController>().categoriesGet();
    getMeals();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void filterRecipesBySingleCategory(String selectedCategory) {
    setState(() {
      recipesCotegory = filteredRecipes.where((recipe) {
        final categories = recipe["categorys"] as List<dynamic>;
        return categories.contains(selectedCategory);
      }).toList();
    });
  }

  Future<void> getMeals() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await MockApiService.getMealHistory(
        Get.find<AuthController>().groupgetId(),
      );

      if (response['statusCode'] == 200) {
        setState(() {
          dataList = List<Map<String, dynamic>>.from(response['data']);
        });
        _filterRecipesByDate(selectedDate);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Group id Not Found'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterRecipesByDate(DateTime selectedDate) {
    setState(() {
      filteredRecipes = dataList.where((recipe) {
        final createdAt = DateTime.parse(recipe["created_at"]);
        return createdAt.year == selectedDate.year &&
            createdAt.month == selectedDate.month &&
            createdAt.day == selectedDate.day;
      }).toList();
    });
    filterRecipesBySingleCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      drawer: const DrawerMenu(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF1A1A1A), Colors.black],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Modern Header
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFC2D86A).withValues(alpha: 0.2),
                                const Color(0xFFC2D86A).withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Color(0xFFC2D86A),
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Diet History",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Track your nutrition journey",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _scaffoldKey.currentState?.openDrawer();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFC2D86A), Color(0xFFD4E87C)],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFC2D86A,
                                ).withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(3),
                          child: const CircleAvatar(
                            radius: 22,
                            backgroundImage: AssetImage(
                              "assets/user_avatar.png",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Time Filter Buttons
                          SizedBox(
                            height: 50,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: timeFilters.length,
                              itemBuilder: (context, index) {
                                var filter = timeFilters[index];
                                bool isActive = index == selectedTimeIndex;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedTimeIndex = index;
                                      if (filter["name"] == "Today") {
                                        isCalender = false;
                                        _filterRecipesByDate(selectedDate);
                                      } else if (filter["name"] == "Calendar") {
                                        isCalender = true;
                                      } else {
                                        isCalender = false;
                                      }
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.only(right: 12),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: isActive
                                          ? const LinearGradient(
                                              colors: [
                                                Color(0xFFC2D86A),
                                                Color(0xFFD4E87C),
                                              ],
                                            )
                                          : LinearGradient(
                                              colors: [
                                                const Color(
                                                  0xFF2A2A2A,
                                                ).withValues(alpha: 0.8),
                                                const Color(
                                                  0xFF1A1A1A,
                                                ).withValues(alpha: 0.8),
                                              ],
                                            ),
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: isActive
                                            ? const Color(0xFFC2D86A)
                                            : const Color(
                                                0xFFC2D86A,
                                              ).withValues(alpha: 0.3),
                                        width: 1,
                                      ),
                                      boxShadow: isActive
                                          ? [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFFC2D86A,
                                                ).withValues(alpha: 0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          filter["icon"] as IconData,
                                          color: isActive
                                              ? const Color(0xFF121212)
                                              : const Color(0xFFC2D86A),
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          filter["name"] as String,
                                          style: TextStyle(
                                            color: isActive
                                                ? const Color(0xFF121212)
                                                : Colors.white,
                                            fontWeight: isActive
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Calendar Widget
                          if (isCalender)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(
                                      0xFF2A2A2A,
                                    ).withValues(alpha: 0.8),
                                    const Color(
                                      0xFF1A1A1A,
                                    ).withValues(alpha: 0.8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(
                                    0xFFC2D86A,
                                  ).withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 0,
                                  bottom: 15,
                                  left: 10,
                                  right: 10,
                                ),
                                child: EasyDateTimeLine(
                                  activeColor: const Color(0xFFC2D86A),
                                  initialDate: DateTime(2024, 10, 15),
                                  onDateChange: (selectedDate) {
                                    setState(() {
                                      _filterRecipesByDate(selectedDate);
                                    });
                                  },
                                  headerProps: const EasyHeaderProps(
                                    monthPickerType: MonthPickerType.switcher,
                                    dateFormatter: DateFormatter.monthOnly(),
                                    selectedDateStyle: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  dayProps: EasyDayProps(
                                    height: 70,
                                    dayStructure: DayStructure.dayStrDayNum,
                                    todayStyle: const DayStyle(
                                      dayNumStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    inactiveDayStyle: const DayStyle(
                                      dayNumStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    disabledDayStyle: const DayStyle(
                                      dayNumStyle: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    borderColor: const Color(0xFFC2D86A),
                                    activeDayStyle: const DayStyle(
                                      dayNumStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        color: Color(0xFFC2D86A),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          if (isCalender) const SizedBox(height: 20),

                          // Body Status Card
                          _buildModernStatsCard(
                            title: 'Body Status And Goal',
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildBodyMetric(
                                    label: 'Target Weight',
                                    value: '75 kg',
                                    currentLabel: 'Body Weight',
                                    currentValue: '94 kg',
                                    currentColor: const Color(0xFFF57552),
                                    icon: 'assets/weight.png',
                                  ),
                                ),
                                Container(
                                  height: 100,
                                  width: 1,
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                                Expanded(
                                  child: _buildBodyMetric(
                                    label: 'Target Fat%',
                                    value: '30%',
                                    currentLabel: 'Fat Percentage',
                                    currentValue: '44%',
                                    currentColor: const Color(0xFFF5D657),
                                    icon: 'assets/fat.png',
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Live Stats Card
                          _buildModernStatsCard(
                            title: 'Live Stats',
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildNutrientStat(
                                  current: '60',
                                  target: '150',
                                  label: 'Proteins',
                                  color: const Color(0xFFF57552),
                                ),
                                Container(
                                  height: 50,
                                  width: 1,
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                                _buildNutrientStat(
                                  current: '120',
                                  target: '200',
                                  label: 'Carbs',
                                  color: const Color(0xFFF5D657),
                                ),
                                Container(
                                  height: 50,
                                  width: 1,
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                                _buildNutrientStat(
                                  current: '35',
                                  target: '65',
                                  label: 'Fats',
                                  color: const Color(0xFFD0B4F9),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Category Filter Buttons
                          SizedBox(
                            height: 50,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: categories.length,
                              itemBuilder: (context, index) {
                                var cat = categories[index];
                                bool isActive = index == selectedCategoryIndex;
                                IconData icon = index == 0
                                    ? Icons.breakfast_dining
                                    : index == 1
                                    ? Icons.lunch_dining
                                    : index == 2
                                    ? Icons.dinner_dining
                                    : Icons.food_bank;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCategoryIndex = index;
                                      category = cat["label_name"].toString();
                                    });
                                    filterRecipesBySingleCategory(
                                      cat["label_name"].toString(),
                                    );
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.only(right: 12),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: isActive
                                          ? const LinearGradient(
                                              colors: [
                                                Color(0xFFC2D86A),
                                                Color(0xFFD4E87C),
                                              ],
                                            )
                                          : LinearGradient(
                                              colors: [
                                                const Color(
                                                  0xFF2A2A2A,
                                                ).withValues(alpha: 0.8),
                                                const Color(
                                                  0xFF1A1A1A,
                                                ).withValues(alpha: 0.8),
                                              ],
                                            ),
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: isActive
                                            ? const Color(0xFFC2D86A)
                                            : const Color(
                                                0xFFC2D86A,
                                              ).withValues(alpha: 0.3),
                                        width: 1,
                                      ),
                                      boxShadow: isActive
                                          ? [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFFC2D86A,
                                                ).withValues(alpha: 0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          icon,
                                          color: isActive
                                              ? const Color(0xFF121212)
                                              : const Color(0xFFC2D86A),
                                          size: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          cat["label_name"].toString(),
                                          style: TextStyle(
                                            color: isActive
                                                ? const Color(0xFF121212)
                                                : Colors.white,
                                            fontWeight: isActive
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Meals List
                          isLoading
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(32.0),
                                    child: CircularProgressIndicator(
                                      color: Color(0xFFC2D86A),
                                    ),
                                  ),
                                )
                              : recipesCotegory.isEmpty
                              ? Center(
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        'assets/no_diet.png',
                                        height: 250,
                                        width: 250,
                                        fit: BoxFit.cover,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No meals found',
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: recipesCotegory.length,
                                  itemBuilder: (context, index) {
                                    var data = recipesCotegory[index];
                                    return _buildModernMealCard(data, index);
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernStatsCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFC2D86A).withValues(alpha: 0.15),
            const Color(0xFFC2D86A).withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildBodyMetric({
    required String label,
    required String value,
    required String currentLabel,
    required String currentValue,
    required Color currentColor,
    required String icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Image.asset(icon, height: 40),
              const SizedBox(width: 8),
              Text(
                currentValue,
                style: TextStyle(
                  color: currentColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            currentLabel,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientStat({
    required String current,
    required String target,
    required String label,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              current,
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '/$target',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildModernMealCard(Map<String, dynamic> data, int index) {
    List<List<Color>> gradients = [
      [const Color(0xFF2A2A2A), const Color(0xFF1A1A1A)],
      [const Color(0xFF2D2D2D), const Color(0xFF1D1D1D)],
      [const Color(0xFF252525), const Color(0xFF151515)],
    ];

    List<Color> cardGradient = gradients[index % gradients.length];

    return GestureDetector(
      onTap: () {
        GetStorage().write("mealdetails", data);
        Get.toNamed('/meals-details?id=${widget.id}');
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: cardGradient,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFC2D86A).withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Subtle pattern overlay
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFC2D86A).withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Meal Icon
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      color: Colors.black,
                      size: 35,
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Meal Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data["name"] ?? "Not Found",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.orange.withValues(alpha: 0.2),
                                    Colors.orange.withValues(alpha: 0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.local_fire_department,
                                color: Colors.orange,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${data["kcal"] ?? "0"} Kcal',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              '• 80g',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Nutritional Info
                        Row(
                          children: [
                            _buildModernNutrientBar(
                              '${data["protein"] ?? "0"}g',
                              'Protein',
                              Colors.green,
                            ),
                            const SizedBox(width: 12),
                            _buildModernNutrientBar(
                              '${data["fat"] ?? "0"}g',
                              'Fat',
                              Colors.blue,
                            ),
                            const SizedBox(width: 12),
                            _buildModernNutrientBar(
                              '${data["carbs"] ?? "0"}g',
                              'Carbs',
                              Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // More Options
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.more_horiz,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernNutrientBar(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
