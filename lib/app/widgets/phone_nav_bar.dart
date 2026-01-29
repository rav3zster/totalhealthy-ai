import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/base/constants/appcolor.dart';
import '../core/base/controllers/auth_controller.dart';
import '../routes/app_pages.dart';
// ignore_for_file: prefer_const_constructors

class MobileNavBar extends StatefulWidget {
  const MobileNavBar({
    super.key,
  });

  @override
  State<MobileNavBar> createState() => _MobileNavBarState();
}

class OntapStore {
  static var index = 0;
  static List<String> routes = [
    Routes.ClientDashboard,
    Routes.GROUP, // Chat functionality can be added later
    Routes.MEAL_HISTORY, // Meal screen
    Routes.PROFILE_MAIN, // Profile main screen
  ];
}

class _MobileNavBarState extends State<MobileNavBar> {
  ontapFunction(int value) {
    Get.offAllNamed(value == 0
        ? Get.find<AuthController>().roleGet() == "admin"
            ? Routes.TrainerDashboard
            : OntapStore.routes[value]
        : OntapStore.routes[value]);

    setState(() {
      OntapStore.index = value;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A), // Darker background to match the image
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            index: 0,
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            label: "Home",
            isSelected: OntapStore.index == 0,
          ),
          _buildNavItem(
            index: 1,
            icon: Icons.timeline_outlined,
            selectedIcon: Icons.timeline,
            label: "Tracking",
            isSelected: OntapStore.index == 1,
          ),
          _buildNavItem(
            index: 2,
            icon: Icons.restaurant_outlined,
            selectedIcon: Icons.restaurant,
            label: "Recipe",
            isSelected: OntapStore.index == 2,
          ),
          _buildNavItem(
            index: 3,
            icon: Icons.person_outline,
            selectedIcon: Icons.person,
            label: "Profile",
            isSelected: OntapStore.index == 3,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => ontapFunction(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              size: 24,
              color: isSelected ? Color(0xFFC2D86A) : Colors.white54,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Color(0xFFC2D86A) : Colors.white54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//
// class ButtomNav extends StatefulWidget {
//   const ButtomNav({
//     super.key,
//   });
//   @override
//   State<ButtomNav> createState() => _ButtomNavState();
// }
//
// class _ButtomNavState extends State<ButtomNav> {
//   var index = 0;
//
//   ontapFunction(int value) {
//     setState(() {
//       index = value;
//     });
//
//     Get.toNamed(
//       routes[value],
//     );
//   }
//
//   List<String> routes = [
//     Routes.HOME,
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: ThemeData(
//         canvasColor: Colors.green,
//       ),
//       child: BottomNavigationBar(
//         iconSize: 20,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Users',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Customers',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: 'Orders',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//         currentIndex: index,
//         onTap: (value) => ontapFunction(value),
//       ),
//     );
//   }
//
//   int chnageIndex(int index) {
//     var i = 0;
//     i = index;
//     return i;
//   }
// }
