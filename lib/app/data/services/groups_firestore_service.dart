import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/group_model.dart';
class GroupsFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'groups';

  /// Stream of groups where user is creator or member
  /// Auto-heals missing admin membership documents
  Stream<List<GroupModel>> getUserGroupsStream(String userId) {
    return _firestore
        .collection(_collection)
        .orderBy('created_at', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          final groups = snapshot.docs
              .map((doc) => GroupModel.fromJson(doc.data(), docId: doc.id))
              .where(
                (group) =>
                    group.createdBy == userId ||
                    group.membersList.contains(userId),
              )
              .toList();

          // Auto-heal: Ensure admin membership documents exist
          for (final group in groups) {
            if (group.id != null) {
              await _ensureAdminMembership(group.id!, group.createdBy);
            }
          }

          return groups;
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
  /// Creates group document AND adds admin to members subcollection
  Future<void> addGroup(GroupModel group) async {
    final user = FirebaseAuth.instance.currentUser;
    debugPrint('AUTH USER: ${user?.uid}');

    // Create group document
    final docRef = await _firestore.collection(_collection).add(group.toJson());
    final groupId = docRef.id;

    debugPrint('=== CREATING GROUP ===');
    debugPrint('Group ID: $groupId');
    debugPrint('Admin ID: ${group.createdBy}');

    // CRITICAL: Add admin to members subcollection
    // This ensures admin appears in members list for leave validation
    await _firestore
        .collection(_collection)
        .doc(groupId)
        .collection('members')
        .doc(group.createdBy)
        .set({
          'joinedAt': FieldValue.serverTimestamp(),
          'role': 'admin',
          'addedBy': group.createdBy,
        });

    debugPrint('✓ Admin added to members subcollection');

    // NOTE: Category initialization removed - groups now reference group categories
    // Categories are managed at the user level under group categories
    // When creating a group, select a group category that already has meal categories

    debugPrint('======================');
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
    // Validate groupId
    if (groupId.isEmpty || groupId == 'default') {
      throw ArgumentError(
        'Invalid group ID. Cannot add member to group with ID: $groupId',
      );
    }

    // Check if group exists
    final groupDoc = await _firestore
        .collection(_collection)
        .doc(groupId)
        .get();
    if (!groupDoc.exists) {
      throw Exception(
        'Group not found. The group may have been deleted or the invitation is invalid.',
      );
    }

    debugPrint('=== ADDING MEMBER TO GROUP ===');
    debugPrint('Group ID: $groupId');
    debugPrint('User ID: $userId');

    // Add member to members_list array
    await _firestore.collection(_collection).doc(groupId).update({
      'members_list': FieldValue.arrayUnion([userId]),
      'member_count': FieldValue.increment(1),
    });

    // CRITICAL: Add member to members subcollection
    // This ensures member appears in members list for leave validation
    await _firestore
        .collection(_collection)
        .doc(groupId)
        .collection('members')
        .doc(userId)
        .set({'joinedAt': FieldValue.serverTimestamp(), 'role': 'member'});

    debugPrint('✓ Member added to both array and subcollection');
    debugPrint('==============================');
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
  /// Auto-heals missing admin membership document
  Future<GroupModel?> getGroupById(String groupId) async {
    final doc = await _firestore.collection(_collection).doc(groupId).get();
    if (doc.exists) {
      final group = GroupModel.fromJson(doc.data()!, docId: doc.id);

      // Auto-heal: Ensure admin has membership document
      await _ensureAdminMembership(groupId, group.createdBy);

      return group;
    }
    return null;
  }

  /// Ensure admin has membership document in members subcollection
  /// Auto-creates if missing (data healing)
  Future<void> _ensureAdminMembership(String groupId, String adminId) async {
    try {
      debugPrint('=== CHECKING ADMIN MEMBERSHIP ===');
      debugPrint('Group ID: $groupId');
      debugPrint('Admin ID: $adminId');

      final adminMemberDoc = await _firestore
          .collection(_collection)
          .doc(groupId)
          .collection('members')
          .doc(adminId)
          .get();

      if (!adminMemberDoc.exists) {
        debugPrint('⚠️ Admin membership document missing - auto-creating...');

        await _firestore
            .collection(_collection)
            .doc(groupId)
            .collection('members')
            .doc(adminId)
            .set({
              'joinedAt': FieldValue.serverTimestamp(),
              'role': 'admin',
              'addedBy': adminId,
              'autoHealed': true, // Flag to track auto-created docs
            });

        debugPrint('✓ Admin membership document created');
      } else {
        debugPrint('✓ Admin membership document exists');
      }

      debugPrint('=================================');
    } catch (e) {
      debugPrint('Error ensuring admin membership: $e');
      // Don't throw - this is a healing operation
    }
  }

  /// Delete a group (admin only)
  /// This will delete the group document from Firestore
  /// Note: Firestore Security Rules should enforce that only the creator can delete
  Future<void> deleteGroup(String groupId) async {
    if (groupId.isEmpty) {
      throw ArgumentError('Group ID cannot be empty');
    }

    // Check if group exists
    final groupDoc = await _firestore
        .collection(_collection)
        .doc(groupId)
        .get();
    if (!groupDoc.exists) {
      throw Exception('Group not found. It may have already been deleted.');
    }

    // Delete the group document
    await _firestore.collection(_collection).doc(groupId).delete();

    debugPrint('Group $groupId deleted successfully');
  }

  /// Get all members of a group
  /// Returns list of user IDs who are members
  /// Auto-heals admin membership if missing
  Future<List<String>> getGroupMembers(String groupId) async {
    if (groupId.isEmpty) {
      throw ArgumentError('Group ID cannot be empty');
    }

    debugPrint('=== FETCHING GROUP MEMBERS ===');
    debugPrint('Group ID: $groupId');
    debugPrint('Collection path: groups/$groupId/members');

    // First, get the group to know who the admin is
    final groupDoc = await _firestore
        .collection(_collection)
        .doc(groupId)
        .get();
    if (groupDoc.exists) {
      final groupData = groupDoc.data()!;
      final adminId = groupData['created_by'] as String?;

      if (adminId != null) {
        // Auto-heal: Ensure admin has membership document
        await _ensureAdminMembership(groupId, adminId);
      }
    }

    final membersSnapshot = await _firestore
        .collection(_collection)
        .doc(groupId)
        .collection('members')
        .get();

    final memberIds = membersSnapshot.docs.map((doc) => doc.id).toList();

    debugPrint('Documents found: ${membersSnapshot.docs.length}');
    debugPrint('Member IDs: $memberIds');
    debugPrint('==============================');

    return memberIds;
  }

  /// Member leaves group (simple removal)
  /// Member can only remove their own membership
  Future<void> memberLeaveGroup(String groupId, String userId) async {
    if (groupId.isEmpty || userId.isEmpty) {
      throw ArgumentError('Group ID and User ID cannot be empty');
    }

    // Check if group exists
    final groupDoc = await _firestore
        .collection(_collection)
        .doc(groupId)
        .get();
    if (!groupDoc.exists) {
      throw Exception('Group not found');
    }

    final groupData = groupDoc.data()!;
    final adminId = groupData['created_by'] as String?;

    // Prevent admin from using simple leave
    if (adminId == userId) {
      throw Exception(
        'Admin cannot leave without transferring ownership. Use adminLeaveGroup instead.',
      );
    }

    // Remove member document
    await _firestore
        .collection(_collection)
        .doc(groupId)
        .collection('members')
        .doc(userId)
        .delete();

    // Update members_list array
    await _firestore.collection(_collection).doc(groupId).update({
      'members_list': FieldValue.arrayRemove([userId]),
      'member_count': FieldValue.increment(-1),
    });

    debugPrint('Member $userId left group $groupId');
  }

  /// Admin leaves group with ownership transfer
  /// Uses Firestore transaction to ensure atomic operation
  Future<void> adminLeaveGroup(
    String groupId,
    String currentAdminId,
    String newAdminId,
  ) async {
    if (groupId.isEmpty || currentAdminId.isEmpty || newAdminId.isEmpty) {
      throw ArgumentError(
        'Group ID, current admin ID, and new admin ID cannot be empty',
      );
    }

    if (currentAdminId == newAdminId) {
      throw ArgumentError('New admin cannot be the same as current admin');
    }

    debugPrint('=== ADMIN LEAVE WITH TRANSFER ===');
    debugPrint('Group ID: $groupId');
    debugPrint('Current Admin: $currentAdminId');
    debugPrint('New Admin: $newAdminId');

    // IMPORTANT: Validate members BEFORE transaction
    // Cannot do collection queries inside Firestore transactions
    final membersSnapshot = await _firestore
        .collection(_collection)
        .doc(groupId)
        .collection('members')
        .get();

    final memberIds = membersSnapshot.docs.map((doc) => doc.id).toList();
    debugPrint('All members before transfer: $memberIds');

    // Remove current admin from member list
    final otherMemberIds = List<String>.from(memberIds)..remove(currentAdminId);

    if (otherMemberIds.isEmpty) {
      throw Exception(
        'Cannot leave group: No other members available. Delete the group instead.',
      );
    }

    // Verify new admin is in the remaining members
    if (!otherMemberIds.contains(newAdminId)) {
      throw Exception('Selected user is not a valid member');
    }

    debugPrint('Other members available: $otherMemberIds');
    debugPrint('Transferring admin rights to: $newAdminId');

    // Use transaction to ensure atomic operation
    await _firestore.runTransaction((transaction) async {
      // 1. Get group document
      final groupRef = _firestore.collection(_collection).doc(groupId);
      final groupDoc = await transaction.get(groupRef);

      if (!groupDoc.exists) {
        throw Exception('Group not found');
      }

      final groupData = groupDoc.data()!;
      final adminId = groupData['created_by'] as String?;

      // 2. Verify current user is admin
      if (adminId != currentAdminId) {
        throw Exception('Only the current admin can transfer ownership');
      }

      // 3. Get new admin's membership document
      final newAdminMemberRef = _firestore
          .collection(_collection)
          .doc(groupId)
          .collection('members')
          .doc(newAdminId);
      final newAdminMemberDoc = await transaction.get(newAdminMemberRef);

      if (!newAdminMemberDoc.exists) {
        throw Exception('New admin must be a member of the group');
      }

      // 4. Update group admin (atomic operation)
      transaction.update(groupRef, {'created_by': newAdminId});

      // 5. Update new admin's role in membership document
      transaction.update(newAdminMemberRef, {
        'role': 'admin',
        'promotedAt': FieldValue.serverTimestamp(),
        'promotedBy': currentAdminId,
      });

      // 6. Delete old admin's membership document
      final oldAdminMemberRef = _firestore
          .collection(_collection)
          .doc(groupId)
          .collection('members')
          .doc(currentAdminId);
      transaction.delete(oldAdminMemberRef);

      // 7. Update members_list array
      transaction.update(groupRef, {
        'members_list': FieldValue.arrayRemove([currentAdminId]),
        'member_count': FieldValue.increment(-1),
      });

      debugPrint('✓ Transaction prepared successfully');
    });

    debugPrint('✓ Admin transfer completed: $currentAdminId → $newAdminId');
    debugPrint('=================================');
  }
}
