import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/meal_model.dart';
import '../../../data/models/meal_category_model.dart';
import '../../../data/models/group_model.dart';
import '../../../data/services/dummy_data_service.dart';
import '../../../data/services/meals_firestore_service.dart';
import '../../../data/services/groups_firestore_service.dart';
import '../../../data/services/meal_categories_firestore_service.dart';

class ClientDashboardControllers extends GetxController {
  final MealsFirestoreService _mealsService = MealsFirestoreService();
  final MealCategoriesFirestoreService _categoriesService =
      MealCategoriesFirestoreService();
  final GetStorage _storage = GetStorage();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
  final isSearchFocused = false.obs;

  // Default categories (always available)
  final List<String> defaultCategories = [
    'Breakfast',
    'Lunch',
    'Morning Snacks',
    'Preworkout',
    'Post Workout',
    'Dinner',
  ];

  // Dynamic categories from selected group
  var groupCategories = <String>[].obs;
  StreamSubscription? _categoriesSubscription;

  // Combined categories (default + group custom categories)
  /// OPTIMIZED: Removed excessive logging for better performance
  List<String> get categories {
    // In group mode, ALWAYS show group categories (even if empty during load)
    if (isGroupMode.value) {
      return groupCategories;
    }

    // In personal mode, show default categories
    final allCategories = <String>{};
    allCategories.addAll(defaultCategories);

    // Add group custom categories (excluding defaults to avoid duplicates)
    for (var category in groupCategories) {
      if (!defaultCategories.contains(category)) {
        allCategories.add(category);
      }
    }

    return allCategories.toList();
  }

  // Group Mode properties
  final isGroupMode = false.obs;
  final isGroupModeLoading = false.obs; // Loading state for smooth transitions
  final selectedGroupId = Rxn<String>();
  final selectedGroupName = ''.obs;
  final selectedGroupCategoryId = Rxn<String>(); // Track group category ID
  final groupMeals = <MealModel>[].obs;
  final todayMealSlots = <String, String?>{}.obs; // Category → MealId mapping
  final userGroups =
      <GroupModel>[].obs; // Store user's groups for role checking

  // Group Stats - Reactive state for Live Stats card
  final RxMap<String, dynamic> groupStats = <String, dynamic>{}.obs;

  StreamSubscription? _groupMealsSubscription;

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
    _categoriesSubscription?.cancel();
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

      // Use Firestore stream for real-time updates
      await _setupMealsStream(user.uid);

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

  final GroupsFirestoreService _groupsService = GroupsFirestoreService();
  final Map<String, List<MealModel>> _mealsMap = {};
  final List<StreamSubscription> _subscriptions = [];

  Future<void> _setupMealsStream(String userId) async {
    try {
      print(
        "ClientDashboardControllers: Setting up meals stream for user: $userId",
      );

      // Cancel existing subscriptions
      for (var sub in _subscriptions) {
        sub.cancel();
      }
      _subscriptions.clear();
      _mealsMap.clear();

      // 1. Subscribe to User's Personal Meals
      _subscribeToStream(
        'user_$userId',
        _mealsService.getUserMealsStream(userId),
      );

      // 2. Fetch User's Groups and Subscribe to Group Meals
      try {
        final fetchedGroups = await _groupsService.getUserGroups(userId);
        print(
          "ClientDashboardControllers: Found ${fetchedGroups.length} groups for user",
        );

        // Store user groups for role checking
        userGroups.value = fetchedGroups;

        for (var group in fetchedGroups) {
          if (group.id != null) {
            _subscribeToStream(
              'group_${group.id}',
              _mealsService.getMealsStream(group.id!),
            );
          }
        }
      } catch (e) {
        print("ClientDashboardControllers: Error fetching user groups: $e");
      }

      print("ClientDashboardControllers: Meals stream setup completed");
    } catch (e) {
      print("ClientDashboardControllers: Failed to setup meals stream: $e");
      // Fallback to one-time fetch if stream fails
      await _tryFallbackQuery(userId);
    }
  }

  void _subscribeToStream(String sourceKey, Stream<List<MealModel>> stream) {
    final subscription = stream.listen(
      (newMeals) {
        _mealsMap[sourceKey] = newMeals;
        _mergeAndUpdateMeals();
      },
      onError: (error) {
        print(
          "ClientDashboardControllers: Stream error for $sourceKey: $error",
        );
        // Don't fail everything, just log
      },
    );
    _subscriptions.add(subscription);
  }

