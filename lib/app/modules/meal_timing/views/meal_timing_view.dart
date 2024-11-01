import 'package:flutter/material.dart';

import '../../../core/base/views/base_view.dart';

import 'meal_timing_screen.dart';

class MealTimingView extends BaseView {
  MealTimingView({super.key});

  @override
  Widget vBuilderTablet() {
    return  MealTimingScreen();
  }

  @override
  Widget vBuilderDesktop() {
    return  MealTimingScreen();
  }

  @override
  Widget vBuilderPhone() {
    return  MealTimingScreen();
  }
}
