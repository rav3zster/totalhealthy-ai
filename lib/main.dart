import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/core/base/controllers/auth_controller.dart';

import 'app/core/base/constants/custom_scroll.dart';
import 'app/core/base/controllers/theme_controller.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeControllers();
  runApp(const MyApp());
}

initializeControllers() {
  Get.putAsync<ThemeController>(() async => ThemeController());
  Get.putAsync<AuthController>(() async => AuthController());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        getPages: AppPages.routes,
        initialRoute: AppPages.INITIAL,
        title: 'Total Healthy',
        onReady: () {
          Get.find<AuthController>().tokenVaildate();
        },
        scrollBehavior: MyCustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        theme: Get.find<ThemeController>().themeData);
  }
}
