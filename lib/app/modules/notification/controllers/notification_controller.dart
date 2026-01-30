import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/core/base/controllers/auth_controller.dart';
import 'package:totalhealthy/app/data/models/notification_model.dart';
import 'package:totalhealthy/app/data/services/notifications_firestore_service.dart';

class NotificationController extends GetxController {
  final NotificationsFirestoreService _notificationsService =
      NotificationsFirestoreService();

  final notifications = <AppNotification>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initNotifications();
  }

  void _initNotifications() {
    final authController = Get.find<AuthController>();
    final currentUser = authController.firebaseUser.value;

    if (currentUser != null) {
      notifications.bindStream(
        _notificationsService.getNotificationsStream(currentUser.uid),
      );
      ever(notifications, (_) => isLoading.value = false);
    } else {
      isLoading.value = false;
    }
  }

  Future<void> acceptInvitation(AppNotification notification) async {
    try {
      if (notification.groupId != null) {
        // Here you would add the user to the group in Firestore
        // For now, we'll just mark it as accepted
        await _notificationsService.updateNotificationStatus(
          notification.id,
          NotificationStatus.accepted,
        );

        Get.snackbar(
          "Success",
          "You have joined ${notification.groupName ?? 'the group'}!",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to accept invitation: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> rejectInvitation(AppNotification notification) async {
    try {
      await _notificationsService.updateNotificationStatus(
        notification.id,
        NotificationStatus.rejected,
      );
      Get.snackbar(
        "Information",
        "Invitation rejected",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to reject invitation: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteNotification(String id) async {
    await _notificationsService.deleteNotification(id);
  }
}
