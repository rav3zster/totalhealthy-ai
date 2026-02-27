import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/notification/controllers/notification_controller.dart';
import 'package:intl/intl.dart';
import 'package:totalhealthy/app/data/models/notification_model.dart';
import 'package:totalhealthy/app/widgets/phone_nav_bar.dart';
import '../../../core/theme/theme_helper.dart';

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

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    OntapStore.index = 2; // Set to Notification tab
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with gradient background
            Container(
              decoration: BoxDecoration(
                gradient: context.headerGradient,
                boxShadow: context.cardShadow,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // App bar
                    Row(
                      children: [
                        const SizedBox(width: 16),
                        Text(
                          'notifications'.tr,
                          style: TextStyle(
                            color: context.textPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const Spacer(),
                        // Clear All button
                        Obx(() {
                          if (widget.controller.notifications.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                _showClearAllDialog();
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.red.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.delete_sweep_rounded,
                                      size: 18,
                                      color: Colors.red.withValues(alpha: 0.9),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'clear_all'.tr,
                                      style: TextStyle(
                                        color: Colors.red.withValues(
                                          alpha: 0.9,
                                        ),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(width: 16),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Modern Tab Bar
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: context.border, width: 1),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                          gradient: context.accentGradient,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: context.accent.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        labelColor: context.backgroundColor,
                        unselectedLabelColor: context.textSecondary,
                        labelStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                        tabs: [
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.notifications_rounded,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text('all'.tr),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.mark_email_unread_rounded,
                                  size: 18,
                                ),
                                const SizedBox(width: 6),
                                Text('unread'.tr),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // All Notifications Tab
                  _buildNotificationsList(showAll: true),

                  // Unread Notifications Tab
                  _buildNotificationsList(showAll: false),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MobileNavBar(),
    );
  }

  Widget _buildNotificationsList({required bool showAll}) {
    return Obx(() {
      if (widget.controller.isLoading.value) {
        return Center(child: CircularProgressIndicator(color: context.accent));
      }

      final filteredList = widget.controller.notifications.where((n) {
        if (showAll) return true;
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
                color: context.textTertiary,
              ),
              const SizedBox(height: 16),
              Text(
                showAll
                    ? 'no_notifications_yet'.tr
                    : 'no_unread_notifications'.tr,
                style: TextStyle(color: context.textSecondary, fontSize: 16),
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
          return Dismissible(
            key: Key(notification.id),
            direction: DismissDirection.endToStart,
            background: Container(
              margin: const EdgeInsets.only(bottom: 16),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red.withValues(alpha: 0.1),
                    Colors.red.withValues(alpha: 0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.delete_rounded,
                color: Colors.red,
                size: 32,
              ),
            ),
            confirmDismiss: (direction) async {
              return await _showDeleteConfirmDialog(notification);
            },
            onDismissed: (direction) {
              widget.controller.deleteNotification(notification.id);
            },
            child: _buildModernNotificationCard(notification, index),
          );
        },
      );
    });
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
          gradient: context.cardGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isInvite && isPending
                ? context.accent.withValues(alpha: 0.3)
                : context.border,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isInvite && isPending
                  ? context.accent.withValues(alpha: 0.1)
                  : context.cardShadowSingle.color,
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
                            ? [context.accent, context.accent]
                            : [
                                context.textPrimary.withValues(alpha: 0.1),
                                context.textPrimary.withValues(alpha: 0.05),
                              ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: isInvite
                              ? context.accent.withValues(alpha: 0.3)
                              : context.cardShadowSingle.color,
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
                          ? context.backgroundColor
                          : context.textPrimary,
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
                                style: TextStyle(
                                  color: context.accent,
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
                                color: context.cardSecondary,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: context.border,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                DateFormat(
                                  'HH:mm',
                                ).format(notification.timestamp),
                                style: TextStyle(
                                  color: context.textSecondary,
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
                            color: context.textPrimary,
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
                                    gradient: context.accentGradient,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: context.accent.withValues(
                                          alpha: 0.3,
                                        ),
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
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        child: Text(
                                          'accept'.tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: context.backgroundColor,
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
                                    color: context.cardSecondary,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: context.border,
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
                                          'reject'.tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: context.textPrimary,
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
                                  '${'status'.tr}: ${notification.status.name.capitalizeFirst}',
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

  Future<bool?> _showDeleteConfirmDialog(AppNotification notification) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'delete_notification'.tr,
          style: TextStyle(
            color: context.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'delete_notification_confirm'.tr,
          style: TextStyle(color: context.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'cancel'.tr,
              style: TextStyle(color: context.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.withValues(alpha: 0.2),
            ),
            child: Text(
              'delete_group'.tr,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'clear_all_notifications'.tr,
          style: TextStyle(
            color: context.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'clear_all_confirm_message'.tr,
          style: TextStyle(color: context.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'cancel'.tr,
              style: TextStyle(color: context.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.controller.clearAllNotifications();
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.withValues(alpha: 0.2),
            ),
            child: Text(
              'clear_all'.tr,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
