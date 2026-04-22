import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/global_settings_controller.dart';
import '../../core/theme/theme_helper.dart';

class WebTopbar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;

  const WebTopbar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: context.cardColor,
        border: Border(
          bottom: BorderSide(color: context.borderColor.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: context.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          if (actions != null) ...actions!,
          const SizedBox(width: 16),
          // Theme toggle
          Obx(() {
            final isDark =
                GlobalSettingsController.to.themeMode.value == ThemeMode.dark;
            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  final isDarkNow =
                      GlobalSettingsController.to.themeMode.value ==
                      ThemeMode.dark;
                  GlobalSettingsController.to.changeTheme(
                    isDarkNow ? 'Light' : 'Dark',
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    color: context.accentColor,
                    size: 18,
                  ),
                ),
              ),
            );
          }),
          const SizedBox(width: 12),
          // User avatar
          _UserAvatar(),
        ],
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => Get.toNamed('/profile-main'),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: context.accentGradient,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person_rounded,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
    );
  }
}
