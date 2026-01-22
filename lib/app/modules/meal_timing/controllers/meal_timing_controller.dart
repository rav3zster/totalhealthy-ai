import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/base/apiservice/api_endpoints.dart';
import '../../../core/base/apiservice/api_status.dart';
import '../../../core/base/apiservice/base_methods.dart';
import '../../../core/base/controllers/auth_controller.dart';

class MealTimingController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  GlobalKey<FormState> key = GlobalKey<FormState>();

  var isLoading = false.obs;
  var title = TextEditingController();
  var startTime = TextEditingController();
  var endTime = TextEditingController();

  Future<void> addMeal(BuildContext context, String id) async {
    if (title.text.trim().isEmpty || startTime.text.trim().isEmpty || endTime.text.trim().isEmpty) {
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
        "time_range": "${startTime.text.trim()} - ${endTime.text.trim()}",
      };

      print("Sending Data: $data");

      var response = await APIMethods.post.post(
        url: APIEndpoints.meals.postMealCategories(id),
        map: data,
      );

      if (APIStatus.success(response.statusCode)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${response.data['message']}"),
            backgroundColor: Colors.green,
          ),
        );
        getMeal(context, id);
        Get.back();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Meal category not created.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error in addMeal: $e");
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

      var response = await APIMethods.get.get(
        url: APIEndpoints.meals.getMealCategories(id),
      );

      if (APIStatus.success(response.statusCode)) {
        dataList(response.data);
        Get.find<AuthController>().categoriesAdd(response.data);
        print("Stored Categories: ${box.read("categories")}");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to retrieve meal categories.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Error in getMeal: $e");
    } finally {
      getLoading(false);
    }
  }

  @override
  void onClose() {
    title.dispose();
    startTime.dispose();
    endTime.dispose();
    super.onClose();
  }
}
