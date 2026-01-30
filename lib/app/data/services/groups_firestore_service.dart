import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/group_model.dart';

class GroupsFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'groups';

  /// Stream of all public groups
  Stream<List<GroupModel>> getGroupsStream() {
    return _firestore
        .collection(_collection)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => GroupModel.fromJson(doc.data(), docId: doc.id))
              .toList();
        });
  }

  /// Add a new group to Firestore
  Future<void> addGroup(GroupModel group) async {
    final user = FirebaseAuth.instance.currentUser;
    print('AUTH USER: ${user?.uid}');
    await _firestore.collection(_collection).add(group.toJson());
  }

  /// Fetch all groups once
  Future<List<GroupModel>> getGroups() async {
    final querySnapshot = await _firestore
        .collection(_collection)
        .orderBy('created_at', descending: true)
        .get();
    return querySnapshot.docs
        .map((doc) => GroupModel.fromJson(doc.data(), docId: doc.id))
        .toList();
  }
}
