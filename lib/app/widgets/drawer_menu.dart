import '../core/base/controllers/auth_controller.dart';
import '../routes/app_pages.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/utitlity/responsive_settings.dart';
import '../controllers/user_controller.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context)
        ? Drawer(
            backgroundColor: Colors.transparent,
            width: 300,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                ),
              ),
              child: SafeArea(
                child: GetBuilder<UserController>(
                  builder: (userController) {
                    return Column(
                      children: [
                        // Header Section
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color(0xFFC2D86A).withValues(alpha: 0.2),
                                const Color(0xFFC2D86A).withValues(alpha: 0.05),
                              ],
                            ),
                            border: Border(
                              bottom: BorderSide(
                                color: const Color(
                                  0xFFC2D86A,
                                ).withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Profile Avatar
                              Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFC2D86A),
                                      Color(0xFFD4E87C),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFC2D86A,
                                      ).withValues(alpha: 0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(3),
                                child: CircleAvatar(
                                  radius: 28,
                                  backgroundColor: const Color(0xFF2A2A2A),
                                  backgroundImage:
                                      UserController.getImageProvider(
                                        userController.profileImage,
                                      ),
                                  child: userController.profileImage.isEmpty
                                      ? const Icon(
                                          Icons.person,
                                          color: Colors.white24,
                                          size: 28,
                                        )
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 16),
                              // User Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userController.fullName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.3,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
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
                                      child: Text(
                                        userController.currentUser?.role
                                                ?.toUpperCase() ??
                                            "MEMBER",
                                        style: const TextStyle(
                                          color: Color(0xFF121212),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Menu Items
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              children: [
                                _buildModernMenuItem(
                                  icon: Icons.person_outline,
                                  title: "Profile",
                                  onTap: () {
                                    Get.back();
                                    Get.toNamed(Routes.PROFILE_MAIN);
                                  },
                                ),
                                _buildModernMenuItem(
                                  icon: Icons.settings_outlined,
                                  title: "Settings",
                                  onTap: () {
                                    Get.back();
                                    Get.toNamed(Routes.SETTING);
                                  },
                                ),
                                _buildModernMenuItem(
                                  icon: Icons.history_rounded,
                                  title: "Diet History",
                                  onTap: () {
                                    Get.back();
                                    Get.toNamed(Routes.MEAL_HISTORY);
                                  },
                                ),

                                // Divider
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  height: 1,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        const Color(
                                          0xFFC2D86A,
                                        ).withValues(alpha: 0.3),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),

                                // Switch Role Section
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    "SWITCH ROLE",
                                    style: TextStyle(
                                      color: const Color(
                                        0xFFC2D86A,
                                      ).withValues(alpha: 0.7),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                _buildModernMenuItem(
                                  icon: Icons.supervisor_account_outlined,
                                  title: "Switch as Advisor",
                                  onTap: () {
                                    Get.back();
                                    authController.switchRole("admin");
                                  },
                                ),
                                _buildModernMenuItem(
                                  icon: Icons.person_outline,
                                  title: "Switch as Member",
                                  onTap: () {
                                    Get.back();
                                    authController.switchRole("user");
                                  },
                                ),

                                // Divider
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  height: 1,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        const Color(
                                          0xFFC2D86A,
                                        ).withValues(alpha: 0.3),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),

                                _buildModernMenuItem(
                                  icon: Icons.help_outline_rounded,
                                  title: "Help & Support",
                                  onTap: () {
                                    Get.back();
                                    Get.toNamed('/help-support');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Logout Button
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: const Color(
                                  0xFFC2D86A,
                                ).withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Get.back();
                                authController.logOut();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.red.withValues(alpha: 0.2),
                                      Colors.red.withValues(alpha: 0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.red.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.logout_rounded,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      "Logout",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          )
        : const SizedBox();
  }

  Widget _buildModernMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFC2D86A).withValues(alpha: 0.2),
                        const Color(0xFFC2D86A).withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: const Color(0xFFC2D86A), size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withValues(alpha: 0.3),
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
