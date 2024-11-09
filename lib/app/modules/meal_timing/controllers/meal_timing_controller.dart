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
  var time = TextEditingController();
  Future<void> addMeal(context, id) async {
    try {
      // if (key.currentState!.validate()) {
      // setState(() {
      isLoading(true);

      Map<String, dynamic> data = {
        "label_name": title.text.trim(),
        "time_range": time.text.trim(),
      };
      print(data);

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
      print(e);
    } finally {
      isLoading = false.obs;
      // });
    }
  }

  var box = GetStorage();

  var dataList = [].obs;
  var getLoading = false.obs;

  Future<void> getMeal(context, id) async {
    try {
      getLoading(true);

      await APIMethods.get
          .get(url: APIEndpoints.meals.getMealCategories(id))
          .then((value) {
        if (APIStatus.success(value.statusCode)) {
          // addMeal(context, id);
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
      print(e);
    } finally {
      getLoading(false);
    }
  }

  final count = 0.obs;

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
