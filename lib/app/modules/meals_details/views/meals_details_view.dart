import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../core/base/views/base_view.dart';
import '../../meal_history/views/meal_history_screen.dart';
import 'meals_details_screen.dart';

class MealsDetailsView extends BaseView {
  MealsDetailsView({super.key});

  @override
  Widget vBuilderTablet() {
    return const MealsDetailsScreen();
  }

  @override
  Widget vBuilderDesktop() {
    return const MealsDetailsScreen();
  }

  @override
  Widget vBuilderPhone() {
    return const MealsDetailsScreen();
  }
}
