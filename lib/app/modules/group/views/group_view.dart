import 'package:flutter/material.dart';

import '../../../core/base/views/base_view.dart';

import 'group_screen.dart';

class GroupView extends BaseView {
  GroupView({super.key});

  @override
  Widget vBuilderTablet() {
    return const GroupScreen();
  }

  @override
  Widget vBuilderDesktop() {
    return const GroupScreen();
  }

  @override
  Widget vBuilderPhone() {
    return const GroupScreen();
  }
}
