import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/base/constants/appcolor.dart';
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
    Routes.GROUP,
    Routes.NOTIFICATION,
    Routes.Registration,
  ];
}

class _MobileNavBarState extends State<MobileNavBar> {
  ontapFunction(int value) {
    Get.toNamed(OntapStore.routes[value]);

    setState(() {
      OntapStore.index = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Theme(
        data: ThemeData(
          navigationBarTheme: NavigationBarThemeData(
            backgroundColor: AppColors.cardbackground,
            indicatorColor: Colors.transparent,
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Circular shape
            ),
            labelTextStyle: MaterialStateProperty.resolveWith<TextStyle?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return TextStyle(
                    color: Color(0XFF808B4D),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  );
                }
                return TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ); // Default style for unselected
              },
            ),
          ),
        ),
        child: NavigationBar(
          surfaceTintColor: Colors.black,
          height: 65,
          selectedIndex: OntapStore.index,
          onDestinationSelected: (value) => ontapFunction(value),
          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.person_outlined,
                color: Colors.white,
              ),
              selectedIcon: Icon(
                Icons.person,
                color: Color(0xFFCDE26D),
              ),
              label: "User",
            ),
            NavigationDestination(
              icon: Icon(
                Icons.group_outlined,
                color: Colors.white,
              ),
              selectedIcon: Icon(
                Icons.group,
                color: Color(0xFFCDE26D),
              ),
              label: "Group",
            ),
            NavigationDestination(
              icon: Icon(
                Icons.notifications_outlined,
                color: Colors.white,
              ),
              selectedIcon: Icon(
                Icons.notifications,
                color: Color(0xFFCDE26D),
              ),
              label: "Notification",
            ),
            NavigationDestination(
              icon: Icon(
                Icons.settings_outlined,
                color: Colors.white,
              ),
              selectedIcon: Icon(
                Icons.settings,
                color: Color(0xFFCDE26D),
              ),
              label: "Setting",
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
