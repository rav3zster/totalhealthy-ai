import 'package:flutter/material.dart';

import '../../../core/base/views/base_view.dart';
import 'home_screen_view.dart';

class HomeView extends BaseView {
  HomeView({super.key});

  @override
  Widget vBuilderTablet() {
    return HomeScreenView();
  }

  @override
  Widget vBuilderDesktop() {
    return HomeScreenView();
  }

  @override
  Widget vBuilderPhone() {
    return HomeScreenView();
  }
}
