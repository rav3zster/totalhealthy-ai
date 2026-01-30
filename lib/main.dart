import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:totalhealthy/app/core/base/controllers/auth_controller.dart';
import 'app/core/base/constants/custom_scroll.dart';
import 'app/core/base/controllers/theme_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/widgets/notification_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final NotificationService _notificationService = NotificationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await GetStorage.init();
  await initializeControllers();

  runApp(const MyApp());
}

initializeControllers() async {
  try {
    await _notificationService.initialize();
  } catch (e) {
    print("Notification service initialization failed: $e");
  }

  await Get.putAsync<AuthController>(
    () async => AuthController().init(),
    permanent: true,
  );
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
        child: child!,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      title: 'Total Healthy',
      onReady: () {},
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        scaffoldBackgroundColor: Colors.black,
      ),
    );
  }
}
