import 'package:flutter/material.dart';

class BaseDesktopView extends StatelessWidget {
  BaseDesktopView({super.key, required this.vBuilderDesktop});
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
