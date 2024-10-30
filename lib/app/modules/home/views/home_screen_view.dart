import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../widgets/home_screen.dart';

class HomeScreenView extends GetView<HomeController> {
  const HomeScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
