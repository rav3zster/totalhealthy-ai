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

      await APIMethods.post
          .post(url: APIEndpoints.meals.postMealCategories(id), map: data)
          .then((value) {
        if (APIStatus.success(value.statusCode)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("${value.data['message']}"),
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
      });
      // }
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

      await APIMethods.get
          .get(url: APIEndpoints.meals.getMealCategories(id))
          .then((value) {
        if (APIStatus.success(value.statusCode)) {
          // addMeal(context, id);
          Get.find<AuthController>().fetchAndScheduleNotifications(value.data);
          dataList(value.data);

          Get.find<AuthController>().categoriesAdd(value.data);
          print(box.read("categories"));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data is not created.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
      // }
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
