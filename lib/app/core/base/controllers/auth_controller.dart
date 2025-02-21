import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';

import '../../../widgets/notification_services.dart';
import '../apiservice/api_endpoints.dart';
import '../apiservice/api_status.dart';
import '../apiservice/base_methods.dart';
import 'theme_controller.dart';

class AuthController extends GetxController {
  Future<AuthController> init() async {
    Get.putAsync<ThemeController>(() async => ThemeController());

    tokenVaildate();
    return this;
  }

  final NotificationService _notificationService = NotificationService();
  final _authToken = "".obs;
  RxBool isLogOut = false.obs;
  RxBool flowloader = false.obs;
  final _deviceToken = "".obs;
  String get authToken => _authToken.value;
  String get deviceToken => _deviceToken.value;
  RxBool isAuthenticated = false.obs;
  set authToken(value) => _authToken.value = value;
  set deviceToken(value) => _deviceToken.value = value;
  final box = GetStorage();
  void refreshAuth() {
    isAuthenticated.refresh();
  }

  roleStore(String role) => box.write("role", role);
  String roleGet() => box.read("role");

  setAuth(String token, String refToken, Map<String, dynamic> userData) async {
    isAuthenticated.value = true;

    await box.write('authToken', token);
    await box.write('refreshToken', refToken);
    await userdataStore(userData);
    authToken = box.read("authToken");

    print("sdadada${token},${refToken}");
    Get.offAllNamed(Routes.SWITCHROLE);

    // Get.toNamed(Routes.ClientDashboard);
  }

  // initAuth() async {
  //   // await configureAmplify();

  //   await validateAuth();
  //   ever(isAuthenticated, (auth) => handleAuthChange());
  // }

  // validateAuth() async {
  //   await tokenVaildate();
  //   return isAuthenticated.value;
  // }
  NotificationService notificationService = NotificationService();
  Future<void> fetchAndScheduleNotifications(data) async {
    try {
      // if (response.statusCode == 200) {
      var categories = data;

      for (int index = 0; index < categories.length; index++) {
        var category = categories[index];

        String title = category['label_name'] ?? "Reminder";

        String? timeRange = category['time_range'];
        // print("time-range:$timeRange");
        if (timeRange == null || !timeRange.contains(":")) {
          continue;
        }

        List<String> timeParts = timeRange.split(":");
        int hour = int.tryParse(timeParts[0]) ?? 0;
        int minute = int.tryParse(timeParts[1].split(" ")[0]) ?? 0;
        // print("timeParts: ${timeParts[1]}");
        String body = "It's time for ${category['label_name'] ?? ""}";

        int uniqueId = category['label_name'].hashCode.abs() % 100000;
        await notificationService.cancelNotification(uniqueId);
        // print("uique id: $uniqueId");
        // print("title: $title");
        // print("hour: $hour");
        // print("minute: $minute");
        await notificationService.scheduleNotification(
          title: title,
          hour: hour,
          id: uniqueId,
          minute: minute,
          body: body,
        );
      }
      // } else {
      //   print("Error ${response.data}");
      // }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  handleAuthChange() {
    print("handleAuthChange  ${Get.currentRoute}");

    if (isAuthenticated.value) {
      print(isAuthenticated.value);
      return Get.currentRoute == '/login' ||
              Get.currentRoute == '/signup' ||
              Get.currentRoute == '/onboarding' ||
              Get.currentRoute.isEmpty
          ? box.hasData("role")
              ? box.read("role") == "admin"
                  ? Routes.TrainerDashboard
                  : Routes.ClientDashboard
              : Routes.SWITCHROLE
          : Get.currentRoute;
    } else {
      return '/onboarding';
    }
  }

  categoriesAdd(data) => box.write("categories", data);
  categoriesGet() => box.read("categories");

  groupgetId() => box.read("groupId");
  userdataget() => box.read("userdata");
  groupIdStore(String id) async {
    await box.write("groupId", id);
    print(box.read("groupId"));
  }

  userdataStore(userData) async {
    await box.write("userdata", userData);
  }

  tokenVaildate() {
    if (box.hasData("authToken")) {
      isAuthenticated.value = true;
      authToken = box.read("authToken");

      var refreshTokend = box.read("refreshToken");

      print("authToken $authToken");
    } else {
      // Get.toNamed(Routes.Login);

      isAuthenticated.value = false;
    }
  }

  void clearAuth() {
    authToken = "";

    isAuthenticated.value = false;

    box.erase();
    Get.offAllNamed(Routes.LoginView);
  }
}
