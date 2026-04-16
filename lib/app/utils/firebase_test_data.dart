import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../data/models/user_model.dart';
/// Helper class to populate Firebase with test data for development
class FirebaseTestData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create sample member users in Firebase
  static Future<void> createSampleMembers() async {
    final sampleMembers = [
      UserModel(
        id: 'member_001',
        email: 'john.doe@example.com',
        username: 'johndoe',
        phone: '+1234567890',
        firstName: 'John',
        lastName: 'Doe',
        profileImage: 'assets/user_avatar.png',
        age: 28,
        weight: 75.0,
        targetWeight: 70.0,
        height: 175,
        activityLevel: 'Moderate',
        goals: ['Weight Loss', 'Build Muscle'],
        joinDate: DateTime.now().subtract(const Duration(days: 30)),
        planName: 'Keto Plan',
        planDuration: 'Oct 1 - Nov 1',
        progressPercentage: 65,
        initialWeight: 80.0,
        fatLost: 5.0,
        muscleGained: 2.0,
        goalDuration: 60,
        role: 'member',
      ),
      UserModel(
        id: 'member_002',
        email: 'jane.smith@example.com',
        username: 'janesmith',
        phone: '+1234567891',
        firstName: 'Jane',
        lastName: 'Smith',
        profileImage: 'assets/user_avatar.png',
        age: 32,
        weight: 65.0,
        targetWeight: 60.0,
        height: 165,
        activityLevel: 'High',
        goals: ['Fat Loss', 'Maintain Weight'],
        joinDate: DateTime.now().subtract(const Duration(days: 45)),
        planName: 'Mediterranean Diet',
        planDuration: 'Sep 15 - Nov 15',
        progressPercentage: 80,
        initialWeight: 70.0,
        fatLost: 5.0,
        muscleGained: 1.0,
        goalDuration: 60,
        role: 'member',
      ),
      UserModel(
        id: 'member_003',
        email: 'mike.johnson@example.com',
        username: 'mikej',
        phone: '+1234567892',
        firstName: 'Mike',
        lastName: 'Johnson',
        profileImage: 'assets/user_avatar.png',
        age: 25,
        weight: 85.0,
        targetWeight: 78.0,
        height: 180,
        activityLevel: 'Very High',
        goals: ['Build Muscle', 'Increase Strength'],
        joinDate: DateTime.now().subtract(const Duration(days: 20)),
        planName: 'High Protein Plan',
        planDuration: 'Oct 10 - Dec 10',
        progressPercentage: 45,
        initialWeight: 88.0,
        fatLost: 3.0,
        muscleGained: 4.0,
        goalDuration: 60,
        role: 'member',
      ),
      UserModel(
        id: 'member_004',
        email: 'sarah.williams@example.com',
        username: 'sarahw',
        phone: '+1234567893',
        firstName: 'Sarah',
        lastName: 'Williams',
        profileImage: 'assets/user_avatar.png',
        age: 29,
        weight: 58.0,
        targetWeight: 55.0,
        height: 160,
        activityLevel: 'Moderate',
        goals: ['Weight Loss', 'Tone Body'],
        joinDate: DateTime.now().subtract(const Duration(days: 15)),
        planName: 'Balanced Diet',
        planDuration: 'Oct 15 - Dec 15',
        progressPercentage: 30,
        initialWeight: 62.0,
        fatLost: 4.0,
        muscleGained: 1.5,
        goalDuration: 60,
        role: 'member',
      ),
      UserModel(
        id: 'member_005',
        email: 'david.brown@example.com',
        username: 'davidb',
        phone: '+1234567894',
        firstName: 'David',
        lastName: 'Brown',
        profileImage: 'assets/user_avatar.png',
        age: 35,
        weight: 92.0,
        targetWeight: 85.0,
        height: 178,
        activityLevel: 'Low',
        goals: ['Weight Loss', 'Improve Health'],
        joinDate: DateTime.now().subtract(const Duration(days: 50)),
        planName: 'Low Carb Plan',
        planDuration: 'Sep 1 - Nov 1',
        progressPercentage: 70,
        initialWeight: 98.0,
        fatLost: 6.0,
        muscleGained: 0.5,
        goalDuration: 60,
        role: 'member',
      ),
    ];

    try {
      for (var member in sampleMembers) {
        await _firestore.collection('user').doc(member.id).set(member.toJson());
        debugPrint('✅ Created member: ${member.fullName}');
      }
      debugPrint('🎉 All sample members created successfully!');
    } catch (e) {
      debugPrint('❌ Error creating sample members: $e');
    }
  }

  /// Create a sample trainer user
  static Future<void> createSampleTrainer(String uid) async {
    final trainer = UserModel(
      id: uid,
      email: 'trainer@example.com',
      username: 'trainer_pro',
      phone: '+1234567899',
      firstName: 'Trainer',
      lastName: 'Pro',
      profileImage: 'assets/user_avatar.png',
      age: 35,
      weight: 75.0,
      targetWeight: 75.0,
      height: 175,
      activityLevel: 'High',
      goals: ['Maintain Weight'],
      joinDate: DateTime.now(),
      role: 'trainer',
    );

    try {
      await _firestore.collection('user').doc(uid).set(trainer.toJson());
      debugPrint('✅ Created trainer profile');
    } catch (e) {
      debugPrint('❌ Error creating trainer: $e');
    }
  }

  /// Delete all sample data
  static Future<void> deleteSampleData() async {
    final sampleIds = [
      'member_001',
      'member_002',
      'member_003',
      'member_004',
      'member_005',
    ];

    try {
      for (var id in sampleIds) {
        await _firestore.collection('user').doc(id).delete();
        debugPrint('🗑️ Deleted member: $id');
      }
      debugPrint('✅ All sample data deleted');
    } catch (e) {
      debugPrint('❌ Error deleting sample data: $e');
    }
  }
}
