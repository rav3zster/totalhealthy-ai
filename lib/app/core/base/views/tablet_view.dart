import 'package:flutter/material.dart';

class BaseTabletView extends StatelessWidget {
  const BaseTabletView({super.key, required this.vBuilderTablet});
  final Widget vBuilderTablet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Flexible(
              child: Column(
            children: [
              //  _TabletAppBar(actions: controller.actions[ResponsiveTypeEnum.studentDesktop],),
              Expanded(child: vBuilderTablet),
            ],
          )),
        ],
      ),
    );
  }
}
