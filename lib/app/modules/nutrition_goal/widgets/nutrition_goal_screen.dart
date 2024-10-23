import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NutritionGoalsScreen extends StatefulWidget {
  @override
  _NutritionGoalsScreenState createState() => _NutritionGoalsScreenState();
}

class _NutritionGoalsScreenState extends State<NutritionGoalsScreen> {
  int selectedIndex = -1;
  final PageController _pageController = PageController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {}, // Skip action
            child: Text('Skip', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
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
                      style: TextStyle(color: Colors.greenAccent, fontSize: 16),
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
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: selectedIndex == index
                              ? Colors.greenAccent.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selectedIndex == index
                                ? Colors.greenAccent
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
                    backgroundColor: Colors.greenAccent, // Replaces `primary`
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    // Continue button action
                    if (pageIndex < goals.length - 1) {
                      _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    } else {
                      // Final action on last page
                    }
                  },
                  child: Text("Continue",
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
