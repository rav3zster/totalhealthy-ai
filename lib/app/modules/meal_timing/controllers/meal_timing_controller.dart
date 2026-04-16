import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/base/controllers/auth_controller.dart';
import '../../../data/services/mock_api_service.dart';
import '../../../data/services/dummy_data_service.dart';

class MealTimingController extends GetxController {
  GlobalKey<FormState> key = GlobalKey<FormState>();

  var isLoading = false.obs;
  var title = TextEditingController();
  var time = TextEditingController();
  var startTime = TextEditingController();
  var endTime = TextEditingController();

  Future<void> addMeal(String id) async {
    if (title.text.trim().isEmpty || time.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading(true);

      Map<String, dynamic> data = {
        "label_name": title.text.trim(),
        "time_range": time.text.trim(),
      };

      final response = await MockApiService.createMealCategory(id, data);

      if (response['statusCode'] == 200) {
        Get.snackbar(
          'Success',
          '${response['message']}',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        getMeal(id);
        title.clear();
        time.clear();
        Get.back();
      } else {
        Get.snackbar(
          'Error',
          'Group is not created.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Error in addMeal: $e");
      Get.snackbar(
        'Error',
        'An error occurred. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  var box = GetStorage();
  var dataList = <Map<String, dynamic>>[].obs;
  var getLoading = false.obs;

  Future<void> getMeal(String id) async {
    try {
      getLoading(true);

      final cachedData = box.read("meal_timings_$id");
      if (cachedData != null) {
        dataList.assignAll(List<Map<String, dynamic>>.from(cachedData));
      } else {
        final response = await MockApiService.getMealCategories(id);

        if (response['statusCode'] == 200) {
          final List<Map<String, dynamic>> items =
              List<Map<String, dynamic>>.from(response['data']);
          dataList.assignAll(items);
          Get.find<AuthController>().categoriesAdd(items);
          Get.find<AuthController>().fetchAndScheduleNotifications(items);
        } else {
          Get.snackbar(
            'Error',
            'Data could not be loaded.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      debugPrint("Error in getMeal: $e");
      final dummyData = List<Map<String, dynamic>>.from(
        DummyDataService.getDummyMealCategories(),
      );
      dataList.assignAll(dummyData);
      Get.find<AuthController>().categoriesAdd(dummyData);
    } finally {
      getLoading(false);
    }
  }

  Future<void> saveChanges(String id) async {
    try {
      isLoading(true);

      await box.write("meal_timings_$id", dataList.toList());
      Get.find<AuthController>().categoriesAdd(dataList.toList());
      await Get.find<AuthController>().fetchAndScheduleNotifications(
        dataList.toList(),
      );

      Get.snackbar(
        'Success',
        'Meal timings saved successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.back();
    } catch (e) {
      debugPrint("Error saving changes: $e");
      Get.snackbar(
        'Error',
        'Failed to save changes.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    title.dispose();
    time.dispose();
    startTime.dispose();
    endTime.dispose();
    super.onClose();
  }
}
