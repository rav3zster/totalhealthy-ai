import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../data/models/user_model.dart';
import '../data/services/users_firestore_service.dart';
import '../core/base/controllers/auth_controller.dart';

import 'dart:io';

class UserController extends GetxController {
  final UsersFirestoreService _usersService = Get.find<UsersFirestoreService>();
  final GetStorage _storage = GetStorage();

  // Cache keys
  static const String _userCacheKey = 'cached_user_data';
  static const String _lastFetchKey = 'last_user_fetch';
  static const Duration _cacheExpiry = Duration(minutes: 5);

  // Get AuthController instance - with null safety
  AuthController? get _authController {
    try {
      return Get.find<AuthController>();
    } catch (e) {
      return null;
    }
  }

  // Reactive user data with caching
  final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;
  final RxBool _isInitialized = false.obs;

  // Public getters with caching fallback - Make these reactive
  UserModel? get currentUser => _currentUser.value ?? _getCachedUser();
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  bool get isInitialized => _isInitialized.value;

  // Computed properties for UI with caching fallback - Make these reactive
  String get fullName =>
      _currentUser.value?.fullName ?? _getCachedUser()?.fullName ?? 'User';
  String get profileImage =>
      _currentUser.value?.profileImage ?? _getCachedUser()?.profileImage ?? '';

  // Helper method to get correct ImageProvider (URL or Base64)
  static ImageProvider? getImageProvider(String imageSource) {
    if (imageSource.isEmpty) return null;
    if (imageSource.startsWith('http')) {
      return NetworkImage(imageSource);
    } else if (imageSource.startsWith('data:image')) {
      try {
        final base64String = imageSource.split(',').last;
        return MemoryImage(base64Decode(base64String));
      } catch (e) {
        print('Error decoding Base64 image: $e');
        return null;
      }
    }
    return null;
  }

  String get email =>
      _currentUser.value?.email ?? _getCachedUser()?.email ?? '';
  int get currentDay =>
      _currentUser.value?.currentDay ?? _getCachedUser()?.currentDay ?? 1;
  double get goalProgress =>
      _currentUser.value?.goalAchievedPercentage ??
      _getCachedUser()?.goalAchievedPercentage ??
      0.0;
  String get primaryGoal =>
      _currentUser.value?.primaryGoal ??
      _getCachedUser()?.primaryGoal ??
      'General Fitness';

  // Live stats calculations - Make these reactive
  String get fatLost =>
      _currentUser.value?.fatLostDisplay ??
      _getCachedUser()?.fatLostDisplay ??
      '0kg';
  String get muscleGained =>
      _currentUser.value?.muscleGainedDisplay ??
      _getCachedUser()?.muscleGainedDisplay ??
      '0g';
  String get goalAchievedPercent =>
      _currentUser.value?.goalProgressDisplay ??
      _getCachedUser()?.goalProgressDisplay ??
      '0%';
  String get dayCountDisplay =>
      _currentUser.value?.dayCountDisplay ??
      _getCachedUser()?.dayCountDisplay ??
      'Day 1/55';
  String get planDateRange =>
      _currentUser.value?.planDateRange ??
      _getCachedUser()?.planDateRange ??
      '';

  // User stats for profile display - Make these reactive
  String get weightDisplay => _currentUser.value != null
      ? '${_currentUser.value!.weight.toInt()}'
      : (_getCachedUser() != null
            ? '${_getCachedUser()!.weight.toInt()}'
            : '0');
  String get ageDisplay =>
      _currentUser.value?.age.toString() ??
      _getCachedUser()?.age.toString() ??
      '0';
  String get heightDisplay =>
      _currentUser.value?.height.toString() ??
      _getCachedUser()?.height.toString() ??
      '0';

  // Stream subscriptions for cleanup
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<UserModel?>? _userSubscription;
  String? _currentUserId;

