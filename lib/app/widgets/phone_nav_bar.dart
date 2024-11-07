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
    // ignore: prefer_const_literals_to_create_immutables
    return Theme(
      data: ThemeData(
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return TextStyle(
                    color: AppColors.chineseGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 12);
              }
              return TextStyle(
                  color: Colors.white,
                  fontSize: 12); // Default style for unselected
            },
          ),
        ),
      ),
      child: NavigationBar(
          backgroundColor: AppColors.cardbackground,
          surfaceTintColor: Colors.black,
          indicatorColor: AppColors.chineseGreen,
          height: 60,
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
                  color: Colors.black,
                ),
                label: "User"),
            NavigationDestination(
                icon: Icon(
                  Icons.group_outlined,
                  color: Colors.white,
                ),
                selectedIcon: Icon(
                  Icons.group,
                  color: Colors.black,
                ),
                label: "Group"),
            NavigationDestination(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                ),
                selectedIcon: Icon(
                  Icons.notifications,
                  color: Colors.black,
                ),
                label: "Notification"),
            NavigationDestination(
                icon: Icon(
                  Icons.settings_outlined,
                  color: Colors.white,
                ),
                selectedIcon: Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                label: "Setting"),
          ]),
    );
  }
}

class ButtomNav extends StatefulWidget {
  const ButtomNav({
    super.key,
  });
  @override
  State<ButtomNav> createState() => _ButtomNavState();
}

class _ButtomNavState extends State<ButtomNav> {
  var index = 0;

  ontapFunction(int value) {
    setState(() {
      index = value;
    });

    Get.toNamed(
      routes[value],
    );
  }

  List<String> routes = [
    Routes.HOME,
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        canvasColor: Colors.green,
      ),
      child: BottomNavigationBar(
        iconSize: 20,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Customers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: index,
        onTap: (value) => ontapFunction(value),
      ),
    );
  }

  int chnageIndex(int index) {
    var i = 0;
    i = index;
    return i;
  }
}
