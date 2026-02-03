# Dynamic User Data Integration - Design Document

## Architecture Overview

This design implements a reactive data architecture using Firebase Auth + Firestore with GetX state management to provide real-time user data synchronization across the Flutter app.

### Core Components

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   UI Layer      │    │  Controller      │    │  Service Layer  │
│                 │    │  Layer           │    │                 │
│ - Profile View  │◄──►│ - UserController │◄──►│ - AuthService   │
│ - Dashboard     │    │ - DashController │    │ - UserFirestore │
│ - Search Bar    │    │ - SearchCtrl     │    │ - MealFirestore │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                ▲
                                │
                       ┌────────▼────────┐
                       │  Firebase       │
                       │  - Auth         │
                       │  - Firestore    │
                       └─────────────────┘
```

## Data Flow Design

### 1. User Authentication & Profile Loading

```dart
// Authentication Flow
FirebaseAuth.authStateChanges() 
  → UserController.onAuthStateChanged()
  → UsersFirestoreService.getUserProfileStream(uid)
  → UserController.updateUserData()
  → UI Reactive Updates
```

### 2. Real-time Data Synchronization

```dart
// Profile Data Stream
Stream<UserModel> getUserProfileStream(String uid) {
  return _firestore
    .collection('users')
    .doc(uid)
    .snapshots()
    .map((doc) => UserModel.fromJson(doc.data()));
}

// Meal Data Stream  
Stream<List<MealModel>> getUserMealsStream(String userId) {
  return _firestore
    .collection('meals')
    .where('userId', isEqualTo: userId)
    .orderBy('createdAt', descending: true)
    .snapshots()
    .map((snapshot) => snapshot.docs
      .map((doc) => MealModel.fromJson(doc.data()))
      .toList());
}
```

## Component Design

### 1. UserController (GetX Controller)

**Responsibilities:**
- Manage authenticated user state
- Provide real-time user data streams
- Calculate dynamic statistics
- Handle authentication state changes

**Key Properties:**
```dart
class UserController extends GetxController {
  // Reactive user data
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  
  // Computed properties
  String get fullName => currentUser.value?.fullName ?? 'User';
  String get profileImage => currentUser.value?.profileImage ?? '';
  int get currentDay => currentUser.value?.currentDay ?? 1;
  double get goalProgress => currentUser.value?.goalAchievedPercentage ?? 0.0;
  
  // Live stats calculations
  String get fatLost => _calculateFatLost();
  String get muscleGained => _calculateMuscleGained();
  String get goalAchievedPercent => '${goalProgress.toInt()}%';
}
```

### 2. DashboardController Enhancement

**New Responsibilities:**
- Manage meal search functionality
- Filter meals in real-time
- Handle meal category switching
- Coordinate with UserController for stats

**Key Properties:**
```dart
class DashboardController extends GetxController {
  // Search functionality
  final RxString searchQuery = ''.obs;
  final RxList<MealModel> filteredMeals = <MealModel>[].obs;
  final RxList<MealModel> allMeals = <MealModel>[].obs;
  
  // Category filtering
  final RxString selectedCategory = 'Breakfast'.obs;
  
  // Computed filtered meals
  List<MealModel> get displayMeals {
    var meals = allMeals.where((meal) => 
      meal.categories.contains(selectedCategory.value)).toList();
    
    if (searchQuery.value.isNotEmpty) {
      meals = meals.where((meal) => 
        meal.name.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }
    
    return meals;
  }
}
```

### 3. Enhanced UserModel

**New Calculated Properties:**
```dart
class UserModel {
  // ... existing properties ...
  
  // Dynamic calculations
  int get currentDay {
    final now = DateTime.now();
    final difference = now.difference(joinDate).inDays + 1;
    return difference > 0 ? difference : 1;
  }
  
  double get goalAchievedPercentage {
    switch (primaryGoal.toLowerCase()) {
      case 'weight loss':
        return _calculateWeightLossProgress();
      case 'muscle gain':
        return _calculateMuscleGainProgress();
      case 'maintenance':
        return _calculateMaintenanceProgress();
      default:
        return 0.0;
    }
  }
  
  String get dayCountDisplay => 'Day $currentDay/$goalDuration';
  
