import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/core/base/constants/custom_scroll.dart';
import 'app/core/base/controllers/theme_controller.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeControllers();
  runApp(const MyApp());
}

Future<void> initializeControllers() async {
  Get.putAsync<ThemeController>(() async => ThemeController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        getPages: AppPages.routes,
        initialRoute: AppPages.INITIAL,
        title: 'Total Healthy',
        scrollBehavior: MyCustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        theme: Get.find<ThemeController>().themeData);
  }
}
