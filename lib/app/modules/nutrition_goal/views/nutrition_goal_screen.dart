import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/widgets/baseWidget.dart';
import '../../../routes/app_pages.dart';

class NutritionGoalsScreen extends StatefulWidget {
  @override
  _NutritionGoalsScreenState createState() => _NutritionGoalsScreenState();
}

class _NutritionGoalsScreenState extends State<NutritionGoalsScreen> {
  final PageController _pageController = PageController();
  int currentPageIndex = 0;

  // Sample data for the screens
  final List<List<String>> goals = [
    [
      "Weight loss",
      "Muscle gain",
      "Maintaining current weight",
      "Improved overall health"
    ],
    ["Increase energy", "Reduce sugar", "Detox diet", "Gluten-free diet"],
    [
      "Improve mental focus",
      "Enhance skin health",
      "Boost immunity",
      "Vegan diet"
    ],
    [
      "Manage diabetes",
      "Lower cholesterol",
      "Improve digestion",
      "Balanced diet"
    ],
  ];

  // List to keep track of selected indexes for each page
  List<int> selectedIndexes = List.filled(4, -1);

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      backButton: true,
      appBarAction: [
        TextButton(
          onPressed: () {
            if (currentPageIndex < goals.length - 1) {
              _pageController.nextPage(
                  duration: Duration(milliseconds: 500), curve: Curves.easeIn);
            }
          },
          child: Text('Skip',
              style: TextStyle(color: Color(0XFFFFFFFF), fontSize: 16)),
        )
      ],
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        itemCount: goals.length,
        itemBuilder: (context, pageIndex) {
          return Column(
            children: [
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "What goal are you pursuing with your nutrition?",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Choose a more suitable option.",
                      style: TextStyle(
                          color: Color(0XFFCDE26D),
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: goals[pageIndex].length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndexes[pageIndex] = index;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Color(0XFF333333),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectedIndexes[pageIndex] == index
                                ? Color(0XFFCDE26D)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          goals[pageIndex][index],
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XFFCDE26D),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    // Continue button action
                    if (pageIndex < goals.length - 1) {
                      _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    } else {
                      // Last page pe ho toh Home pe navigate kar do
                      Get.toNamed(Routes.HOME);
                    }
                  },
                  child: Text("Continue",
                      style: TextStyle(color: Color(0XFF242522), fontSize: 18)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}