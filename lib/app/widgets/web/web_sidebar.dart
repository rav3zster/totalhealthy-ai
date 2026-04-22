import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/base/controllers/auth_controller.dart';
import '../../core/theme/theme_helper.dart';
import '../../routes/app_pages.dart';

class WebSidebar extends StatelessWidget {
  const WebSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = Get.currentRoute;

    return Container(
      width: 240,
      decoration: BoxDecoration(
        gradient: context.headerGradient,
        border: Border(
          right: BorderSide(color: context.borderColor.withValues(alpha: 0.3)),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 32),
          // Logo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: context.accentGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'TotalHealthy',
                  style: TextStyle(
                    color: context.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _NavItem(
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  route: Routes.clientDashboard,
                  active: currentRoute.contains('clientdashboard'),
                ),
                _NavItem(
                  icon: Icons.auto_awesome_rounded,
                  label: 'AI Meal Planner',
                  route: Routes.generateAi,
                  active: currentRoute.contains('generate-ai'),
                ),
                _NavItem(
                  icon: Icons.add_circle_outline_rounded,
                  label: 'Create Meal',
                  route: Routes.createMeal,
                  active: currentRoute.contains('createmeal'),
                ),
                _NavItem(
                  icon: Icons.history_rounded,
                  label: 'Meal History',
                  route: Routes.mealHistory,
                  active: currentRoute.contains('meal-history'),
                ),
                _NavItem(
                  icon: Icons.group_rounded,
                  label: 'Groups',
                  route: Routes.group,
                  active: currentRoute.contains('/group'),
                ),
                _NavItem(
                  icon: Icons.calendar_month_rounded,
                  label: 'Planner',
                  route: Routes.planner,
                  active: currentRoute.contains('planner'),
                ),
                const Divider(height: 32),
                _NavItem(
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  route: Routes.profileMain,
                  active: currentRoute.contains('profile'),
                ),
                _NavItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  route: Routes.setting,
                  active: currentRoute.contains('setting'),
                ),
              ],
            ),
          ),
          // Logout
          Padding(
            padding: const EdgeInsets.all(16),
            child: _NavItem(
              icon: Icons.logout_rounded,
              label: 'Logout',
              route: '',
              active: false,
              onTap: () => Get.find<AuthController>().logOut(),
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;
  final bool active;
  final VoidCallback? onTap;
  final Color? color;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.active,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final itemColor =
        color ?? (active ? context.accentColor : context.textSecondary);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap ?? () => Get.toNamed(route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: active
                ? context.accentColor.withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: active
                ? Border.all(color: context.accentColor.withValues(alpha: 0.3))
                : null,
          ),
          child: Row(
            children: [
              Icon(icon, color: itemColor, size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: itemColor,
                  fontSize: 14,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
