import 'package:flutter/material.dart';

class BaseMobileView extends StatelessWidget {
  const BaseMobileView({super.key, required this.vBuilderMobile});
  final Widget vBuilderMobile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: vBuilderMobile,
    );
  }
}
