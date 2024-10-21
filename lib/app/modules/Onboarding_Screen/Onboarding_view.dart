import 'package:flutter/material.dart';
import 'package:totalhealthy/app/modules/Registration_Screen/Registration_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _onDotTapped(int index) {
    _pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _goToNextPage() {
    if (_currentPage < 2) {
      // Assuming there are 3 pages (index 0, 1, 2)
      _pageController.animateToPage(_currentPage + 1,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: [
                  Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            _buildPageContent(
                              "assets/Group.png",
                              "Welcome to TotalHealthy",
                              "Your all-in-one health and fitness app.",
                            ),
                            SizedBox(height: 3),
                            Container(
                              child: Text(
                                "Get personalized plans and track your",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white54,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            SizedBox(height: 3),
                            Container(
                              child: Text(
                                "progress to achieve your goals.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white54,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: Column(
                      children: [
                        _buildPageContent(
                          "assets/Second.png",
                          "Personalized Diet Plans",
                          "Receive custom diet plans tailored to",
                        ),
                        Container(
                          child: Text(
                            "your goals. Whether it's weight loss or",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white54,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            "fitness, we've got you covered.",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white54,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        _buildPageContent(
                          "assets/Third.png",
                          "Track Your Progress",
                          "Monitor your daily progress and view",
                        ),
                        Container(
                          child: Text(
                            "detailed results. Stay motivated and",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white54,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            "reach your fitness milestones.",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white54,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 0),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return GestureDetector(
                      onTap: () => _onDotTapped(index),
                      child: DotIndicator(isActive: _currentPage == index),
                    );
                  }),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(left: 20, top: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Implement skip functionality if needed
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegistrationView(),
                                ));
                          },
                          child: Text(
                            "Skip",
                            style: TextStyle(
                              color: Colors.lightGreenAccent,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          onTap: _goToNextPage,
                          child: Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.lightGreenAccent,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(String imagePath, String title, String subtitle) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 120),
          height: 400,
          width: 450,
          child: Image.asset(imagePath, fit: BoxFit.fitWidth),
        ),
        SizedBox(height: 20),
        Container(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 32,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          child: Text(
            subtitle,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white54,
              fontSize: 22,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class DotIndicator extends StatelessWidget {
  final bool isActive;

  const DotIndicator({Key? key, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5),
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            color: isActive ? Colors.lightGreenAccent : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
