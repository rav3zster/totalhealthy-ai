import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/widgets/phone_nav_bar.dart';
import '../core/base/constants/appcolor.dart';
import 'back_button.dart';
import 'drawer_menu.dart';

class BaseWidget extends StatefulWidget {
  const BaseWidget({
    super.key,
    this.title = "",
    this.body,
    this.isNav = true,
    this.isDrawer = true,
    this.backButton = false,
    this.istopBar = false,
    this.isAppBar = true,
    this.isGradient = false,
    this.titlestyle = const TextStyle(color: AppColors.white, fontSize: 18),
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
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                child: AppBar(
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
                          icon: Icon(Icons.menu),
                        )
                      : null,
                  backgroundColor: AppColors.cardbackground,
                  title:
                      widget.titleWidget ??
                      Text(widget.title, style: widget.titlestyle),
                ),
              ),
            )
          : null,
      drawer: widget.isDrawer ? DrawerMenu() : null,
      body: Column(
        children: [
          if (widget.istopBar)
            Container(
              decoration: BoxDecoration(
                color: Color(0xff0B8FAC),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40),
                  bottomLeft: Radius.circular(40),
                ),
              ),
              height: widget.topBarHeight,
              child: widget.widget,
            ),
          // No `Expanded` here, as it causes issues inside `SingleChildScrollView`
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: widget.body!,
            ),
          ),
        ],
      ),
      bottomNavigationBar: MobileNavBar(),
    );
  }
}

class OnTap {
  static int selectIndex = 0;
}

class DialogUtils {
  static void showConfirmationDialog1(
    String message,
    dynamic datades, {
    Color? popColor,
  }) {
    Color textColor = popColor ?? Colors.blue;

    Get.dialog(
      AlertDialog(
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
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
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
                      backgroundColor: WidgetStateProperty.all<Color>(
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
      ),
    );
  }
}

class Snackbar {
  static void showErrorSnackBar({String title = "", String message = ""}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color(0x8AD32F2F),
      barBlur: 10.0,
      snackPosition: SnackPosition.BOTTOM,
      colorText: Colors.white,
      margin: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.error, color: Colors.white),
    );
  }
}
