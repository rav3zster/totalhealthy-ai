import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/base/controllers/auth_controller.dart';
import '../../../data/services/mock_api_service.dart';
import '../../../data/services/dummy_data_service.dart';

class MealTimingController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  GlobalKey<FormState> key = GlobalKey<FormState>();

  var isLoading = false.obs;
  var title = TextEditingController();
  var time = TextEditingController();
  var startTime = TextEditingController();
  var endTime = TextEditingController();

  Future<void> addMeal(BuildContext context, String id) async {
    if (title.text.trim().isEmpty || time.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all fields."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      isLoading(true);

      Map<String, dynamic> data = {
        "label_name": title.text.trim(),
        "time_range": time.text.trim(),
      };

      // Use mock API instead of real API
      final response = await MockApiService.createMealCategory(id, data);
      
      if (response['statusCode'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${response['message']}"),
            backgroundColor: Colors.green,
          ),
        );
        getMeal(context, id);
        title.clear();
        time.clear();
        Get.back();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Group is not created.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error in addMeal: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      isLoading(false);
    }
  }

  var box = GetStorage();
  var dataList = [].obs;
  var getLoading = false.obs;

  Future<void> getMeal(BuildContext context, String id) async {
    try {
      getLoading(true);

      // Use mock API instead of real API
      final response = await MockApiService.getMealCategories(id);
      
      if (response['statusCode'] == 200) {
        Get.find<AuthController>().fetchAndScheduleNotifications(response['data']);
        dataList(response['data']);
        Get.find<AuthController>().categoriesAdd(response['data']);
        print("Categories stored: ${box.read("categories")}");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data could not be loaded.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error in getMeal: $e");
      // Load dummy data as fallback
      final dummyData = DummyDataService.getDummyMealCategories();
      dataList(dummyData);
      Get.find<AuthController>().categoriesAdd(dummyData);
    } finally {
      getLoading(false);
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
