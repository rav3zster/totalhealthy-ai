import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/widgets/phone_nav_bar.dart';
import '../core/base/constants/appcolor.dart';
import 'backButton.dart';
import 'customDrawer.dart';

import 'drawer_menu.dart';

class BaseWidget extends StatefulWidget {
  BaseWidget({
    this.title = "",
    this.body,
    this.isNav = true,
    this.isDrawer = true,
    this.backButton = false,
    this.istopBar = false,
    this.isAppBar = true,
    this.isGradient = false,
    this.titlestyle = const TextStyle(color: AppColors.grey, fontSize: 18),
    this.centerTitle = false,
    this.widget,
    this.topBarHeight = 60,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.titleWidget,
    this.appBarAction,
  });

  final String title;
  final bool istopBar;
  final Widget? body;
  final Widget? widget;
  final bool isNav;
  final bool backButton;
  final bool isAppBar;
  final bool centerTitle;
  final Widget? floatingActionButton;
  final bool isDrawer;
  final double topBarHeight;
  final bool isGradient;
  final TextStyle titlestyle;
  final List<Widget>? appBarAction;
  final Widget? titleWidget;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  State<BaseWidget> createState() => _BaseWidgetState();
}

class _BaseWidgetState extends State<BaseWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      floatingActionButton: widget.floatingActionButton,
      appBar: widget.isAppBar
          ? PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Stack(
          children: [
            // Gradient layer for AppBar
            if (widget.isGradient)
              Positioned(
                top: -50,
                left: -100,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color(0xffA8E6FF),
                        Color(0xffA8E6FF).withOpacity(0.0),
                      ],
                      radius: 0.5,
                      focalRadius: 0.7,
                    ),
                  ),
                ),
              ),
            AppBar(
              actions: widget.appBarAction,
              automaticallyImplyLeading: false,
              elevation: 0.0,
              centerTitle: widget.centerTitle,
              leading: widget.backButton
                  ? CustomBackButton()
                  : widget.isDrawer
                  ? IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                  icon: Icon(Icons.menu))
                  : null,
              backgroundColor:
              Colors.transparent, // Make AppBar transparent
              title: widget.titleWidget ??
                  Text(
                    widget.title,
                    style: widget.titlestyle,
                  ),
            ),
          ],
        ),
      )
          : null,
      drawer: widget.isDrawer ? DrawerMenu() : null,
      body: Column(
        children: [
          Container(),
          if (widget.istopBar)
            Container(
              decoration: BoxDecoration(
                  color: Color(0xff0B8FAC),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(40),
                      bottomLeft: Radius.circular(40))),
              child: widget.widget,
              height: widget.topBarHeight,
            ),
          Expanded(
            child: Stack(
              children: [
                if (widget.isGradient) ...[
                  Positioned(
                    top: -100,
                    left: -100,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Color(0xffA8E6FF),
                            Color(0xffA8E6FF).withOpacity(0.0),
                          ],
                          radius: 0.5,
                          focalRadius: 0.7,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -100,
                    right: -100,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Color(0xffA8E6FF),
                            Color(0xffA8E6FF).withOpacity(0.0),
                          ],
                          radius: 0.5,
                          focalRadius: 0.7,
                        ),
                      ),
                    ),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: widget.body!,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar:
      // widget.isNav
      //     ? BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   onTap: (value) {
      //     if (value == 0) {
      //       Get.toNamed(Routes.APPOINTMENT_DESHBORD);
      //     } else if (value == 1) {
      //       Get.toNamed(Routes.WALK_IN_APPOINTMENT);
      //     } else if (value == 2) {
      //       Get.toNamed(Routes.APPOINTMENT_MANAGEMENT);
      //     } else if (value == 3) {
      //       Get.toNamed(Routes.EMPLOYEE);
      //     } else if (value == 4) {
      //       Get.toNamed(Routes.PAYMENT_HISTORY);
      //     }
      //     setState(() {
      //       OnTap.selectIndex = value;
      //     });
      //   },
      //   currentIndex: OnTap.selectIndex,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.schedule),
      //       label: 'Schedule',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.directions_walk),
      //       label: 'Walk-In',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.add_box_rounded),
      //       label: 'Add',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.people),
      //       label: 'Employees',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.account_balance_wallet),
      //       label: 'Finance',
      //     ),
      //   ],
      // )
      //     : null
      MobileNavBar(),
    );
  }
}

class OnTap {
  static int selectIndex = 0;
}

class DialogUtils {
  static void showConfirmationDialog1(String message, dynamic datades,
      {Color? popColor}) {
    Color textColor = popColor ?? Colors.blue;

    Get.dialog(AlertDialog(
      contentPadding: const EdgeInsets.all(20),
      scrollable: true,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      elevation: 0,
      backgroundColor: Colors.white,
      // Replace AppColors.background if not accessible
      actionsAlignment: MainAxisAlignment.center,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
      content: SizedBox(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    datades.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      textColor,
                    ),
                  ),
                  child: const Text(
                    "Ok",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}

class Snackbar {
  static void showErrorSnackBar({String title = "", String message = ""}) {
    Get.snackbar(title, message,
        backgroundColor: const Color(0x8AD32F2F),
        barBlur: 10.0,
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        margin: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.error, color: Colors.white));
  }
}