  void _mergeAndUpdateMeals() {
    final allMeals = <MealModel>[];

    // Merge all meals from different sources
    for (var mealList in _mealsMap.values) {
      allMeals.addAll(mealList);
    }

    // Remove duplicates based on ID (just in case)
    final uniqueMeals = <String, MealModel>{};
    for (var meal in allMeals) {
      if (meal.id != null) {
        uniqueMeals[meal.id!] = meal;
      }
    }

    // Convert back to list and sort
    final sortedMeals = uniqueMeals.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    meals.value = sortedMeals;
    _cacheMeals(sortedMeals);

    // Clear loading and error states
    isLoading.value = false;
    isRefreshing.value = false;
    error.value = '';

    // Force UI update
    update();
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
    // Start with all meals (master list)
    var filtered = List<MealModel>.from(meals);

    // DEBUG: Log the data flow
    print('🔍 SEARCH DEBUG - Total meals in allMeals: ${meals.length}');
    print('🔍 SEARCH DEBUG - Search query raw: "${searchQuery.value}"');
    print(
      '🔍 SEARCH DEBUG - Search query trimmed: "${searchQuery.value.trim()}"',
    );
    print('🔍 SEARCH DEBUG - isSearchFocused: $isSearchFocused');

    // CRITICAL: Check if search query has actual content (after trimming)
    final trimmedQuery = searchQuery.value.trim();

    if (trimmedQuery.isNotEmpty) {
      // SEARCH MODE: Search across ALL meals, ignore category
      final query = trimmedQuery.toLowerCase();
      print('🔍 SEARCH DEBUG - Entering search mode with query: "$query"');

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

        // Search in categories (meal type: Breakfast, Lunch, Dinner)
        final categoryMatch = meal.categories.any(
          (cat) => cat.toLowerCase().contains(query),
        );

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

        final matches =
            nameMatch ||
            descriptionMatch ||
            calorieMatch ||
            proteinMatch ||
            fatMatch ||
            carbsMatch ||
            categoryMatch ||
            ingredientMatch ||
            instructionsMatch ||
            prepTimeMatch ||
            difficultyMatch;

        if (matches) {
          print('🔍 SEARCH DEBUG - Match found: ${meal.name}');
        }

        return matches;
      }).toList();

