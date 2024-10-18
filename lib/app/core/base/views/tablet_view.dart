import 'package:flutter/material.dart';

class BaseTabletView extends StatelessWidget {
  const BaseTabletView({Key? key, required this.vBuilderTablet})
      : super(key: key);
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