  @override
  void onInit() {
    super.onInit();
    print("UserController: onInit called");
    _loadCachedData();

    // Initialize immediately after the frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeAuthListener();
    });
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    _userSubscription?.cancel();
    super.onClose();
  }

  // Cache management methods
  void _loadCachedData() {
    try {
      final cachedData = _storage.read(_userCacheKey);
      final lastFetch = _storage.read(_lastFetchKey);

      if (cachedData != null && lastFetch != null) {
        final lastFetchTime = DateTime.fromMillisecondsSinceEpoch(lastFetch);
        final isExpired =
            DateTime.now().difference(lastFetchTime) > _cacheExpiry;

        if (!isExpired) {
          _currentUser.value = UserModel.fromJson(
            Map<String, dynamic>.from(cachedData),
          );
          _isInitialized.value = true;
        }
      }
    } catch (e) {
      print('Error loading cached user data: $e');
    }
  }

  UserModel? _getCachedUser() {
    try {
      final cachedData = _storage.read(_userCacheKey);
      if (cachedData != null) {
        return UserModel.fromJson(Map<String, dynamic>.from(cachedData));
      }
    } catch (e) {
      print('Error getting cached user: $e');
    }
    return null;
  }

  void _cacheUserData(UserModel user) {
    try {
      _storage.write(_userCacheKey, user.toJson());
      _storage.write(_lastFetchKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Error caching user data: $e');
    }
  }

  void _clearCache() {
    try {
      _storage.remove(_userCacheKey);
      _storage.remove(_lastFetchKey);
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  void _initializeAuthListener() {
    print("UserController: Initializing auth listener");

    // Check if AuthController is available
    final authController = _authController;
    if (authController == null) {
      print(
        "UserController: AuthController not available, using direct Firebase Auth",
      );
      // Fallback to direct Firebase Auth if AuthController is not ready
      _authSubscription = FirebaseAuth.instance.authStateChanges().listen((
        user,
      ) {
        print("UserController: Auth state changed - User: ${user?.uid}");
        if (user != null && user.uid != _currentUserId) {
          _currentUserId = user.uid;
          _subscribeToUserData(user.uid);
        } else if (user == null) {
          _clearUserData();
        }
      });
      return;
    }

    print("UserController: Using AuthController for auth state");
    // Listen to AuthController's authentication state
    _authSubscription = authController.firebaseUser.listen((user) {
      print(
        "UserController: AuthController state changed - User: ${user?.uid}",
      );
      if (user != null && user.uid != _currentUserId) {
        _currentUserId = user.uid;
        _subscribeToUserData(user.uid);
      } else if (user == null) {
        _clearUserData();
      }
    });
  }

  void _subscribeToUserData(String uid) {
    print("UserController: Subscribing to user data for UID: $uid");

    // Don't show loading if we have cached data
    if (_currentUser.value == null) {
      print("UserController: No cached data, showing loading");
      _isLoading.value = true;
    } else {
      print(
        "UserController: Using cached data for user: ${_currentUser.value?.fullName}",
      );
    }
    _error.value = '';

    _userSubscription?.cancel();

    // Set a timeout for the user data subscription
    _userSubscription = _usersService
        .getUserProfileStream(uid)
        .timeout(const Duration(seconds: 8))
        .listen(
          (userData) {
            print("UserController: Received user data: ${userData?.fullName}");
            if (userData != null) {
              _currentUser.value = userData;
              _cacheUserData(userData);

              // Sync with AuthController's local storage if available
              final authController = _authController;
              if (authController != null) {
                authController.userdataStore(userData.toJson());
              }
            }

            _isLoading.value = false;
            _error.value = '';
            _isInitialized.value = true;
            print("UserController: User data loading completed");
          },
          onError: (err) {
            print('UserController stream error: $err');
            // Only show error if we don't have cached data
            if (_currentUser.value == null) {
              _error.value = 'Failed to load user data';
            }
            _isLoading.value = false;
            _isInitialized.value = true; // Mark as initialized even on error
          },
        );

    // Safety timeout to ensure loading state is cleared
    Future.delayed(const Duration(seconds: 10), () {
      if (_isLoading.value) {
        print("UserController: Timeout reached, clearing loading state");
        _isLoading.value = false;
        _isInitialized.value = true;
        if (_currentUser.value == null) {
          _error.value = 'Timeout loading user data';
        }
      }
    });
  }

  void _clearUserData() {
    _currentUser.value = null;
    _userSubscription?.cancel();
    _isLoading.value = false;
    _error.value = '';
    _isInitialized.value = false;
    _currentUserId = null;
    _clearCache();
  }

  // Update user progress data
  Future<void> updateUserProgress({
    double? currentWeight,
    double? fatLost,
    double? muscleGained,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      await _usersService.updateUserProgress(
        uid: user.uid,
        currentWeight: currentWeight,
        fatLost: fatLost,
        muscleGained: muscleGained,
      );
    } catch (e) {
      _error.value = 'Failed to update progress: $e';
      print('Update progress error: $e');
    }
  }

  // Update user profile data
  Future<void> updateUserProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? profileImage,
    int? age,
    double? weight,
    int? height,
    String? activityLevel,
    List<String>? goals,
  }) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final currentUserData = _currentUser.value;
      if (currentUserData == null) throw Exception('No user data available');

      // Create updated user model
      final updatedUser = UserModel(
        id: currentUserData.id,
        email: currentUserData.email, // Email shouldn't change
        username: currentUserData.username, // Keep existing username
        firstName: firstName ?? currentUserData.firstName,
        lastName: lastName ?? currentUserData.lastName,
        phone: phone ?? currentUserData.phone,
        profileImage: profileImage ?? currentUserData.profileImage,
        age: age ?? currentUserData.age,
        weight: weight ?? currentUserData.weight,
        height: height ?? currentUserData.height,
        activityLevel: activityLevel ?? currentUserData.activityLevel,
        goals: goals ?? currentUserData.goals,
        joinDate: currentUserData.joinDate, // Keep original join date
        planName: currentUserData.planName,
        planDuration: currentUserData.planDuration,
        progressPercentage: currentUserData.progressPercentage,
      );

      await _usersService.updateUserProfile(updatedUser);

      // Update cache immediately
      _currentUser.value = updatedUser;
      _cacheUserData(updatedUser);

      // Sync with AuthController's local storage if available
      final authController = _authController;
      if (authController != null) {
        await authController.userdataStore(updatedUser.toJson());
      }

      _isLoading.value = false;
    } catch (e) {
      _error.value = 'Failed to update profile: $e';
      _isLoading.value = false;
      print('Update profile error: $e');
      rethrow;
    }
  }

  // Method to upload profile image (Using Base64 for Firestore storage - Free alternative)
  Future<void> uploadProfileImage(File file) async {
    try {
      _isLoading.value = true;
      _error.value = '';

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Read file bytes
      final bytes = await file.readAsBytes();

      // Check size (Firestore limit is 1MB total per document, aim for < 100KB for profile)
      if (bytes.lengthInBytes > 500000) {
        throw Exception(
          'Image is too large. Please choose a smaller image or resize it.',
        );
      }

      // Convert to Base64 string
      final String base64Image =
          'data:image/jpeg;base64,${base64Encode(bytes)}';

      // Update the user profile with the Base64 string instead of a URL
      await updateUserProfile(profileImage: base64Image);

      _isLoading.value = false;
    } catch (e) {
      _error.value = 'Failed to save profile image: $e';
      _isLoading.value = false;
      print('Save profile image error: $e');
      rethrow;
    }
  }

  // Refresh user data manually
  Future<void> refreshUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _subscribeToUserData(user.uid);
    }
  }

  // Check if user data is valid
  bool get isUserDataValid {
    final user = currentUser;
    if (user == null) return false;
    return user.validateUserData() == null;
  }

  // Get validation error message
  String? get userDataValidationError {
    return currentUser?.validateUserData();
  }

  // Force refresh from server (bypass cache)
  Future<void> forceRefresh() async {
    _clearCache();
    await refreshUserData();
  }
}
