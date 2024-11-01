import 'package:flutter/material.dart';

import '../../../core/base/views/base_view.dart';

import 'create_meal_view.dart';

class CreateMealView extends BaseView {
  CreateMealView({super.key});

  @override
  Widget vBuilderTablet() {
    return CreateMealScreen();
  }

  @override
  Widget vBuilderDesktop() {
    return CreateMealScreen();
  }

  @override
  Widget vBuilderPhone() {
    return CreateMealScreen();
  }
}
