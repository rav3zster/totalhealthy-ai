import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UsersFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'users';

  /// Stream of all users
  Stream<List<UserModel>> getUsersStream() {
    print(
      "DEBUG: UsersFirestoreService - Fetching users from 'users' collection",
    );
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      print(
        "DEBUG: UsersFirestoreService - Received ${snapshot.docs.length} user documents",
      );
      return snapshot.docs.map((doc) {
        try {
          final data = Map<String, dynamic>.from(doc.data());
          data['id'] = doc.id;
          return UserModel.fromJson(data);
        } catch (e) {
          print(
            "DEBUG: UsersFirestoreService - Error parsing user ${doc.id}: $e",
          );
          rethrow;
        }
      }).toList();
    });
  }

  /// Stream of total users count
  Stream<int> getTotalUsersCountStream() {
    print("DEBUG: UsersFirestoreService - Streaming total users count");
    return _firestore.collection(_collection).snapshots().map((snapshot) {
      print("DEBUG: UsersFirestoreService - Count: ${snapshot.docs.length}");
      return snapshot.docs.length;
    });
  }

  /// Create a user profile in Firestore
  Future<void> createUserProfile(UserModel user) async {
    await _firestore.collection(_collection).doc(user.id).set(user.toJson());
  }

  /// Fetch total users count once
  Future<int> getTotalUsersCount() async {
    final snapshot = await _firestore.collection(_collection).get();
    return snapshot.docs.length;
  }
}
