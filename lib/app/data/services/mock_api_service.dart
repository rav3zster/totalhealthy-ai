import 'dart:convert';
import 'dummy_data_service.dart';

class MockApiService {
  // Mock response structure
  static Map<String, dynamic> _createResponse(dynamic data, {bool success = true, String? message}) {
    return {
      "data": data,
      "statusCode": success ? 200 : 400,
      "success": success,
      "message": message ?? (success ? "Success" : "Error"),
    };
  }

  // Authentication
  static Future<Map<String, dynamic>> login(String email, String password) async {
    await Future.delayed(Duration(milliseconds: 1500)); // Simulate network delay
    
    if (DummyDataService.validateLogin(email, password)) {
      final userData = DummyDataService.getDummyUser();
      return _createResponse({
        "access_token": "mock_access_token_${DateTime(2024, 10, 15).millisecondsSinceEpoch}",
        "refresh_token": "mock_refresh_token_${DateTime(2024, 10, 15).millisecondsSinceEpoch}",
        "user_details": userData.toJson(),
      });
    } else {
      return _createResponse(null, success: false, message: "Invalid credentials");
    }
  }

  static Future<Map<String, dynamic>> signup(Map<String, dynamic> userData) async {
    await Future.delayed(Duration(milliseconds: 2000)); // Simulate network delay
    
    // Always succeed for demo
    return _createResponse({
      "message": "Registration successful",
      "user_id": "new_user_${DateTime(2024, 10, 15).millisecondsSinceEpoch}",
    });
  }

  // Groups
  static Future<Map<String, dynamic>> getGroups(String role) async {
    await Future.delayed(Duration(milliseconds: 1000));
    return _createResponse(DummyDataService.getDummyGroups());
  }

  static Future<Map<String, dynamic>> createGroup(Map<String, dynamic> groupData) async {
    await Future.delayed(Duration(milliseconds: 1500));
    return _createResponse({
      "message": "Group created successfully",
      "group_id": "group_${DateTime(2024, 10, 15).millisecondsSinceEpoch}",
    });
  }

  static Future<Map<String, dynamic>> getGroupMembers(String groupId) async {
    await Future.delayed(Duration(milliseconds: 800));
    return _createResponse([
      {"id": "1", "name": "Demo User", "email": "demo@totalhealthy.com", "role": "admin"},
      {"id": "2", "name": "Jane Smith", "email": "jane@example.com", "role": "member"},
      {"id": "3", "name": "Mike Johnson", "email": "mike@example.com", "role": "member"},
    ]);
  }

  static Future<Map<String, dynamic>> addGroupMember(String groupId, String userId) async {
    await Future.delayed(Duration(milliseconds: 1200));
    return _createResponse({"message": "Member added successfully"});
  }

  // Meals
  static Future<Map<String, dynamic>> getMeals(String groupId, String role) async {
    await Future.delayed(Duration(milliseconds: 1000));
    return _createResponse(DummyDataService.getDummyMeals());
  }

  static Future<Map<String, dynamic>> getMealCategories(String groupId) async {
    await Future.delayed(Duration(milliseconds: 800));
    return _createResponse(DummyDataService.getDummyMealCategories());
  }

  static Future<Map<String, dynamic>> createMealCategory(String groupId, Map<String, dynamic> categoryData) async {
    await Future.delayed(Duration(milliseconds: 1500));
    return _createResponse({"message": "Meal category created successfully"});
  }

  static Future<Map<String, dynamic>> createMeal(Map<String, dynamic> mealData) async {
    await Future.delayed(Duration(milliseconds: 1800));
    return _createResponse({"message": "Meal created successfully"});
  }

  static Future<Map<String, dynamic>> getMealHistory(String groupId) async {
    await Future.delayed(Duration(milliseconds: 1000));
    return _createResponse(DummyDataService.getDummyMeals());
  }

  static Future<Map<String, dynamic>> copyMeals(Map<String, dynamic> copyData) async {
    await Future.delayed(Duration(milliseconds: 1200));
    return _createResponse({"message": "Meals copied successfully"});
  }

  // Notifications
  static Future<Map<String, dynamic>> getNotifications() async {
    await Future.delayed(Duration(milliseconds: 800));
    return _createResponse(DummyDataService.getDummyNotifications());
  }

