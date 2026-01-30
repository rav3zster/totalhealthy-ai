import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/notification/controllers/notification_controller.dart';
import 'package:totalhealthy/app/widgets/custom_button.dart';

import '../../../core/base/constants/appcolor.dart';
import '../../../core/base/controllers/auth_controller.dart';
import '../../../data/services/mock_api_service.dart';
import 'package:intl/intl.dart';
import 'package:totalhealthy/app/data/models/notification_model.dart';

class NotificationsPage extends StatefulWidget {
  final NotificationController controller;
  final String id;
  const NotificationsPage({
    super.key,
    required this.controller,
    required this.id,
  });

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool showAllNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Toggle buttons
            Row(
              children: [
                _buildToggleButton('All', showAllNotifications, () {
                  setState(() => showAllNotifications = true);
                }),
                const SizedBox(width: 20),
                _buildToggleButton('Unread', !showAllNotifications, () {
                  setState(() => showAllNotifications = false);
                }),
              ],
            ),

            const SizedBox(height: 30),

            Expanded(
              child: Obx(() {
                if (widget.controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filteredList = widget.controller.notifications.where((n) {
                  if (showAllNotifications) return true;
                  return n.status == NotificationStatus.pending;
                }).toList();

                if (filteredList.isEmpty) {
                  return const Center(
                    child: Text(
                      'No notifications found',
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final notification = filteredList[index];
                    return _buildNotificationCard(notification);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC2D86A) : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: isSelected ? null : Border.all(color: Colors.white54),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification notification) {
    final isInvite = notification.type == NotificationType.invitation;
    final isPending = notification.status == NotificationStatus.pending;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isInvite ? const Color(0xFFC2D86A) : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isInvite ? Icons.mail_outline : Icons.notifications_none,
                  color: Colors.black,
                  size: 20,
                ),
              ),

              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          notification.title,
                          style: const TextStyle(
                            color: Color(0xFFC2D86A),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          DateFormat('HH:mm').format(notification.timestamp),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      notification.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),

                    if (isInvite && isPending) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => widget.controller
                                  .acceptInvitation(notification),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFC2D86A),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Accept'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => widget.controller
                                  .rejectInvitation(notification),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white54),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Reject'),
                            ),
                          ),
                        ],
                      ),
                    ] else if (isInvite && !isPending) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Status: ${notification.status.name.capitalizeFirst}',
                        style: TextStyle(
                          color:
                              notification.status == NotificationStatus.accepted
                              ? Colors.green
                              : Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
