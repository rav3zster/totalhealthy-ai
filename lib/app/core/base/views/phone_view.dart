import 'package:flutter/material.dart';

class BaseMobileView extends StatelessWidget {
  BaseMobileView({Key? key, required this.vBuilderMobile}) : super(key: key);
  final Widget vBuilderMobile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: vBuilderMobile,
    );
  }
}
