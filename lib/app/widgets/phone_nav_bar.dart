import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/base/controllers/auth_controller.dart';
import '../routes/app_pages.dart';

class OntapStore {
  static var index = 0;
  static List<String> routes = [
    Routes.ClientDashboard,
    Routes.GROUP,
    Routes.NOTIFICATION,
    Routes.PROFILE_MAIN,
  ];
}

class MobileNavBar extends StatefulWidget {
  const MobileNavBar({super.key});

  @override
  State<MobileNavBar> createState() => _MobileNavBarState();
}

class _MobileNavBarState extends State<MobileNavBar> {
  void ontapFunction(int value) {
    Get.offAllNamed(
      value == 0
          ? Get.find<AuthController>().roleGet() == "admin"
                ? Routes.TrainerDashboard
                : OntapStore.routes[value]
          : OntapStore.routes[value],
    );

    setState(() {
      OntapStore.index = value;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
        ),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFC2D86A).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                Icons.person,
                'member'.tr,
                OntapStore.index == 0,
                () => ontapFunction(0),
              ),
              _buildNavItem(
                Icons.group,
                'group'.tr,
                OntapStore.index == 1,
                () => ontapFunction(1),
              ),
              _buildNavItem(
                Icons.notifications,
                'notification'.tr,
                OntapStore.index == 2,
                () => ontapFunction(2),
              ),
              _buildNavItem(
                Icons.person,
                'profile'.tr,
                OntapStore.index == 3,
                () => ontapFunction(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFFC2D86A) : Colors.white54,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFFC2D86A) : Colors.white54,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
