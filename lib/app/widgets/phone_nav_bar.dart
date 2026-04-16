import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/base/controllers/auth_controller.dart';
import '../core/theme/theme_helper.dart';
import '../routes/app_pages.dart';

class OntapStore {
  static var index = 0;
  static List<String> routes = [
    Routes.clientDashboard,
    Routes.group,
    Routes.notification,
    Routes.profileMain,
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
                ? Routes.trainerDashboard
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
        gradient: context.headerGradient,
        border: Border(
          top: BorderSide(
            color: context.accent.withValues(alpha: 0.2),
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
                context,
                Icons.person,
                'member'.tr,
                OntapStore.index == 0,
                () => ontapFunction(0),
              ),
              _buildNavItem(
                context,
                Icons.group,
                'group'.tr,
                OntapStore.index == 1,
                () => ontapFunction(1),
              ),
              _buildNavItem(
                context,
                Icons.notifications,
                'notification'.tr,
                OntapStore.index == 2,
                () => ontapFunction(2),
              ),
              _buildNavItem(
                context,
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
    BuildContext context,
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
            color: isActive ? context.accent : context.textSecondary,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? context.accent : context.textSecondary,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
