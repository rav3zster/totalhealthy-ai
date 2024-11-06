import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/base/apiservice/api_endpoints.dart';
import '../../../core/base/apiservice/api_status.dart';
import '../../../core/base/apiservice/base_methods.dart';

class UserGroupViewController extends GetxController {
  //TODO: Implement UserGroupViewController
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
      isLoading(true); // });
      // print(data);  String input = searchController.text.trim();
      // String input = searchController.text.trim();
      // var phone = int.tryParse(input);
      await APIMethods.get
          .get(
        url: APIEndpoints.group.createGroup,
      )
          .then((value) {
        if (APIStatus.success(value.statusCode)) {
          groupData(value.data);

          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('User  Successful!'),
          //     backgroundColor: Colors.green,
          //   ),
          // );
        } else {
          // printError("Auth Controller", "Signup", value.data);
          ScaffoldMessenger.of(context!).showSnackBar(
            SnackBar(
              content: Text('${value.data["detail"]}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
      // }
    } catch (e) {
      print(e);
    } finally {
      isLoading(false);
    }
    // if (_formKey.currentState!.validate()) {
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
}