  String get planDateRange {
    final endDate = joinDate.add(Duration(days: goalDuration));
    final formatter = DateFormat('MMM d');
    return '${formatter.format(joinDate)} - ${formatter.format(endDate)}';
  }
}
```

## UI Component Design

### 1. Dynamic Profile Header

```dart
class DynamicProfileHeader extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingHeader();
      }
      
      if (controller.error.value.isNotEmpty) {
        return _buildErrorHeader();
      }
      
      return _buildProfileHeader(controller.currentUser.value);
    });
  }
  
  Widget _buildProfileHeader(UserModel? user) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: user?.profileImage.isNotEmpty == true
            ? NetworkImage(user!.profileImage)
            : AssetImage('assets/user_avatar.png') as ImageProvider,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome!', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              Text(user?.fullName ?? 'User', style: TextStyle(color: Colors.white70, fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }
}
```

### 2. Dynamic Live Stats Card

```dart
class DynamicLiveStatsCard extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Live Stats', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(controller.goalAchievedPercent, 'Goal Achieved', Colors.orange),
              _buildStatItem(controller.fatLost, 'Fat Lost', Colors.yellow),
              _buildStatItem(controller.muscleGained, 'Muscle Gained', Colors.purple),
            ],
          ),
        ],
      ),
    ));
  }
}
```

### 3. Dynamic Day Counter

```dart
class DynamicDayCounter extends GetView<UserController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.currentUser.value;
      if (user == null) return SizedBox.shrink();
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${user.dayCountDisplay} (${user.primaryGoal})',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            user.planDateRange,
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
        ],
      );
    });
  }
}
```

### 4. Real-time Search Bar

```dart
class RealTimeSearchBar extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.white54),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search meals...',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              onChanged: (value) => controller.searchQuery.value = value,
            ),
          ),
          Obx(() => controller.searchQuery.value.isNotEmpty
            ? GestureDetector(
                onTap: () => controller.searchQuery.value = '',
                child: Icon(Icons.clear, color: Colors.white54),
              )
            : Icon(Icons.tune, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}
```

## Service Layer Design

### 1. Enhanced UsersFirestoreService

```dart
class UsersFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'users';

  // Real-time user profile stream
  Stream<UserModel?> getUserProfileStream(String uid) {
    return _firestore
      .collection(_collection)
      .doc(uid)
      .snapshots()
      .map((doc) {
        if (!doc.exists || doc.data() == null) return null;
        final data = Map<String, dynamic>.from(doc.data()!);
        data['id'] = doc.id;
        return UserModel.fromJson(data);
      })
      .handleError((error) {
        print('Error fetching user profile: $error');
        return null;
      });
  }

  // Update user profile with progress tracking
  Future<void> updateUserProgress({
    required String uid,
    double? currentWeight,
    double? fatLost,
    double? muscleGained,
  }) async {
    final updates = <String, dynamic>{};
    if (currentWeight != null) updates['weight'] = currentWeight;
    if (fatLost != null) updates['fatLost'] = fatLost;
    if (muscleGained != null) updates['muscleGained'] = muscleGained;
    
    if (updates.isNotEmpty) {
      updates['lastUpdated'] = FieldValue.serverTimestamp();
      await _firestore.collection(_collection).doc(uid).update(updates);
    }
  }
}
```

### 2. Enhanced MealsFirestoreService

```dart
class MealsFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'meals';

  // User-specific meals stream
  Stream<List<MealModel>> getUserMealsStream(String userId) {
    return _firestore
      .collection(_collection)
      .where('userId', isEqualTo: userId)
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
        .map((doc) => MealModel.fromJson(doc.data(), docId: doc.id))
        .toList())
      .handleError((error) {
        print('Error fetching user meals: $error');
        return <MealModel>[];
      });
  }
}
```

## State Management Strategy

### 1. Controller Dependencies

```dart
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Core services
    Get.lazyPut<UsersFirestoreService>(() => UsersFirestoreService());
    Get.lazyPut<MealsFirestoreService>(() => MealsFirestoreService());
    
    // Controllers with proper dependency injection
    Get.lazyPut<UserController>(() => UserController());
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
```

### 2. Reactive Data Flow

```dart
class UserController extends GetxController {
  late StreamSubscription<User?> _authSubscription;
  late StreamSubscription<UserModel?> _userSubscription;
  
  @override
  void onInit() {
    super.onInit();
    _initializeAuthListener();
  }
  
  void _initializeAuthListener() {
    _authSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _subscribeToUserData(user.uid);
      } else {
        currentUser.value = null;
        _userSubscription?.cancel();
      }
    });
  }
  
  void _subscribeToUserData(String uid) {
    isLoading.value = true;
    _userSubscription = _usersService.getUserProfileStream(uid).listen(
      (userData) {
        currentUser.value = userData;
        isLoading.value = false;
        error.value = '';
      },
      onError: (err) {
        error.value = 'Failed to load user data';
        isLoading.value = false;
      },
    );
  }
}
```

## Error Handling Strategy

### 1. Network Error Handling

```dart
class NetworkErrorHandler {
  static Widget buildErrorWidget(String error, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 48),
          SizedBox(height: 16),
          Text(error, style: TextStyle(color: Colors.white70)),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}
```

### 2. Loading State Management

```dart
class LoadingStateWidget extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Widget? loadingWidget;
  
  const LoadingStateWidget({
    required this.isLoading,
    required this.child,
    this.loadingWidget,
  });
  
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ?? Center(
        child: CircularProgressIndicator(color: Color(0xFFC2D86A)),
      );
    }
    return child;
  }
}
```

## Performance Optimizations

### 1. Stream Management
- Use `StreamSubscription` for proper cleanup
- Implement debouncing for search queries
- Cache frequently accessed data
- Use `Obx` selectively to minimize rebuilds

### 2. Memory Management
- Cancel streams in `onClose()`
- Use lazy loading for large datasets
- Implement pagination for meal lists
- Optimize image loading with caching

### 3. Firestore Optimization
- Use compound indexes for complex queries
- Implement offline persistence
- Batch write operations when possible
- Use field-level updates instead of full document updates

## Security Considerations

### 1. Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Users can only access their own meals
    match /meals/{mealId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
    }
  }
}
```