  static Future<Map<String, dynamic>> respondToNotification(String notificationId, String action) async {
    await Future.delayed(Duration(milliseconds: 600));
    return _createResponse({"message": "Notification updated successfully"});
  }

  // User Profile
  static Future<Map<String, dynamic>> getUserProfile() async {
    await Future.delayed(Duration(milliseconds: 800));
    return _createResponse(DummyDataService.getDummyUser().toJson());
  }

  static Future<Map<String, dynamic>> updateUserProfile(Map<String, dynamic> profileData) async {
    await Future.delayed(Duration(milliseconds: 1500));
    return _createResponse({"message": "Profile updated successfully"});
  }

  // Diet Generation
  static Future<Map<String, dynamic>> generateDietPlan(Map<String, dynamic> preferences) async {
    await Future.delayed(Duration(milliseconds: 3000)); // Longer delay for AI generation
    return _createResponse({
      "message": "Diet plan generated successfully",
      "diet_plan": {
        "breakfast": DummyDataService.getDummyMeals().where((meal) => meal['category'] == 'Breakfast').toList(),
        "lunch": DummyDataService.getDummyMeals().where((meal) => meal['category'] == 'Lunch').toList(),
        "dinner": DummyDataService.getDummyMeals().where((meal) => meal['category'] == 'Dinner').toList(),
        "total_calories": 1800,
        "total_protein": 120,
        "total_carbs": 200,
        "total_fat": 60,
      }
    });
  }

  // Search Users
  static Future<Map<String, dynamic>> searchUserByEmail(String email) async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (email.toLowerCase().contains('demo') || email.toLowerCase().contains('test')) {
      return _createResponse([
        {"id": "1", "email": email, "name": "Demo User", "phone": "+1234567890"},
      ]);
    }
    return _createResponse([], success: false, message: "User not found");
  }

  static Future<Map<String, dynamic>> searchUserByPhone(String phone) async {
    await Future.delayed(Duration(milliseconds: 1000));
    if (phone.contains('123') || phone.contains('demo')) {
      return _createResponse([
        {"id": "1", "phone": phone, "name": "Demo User", "email": "demo@totalhealthy.com"},
      ]);
    }
    return _createResponse([], success: false, message: "User not found");
  }

  // Dashboard Stats
  static Future<Map<String, dynamic>> getDashboardStats() async {
    await Future.delayed(Duration(milliseconds: 1200));
    return _createResponse(DummyDataService.getDummyDashboardStats());
  }

  // Health Data
  static Future<Map<String, dynamic>> getHealthData() async {
    await Future.delayed(Duration(milliseconds: 1000));
    return _createResponse(DummyDataService.getDummyHealthData().map((e) => e.toJson()).toList());
  }

  static Future<Map<String, dynamic>> updateHealthData(Map<String, dynamic> healthData) async {
    await Future.delayed(Duration(milliseconds: 1200));
    return _createResponse({"message": "Health data updated successfully"});
  }

  // Workouts
  static Future<Map<String, dynamic>> getWorkouts() async {
    await Future.delayed(Duration(milliseconds: 1000));
    return _createResponse(DummyDataService.getDummyWorkouts().map((e) => e.toJson()).toList());
  }

  // Achievements
  static Future<Map<String, dynamic>> getAchievements() async {
    await Future.delayed(Duration(milliseconds: 800));
    return _createResponse(DummyDataService.getDummyAchievements());
  }

  // Generic error simulation
  static Future<Map<String, dynamic>> simulateError() async {
    await Future.delayed(Duration(milliseconds: 2000));
    return _createResponse(null, success: false, message: "Network error occurred");
  }

  // Simulate different response scenarios
  static Future<Map<String, dynamic>> simulateEmptyResponse() async {
    await Future.delayed(Duration(milliseconds: 1000));
    return _createResponse([]);
  }

  static Future<Map<String, dynamic>> simulateLoadingState() async {
    await Future.delayed(Duration(milliseconds: 3000));
    return _createResponse({"message": "Operation completed after delay"});
  }
}

// Mock response class to mimic Dio Response
class MockResponse {
  final dynamic data;
  final int statusCode;
  final Map<String, dynamic> headers;

  MockResponse({
    required this.data,
    required this.statusCode,
    this.headers = const {},
  });
}

// Mock API status checker
class MockApiStatus {
  static bool success(int? statusCode) {
    return statusCode != null && statusCode >= 200 && statusCode < 300;
  }
}