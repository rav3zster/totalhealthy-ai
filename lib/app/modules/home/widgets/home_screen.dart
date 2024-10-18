import 'package:flutter/material.dart';
import 'package:totalhealthy/app/widgets/base_screen.dart';

import '../../../widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      heading: "Home",
      isDrawer: true,
      child: Column(
        children: [
          Center(
            child: Text("Home Is Working"),
          ),
          CustomButton(
            size: ButtonSize.medium,
            child: Text("Use  Only Custom Button or AppColors"),
            onPressed: () {},
            type: ButtonType.elevated,
          ),
        ],
      ),
    );
  }
}
