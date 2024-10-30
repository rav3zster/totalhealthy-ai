import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/meals_details_controller.dart';
import '../widgets/meals_details_page.dart';

class MealsDetailsScreen extends GetView<MealsDetailsController> {
  const MealsDetailsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MealsDetailsPage();
  }
}
