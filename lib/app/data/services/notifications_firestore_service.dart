import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

class NotificationsFirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'notifications';

  /// Stream of user notifications
  Stream<List<AppNotification>> getNotificationsStream(String recipientId) {
    return _firestore
        .collection(_collection)
        .where('recipientId', isEqualTo: recipientId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = Map<String, dynamic>.from(doc.data());
            data['id'] = doc.id;
            return AppNotification.fromJson(data);
          }).toList();
        });
  }

  /// Create a notification (send invite)
  Future<void> sendNotification(AppNotification notification) async {
    await _firestore.collection(_collection).add(notification.toJson());
  }

  /// Stream of notifications sent by a user (for tracking pending invitations)
  Stream<List<AppNotification>> getSentInvitationsStream(String senderId) {
    return _firestore
        .collection(_collection)
        .where('senderId', isEqualTo: senderId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = Map<String, dynamic>.from(doc.data());
            data['id'] = doc.id;
            return AppNotification.fromJson(data);
          }).toList();
        });
  }

  /// Update notification status (accept/reject)
  Future<void> updateNotificationStatus(
    String notificationId,
    NotificationStatus status,
  ) async {
    await _firestore.collection(_collection).doc(notificationId).update({
      'status': status.toString().split('.').last,
    });
  }

  /// Delete notification
  Future<void> deleteNotification(String id) async {
    await _firestore.collection(_collection).doc(id).delete();
  }
}
