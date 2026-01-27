import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/core/base/controllers/auth_controller.dart';

import '../../../data/services/mock_api_service.dart';

class GroupController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    submitUser();
  }

  //TODO: Implement GroupController
  var isLoading = false.obs;
  var groupData = [].obs;
  final context = Get.context;

  Future<void> submitUser() async {
    try {
      isLoading(true);
      
      // Use mock API instead of real API
      final response = await MockApiService.getGroups(
        Get.find<AuthController>().roleGet() == "admin" ? "admin" : "user"
      );
      
      if (response['statusCode'] == 200) {
        groupData(response['data']);
      } else {
        ScaffoldMessenger.of(context!).showSnackBar(
          SnackBar(
            content: Text('${response["message"]}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
  }

  final count = 0.obs;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
  var group = {}.obs;
}
