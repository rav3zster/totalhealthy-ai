import 'package:flutter/material.dart';

class BaseDesktopView extends StatelessWidget {
  BaseDesktopView({Key? key, required this.vBuilderDesktop}) : super(key: key);
  final Widget vBuilderDesktop;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: vBuilderDesktop,
    );
  }
}
