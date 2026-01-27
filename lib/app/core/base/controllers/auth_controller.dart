import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';
import '../../../data/services/dummy_data_service.dart';
import '../../../data/models/user_model.dart';
import '../../../widgets/notification_services.dart';
import '../../../modules/login/views/login_view.dart';
import 'theme_controller.dart';

class AuthController extends GetxController {
  Future<AuthController> init() async {
    Get.putAsync<ThemeController>(() async => ThemeController());
    tokenValidate();
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
  String roleGet() => box.read("role") ?? "user";

  // Mock authentication - no API calls
  setAuth(String token, String refToken, Map<String, dynamic> userData) async {
    isAuthenticated.value = true;

    await box.write('authToken', token);
    await box.write('refreshToken', refToken);
    await userdataStore(userData);
    authToken = box.read("authToken");

    print("Auth set: ${token}, ${refToken}");
    
    // Set default role if not exists
    if (!box.hasData("role")) {
      roleStore("user");
    }
    
    // Navigate based on role
    String role = roleGet();
    if (role == "admin") {
      Get.offAllNamed(Routes.TrainerDashboard);
    } else {
      Get.offAllNamed(Routes.ClientDashboard);
    }
  }

  // Mock login method
  Future<bool> mockLogin(String email, String password) async {
    if (DummyDataService.validateLogin(email, password)) {
      final userData = DummyDataService.getDummyUser();
      await setAuth(
        "token_${DateTime(2024, 10, 15).millisecondsSinceEpoch}",
        "refresh_${DateTime(2024, 10, 15).millisecondsSinceEpoch}",
        userData.toJson(),
      );
      return true;
    }
    return false;
  }

  NotificationService notificationService = NotificationService();
  
  // Mock notification scheduling with dummy data
  Future<void> fetchAndScheduleNotifications(data) async {
    try {
      var categories = data ?? DummyDataService.getDummyMealCategories();

      for (int index = 0; index < categories.length; index++) {
        var category = categories[index];

        String title = category['label_name'] ?? "Reminder";
        String? timeRange = category['time_range'];
        
        if (timeRange == null || !timeRange.contains(":")) {
          continue;
        }

        List<String> timeParts = timeRange.split(":");
        int hour = int.tryParse(timeParts[0]) ?? 0;
        int minute = int.tryParse(timeParts[1].split(" ")[0]) ?? 0;
        
        String body = "It's time for ${category['label_name'] ?? ""}";
        int uniqueId = category['label_name'].hashCode.abs() % 100000;
        
        await notificationService.cancelNotification(uniqueId);
        await notificationService.scheduleNotification(
          title: title,
          hour: hour,
          id: uniqueId,
          minute: minute,
          body: body,
        );
      }
    } catch (e) {
      print('Error scheduling notifications: $e');
    }
  }

  handleAuthChange() {
    print("handleAuthChange ${Get.currentRoute}");

    if (isAuthenticated.value) {
      print("User is authenticated: ${isAuthenticated.value}");
      
      // Check current route and redirect accordingly
      if (Get.currentRoute == '/login' ||
          Get.currentRoute == '/signup' ||
          Get.currentRoute == '/onboarding' ||
          Get.currentRoute.isEmpty) {
        
        if (box.hasData("role")) {
          String role = box.read("role");
          return role == "admin" ? Routes.TrainerDashboard : Routes.ClientDashboard;
        } else {
          return Routes.SWITCHROLE;
        }
      }
      return Get.currentRoute;
    } else {
      return '/onboarding';
    }
  }

  categoriesAdd(data) => box.write("categories", data);
  categoriesGet() => box.read("categories") ?? DummyDataService.getDummyMealCategories();

  groupgetId() => box.read("groupId") ?? "group_123";
  userdataget() => box.read("userdata") ?? DummyDataService.getDummyUser().toJson();
  
  groupIdStore(String id) async {
    await box.write("groupId", id);
    print("Group ID stored: ${box.read("groupId")}");
  }

  userdataStore(userData) async {
    await box.write("userdata", userData);
  }

  tokenValidate() {
    if (box.hasData("authToken")) {
      isAuthenticated.value = true;
      authToken = box.read("authToken");
      var refreshToken = box.read("refreshToken");
      print("Token validated: $authToken");
    } else {
      isAuthenticated.value = false;
    }
  }

  void clearAuth() {
    authToken = "";
    isAuthenticated.value = false;
    box.erase();
    Get.offAll(() => LoginView());
  }

  // Mock user data getter
  UserModel getCurrentUser() {
    var userData = userdataget();
    if (userData is Map<String, dynamic>) {
      return UserModel.fromJson(userData);
    }
    return DummyDataService.getDummyUser();
  }

  // Mock role switching
  void switchRole(String role) {
    roleStore(role);
    if (role == "admin") {
      Get.offAllNamed(Routes.TrainerDashboard);
    } else {
      Get.offAllNamed(Routes.ClientDashboard);
    }
  }
}
