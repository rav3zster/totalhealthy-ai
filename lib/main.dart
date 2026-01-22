import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:totalhealthy/app/core/base/controllers/auth_controller.dart';
import 'app/core/base/constants/custom_scroll.dart';
import 'app/core/base/controllers/theme_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/widgets/notification_services.dart';

final NotificationService _notificationService = NotificationService();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await initializeControllers();

  runApp(const MyApp());
}

initializeControllers() async {
  await _notificationService.initialize();

  Get.putAsync<AuthController>(() async => AuthController().init(),
      permanent: true);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!),
        getPages: AppPages.routes,
        initialRoute: Get.find<AuthController>().handleAuthChange(),
        title: 'Total Healthy',
        onReady: () {},
        scrollBehavior: MyCustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        theme: Get.find<ThemeController>().themeData);
  }
}
