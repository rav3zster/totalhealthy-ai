import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    Routes.HOME,
  ];
}

class _MobileNavBarState extends State<MobileNavBar> {
  ontapFunction(int value) {
    Get.offAllNamed(OntapStore.routes[value]);

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
                    color: Colors.pink.shade400,
                    fontWeight: FontWeight.bold,
                    fontSize: 12);
              }
              return TextStyle(
                  color: Colors.grey,
                  fontSize: 12); // Default style for unselected
            },
          ),
        ),
      ),
      child: NavigationBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          indicatorColor: Colors.pink.shade300,
          height: 50,
          selectedIndex: OntapStore.index,
          onDestinationSelected: (value) => ontapFunction(value),
          destinations: const [
            NavigationDestination(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                ),
                selectedIcon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                label: "HOME"),
            NavigationDestination(
                icon: Icon(
                  Icons.person_outlined,
                ),
                selectedIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                label: "FOOD DETAILS"),
            NavigationDestination(
                icon: Icon(
                  Icons.group_outlined,
                ),
                selectedIcon: Icon(
                  Icons.group,
                  color: Colors.white,
                ),
                label: "Customer"),
            NavigationDestination(
                icon: Icon(
                  Icons.shopping_bag_outlined,
                ),
                selectedIcon: Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                ),
                label: "Product"),

            // NavigationDestination(
            //     icon: Icon(
            //       Icons.settings_outlined,
            //     ),
            //     selectedIcon: Icon(
            //       Icons.settings,
            //       color: Colors.white,
            //     ),
            //     label: "Setting"),
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
