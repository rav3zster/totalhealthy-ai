import '../core/base/constants/appcolor.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'drawer_menu.dart';
import 'phone_nav_bar.dart';

class BaseScreen extends StatefulWidget {
  BaseScreen({
    super.key,
    required this.child,
    this.isDrawer = true,
    this.isfloaingbutton = true,
    this.istheme = true,
    required this.heading,
    this.isBottomNavbar = false,
    this.backgroundheight = 80,
    this.floatingActionButton,
    this.backgroundColor = AppColors.pageBackground,
  });
  final Widget child;
  double backgroundheight;

  final Widget? floatingActionButton;
  final bool isDrawer;
  final bool? isBottomNavbar;
  final bool istheme;
  final String heading;
  final bool isfloaingbutton;
  final Color backgroundColor;

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to exit the app?'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Close the dialog
                  _exitApp(); // Call the exit function
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _exitApp() {
    SystemNavigator.pop(); // This will close the app
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar:
            widget.isBottomNavbar == true ? const MobileNavBar() : null,
        backgroundColor: widget.backgroundColor,
        floatingActionButton:
            widget.isfloaingbutton ? widget.floatingActionButton : null,
        drawer: widget.isDrawer ? const DrawerMenu() : null,
        body: widget.istheme
            ? Stack(
                children: [
                  Container(
                    constraints:
                        BoxConstraints(maxHeight: widget.backgroundheight),
                    decoration: const BoxDecoration(color: Colors.blue
                        // gradient: LinearGradient(
                        //     begin: Alignment.topLeft,
                        //     end: Alignment.bottomRight,
                        //     colors: [Colors.grey, Colors.blue]),
                        ),
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.isDrawer == false
                                ? InkWell(
                                    onTap: () {
                                      // Get.back();
                                      Navigator.pop(context);
                                      // _scaffoldKey.currentState?.openDrawer();
                                    },
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      _scaffoldKey.currentState?.openDrawer();
                                    },
                                    child: const Icon(
                                      Icons.menu,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                  ),
                            Text(
                              widget.heading,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            // Image.asset('assets/Ellipse 2149.png',
                            //     width: 30, height: 50)
                          ],
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 90),
                      Expanded(child: widget.child),
                    ],
                  ),
                ],
              )
            : Column(
                children: [
                  const SizedBox(height: 200),
                  Expanded(child: widget.child),
                ],
              ),
      ),
    );
  }
}