### 2. Data Validation

```dart
class UserDataValidator {
  static bool isValidWeight(double weight) => weight > 0 && weight < 1000;
  static bool isValidHeight(int height) => height > 0 && height < 300;
  static bool isValidAge(int age) => age > 0 && age < 150;
  
  static String? validateUserData(UserModel user) {
    if (!isValidWeight(user.weight)) return 'Invalid weight';
    if (!isValidHeight(user.height)) return 'Invalid height';
    if (!isValidAge(user.age)) return 'Invalid age';
    return null;
  }
}
```

## Testing Strategy

### 1. Unit Tests
- Test calculation methods in UserModel
- Test search filtering logic
- Test data validation functions
- Test error handling scenarios

### 2. Widget Tests
- Test UI components with different data states
- Test loading, error, and empty states
- Test search functionality
- Test reactive updates

### 3. Integration Tests
- Test Firebase authentication flow
- Test real-time data synchronization
- Test offline functionality
- Test performance under load

## Correctness Properties

### Property 1: User Data Consistency
**Validates: Requirements 1.1, 1.4**
```dart
// Property: User data displayed in UI always matches Firestore data
property('user_data_consistency', () {
  forAll(userDataGenerator, (userData) {
    // When user data is updated in Firestore
    updateUserInFirestore(userData);
    
    // Then UI should reflect the same data within reasonable time
    return eventually(() => 
      getDisplayedUserData() == userData
    );
  });
});
```

### Property 2: Live Stats Accuracy
**Validates: Requirements 2.1, 2.2, 2.3**
```dart
// Property: Live stats calculations are mathematically correct
property('live_stats_accuracy', () {
  forAll(userProgressGenerator, (progress) {
    final expectedGoalPercent = calculateExpectedGoalPercent(progress);
    final expectedFatLost = calculateExpectedFatLost(progress);
    final expectedMuscleGained = calculateExpectedMuscleGained(progress);
    
    final actualStats = calculateLiveStats(progress);
    
    return actualStats.goalPercent == expectedGoalPercent &&
           actualStats.fatLost == expectedFatLost &&
           actualStats.muscleGained == expectedMuscleGained;
  });
});
```

### Property 3: Day Counter Accuracy
**Validates: Requirements 3.1, 3.2**
```dart
// Property: Day counter always reflects correct days since join date
property('day_counter_accuracy', () {
  forAll(joinDateGenerator, (joinDate) {
    final user = UserModel(joinDate: joinDate, /* other fields */);
    final expectedDay = DateTime.now().difference(joinDate).inDays + 1;
    
    return user.currentDay == max(1, expectedDay);
  });
});
```

### Property 4: Search Functionality
**Validates: Requirements 4.1, 4.2, 4.3**
```dart
// Property: Search always returns meals containing the query string
property('search_functionality', () {
  forAll(mealListGenerator, searchQueryGenerator, (meals, query) {
    final filteredMeals = filterMealsBySearch(meals, query);
    
    return filteredMeals.every((meal) => 
      meal.name.toLowerCase().contains(query.toLowerCase())
    ) && filteredMeals.length <= meals.length;
  });
});
```

### Property 5: Real-time Updates
**Validates: Requirements 1.4, 5.2**
```dart
// Property: UI updates within acceptable time when data changes
property('realtime_updates', () {
  forAll(userDataChangeGenerator, (change) {
    final startTime = DateTime.now();
    
    // Apply change to Firestore
    applyUserDataChange(change);
    
    // UI should update within 5 seconds
    return eventually(() => 
      getUIUpdateTime().difference(startTime).inSeconds <= 5
    );
  });
});
```

## Implementation Phases

### Phase 1: Core Infrastructure
1. Enhance UserModel with calculated properties
2. Implement UserController with Firebase streams
3. Update UsersFirestoreService for real-time data
4. Add proper error handling and loading states

### Phase 2: UI Components
1. Create DynamicProfileHeader component
2. Implement DynamicLiveStatsCard
3. Build DynamicDayCounter component
4. Add LoadingStateWidget and error handling

### Phase 3: Search Functionality
1. Enhance DashboardController with search logic
2. Implement RealTimeSearchBar component
3. Add search filtering to meal lists
4. Handle empty search results

### Phase 4: Integration & Testing
1. Integrate all components in dashboard and profile screens
2. Add comprehensive error handling
3. Implement performance optimizations
4. Add unit and integration tests

### Phase 5: Polish & Optimization
1. Add offline support
2. Optimize performance and memory usage
3. Enhance security rules
4. Add analytics and monitoring