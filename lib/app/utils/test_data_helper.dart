import 'package:firebase_auth/firebase_auth.dart';
import '../data/models/user_model.dart';
import '../data/services/users_firestore_service.dart';

class TestDataHelper {
  static final UsersFirestoreService _userService = UsersFirestoreService();

  /// Create test user data for the currently authenticated user
  static Future<void> createTestUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No authenticated user found');
      return;
    }

    final testUser = UserModel(
      id: user.uid,
      email: user.email ?? 'test@example.com',
      username: 'TestUser',
      phone: '+1234567890',
      firstName: 'John',
      lastName: 'Doe',
      profileImage: 'https://via.placeholder.com/150',
      age: 25,
      weight: 70.0,
      targetWeight: 65.0,
      height: 175,
      activityLevel: 'Moderate',
      goals: ['Weight Loss'],
      joinDate: DateTime.now().subtract(
        const Duration(days: 10),
      ), // 10 days ago
      initialWeight: 75.0,
      fatLost: 2.5,
      muscleGained: 0.5,
      goalDuration: 90,
    );

    try {
      await _userService.createUserProfile(testUser);
      print('Test user data created successfully!');
    } catch (e) {
      print('Error creating test user data: $e');
    }
  }

  /// Update user progress for testing
  static Future<void> updateTestProgress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _userService.updateUserProgress(
        uid: user.uid,
        currentWeight: 68.0,
        fatLost: 3.0,
        muscleGained: 0.8,
      );
      print('Test progress updated successfully!');
    } catch (e) {
      print('Error updating test progress: $e');
    }
  }
}
