import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../data/models/user_model.dart';
import '../data/services/users_firestore_service.dart';
import '../core/base/controllers/auth_controller.dart';

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

  // Public getters with caching fallback
  UserModel? get currentUser => _currentUser.value ?? _getCachedUser();
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  bool get isInitialized => _isInitialized.value;

  // Stream subscriptions for cleanup
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<UserModel?>? _userSubscription;
  String? _currentUserId;

  @override
  void onInit() {
    super.onInit();
    _loadCachedData();
    // Delay initialization to allow AuthController to be ready
    Future.delayed(Duration.zero, () {
      _initializeAuthListener();
    });
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    _userSubscription?.cancel();
    super.onClose();
  }

  // Computed properties for UI with caching fallback
  String get fullName => currentUser?.fullName ?? 'User';
  String get profileImage => currentUser?.profileImage ?? '';
  String get email => currentUser?.email ?? '';
  int get currentDay => currentUser?.currentDay ?? 1;
  double get goalProgress => currentUser?.goalAchievedPercentage ?? 0.0;
  String get primaryGoal => currentUser?.primaryGoal ?? 'General Fitness';

  // Live stats calculations
  String get fatLost => currentUser?.fatLostDisplay ?? '0kg';
  String get muscleGained => currentUser?.muscleGainedDisplay ?? '0g';
  String get goalAchievedPercent => currentUser?.goalProgressDisplay ?? '0%';
  String get dayCountDisplay => currentUser?.dayCountDisplay ?? 'Day 1/55';
  String get planDateRange => currentUser?.planDateRange ?? '';

  // User stats for profile display
  String get weightDisplay =>
      currentUser != null ? '${currentUser!.weight.toInt()}' : '0';
  String get ageDisplay => currentUser?.age.toString() ?? '0';
  String get heightDisplay => currentUser?.height.toString() ?? '0';

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
    // Check if AuthController is available
    final authController = _authController;
    if (authController == null) {
      // Fallback to direct Firebase Auth if AuthController is not ready
      _authSubscription = FirebaseAuth.instance.authStateChanges().listen((
        user,
      ) {
        if (user != null && user.uid != _currentUserId) {
          _currentUserId = user.uid;
          _subscribeToUserData(user.uid);
        } else if (user == null) {
          _clearUserData();
        }
      });
      return;
    }

    // Listen to AuthController's authentication state
    _authSubscription = authController.firebaseUser.listen((user) {
      if (user != null && user.uid != _currentUserId) {
        _currentUserId = user.uid;
        _subscribeToUserData(user.uid);
      } else if (user == null) {
        _clearUserData();
      }
    });
  }

  void _subscribeToUserData(String uid) {
    // Don't show loading if we have cached data
    if (_currentUser.value == null) {
      _isLoading.value = true;
    }
    _error.value = '';

    _userSubscription?.cancel();

    // Set a timeout for the user data subscription
    _userSubscription = _usersService
        .getUserProfileStream(uid)
        .timeout(const Duration(seconds: 8))
        .listen(
          (userData) {
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
