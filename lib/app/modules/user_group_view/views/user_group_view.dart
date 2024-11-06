import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/user_group_view/views/group_user_page.dart';

import '../controllers/user_group_view_controller.dart';

class UserGroupView extends GetView<UserGroupViewController> {
  const UserGroupView({super.key});
  @override
  Widget build(BuildContext context) {
    return GroupListPage();
  }
}
