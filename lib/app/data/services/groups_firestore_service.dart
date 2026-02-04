import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/group_model.dart';

class GroupsFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'groups';

  /// Stream of groups where user is creator or member
  Stream<List<GroupModel>> getUserGroupsStream(String userId) {
    return _firestore
        .collection(_collection)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => GroupModel.fromJson(doc.data(), docId: doc.id))
              .where(
                (group) =>
                    group.createdBy == userId ||
                    group.membersList.contains(userId),
              )
              .toList();
        });
  }

  /// Stream of all public groups (deprecated - use getUserGroupsStream instead)
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

  /// Fetch user-specific groups once
  Future<List<GroupModel>> getUserGroups(String userId) async {
    final querySnapshot = await _firestore
        .collection(_collection)
        .orderBy('created_at', descending: true)
        .get();
    return querySnapshot.docs
        .map((doc) => GroupModel.fromJson(doc.data(), docId: doc.id))
        .where(
          (group) =>
              group.createdBy == userId || group.membersList.contains(userId),
        )
        .toList();
  }

  /// Fetch all groups once (deprecated - use getUserGroups instead)
  Future<List<GroupModel>> getGroups() async {
    final querySnapshot = await _firestore
        .collection(_collection)
        .orderBy('created_at', descending: true)
        .get();
    return querySnapshot.docs
        .map((doc) => GroupModel.fromJson(doc.data(), docId: doc.id))
        .toList();
  }

  /// Add a user to a group
  Future<void> addMemberToGroup(String groupId, String userId) async {
    await _firestore.collection(_collection).doc(groupId).update({
      'members_list': FieldValue.arrayUnion([userId]),
      'member_count': FieldValue.increment(1),
    });
  }

  /// Update an existing group
  Future<void> updateGroup(GroupModel group) async {
    if (group.id == null) {
      throw ArgumentError('Group ID cannot be null for update operation');
    }
    await _firestore
        .collection(_collection)
        .doc(group.id)
        .update(group.toJson());
  }

  /// Get a specific group by ID
  Future<GroupModel?> getGroupById(String groupId) async {
    final doc = await _firestore.collection(_collection).doc(groupId).get();
    if (doc.exists) {
      return GroupModel.fromJson(doc.data()!, docId: doc.id);
    }
    return null;
  }
}
