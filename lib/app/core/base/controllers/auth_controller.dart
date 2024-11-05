import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';

import 'theme_controller.dart';

class AuthController extends GetxController {
  Future<AuthController> init() async {
    Get.putAsync<ThemeController>(() async => ThemeController());

    tokenVaildate();
    return this;
  }

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

  setAuth(String token, String refToken) async {
    isAuthenticated.value = true;

    await box.write('authToken', token);
    await box.write('refreshToken', refToken);
    authToken = box.read("authToken");

    print("sdadada${token},${refToken}");
    Get.toNamed(Routes.TrainerDashboard);
  }

  initAuth() async {
    // await configureAmplify();

    await validateAuth();
    ever(isAuthenticated, (auth) => handleAuthChange());
  }

  validateAuth() async {
    await tokenVaildate();
    return isAuthenticated.value;
  }

  handleAuthChange() {
    print("handleAuthChange  ${Get.currentRoute}");

    if (isLogOut.value) {
      return Routes.Login;
    } else if (isAuthenticated.value) {
      print(isAuthenticated.value);
      return Get.currentRoute == '/login' ||
              Get.currentRoute == '/signup' ||
              Get.currentRoute == '/onboarding' ||
              Get.currentRoute.isEmpty
          ? Routes.ClientDashboard
          : Get.currentRoute;
    } else {
      return '/onboarding';
    }
  }

  groupgetId() => box.read("groupId");
  usergetId() => box.read("userId");
  groupIdStore(String id) async {
    await box.write("groupId", id);
    print(box.read("groupId"));
  }

  userIdStore(String id) async {
    await box.write("userId", id);
    print(box.read("userId"));
  }

  tokenVaildate() {
    if (box.hasData("authToken")) {
      isAuthenticated.value = true;
      authToken = box.read("authToken");
      print("ddf $authToken");
      var refreshTokend = box.read("refreshToken");

      print("ddff $authToken");
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
