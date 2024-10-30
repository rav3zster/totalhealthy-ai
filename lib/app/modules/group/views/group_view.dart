import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../core/base/views/base_view.dart';
import '../controllers/group_controller.dart';
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
