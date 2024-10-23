import 'package:flutter/material.dart';

import '../../../core/base/views/base_view.dart';

import 'meal_history_screen.dart';

class MealHistoryView extends BaseView {
  MealHistoryView({super.key});

  @override
  Widget vBuilderTablet() {
    return const MealHistoryScreen();
  }

  @override
  Widget vBuilderDesktop() {
    return const MealHistoryScreen();
  }

  @override
  Widget vBuilderPhone() {
    return const MealHistoryScreen();
  }
}
