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
    // DO NOT bind auth state changes to navigation
    // Navigation is handled explicitly by login/register/bootstrap
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, (user) {
      if (user == null) {
        isAuthenticated.value = false;
      } else {
        isAuthenticated.value = true;
        box.write('authToken', user.uid);
      }
    });
  }

  Future<AuthController> init() async {
    Get.putAsync<ThemeController>(() async => ThemeController());
    // Check if user is already authenticated on app start
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      firebaseUser.value = currentUser;
      // Bootstrap user on app start (not a new signup)
      await bootstrapUser(currentUser.uid, isNewSignup: false);
    }
    return this;
  }

  /// CENTRALIZED BOOTSTRAP FUNCTION
  /// This is the ONLY function that makes navigation decisions
  /// Called after login, signup, and app start
  Future<void> bootstrapUser(String uid, {bool isNewSignup = false}) async {
    try {
      print("🚀 Bootstrapping user: $uid (isNewSignup: $isNewSignup)");

      final usersService = UsersFirestoreService();

      // Fetch Firestore document
      UserModel? profile = await usersService.getUserProfile(uid);

      if (profile == null) {
        // Document DOES NOT exist - this is a BRAND NEW USER
        print("📝 New user detected - no Firestore document");
        Get.offAllNamed(Routes.SWITCHROLE);
        return;
      }

      // Document EXISTS - check if role is set
      print("👤 Existing user found - role: ${profile.role}");

      // Sync profile to local storage
      await userdataStore(profile.toJson());

      if (profile.role == null || profile.role!.isEmpty) {
        // User exists but hasn't selected role yet

        if (isNewSignup) {
          // This is a new signup - show Switch Role screen
          print("⚠️ New signup without role - showing Switch Role");
          Get.offAllNamed(Routes.SWITCHROLE);
          return;
        } else {
          // This is an existing user logging in - assign default role "member"
          print(
            "⚠️ Existing user without role - assigning default 'member' role",
          );

          // Update profile with default role
          final updatedProfile = UserModel(
            id: profile.id,
            email: profile.email,
            username: profile.username,
            phone: profile.phone,
            firstName: profile.firstName,
            lastName: profile.lastName,
            profileImage: profile.profileImage,
            age: profile.age,
            weight: profile.weight,
            height: profile.height,
            activityLevel: profile.activityLevel,
            goals: profile.goals,
            joinDate: profile.joinDate,
            targetWeight: profile.targetWeight,
            initialWeight: profile.initialWeight,
            fatLost: profile.fatLost,
            muscleGained: profile.muscleGained,
            profileCompleted: profile.profileCompleted,
            role: "member", // Assign default role
            roleSetAt: DateTime.now(), // Mark role as set
            createdAt: profile.createdAt,
          );

          await usersService.updateUserProfile(updatedProfile);
          await userdataStore(updatedProfile.toJson());

          roleStore("member");
          print("✅ Navigating to Client Dashboard with default role");
          Get.offAllNamed(Routes.ClientDashboard);
          return;
        }
      }

      // User has a role - navigate to appropriate dashboard
      // Normalize role for routing
      String normalizedRole = profile.normalizedRole;

      roleStore(normalizedRole);

      if (normalizedRole == "advisor") {
        print("✅ Navigating to Trainer Dashboard");
        Get.offAllNamed(Routes.TrainerDashboard);
      } else {
        print("✅ Navigating to Client Dashboard");
        Get.offAllNamed(Routes.ClientDashboard);
      }
    } catch (e) {
      print("❌ Bootstrap error: $e");
      // On error, go to login
      Get.offAllNamed(Routes.Login);
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
        // DO NOT create or modify Firestore documents on login
        // Just call bootstrap to handle navigation
        await bootstrapUser(credential.user!.uid, isNewSignup: false);
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
        // Create EMPTY Firestore document immediately (without role)
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
          age: 0,
          weight: 0.0,
          height: 0,
          activityLevel: "Not Set",
          goals: [],
          joinDate: DateTime.now(),
          targetWeight: 0.0,
          initialWeight: 0.0,
          fatLost: 0.0,
          muscleGained: 0.0,
          profileCompleted: false,
          role: null, // No role - will be set via Switch Role (ONE TIME ONLY)
          roleSetAt: null, // Not set yet
          createdAt: DateTime.now(), // Account creation timestamp
        );

        final usersService = UsersFirestoreService();
        await usersService.createUserProfile(newUser);

        // Save locally
        await userdataStore(newUser.toJson());

        // Call bootstrap to handle navigation (this is a NEW SIGNUP)
        await bootstrapUser(credential.user!.uid, isNewSignup: true);
      }

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
