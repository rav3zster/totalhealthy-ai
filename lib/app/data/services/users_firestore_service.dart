import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UsersFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'user';

  /// Real-time user profile stream for a specific user
  Stream<UserModel?> getUserProfileStream(String uid) {
    return _firestore
        .collection(_collection)
        .doc(uid)
        .snapshots()
        .map((doc) {
          if (!doc.exists || doc.data() == null) return null;
          try {
            final data = Map<String, dynamic>.from(doc.data()!);
            data['id'] = doc.id;
            return UserModel.fromJson(data);
          } catch (e) {
            print('Error parsing user profile for $uid: $e');
            return null;
          }
        })
        .handleError((error) {
          print('Error in getUserProfileStream for $uid: $error');
          return null;
        });
  }

  /// Update user progress with specific fields
  Future<void> updateUserProgress({
    required String uid,
    double? currentWeight,
    double? fatLost,
    double? muscleGained,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (currentWeight != null) updates['weight'] = currentWeight;
      if (fatLost != null) updates['fatLost'] = fatLost;
      if (muscleGained != null) updates['muscleGained'] = muscleGained;

      if (updates.isNotEmpty) {
        updates['lastUpdated'] = FieldValue.serverTimestamp();
        await _firestore.collection(_collection).doc(uid).update(updates);
      }
    } catch (e) {
      print('Error updating user progress for $uid: $e');
      rethrow;
    }
  }

  /// Stream of all users
  Stream<List<UserModel>> getUsersStream() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            try {
              final data = Map<String, dynamic>.from(doc.data());
              data['id'] = doc.id;
              return UserModel.fromJson(data);
            } catch (e) {
              print('Error parsing user ${doc.id}: $e');
              rethrow;
            }
          }).toList();
        })
        .handleError((error) {
          print('Error in getUsersStream: $error');
          return <UserModel>[];
        });
  }

  /// Stream of total users count
  Stream<int> getTotalUsersCountStream() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.length;
        })
        .handleError((error) {
          print('Error in getTotalUsersCountStream: $error');
          return 0;
        });
  }

  /// Create a user profile in Firestore
  Future<void> createUserProfile(UserModel user) async {
    try {
      // Validate user data before creating
      final validationError = user.validateUserData();
      if (validationError != null) {
        throw Exception('Invalid user data: $validationError');
      }

      await _firestore.collection(_collection).doc(user.id).set(user.toJson());
    } catch (e) {
      print('Error creating user profile for ${user.id}: $e');
      rethrow;
    }
  }

  /// Fetch a user profile by UID
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection(_collection).doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final data = Map<String, dynamic>.from(doc.data()!);
        data['id'] = doc.id;
        return UserModel.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error fetching user profile for $uid: $e');
      return null;
    }
  }

  /// Update a user profile
  Future<void> updateUserProfile(UserModel user) async {
    try {
      // Validate user data before updating
      final validationError = user.validateUserData();
      if (validationError != null) {
        throw Exception('Invalid user data: $validationError');
      }

      await _firestore
          .collection(_collection)
          .doc(user.id)
          .update(user.toJson());
    } catch (e) {
      print('Error updating user profile for ${user.id}: $e');
      rethrow;
    }
  }

  /// Fetch total users count once
  Future<int> getTotalUsersCount() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs.length;
    } catch (e) {
      print('Error fetching total users count: $e');
      return 0;
    }
  }
}
