import 'package:flutter/material.dart';

import '../../../core/base/views/base_view.dart';
import '../../nutrition_goal/views/nutrition_goal_screen_view.dart';
import 'notification_screen.dart';

class NotificationView extends BaseView {
  NotificationView({super.key});

  @override
  Widget vBuilderTablet() {
    return const NotificationScreen();
  }

  @override
  Widget vBuilderDesktop() {
    return const NotificationScreen();
  }

  @override
  Widget vBuilderPhone() {
    return const NotificationScreen();
  }
}
