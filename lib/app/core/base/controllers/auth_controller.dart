import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../routes/app_pages.dart';
import '../../../routes/route_access.dart';

class AuthController extends GetxController {
  Future<AuthController> init() async => this;

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
    Get.toNamed(Routes.NUTRITION_GOAL);
  }

  // initAuth() async {
  //   // await configureAmplify();

  //   await validateAuth();
  //   ever(isAuthenticated, (auth) => handleAuthChange());

  //   // FlutterNativeSplash.remove();
  // }

  validateAuth() async {
    await tokenVaildate();
    return isAuthenticated.value;
  }

  handleAuthChange() {
    print("handleAuthChange  ${Get.currentRoute}");
    if (isLogOut.value) {
      Get.offAllNamed(Routes.Login);
    } else {
      AppRouteAccess.handleRedirect(Get.currentRoute, isAuthChange: true);
    }
  }

  tokenVaildate() {
    print("ddf $authToken");
    if (box.hasData("authToken")) {
      isAuthenticated.value = true;
      authToken = box.read("authToken");
      var refreshTokend = box.read("refreshToken");

      Get.toNamed(Routes.NUTRITION_GOAL);

      print("ddff $authToken");
    } else {
      Get.toNamed(Routes.Login);

      isAuthenticated.value = false;
    }
  }

  void clearAuth() {
    authToken = "";
    box.remove('redirect');
    isAuthenticated.value = false;
    box.remove('authToken');
    box.remove('refreshToken');
  }
}
