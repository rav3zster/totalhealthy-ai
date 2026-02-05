import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/meal_model.dart';
import '../../../data/services/dummy_data_service.dart';
import '../../../data/services/meals_firestore_service.dart';

class ClientDashboardControllers extends GetxController {
  final MealsFirestoreService _mealsService = MealsFirestoreService();
  final GetStorage _storage = GetStorage();

  // Cache keys
  static const String _mealsCacheKey = 'cached_meals_data';
  static const String _lastMealsFetchKey = 'last_meals_fetch';
  static const Duration _cacheExpiry = Duration(minutes: 3);

  // Reactive properties - Start with false to show UI immediately
  final meals = <MealModel>[].obs;
  final isLoading = false.obs;
  final isRefreshing = false.obs;
  final selectedCategory = 'Breakfast'.obs;
  final searchQuery = ''.obs;
  final error = ''.obs;

  // Stream subscription for cleanup
  StreamSubscription<List<MealModel>>? _mealsSubscription;
  StreamSubscription<User?>? _authSubscription;
  String? _currentUserId;
  bool _isInitialized = false;
  bool _isWaitingForAuth = true;

  @override
  void onInit() {
    super.onInit();
    print("ClientDashboardControllers: onInit called");
    _loadCachedMeals();

    // CRITICAL: Wait for auth state before loading data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listenToAuthState();
    });

    // Safety mechanism: Force clear loading state after 15 seconds
    Future.delayed(const Duration(seconds: 15), () {
      if (isLoading.value) {
        print(
          "ClientDashboardControllers: Timeout reached, clearing loading state",
        );
        isLoading.value = false;
        _isWaitingForAuth = false;
        if (meals.isEmpty && error.value.isEmpty) {
          error.value = 'Loading timeout - please refresh';
        }
        update(); // Force UI update
      }
    });
  }

  @override
  void onClose() {
    _mealsSubscription?.cancel();
    _authSubscription?.cancel();
    super.onClose();
  }

  void _loadCachedMeals() {
    try {
      final cachedData = _storage.read(_mealsCacheKey);
      final lastFetch = _storage.read(_lastMealsFetchKey);

      if (cachedData != null && lastFetch != null) {
        final lastFetchTime = DateTime.fromMillisecondsSinceEpoch(lastFetch);
        final isExpired =
            DateTime.now().difference(lastFetchTime) > _cacheExpiry;

        if (!isExpired && cachedData is List) {
          meals.value = cachedData
              .map(
                (json) => MealModel.fromJson(Map<String, dynamic>.from(json)),
              )
              .toList();
        }
      }
    } catch (e) {
      // Cache loading failed, continue without cached data
    }
  }

  void _cacheMeals(List<MealModel> mealsData) {
    try {
      final jsonList = mealsData.map((meal) => meal.toJson()).toList();
      _storage.write(_mealsCacheKey, jsonList);
      _storage.write(_lastMealsFetchKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Cache saving failed, continue without caching
    }
  }

  void _listenToAuthState() {
    print("ClientDashboardControllers: Setting up auth state listener");

    // Listen to Firebase Auth state changes
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      print(
        "ClientDashboardControllers: Auth state changed - User: ${user?.uid}",
      );

      if (user != null) {
        // User is authenticated, initialize data
        _isWaitingForAuth = false;
        if (user.uid != _currentUserId) {
          _currentUserId = user.uid;
          _initData();
        }
      } else {
        // User is not authenticated, clear data and show appropriate state
        _isWaitingForAuth = false;
        _currentUserId = null;
        _clearDataForUnauthenticatedUser();
      }
    });
  }

  void _clearDataForUnauthenticatedUser() {
    print("ClientDashboardControllers: Clearing data for unauthenticated user");
    meals.clear();
    isLoading.value = false;
    isRefreshing.value = false;
    error.value = '';
    _isInitialized = false;
    update();
  }

  Future<void> _initData() async {
    if (_isInitialized) {
      print("ClientDashboardControllers: Already initialized, skipping");
      return;
    }

    print("ClientDashboardControllers: Starting data initialization");

    try {
      // Only show loading if we don't have cached data
      if (meals.isEmpty) {
        print("ClientDashboardControllers: No cached data, showing loading");
        isLoading.value = true;
      } else {
        print(
          "ClientDashboardControllers: Using cached data (${meals.length} meals)",
        );
      }
      error.value = '';

      // Get current user ID for user-specific meals
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Don't throw error, just wait for auth state
        print(
          "ClientDashboardControllers: No authenticated user, waiting for auth",
        );
        isLoading.value = false;
        return;
      }

      print("ClientDashboardControllers: User authenticated: ${user.uid}");
      _currentUserId = user.uid;

      // Seed dummy data in background (don't wait for it)
      _seedDummyDataInBackground();

      // Try fallback approach immediately since Firebase stream has issues
      await _tryFallbackQuery(user.uid);

      _isInitialized = true;
      print(
        "ClientDashboardControllers: Initialization completed successfully",
      );
    } catch (e) {
      print("ClientDashboardControllers: Initialization failed: $e");
      error.value = 'Failed to initialize: ${e.toString()}';
      isLoading.value = false;
      isRefreshing.value = false;
      _isInitialized = true; // Mark as initialized even on error

      // CRITICAL: Force UI update for GetBuilder
      update();
    }
  }

  Future<void> _tryFallbackQuery(String userId) async {
    try {
      print("ClientDashboardControllers: Fetching meals for user: $userId");

      // Fallback: Get all meals and filter locally
      final allMeals = await _mealsService.getMeals();
      print(
        "ClientDashboardControllers: Retrieved ${allMeals.length} total meals from Firebase",
      );

      // Validate userId filtering
      if (userId.isEmpty) {
        throw Exception('Invalid user ID for filtering');
      }

      final userMeals = allMeals.where((meal) {
        return meal.userId == userId;
      }).toList();

      print(
        "ClientDashboardControllers: Filtered to ${userMeals.length} meals for user",
      );

      meals.value = userMeals;
      _cacheMeals(userMeals);

      // CRITICAL: Always clear loading state
      isLoading.value = false;
      isRefreshing.value = false;
      error.value = '';

      print("ClientDashboardControllers: Data loading completed successfully");

      // CRITICAL: Force UI update for GetBuilder
      update();
    } catch (e) {
      print("ClientDashboardControllers: Fallback query failed: $e");

      // CRITICAL: Always clear loading state even on error
      isLoading.value = false;
      isRefreshing.value = false;

      // Only show error if we don't have cached data
      if (meals.isEmpty) {
        error.value = 'Failed to load meals - check connection';
      }

      // CRITICAL: Force UI update for GetBuilder
      update();
    }
  }

  void _seedDummyDataInBackground() {
    // Run in background without blocking UI
    Future.microtask(() async {
      try {
        await DummyDataService.uploadDummyMealsToFirestore();
      } catch (e) {
        // Seeding failed, continue without dummy data
      }
    });
  }

  // Enhanced filtered meals with comprehensive search functionality
  List<MealModel> get filteredMeals {
    // Start with all meals
    var filtered = List<MealModel>.from(meals);

    // Apply category filter first - ALWAYS filter by category
    filtered = filtered.where((meal) {
      return meal.categories.contains(selectedCategory.value);
    }).toList();

    // Apply search filter if query is not empty
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase().trim();

      filtered = filtered.where((meal) {
        // Search in meal name
        final nameMatch = meal.name.toLowerCase().contains(query);

        // Search in description
        final descriptionMatch = meal.description.toLowerCase().contains(query);

        // Search in calories (kcal) - handle both string and numeric search
        final calorieMatch = meal.kcal.toLowerCase().contains(query);

        // Search in macros (protein, fat, carbs) - handle both string and numeric
        final proteinMatch = meal.protein.toLowerCase().contains(query);
        final fatMatch = meal.fat.toLowerCase().contains(query);
        final carbsMatch = meal.carbs.toLowerCase().contains(query);

        // Search in ingredients (name, amount, unit)
        final ingredientMatch = meal.ingredients.any(
          (ingredient) =>
              ingredient.name.toLowerCase().contains(query) ||
              ingredient.amount.toLowerCase().contains(query) ||
              ingredient.unit.toLowerCase().contains(query),
        );

        // Search in instructions
        final instructionsMatch = meal.instructions.toLowerCase().contains(
          query,
        );

        // Search in prep time and difficulty
        final prepTimeMatch = meal.prepTime.toLowerCase().contains(query);
        final difficultyMatch = meal.difficulty.toLowerCase().contains(query);

        return nameMatch ||
            descriptionMatch ||
            calorieMatch ||
            proteinMatch ||
            fatMatch ||
            carbsMatch ||
            ingredientMatch ||
            instructionsMatch ||
            prepTimeMatch ||
            difficultyMatch;
      }).toList();
    }

    return filtered;
  }

  // Display meals (computed property for UI) - ensures consistent results
  List<MealModel> get displayMeals {
    final result = filteredMeals;
    // Ensure deterministic ordering by sorting by name
    result.sort((a, b) => a.name.compareTo(b.name));
    return result;
  }

  // Enhanced category change with immediate UI update
  void changeCategory(String category) {
    if (selectedCategory.value != category) {
      selectedCategory.value = category;
      // Clear search when changing categories for better UX
      if (searchQuery.value.isNotEmpty) {
        searchQuery.value = '';
      }
      update(); // Force immediate UI update
    }
  }

  // Enhanced search with debouncing for better performance
  void updateSearchQuery(String query) {
    final trimmedQuery = query.trim();
    if (searchQuery.value != trimmedQuery) {
      searchQuery.value = trimmedQuery;
      update(); // Force immediate UI update
    }
  }

  // Clear search and update UI
  void clearSearch() {
    if (searchQuery.value.isNotEmpty) {
      searchQuery.value = '';
      update(); // Force immediate UI update
    }
  }

  // Refresh meals data with pull-to-refresh
  Future<void> refreshMeals() async {
    isRefreshing.value = true;
    _isInitialized = false;

    // If user is authenticated, reload data
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _initData();
    } else {
      // If not authenticated, just clear the refreshing state
      isRefreshing.value = false;
    }
  }

  // Force refresh from server (bypass cache)
  Future<void> forceRefresh() async {
    try {
      _storage.remove(_mealsCacheKey);
      _storage.remove(_lastMealsFetchKey);
    } catch (e) {
      // Cache clear failed, continue anyway
    }
    _isInitialized = false;
    await refreshMeals();
  }

  // Delete a meal from Firebase and update local state
  Future<bool> deleteMeal(MealModel meal) async {
    try {
      if (meal.id == null) {
        error.value = 'Cannot delete meal: Invalid meal ID';
        return false;
      }

      // Show loading state
      isLoading.value = true;
      error.value = '';

      // Delete from Firebase
      await _mealsService.deleteMeal(meal.id!);

      // Remove from local state immediately for better UX
      final updatedMeals = List<MealModel>.from(meals);
      updatedMeals.removeWhere((m) => m.id == meal.id);
      meals.value = updatedMeals;

      // Update cache
      _cacheMeals(updatedMeals);

      // Clear loading state
      isLoading.value = false;

      print(
        "ClientDashboardControllers: Meal '${meal.name}' deleted successfully",
      );

      // Force UI update
      update();

      return true;
    } catch (e) {
      print("ClientDashboardControllers: Failed to delete meal: $e");
      error.value = 'Failed to delete meal: ${e.toString()}';
      isLoading.value = false;
      update();
      return false;
    }
  }

  // Get meal count for current category
  int get currentCategoryMealCount {
    return meals
        .where((meal) => meal.categories.contains(selectedCategory.value))
        .length;
  }

  // Get search result count
  int get searchResultCount => filteredMeals.length;

  // Check if search is active
  bool get isSearchActive => searchQuery.value.isNotEmpty;

  // Check if we have any data (cached or fresh)
  bool get hasData => meals.isNotEmpty;

  // Check if we should show loading state (only when no data exists and either loading or waiting for auth)
  bool get shouldShowLoading =>
      (isLoading.value || _isWaitingForAuth) && meals.isEmpty;

  // Check if we should show error state (only when no data and error exists and not waiting for auth)
  bool get shouldShowError =>
      error.value.isNotEmpty && meals.isEmpty && !_isWaitingForAuth;

  // Check if current category has any meals at all
  bool get currentCategoryHasMeals => currentCategoryMealCount > 0;

  // Check if search has results
  bool get searchHasResults => isSearchActive && searchResultCount > 0;

  // Check if we should show empty state for category
  bool get shouldShowCategoryEmpty =>
      hasData && !isSearchActive && !currentCategoryHasMeals;

  // Check if we should show empty state for search
  bool get shouldShowSearchEmpty =>
      hasData && isSearchActive && !searchHasResults;

  // Get debug info for troubleshooting
  Map<String, dynamic> get debugInfo => {
    'totalMeals': meals.length,
    'categoryMeals': currentCategoryMealCount,
    'filteredMeals': searchResultCount,
    'selectedCategory': selectedCategory.value,
    'searchQuery': searchQuery.value,
    'isLoading': isLoading.value,
    'hasData': hasData,
    'isSearchActive': isSearchActive,
  };
}
