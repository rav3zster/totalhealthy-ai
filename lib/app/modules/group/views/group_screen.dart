import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../core/base/views/base_view.dart';
import '../controllers/group_controller.dart';
import '../widgets/group_page.dart';

class GroupScreen extends GetView<GroupController> {
  const GroupScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return GroupListPage();
  }
}
