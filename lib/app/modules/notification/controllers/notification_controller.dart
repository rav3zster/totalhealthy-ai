import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/core/base/controllers/auth_controller.dart';
import 'package:totalhealthy/app/data/models/notification_model.dart';
import 'package:totalhealthy/app/data/services/notifications_firestore_service.dart';
import 'package:totalhealthy/app/data/services/groups_firestore_service.dart';

class NotificationController extends GetxController {
  final NotificationsFirestoreService _notificationsService =
      NotificationsFirestoreService();
  final GroupsFirestoreService _groupsService = GroupsFirestoreService();

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
      try {
        notifications.bindStream(
          _notificationsService.getNotificationsStream(currentUser.uid),
        );
        ever(notifications, (_) => isLoading.value = false);

        // Safety timeout for loading
        Future.delayed(const Duration(seconds: 10), () {
          if (isLoading.value) {
            debugPrint("DEBUG: NotificationController - Loading timeout reached");
            isLoading.value = false;
          }
        });
      } catch (e) {
        debugPrint(
          "DEBUG: NotificationController - Error initializing notifications: $e",
        );
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;
    }
  }

  Future<void> acceptInvitation(AppNotification notification) async {
    try {
      // Validate groupId
      if (notification.groupId == null ||
          notification.groupId!.isEmpty ||
          notification.groupId == 'default') {
        Get.snackbar(
          "Error",
          "Invalid invitation. The group information is missing or incorrect.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );

        // Mark invitation as rejected since it's invalid
        await _notificationsService.updateNotificationStatus(
          notification.id,
          NotificationStatus.rejected,
        );
        return;
      }

      // Add the user to the group in Firestore
      await _groupsService.addMemberToGroup(
        notification.groupId!,
        notification.recipientId,
      );

      // Update status to accepted
      await _notificationsService.updateNotificationStatus(
        notification.id,
        NotificationStatus.accepted,
      );

      Get.snackbar(
        "Success",
        "You have joined ${notification.groupName ?? 'the group'}!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      String errorMessage = "Failed to accept invitation";

      // Provide more specific error messages
      if (e.toString().contains('not-found') ||
          e.toString().contains('Group not found')) {
        errorMessage = "This group no longer exists or has been deleted.";
      } else if (e.toString().contains('Invalid group ID')) {
        errorMessage = "Invalid invitation. Please contact the group admin.";
      }

      Get.snackbar(
        "Error",
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );

      debugPrint("DEBUG: Error accepting invitation: $e");
    }
  }

  Future<void> rejectInvitation(AppNotification notification) async {
    try {
      // Update status to rejected instead of deleting
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

  Future<void> clearAllNotifications() async {
    try {
      final authController = Get.find<AuthController>();
      final currentUser = authController.firebaseUser.value;

      if (currentUser != null) {
        await _notificationsService.deleteAllNotifications(currentUser.uid);

        Get.snackbar(
          "Success",
          "All notifications cleared",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to clear notifications: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
