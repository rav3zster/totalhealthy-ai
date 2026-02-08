import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../routes/app_pages.dart';
import '../../../data/services/dummy_data_service.dart';
import '../../../data/services/users_firestore_service.dart';
import '../../../data/models/user_model.dart';
import '../../../widgets/notification_services.dart';

import 'theme_controller.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final box = GetStorage();

  // Observables
  Rx<User?> firebaseUser = Rx<User?>(null);
  RxBool isAuthenticated = false.obs;
  RxBool flowloader = false.obs;

  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  Future<AuthController> init() async {
    Get.putAsync<ThemeController>(() async => ThemeController());
    // Trigger initial check
    firebaseUser.value = _auth.currentUser;
    return this;
  }

  _setInitialScreen(User? user) async {
    if (user == null) {
      print("User is currently signed out!");
      isAuthenticated.value = false;
      Get.offAllNamed(Routes.Login);
    } else {
      print("User is signed in!");
      isAuthenticated.value = true;
      box.write('authToken', user.uid);

      // Check if profile is completed
      final usersService = UsersFirestoreService();
      UserModel? profile = await usersService.getUserProfile(user.uid);

      if (profile != null && profile.needsProfileCompletion) {
        // Redirect to profile settings to complete profile
        Get.offAllNamed(Routes.SETTING);
        Get.snackbar(
          "Complete Your Profile",
          "Please complete your profile information to continue",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFC2D86A),
          colorText: Colors.black,
          duration: const Duration(seconds: 4),
        );
        return;
      }

      // Determine dashboard based on role
      if (box.hasData("role") && box.read("role") == "admin") {
        Get.offAllNamed(Routes.TrainerDashboard);
      } else {
        Get.offAllNamed(Routes.ClientDashboard);
      }
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    try {
      flowloader.value = true;
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final usersService = UsersFirestoreService();
        UserModel? profile = await usersService.getUserProfile(
          credential.user!.uid,
        );

        if (profile == null) {
          // Create missing profile for legacy users
          profile = UserModel(
            id: credential.user!.uid,
            email: email,
            username: email.split('@')[0],
            phone: "",
            firstName: "",
            lastName: "",
            profileImage: "",
            age: 0,
            weight: 0.0,
            height: 0,
            activityLevel: "Not Set",
            goals: [],
            joinDate: DateTime.now(),
            profileCompleted: false, // Mark as incomplete for legacy users
          );
          await usersService.createUserProfile(profile);
        }

        // Sync with local storage
        await userdataStore(profile.toJson());

        // Check if role is admin
        if (email == "admin@gmail.com") {
          roleStore("admin");
        } else {
          roleStore("user");
        }
      }
      return true;
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Login Failed",
        e.message ?? "Unknown error occurred",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      print("Login error: $e");
      return false;
    } finally {
      flowloader.value = false;
    }
  }

  // Register
  Future<bool> register(
    String email,
    String password, {
    String? name,
    String? phone,
  }) async {
    try {
      flowloader.value = true;
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Create user profile in Firestore with safe defaults
        final newUser = UserModel(
          id: credential.user!.uid,
          email: email,
          username: name ?? email.split('@')[0],
          phone: phone ?? "",
          firstName: name?.split(' ').first ?? "",
          lastName: (name != null && name.contains(' '))
              ? name.split(' ').last
              : "",
          profileImage: "",
          age: 0, // Safe default
          weight: 0.0, // Safe default
          height: 0, // Safe default
          activityLevel: "Not Set", // Safe default
          goals: [], // Empty list is safe
          joinDate: DateTime.now(),
          targetWeight: 0.0,
          initialWeight: 0.0,
          fatLost: 0.0,
          muscleGained: 0.0,
          profileCompleted: false, // Mark as incomplete
        );

        final usersService = UsersFirestoreService();
        await usersService.createUserProfile(newUser);

        // Save locally
        await userdataStore(newUser.toJson());
      }

      roleStore("user"); // Default role
      return true;
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Registration Failed",
        e.message ?? "Unknown error occurred",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to create account. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return false;
    } finally {
      flowloader.value = false;
    }
  }

  // Logout
  Future<void> logOut() async {
    await clearAuth();
  }

  // Clear Auth
  Future<void> clearAuth() async {
    await _auth.signOut();
    box.erase();
    isAuthenticated.value = false;
    Get.offAllNamed(Routes.Login);
  }

  // Role Management
  roleStore(String role) => box.write("role", role);
  String roleGet() => box.read("role") ?? "user";

  // Notification Service
  final NotificationService _notificationService = NotificationService();
  NotificationService get notificationService => _notificationService;

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

  // Navigation Helper
  handleAuthChange() {
    if (isAuthenticated.value) {
      if (Get.currentRoute == '/login' ||
          Get.currentRoute == '/signup' ||
          Get.currentRoute == '/onboarding' ||
          Get.currentRoute.isEmpty) {
        if (box.hasData("role")) {
          String role = box.read("role");
          return role == "admin"
              ? Routes.TrainerDashboard
              : Routes.ClientDashboard;
        } else {
          return Routes.SWITCHROLE;
        }
      }
      return Get.currentRoute;
    } else {
      return '/login';
    }
  }

  // Data Helpers
  categoriesAdd(data) => box.write("categories", data);
  categoriesGet() =>
      box.read("categories") ?? DummyDataService.getDummyMealCategories();

  groupgetId() => box.read("groupId") ?? "group_123";
  userdataget() =>
      box.read("userdata") ?? DummyDataService.getDummyUser().toJson();

  groupIdStore(String id) async {
    await box.write("groupId", id);
  }

  userdataStore(userData) async {
    await box.write("userdata", userData);
  }

  // Data Getters for UI
  UserModel getCurrentUser() {
    // In a real app, parse from Firestore or use basic User info
    var userData = userdataget();
    if (userData is Map<String, dynamic>) {
      return UserModel.fromJson(userData);
    }
    // Fallback if not found locally, maybe create from Firebase User
    if (_auth.currentUser != null) {
      return UserModel(
        username: _auth.currentUser!.displayName ?? "User",
        email: _auth.currentUser!.email ?? "",
        id: _auth.currentUser!.uid,
        phone: _auth.currentUser!.phoneNumber ?? "",
        firstName: "User",
        lastName: "",
        profileImage: _auth.currentUser!.photoURL ?? "",
        age: 0,
        weight: 0.0,
        height: 0,
        activityLevel: "Moderate",
        goals: [],
        joinDate: DateTime.now(),
      );
    }
    return DummyDataService.getDummyUser();
  }

  void switchRole(String role) {
    roleStore(role);
    if (role == "admin") {
      Get.offAllNamed(Routes.TrainerDashboard);
    } else {
      Get.offAllNamed(Routes.ClientDashboard);
    }
  }
}
