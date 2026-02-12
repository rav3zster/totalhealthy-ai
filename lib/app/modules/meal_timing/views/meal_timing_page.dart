import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/controllers/user_controller.dart';
import 'package:totalhealthy/app/modules/meal_timing/controllers/meal_timing_controller.dart';
import 'package:totalhealthy/app/widgets/drawer_menu.dart';

class MealTimingPage extends StatefulWidget {
  const MealTimingPage({super.key, required this.id, required this.controller});

  final MealTimingController controller;
  final String id;

  @override
  _MealTimingPageState createState() => _MealTimingPageState();
}

class _MealTimingPageState extends State<MealTimingPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? expandedIndex;
  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    widget.controller.getMeal(context, widget.id);
  }

  void _onToggleMeal(int index, bool value) {
    setState(() {
      widget.controller.dataList[index]['enabled'] = value;
    });
    // In a real app, you'd save this to the backend/local storage
  }

  void _onTimeChanged(int index, DateTime dateTime) {
    final format = TimeOfDay.fromDateTime(dateTime).format(context);
    setState(() {
      widget.controller.dataList[index]['time_range'] = format;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const DrawerMenu(),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _scaffoldKey.currentState?.openDrawer(),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.grey[800],
                            backgroundImage: UserController.getImageProvider(
                              userController.profileImage,
                            ),
                            child: userController.profileImage.isEmpty
                                ? const Icon(
                                    Icons.person,
                                    color: Colors.white24,
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Welcome!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                userController.fullName,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.notifications_none_rounded,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Set Your Daily Meal & Snack Timings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Choose Suitable Times For Your Meals, Snacks, And Workout Nutrition.',
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                    const SizedBox(height: 24),

                    // Meal List
                    Obx(() {
                      if (widget.controller.getLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xffCDE26D),
                          ),
                        );
                      }
                      if (widget.controller.dataList.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Text(
                              "No meal timings found",
                              style: TextStyle(color: Colors.white54),
                            ),
                          ),
                        );
                      }

                      return Column(
                        children: List.generate(
                          widget.controller.dataList.length,
                          (index) {
                            final data = widget.controller.dataList[index];
                            final isExpanded = expandedIndex == index;
                            final isEnabled = data['enabled'] ?? false;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        expandedIndex = isExpanded
                                            ? null
                                            : index;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1A1A1A),
                                        borderRadius: BorderRadius.circular(16),
                                        border: isExpanded
                                            ? Border.all(
                                                color: const Color(
                                                  0xffCDE26D,
                                                ).withOpacity(0.3),
                                              )
                                            : null,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  data['label_name'] ?? "",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  data['time_range'] ?? "--:--",
                                                  style: TextStyle(
                                                    color: isEnabled
                                                        ? const Color(
                                                            0xffCDE26D,
                                                          )
                                                        : Colors.white38,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          CupertinoSwitch(
                                            activeColor: const Color(
                                              0xffCDE26D,
                                            ),
                                            value: isEnabled,
                                            onChanged: (val) =>
                                                _onToggleMeal(index, val),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (isExpanded) ...[
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1A1A1A),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: CupertinoTheme(
                                              data: const CupertinoThemeData(
                                                brightness: Brightness.dark,
                                                textTheme:
                                                    CupertinoTextThemeData(
                                                      dateTimePickerTextStyle:
                                                          TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 18,
                                                          ),
                                                    ),
                                              ),
                                              child: CupertinoDatePicker(
                                                mode: CupertinoDatePickerMode
                                                    .time,
                                                initialDateTime: DateTime.now(),
                                                onDateTimeChanged: (dt) =>
                                                    _onTimeChanged(index, dt),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: const Color(0xffCDE26D),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    expandedIndex = null;
                                                  });
                                                },
                                                child: const Text(
                                                  "Done",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Bottom Continue Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: Obx(() {
                final isSaving = widget.controller.isLoading.value;
                return Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xffCDE26D),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xffCDE26D).withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: isSaving
                        ? null
                        : () =>
                              widget.controller.saveChanges(context, widget.id),
                    child: isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
