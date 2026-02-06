import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/notification/controllers/notification_controller.dart';
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
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool showAllNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF1A1A1A), Colors.black],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header with gradient background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // App bar
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(
                              Icons.arrow_back_ios_new_outlined,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Notifications',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Toggle buttons
                      Row(
                        children: [
                          _buildModernToggleButton(
                            'All',
                            showAllNotifications,
                            () {
                              setState(() => showAllNotifications = true);
                            },
                          ),
                          const SizedBox(width: 12),
                          _buildModernToggleButton(
                            'Unread',
                            !showAllNotifications,
                            () {
                              setState(() => showAllNotifications = false);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Notifications list
              Expanded(
                child: Obx(() {
                  if (widget.controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFC2D86A),
                      ),
                    );
                  }

                  final filteredList = widget.controller.notifications.where((
                    n,
                  ) {
                    if (showAllNotifications) return true;
                    return n.status == NotificationStatus.pending;
                  }).toList();

                  if (filteredList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_none,
                            size: 64,
                            color: Colors.white54,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            showAllNotifications
                                ? 'No notifications yet'
                                : 'No unread notifications',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final notification = filteredList[index];
                      return _buildModernNotificationCard(notification, index);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernToggleButton(
    String text,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    Color(0xFFC2D86A).withValues(alpha: 0.3),
                    Color(0xFFC2D86A).withValues(alpha: 0.1),
                  ],
                )
              : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected
                ? Color(0xFFC2D86A)
                : Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Color(0xFFC2D86A).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white54,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildModernNotificationCard(AppNotification notification, int index) {
    final isInvite = notification.type == NotificationType.invitation;
    final isPending = notification.status == NotificationStatus.pending;

    // Different gradient combinations for variety
    List<List<Color>> gradients = [
      [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
      [Color(0xFF2D2D2D), Color(0xFF1D1D1D)],
      [Color(0xFF252525), Color(0xFF151515)],
    ];

    List<Color> cardGradient = gradients[index % gradients.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: cardGradient,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xFFC2D86A).withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle pattern overlay
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Color(0xFFC2D86A).withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon with gradient
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isInvite
                              ? [Color(0xFFC2D86A), Color(0xFFB8CC5A)]
                              : [Color(0xFF3A3A3A), Color(0xFF2A2A2A)],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: isInvite
                                ? Color(0xFFC2D86A).withValues(alpha: 0.3)
                                : Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        isInvite
                            ? Icons.mail_outline
                            : Icons.notifications_none,
                        color: isInvite ? Colors.black : Colors.white,
                        size: 24,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title,
                                  style: const TextStyle(
                                    color: Color(0xFFC2D86A),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withValues(alpha: 0.1),
                                      Colors.white.withValues(alpha: 0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  DateFormat(
                                    'HH:mm',
                                  ).format(notification.timestamp),
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11,
                                  ),
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
                              height: 1.5,
                            ),
                          ),

                          if (isInvite && isPending) ...[
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFC2D86A),
                                          Color(0xFFB8CC5A),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(
                                            0xFFC2D86A,
                                          ).withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () => widget.controller
                                          .acceptInvitation(notification),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        foregroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                      child: const Text(
                                        'Accept',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withValues(alpha: 0.1),
                                          Colors.white.withValues(alpha: 0.05),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () => widget.controller
                                          .rejectInvitation(notification),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        shadowColor: Colors.transparent,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                      child: const Text(
                                        'Reject',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ] else if (isInvite && !isPending) ...[
                            const SizedBox(height: 12),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors:
                                      notification.status ==
                                          NotificationStatus.accepted
                                      ? [
                                          Colors.green.withValues(alpha: 0.2),
                                          Colors.green.withValues(alpha: 0.1),
                                        ]
                                      : [
                                          Colors.red.withValues(alpha: 0.2),
                                          Colors.red.withValues(alpha: 0.1),
                                        ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    notification.status ==
                                            NotificationStatus.accepted
                                        ? Icons.check_circle_outline
                                        : Icons.cancel_outlined,
                                    color:
                                        notification.status ==
                                            NotificationStatus.accepted
                                        ? Colors.green
                                        : Colors.red,
                                    size: 16,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Status: ${notification.status.name.capitalizeFirst}',
                                    style: TextStyle(
                                      color:
                                          notification.status ==
                                              NotificationStatus.accepted
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
          ),
        ],
      ),
    );
  }
}
