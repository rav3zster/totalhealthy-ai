import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/core/base/controllers/auth_controller.dart';
import 'package:totalhealthy/app/data/models/user_model.dart';
import 'package:totalhealthy/app/data/models/group_model.dart';
import 'package:totalhealthy/app/data/services/groups_firestore_service.dart';

import 'package:totalhealthy/app/data/services/users_firestore_service.dart';

class GroupController extends GetxController {
  final GroupsFirestoreService _groupsService = GroupsFirestoreService();
  final UsersFirestoreService _usersService = UsersFirestoreService();

  final groupData = <GroupModel>[].obs;
  final users = <UserModel>[].obs; // Real user list
  final isLoading = true.obs;
  final totalUsers = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initGroups();
    _initUsers();
  }

  void _initUsers() {
    totalUsers.bindStream(_usersService.getTotalUsersCountStream());
    users.bindStream(_usersService.getUsersStream());
  }

  void _initGroups() {
    isLoading.value = true;
    // Bind the groupData to the Firestore stream
    groupData.bindStream(_groupsService.getGroupsStream());

    // Set isLoading to false when the first batch of data is received
    ever(groupData, (_) => isLoading.value = false);

    // Safety timeout
    Future.delayed(const Duration(seconds: 5), () {
      if (isLoading.value) isLoading.value = false;
    });
  }

  Future<void> createGroup(String name, String description) async {
    try {
      if (name.trim().isEmpty) {
        Get.snackbar(
          "Error",
          "Group name cannot be empty",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      isLoading.value = true;
      final authController = Get.find<AuthController>();
      final currentUser = authController.firebaseUser.value;

      final newGroup = GroupModel(
        name: name.trim(),
        description: description.trim(),
        createdBy: currentUser?.uid ?? 'unknown',
        createdAt: DateTime.now(),
        memberCount: 1,
      );

      await _groupsService.addGroup(newGroup);

      Get.snackbar(
        'Success',
        'Group "$name" created successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print("Error creating group: $e");
      Get.snackbar(
        'Error',
        'Failed to create group: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
