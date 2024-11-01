import 'package:flutter/material.dart';

import '../../../core/base/views/base_view.dart';
import 'empty_screen.dart';

class EmptyScreenView extends BaseView {
  EmptyScreenView({super.key});

  @override
  Widget vBuilderTablet() {
    return EmptyScreen();
  }

  @override
  Widget vBuilderDesktop() {
    return EmptyScreen();
  }

  @override
  Widget vBuilderPhone() {
    return EmptyScreen();
  }
}
