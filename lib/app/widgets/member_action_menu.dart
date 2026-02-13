import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/user_model.dart';
import '../controllers/user_controller.dart';
import '../core/base/controllers/auth_controller.dart';

class MemberActionMenu {
  static void show(BuildContext context, UserModel member, bool isAdmin) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) =>
          _MemberActionSheet(member: member, isAdmin: isAdmin),
    );
  }

  // Show menu for current user (from profile header)
  static void showForCurrentUser(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _CurrentUserActionSheet(),
    );
  }
}

class _MemberActionSheet extends StatelessWidget {
  final UserModel member;
  final bool isAdmin;

  const _MemberActionSheet({required this.member, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Member Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Profile Image
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isAdmin
                            ? [const Color(0xFFC2D86A), const Color(0xFFD4E87C)]
                            : [
                                Colors.white.withValues(alpha: 0.1),
                                Colors.white.withValues(alpha: 0.05),
                              ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isAdmin
                              ? const Color(0xFFC2D86A).withValues(alpha: 0.4)
                              : Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(2),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: UserController.getImageProvider(
                        member.profileImage,
                      ),
                      child:
                          UserController.getImageProvider(
                                member.profileImage,
                              ) ==
                              null
                          ? const Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.white54,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Member Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                member.username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isAdmin) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFC2D86A),
                                      Color(0xFFD4E87C),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'ADMIN',
                                  style: TextStyle(
                                    color: Color(0xFF121212),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          member.email,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action Items
            _buildActionItem(
              icon: Icons.access_time_outlined,
              label: 'Set Meal Timing',
              onTap: () {
                Get.back();
                Get.toNamed('/meal-timing?id=${member.id}');
              },
            ),
            _buildActionItem(
              icon: Icons.person_outline,
              label: 'View Profile',
              onTap: () {
                Get.back();
                Get.toNamed('/member-profile', arguments: member);
              },
            ),
            _buildActionItem(
              icon: Icons.phone_outlined,
              label: 'Call',
              onTap: () {
                Get.back();
                // TODO: Implement call functionality
                Get.snackbar(
                  'Call',
                  'Calling ${member.username}...',
                  backgroundColor: const Color(0xFFC2D86A),
                  colorText: Colors.black,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                );
              },
            ),
            _buildActionItem(
              icon: Icons.email_outlined,
              label: 'Send Email',
              onTap: () {
                Get.back();
                // TODO: Implement email functionality
                Get.snackbar(
                  'Email',
                  'Opening email to ${member.email}...',
                  backgroundColor: const Color(0xFFC2D86A),
                  colorText: Colors.black,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                );
              },
            ),
            _buildActionItem(
              icon: Icons.chat_bubble_outline,
              label: 'Send Message',
              onTap: () {
                Get.back();
                // TODO: Implement messaging functionality
                Get.snackbar(
                  'Message',
                  'Opening chat with ${member.username}...',
                  backgroundColor: const Color(0xFFC2D86A),
                  colorText: Colors.black,
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFC2D86A).withValues(alpha: 0.2),
                      const Color(0xFFC2D86A).withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFFC2D86A), size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withValues(alpha: 0.3),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CurrentUserActionSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFC2D86A), Color(0xFFD4E87C)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFF121212),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Profile Options',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action Items
            _buildActionItem(
              icon: Icons.person_outline,
              label: 'View Profile',
              onTap: () {
                Get.back();
                Get.toNamed('/profile-settings');
              },
            ),
            _buildActionItem(
              icon: Icons.edit_outlined,
              label: 'Edit Profile',
              onTap: () {
                Get.back();
                Get.toNamed('/profile-settings');
              },
            ),
            _buildActionItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              onTap: () {
                Get.back();
                Get.toNamed('/setting');
              },
            ),
            _buildActionItem(
              icon: Icons.help_outline,
              label: 'Help & Support',
              onTap: () {
                Get.back();
                Get.toNamed('/help-support');
              },
            ),
            _buildActionItem(
              icon: Icons.logout,
              label: 'Logout',
              color: Colors.red,
              onTap: () {
                Get.back();
                Get.find<AuthController>().logOut();
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final itemColor = color ?? const Color(0xFFC2D86A);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      itemColor.withValues(alpha: 0.2),
                      itemColor.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: itemColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color == Colors.red ? Colors.red : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white.withValues(alpha: 0.3),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
