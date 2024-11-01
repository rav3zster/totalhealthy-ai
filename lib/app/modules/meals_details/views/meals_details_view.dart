import 'package:flutter/material.dart';

import '../../../core/base/views/base_view.dart';

import 'meals_details_screen.dart';

class MealsDetailsView extends BaseView {
  MealsDetailsView({super.key});

  @override
  Widget vBuilderTablet() {
    return MealsDetailsScreen();
  }

  @override
  Widget vBuilderDesktop() {
    return MealsDetailsScreen();
  }

  @override
  Widget vBuilderPhone() {
    return MealsDetailsScreen();
  }
}
