import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:totalhealthy/app/core/base/controllers/auth_controller.dart';
import 'app/core/base/constants/custom_scroll.dart';
import 'app/routes/app_pages.dart';
import 'app/widgets/notification_services.dart' as old_notification;
import 'app/bindings/app_bindings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'app/core/controllers/global_settings_controller.dart';
import 'app/core/translations/app_translations.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/services/notification_service.dart';

final old_notification.NotificationService _notificationService =
    old_notification.NotificationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await GetStorage.init();

  // Initialize global settings controller FIRST
  Get.put(GlobalSettingsController(), permanent: true);

  // Initialize production notification service (optional, non-blocking)
  // If this fails, app will continue without notification support
  NotificationService.init()
      .then((_) {
        debugPrint('✅ Production NotificationService initialized');
      })
      .catchError((e) {
        debugPrint('⚠️ NotificationService initialization failed: $e');
        debugPrint('⚠️ App will continue without notification support');
      });

  await initializeControllers();

  // Determine initial route before running the app
  final auth = FirebaseAuth.instance;
  final box = GetStorage();
  String initialRoute = AppPages.initial;

  if (auth.currentUser != null) {
    // User is logged in, skip onboarding
    final role = box.read('role');
    if (role == 'advisor' || role == 'admin') {
      initialRoute = Routes.trainerDashboard;
    } else {
      // Default to Client Dashboard if logged in
      initialRoute = Routes.clientDashboard;
    }
    debugPrint("🚀 App Launch: Logged in as $role, starting at $initialRoute");
  } else {
    debugPrint("👋 App Launch: No user found, starting at Onboarding");
  }

  runApp(MyApp(initialRoute: initialRoute));
}

Future<void> initializeControllers() async {
  try {
    await _notificationService.initialize();
  } catch (e) {
    debugPrint("Notification service initialization failed: $e");
  }

  // Initialize core bindings first
  InitialBindings().dependencies();

  await Get.putAsync<AuthController>(
    () async => AuthController().init(),
    permanent: true,
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    // Make GetMaterialApp reactive to theme and locale changes
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        ),
        initialRoute: initialRoute,
        getPages: AppPages.routes,
        initialBinding: AppBindings(),
        title: 'Total Healthy',

        // Reactive theme and locale
        themeMode: GlobalSettingsController.to.themeMode.value,
        locale: GlobalSettingsController.to.locale.value,
        translations: AppTranslations(),
        fallbackLocale: const Locale('en'),

        // Theme definitions with custom colors
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,

        onReady: () {},
        scrollBehavior: MyCustomScrollBehavior(),
      ),
    );
  }
}
