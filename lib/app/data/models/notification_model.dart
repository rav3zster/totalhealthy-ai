import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType { invitation, info, alert }

enum NotificationStatus { pending, accepted, rejected }

class AppNotification {
  final String id;
  final String recipientId;
  final String senderId;
  final String senderName;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationStatus status;
  final DateTime timestamp;
  final String? groupId;
  final String? groupName;

  AppNotification({
    required this.id,
    required this.recipientId,
    required this.senderId,
    required this.senderName,
    required this.title,
    required this.message,
    required this.type,
    this.status = NotificationStatus.pending,
    required this.timestamp,
    this.groupId,
    this.groupName,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] ?? '',
      recipientId: json['recipientId'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == (json['type'] ?? 'info'),
        orElse: () => NotificationType.info,
      ),
      status: NotificationStatus.values.firstWhere(
        (e) => e.toString().split('.').last == (json['status'] ?? 'pending'),
        orElse: () => NotificationStatus.pending,
      ),
      timestamp: json['timestamp'] != null
          ? (json['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
      groupId: json['groupId'],
      groupName: json['groupName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipientId': recipientId,
      'senderId': senderId,
      'senderName': senderName,
      'title': title,
      'message': message,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'timestamp': FieldValue.serverTimestamp(),
      'groupId': groupId,
      'groupName': groupName,
    };
  }
}
