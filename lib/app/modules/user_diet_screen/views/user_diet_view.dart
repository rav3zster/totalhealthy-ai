import 'package:flutter/material.dart';

import '../../../core/base/views/base_view.dart';
import 'user_diet_screen_view.dart';

class UserDietView extends BaseView {
  UserDietView({super.key});

  @override
  Widget vBuilderTablet() {
    return UserDietScreen();
  }

  @override
  Widget vBuilderDesktop() {
    return UserDietScreen();
  }

  @override
  Widget vBuilderPhone() {
    return UserDietScreen();
  }
}