      print('🔍 SEARCH DEBUG - Filtered meals count: ${filtered.length}');
    } else {
      // CATEGORY MODE: Filter by selected category only
      print(
        '🔍 SEARCH DEBUG - Category mode, selected: ${selectedCategory.value}',
      );
      filtered = filtered.where((meal) {
        return meal.categories.contains(selectedCategory.value);
      }).toList();
      print(
        '🔍 SEARCH DEBUG - Category filtered meals count: ${filtered.length}',
      );
    }

    return filtered;
  }

  // Display meals (computed property for UI) - ensures consistent results
  // Switches data source based on selectedGroupId, but UI remains the same
  List<MealModel> get displayMeals {
    // Determine which meal list to use based on group selection
    final sourceMeals = selectedGroupId.value != null ? groupMeals : meals;

    // Apply the same filtering logic regardless of source
    var filtered = List<MealModel>.from(sourceMeals);

    // Check if search query has actual content (after trimming)
    final trimmedQuery = searchQuery.value.trim();

    if (trimmedQuery.isNotEmpty) {
      // SEARCH MODE: Search across ALL meals, ignore category
      final query = trimmedQuery.toLowerCase();

      filtered = filtered.where((meal) {
        // Search in meal name
        final nameMatch = meal.name.toLowerCase().contains(query);

        // Search in description
        final descriptionMatch = meal.description.toLowerCase().contains(query);

        // Search in calories (kcal)
        final calorieMatch = meal.kcal.toLowerCase().contains(query);

        // Search in macros (protein, fat, carbs)
        final proteinMatch = meal.protein.toLowerCase().contains(query);
        final fatMatch = meal.fat.toLowerCase().contains(query);
        final carbsMatch = meal.carbs.toLowerCase().contains(query);

        // Search in categories
        final categoryMatch = meal.categories.any(
          (cat) => cat.toLowerCase().contains(query),
        );

        // Search in ingredients
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
            categoryMatch ||
            ingredientMatch ||
            instructionsMatch ||
            prepTimeMatch ||
            difficultyMatch;
      }).toList();
    } else {
      // CATEGORY MODE: Filter by selected category only
      filtered = filtered.where((meal) {
        return meal.categories.contains(selectedCategory.value);
      }).toList();
    }

    // Ensure deterministic ordering by sorting by name
    filtered.sort((a, b) => a.name.compareTo(b.name));
    return filtered;
  }

  // Enhanced category change with immediate UI update
  void changeCategory(String category) {
    if (selectedCategory.value != category) {
      selectedCategory.value = category;
      // Keep search query active when changing categories
      // This allows search + category filtering to work together
      update(); // Force immediate UI update
    }
  }

  // Enhanced search with immediate update
  void updateSearchQuery(String query) {
    print('📝 CONTROLLER DEBUG - updateSearchQuery called with: "$query"');
    // Ensure the query is updated and UI is rebuilt
    // We update even if values match because SimpleRealTimeSearchBar might have already
    // updated the RxString directly, but we still need to trigger GetBuilder's update()
    searchQuery.value = query;
    print('📝 CONTROLLER DEBUG - Calling update() to rebuild UI');
    update();
  }

  // Called when search field is focused/activated
  void onSearchFocused() {
    if (!isSearchFocused.value) {
      isSearchFocused.value = true;
      update(); // Force immediate UI update
    }
  }

  // Called when search field loses focus and is empty
  void onSearchBlurred() {
    // Only blur if search is empty
    if (searchQuery.value.isEmpty && isSearchFocused.value) {
      isSearchFocused.value = false;
      update(); // Force immediate UI update
    }
  }

  // Clear search and exit search mode
  void clearSearch() {
    searchQuery.value = '';
    isSearchFocused.value = false;
    update(); // Force immediate UI update
  }

  // Refresh meals data with pull-to-refresh
  Future<void> refreshMeals() async {
    isRefreshing.value = true;

    // If user is authenticated, reload data
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Re-setup the stream to get fresh data
      await _setupMealsStream(user.uid);
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

  // Check if search is active (only true when user has actually entered text)
  bool get isSearchActive => searchQuery.value.trim().isNotEmpty;

  // Check if category buttons should be visible (show them unless user is actively searching with text)
  bool get shouldShowCategoryButtons => !isSearchActive;

  // Check if we should show meals (only when not in search mode OR when search has text)
  bool get shouldShowMeals =>
      !isSearchFocused.value || searchQuery.value.isNotEmpty;

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

  // ========== GROUP MODE METHODS ==========

  /// Enter Group Mode - Switch dashboard to show only group meals
  /// OPTIMIZED: Reduced loading time and improved state management
  void enterGroupMode(String groupId, String groupName) {
    // Prevent rapid switching
    if (isGroupModeLoading.value) return;

    print('🔵 GROUP SWITCHED → $groupId');
    print('🔵 ENTERING GROUP MODE: $groupName (ID: $groupId)');

    // Set group mode immediately for instant UI feedback
    selectedGroupId.value = groupId;
    selectedGroupName.value = groupName;
    isGroupMode.value = true;

    // Clear search when entering group mode
    searchQuery.value = '';
    isSearchFocused.value = false;

    // Clear previous group data immediately
    groupMeals.clear();
    todayMealSlots.clear();
    groupCategories.clear(); // Clear old categories

    // Load group stats for Live Stats card
    _loadGroupStats(groupId);

    // Load categories and meal plan in parallel for faster loading
    _loadGroupCategories(groupId);
    fetchTodayGroupPlan(groupId);

    print('🔵 Group mode activated');
  }

  /// Load categories for the selected group
  /// OPTIMIZED: Reduced logging, faster execution
  Future<void> _loadGroupCategories(String groupId) async {
    // Cancel existing subscription
    _categoriesSubscription?.cancel();

    try {
      print('🔵 Dashboard: Loading categories for group: $groupId');

      // Get the group to find its groupCategoryId
      final groupDoc = await _firestore.collection('groups').doc(groupId).get();

      if (!groupDoc.exists) {
        print('❌ Dashboard: Group document does not exist');
        groupCategories.assignAll([]);
        selectedGroupCategoryId.value = null;
        return;
      }

      final groupData = groupDoc.data();
      final groupCategoryId = groupData?['group_category_id'] as String?;

      print('🔵 Dashboard: Group category ID from Firestore: $groupCategoryId');

      if (groupCategoryId == null) {
        print('❌ Dashboard: Group category ID is null');
        groupCategories.assignAll([]);
        selectedGroupCategoryId.value = null;
        return;
      }

      // Store the group category ID for use in Create Meal
      selectedGroupCategoryId.value = groupCategoryId;
      print(
        '🟢 Dashboard: Stored group category ID: ${selectedGroupCategoryId.value}',
      );

      // Get the current user ID
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        print('❌ Dashboard: User ID is null');
        groupCategories.assignAll([]);
        selectedGroupCategoryId.value = null;
        return;
      }

      // Subscribe to meal categories stream
      _categoriesSubscription = _firestore
          .collection('users')
          .doc(userId)
          .collection('group_categories')
          .doc(groupCategoryId)
          .collection('meal_categories')
          .orderBy('order')
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              final data = doc.data();
              return MealCategoryModel.fromJson(data, docId: doc.id);
            }).toList();
          })
          .listen(
            (categoryModels) {
              final categoryNames = categoryModels.map((c) => c.name).toList();

              // Use assignAll for proper reactive update
              groupCategories.assignAll(categoryNames);

              // If selected category doesn't exist in new categories, reset to first
              if (groupCategories.isNotEmpty &&
                  !groupCategories.contains(selectedCategory.value)) {
                selectedCategory.value = groupCategories.first;
              }
            },
            onError: (error) {
              print('❌ ERROR loading categories: $error');
              groupCategories.assignAll([]);
            },
          );
    } catch (e) {
      print('❌ EXCEPTION in _loadGroupCategories: $e');
      groupCategories.assignAll([]);
    }
  }

  /// Exit Group Mode - Restore normal dashboard
  void exitGroupMode() {
    // Cancel group meals subscription
    _groupMealsSubscription?.cancel();
    _groupMealsSubscription = null;

    // Cancel categories subscription
    _categoriesSubscription?.cancel();
    _categoriesSubscription = null;

    // Clear group state immediately
    isGroupMode.value = false;
    selectedGroupId.value = null;
    selectedGroupName.value = '';
    groupMeals.clear();
    todayMealSlots.clear();
    groupCategories.clear();
    groupStats.clear(); // Clear group stats

    // Reset to default category
    selectedCategory.value = 'Breakfast';

    // Clear search
    searchQuery.value = '';
    isSearchFocused.value = false;

    // Force UI update to reload personal meals
    update();
  }

  /// Compute group stats from actual meals filtered by groupId and today's date
  Future<void> _loadGroupStats(String groupId) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;

      // Fetch all meals for this group
      final snapshot = await _firestore
          .collection('meals')
          .where('groupId', isEqualTo: groupId)
          .get();

      final allMeals = snapshot.docs
          .map((d) => MealModel.fromJson(d.data(), docId: d.id))
          .toList();

      // Today's meals only
      final today = DateTime.now();
      final todayMeals = allMeals.where((m) {
        return m.createdAt.year == today.year &&
            m.createdAt.month == today.month &&
            m.createdAt.day == today.day;
      }).toList();

      // Compute totals
      double totalCal = 0, totalProtein = 0, totalCarbs = 0, totalFat = 0;
      for (final m in todayMeals) {
        totalCal += double.tryParse(m.kcal) ?? 0;
        totalProtein += double.tryParse(m.protein) ?? 0;
        totalCarbs += double.tryParse(m.carbs) ?? 0;
        totalFat += double.tryParse(m.fat) ?? 0;
      }

      // Fetch group goal calories from group doc
      final groupDoc = await _firestore.collection('groups').doc(groupId).get();
      final goalCal =
          double.tryParse(groupDoc.data()?['goalCalories']?.toString() ?? '') ??
          2000.0;

      final remaining = (goalCal - totalCal).clamp(0, goalCal);
      final pct = goalCal > 0
          ? ((totalCal / goalCal) * 100).clamp(0, 100).toStringAsFixed(0)
          : '0';

      groupStats.assignAll({
        'totalCalories': totalCal.toStringAsFixed(0),
        'totalProtein': '${totalProtein.toStringAsFixed(1)}g',
        'totalCarbs': '${totalCarbs.toStringAsFixed(1)}g',
        'totalFat': '${totalFat.toStringAsFixed(1)}g',
        'remainingCalories': remaining.toStringAsFixed(0),
        'totalMeals': todayMeals.length.toString(),
        'goalAchieved': '$pct%',
        'fatLost': '${totalFat.toStringAsFixed(1)}g',
        'muscleGained': '${totalProtein.toStringAsFixed(1)}g',
      });
    } catch (e) {
      groupStats.clear();
    }
  }

  /// Fetch TODAY's meal plan for a specific group
  /// This loads only the meals assigned for today's date
  void fetchTodayGroupPlan(String groupId) {
    // Get today's date in yyyy-MM-dd format
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    // Cancel existing subscription
    _groupMealsSubscription?.cancel();

    // Subscribe to today's meal plan document
    _groupMealsSubscription = _firestore
        .collection('group_meal_plans')
        .where('groupId', isEqualTo: groupId)
        .where('date', isEqualTo: todayStr)
        .limit(1)
        .snapshots()
        .listen(
          (snapshot) async {
            if (snapshot.docs.isEmpty) {
              todayMealSlots.clear();
              groupMeals.clear();
              return;
            }

            final planDoc = snapshot.docs.first;
            final planData = planDoc.data();
            final mealSlots = planData['mealSlots'] as Map<String, dynamic>?;

            if (mealSlots == null || mealSlots.isEmpty) {
              todayMealSlots.clear();
              groupMeals.clear();
              return;
            }

            // Store the mealSlots structure (category → mealId)
            todayMealSlots.value = Map<String, String?>.from(
              mealSlots.map((key, value) => MapEntry(key, value?.toString())),
            );

            // Extract all meal IDs from mealSlots
            final mealIds = mealSlots.values
                .where((id) => id != null && id.toString().isNotEmpty)
                .map((id) => id.toString())
                .toList();

            if (mealIds.isEmpty) {
              groupMeals.clear();
              return;
            }

            // Fetch meals from meals collection where documentId IN mealIds
            try {
              List<MealModel> allMeals = [];

              // Handle Firestore whereIn limit (max 10 items)
              if (mealIds.length <= 10) {
                // Single query for 10 or fewer IDs
                final mealsSnapshot = await _firestore
                    .collection('meals')
                    .where('groupId', isEqualTo: groupId)
                    .where(FieldPath.documentId, whereIn: mealIds)
                    .get();

                allMeals = mealsSnapshot.docs
                    .map((doc) => MealModel.fromJson(doc.data(), docId: doc.id))
                    .toList();
              } else {
                // Chunked queries for more than 10 IDs
                for (int i = 0; i < mealIds.length; i += 10) {
                  final chunk = mealIds.sublist(
                    i,
                    (i + 10 < mealIds.length) ? i + 10 : mealIds.length,
                  );

                  final mealsSnapshot = await _firestore
                      .collection('meals')
                      .where('groupId', isEqualTo: groupId)
                      .where(FieldPath.documentId, whereIn: chunk)
                      .get();

                  final chunkMeals = mealsSnapshot.docs
                      .map(
                        (doc) => MealModel.fromJson(doc.data(), docId: doc.id),
                      )
                      .toList();

                  allMeals.addAll(chunkMeals);
                }
              }

              groupMeals.value = allMeals;
            } catch (e) {
              print('Error fetching group meals: $e');
              groupMeals.clear();
            }
          },
          onError: (error) {
            print('Stream error: $error');
            todayMealSlots.clear();
            groupMeals.clear();
          },
        );
  }

  /// Get meal by ID from groupMeals list
  MealModel? getMealByIdFromGroup(String? mealId) {
    if (mealId == null || mealId.isEmpty) return null;
    return groupMeals.firstWhereOrNull((meal) => meal.id == mealId);
  }

  /// Check if current user is admin of the selected group
  /// Returns true if:
  /// - No group is selected (personal mode)
  /// - User is the admin (createdBy) of the selected group
  /// Returns false if:
  /// - User is only a member of the selected group
  bool isCurrentUserAdminOfSelectedGroup() {
    // If no group selected, user is in personal mode (allow Add Meal)
    if (selectedGroupId.value == null) {
      return true;
    }

    // Get current user ID
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return false;
    }

    final userId = user.uid;

    // Find the selected group in user's groups
    final selectedGroup = userGroups.firstWhereOrNull(
      (group) => group.id == selectedGroupId.value,
    );

    // If group not found, deny access
    if (selectedGroup == null) {
      return false;
    }

    // Check if user is admin using the group's isAdmin method
    return selectedGroup.isAdmin(userId);
  }

  /// Check if Add Meal button should be visible
  /// Visible when:
  /// - In personal mode (no group selected), OR
  /// - In group mode AND user is admin of the group
  bool get shouldShowAddMealButton {
    return isCurrentUserAdminOfSelectedGroup();
  }
}
