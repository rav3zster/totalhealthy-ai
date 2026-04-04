import 'package:flutter/material.dart';

import 'package:totalhealthy/app/modules/signup/views/signup_screen.dart';

import '../../../core/base/views/base_view.dart';

class SignupView extends BaseView {
  SignupView({super.key});

  @override
  Widget vBuilderTablet() {
    return const SignupScreen();
  }

  @override
  Widget vBuilderDesktop() {
    return SignupScreen();
  }

  @override
  Widget vBuilderPhone() {
    return SignupScreen();
  }
}
