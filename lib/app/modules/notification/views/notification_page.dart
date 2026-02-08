import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/notification/controllers/notification_controller.dart';
import 'package:intl/intl.dart';
import 'package:totalhealthy/app/data/models/notification_model.dart';
import 'package:totalhealthy/app/widgets/phone_nav_bar.dart';

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
  void initState() {
    super.initState();
    OntapStore.index = 2; // Set to Notification tab
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: Column(
          children: [
            // Header with gradient background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [const Color(0xFF1E1E1E), const Color(0xFF121212)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
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
                        const SizedBox(width: 16),
                        const Text(
                          'Notifications',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
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
                    child: CircularProgressIndicator(color: Color(0xFFC2D86A)),
                  );
                }

                final filteredList = widget.controller.notifications.where((n) {
                  if (showAllNotifications) return true;
                  return n.status == NotificationStatus.pending;
                }).toList();

                if (filteredList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_none_rounded,
                          size: 64,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          showAllNotifications
                              ? 'No notifications yet'
                              : 'No unread notifications',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
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
      bottomNavigationBar: const MobileNavBar(),
    );
  }

  Widget _buildModernToggleButton(
    String text,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [Color(0xFFC2D86A), Color(0xFFD4E87C)],
                  )
                : null,
            color: isSelected ? null : const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFC2D86A)
                  : Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF121212)
                  : Colors.white.withValues(alpha: 0.6),
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernNotificationCard(AppNotification notification, int index) {
    final isInvite = notification.type == NotificationType.invitation;
    final isPending = notification.status == NotificationStatus.pending;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 300 + (index * 50)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E1E1E), Color(0xFF1A1A1A)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isInvite && isPending
                ? const Color(0xFFC2D86A).withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.05),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isInvite && isPending
                  ? const Color(0xFFC2D86A).withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
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
                            ? [const Color(0xFFC2D86A), const Color(0xFFD4E87C)]
                            : [
                                Colors.white.withValues(alpha: 0.1),
                                Colors.white.withValues(alpha: 0.05),
                              ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: isInvite
                              ? const Color(0xFFC2D86A).withValues(alpha: 0.3)
                              : Colors.black.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      isInvite
                          ? Icons.mail_outline_rounded
                          : Icons.notifications_none_rounded,
                      color: isInvite
                          ? const Color(0xFF121212)
                          : Colors.white.withValues(alpha: 0.8),
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
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                DateFormat(
                                  'HH:mm',
                                ).format(notification.timestamp),
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.5),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text(
                          notification.message,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
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
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFC2D86A),
                                        Color(0xFFD4E87C),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFFC2D86A,
                                        ).withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () => widget.controller
                                          .acceptInvitation(notification),
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: Text(
                                          'Accept',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFF121212),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () => widget.controller
                                          .rejectInvitation(notification),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: Text(
                                          'Reject',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white.withValues(
                                              alpha: 0.8,
                                            ),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
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
                            padding: const EdgeInsets.symmetric(
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
                              border: Border.all(
                                color:
                                    notification.status ==
                                        NotificationStatus.accepted
                                    ? Colors.green.withValues(alpha: 0.3)
                                    : Colors.red.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  notification.status ==
                                          NotificationStatus.accepted
                                      ? Icons.check_circle_outline_rounded
                                      : Icons.cancel_outlined,
                                  color:
                                      notification.status ==
                                          NotificationStatus.accepted
                                      ? Colors.green
                                      : Colors.red,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Status: ${notification.status.name.capitalizeFirst}',
                                  style: TextStyle(
                                    color:
                                        notification.status ==
                                            NotificationStatus.accepted
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
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
      ),
    );
  }
}
