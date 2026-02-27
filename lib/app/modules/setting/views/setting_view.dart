import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_helper.dart';
import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: context.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  gradient: context.headerGradient,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  boxShadow: context.cardShadow,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              context.accentColor.withValues(alpha: 0.2),
                              context.accentColor.withValues(alpha: 0.1),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: context.textPrimary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'settings'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: context.textPrimary,
                            fontFamily: 'inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 48,
                      ), // Spacer to balance the back button
                    ],
                  ),
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      SettingOption(
                        title: "general_settings".tr,
                        onTap: () {
                          Get.toNamed('/general-settings');
                        },
                      ),
                      const SizedBox(height: 20),
                      SettingOption(
                        title: "notifications".tr,
                        onTap: () {
                          Get.toNamed('/notification-settings');
                        },
                      ),
                      const SizedBox(height: 20),
                      SettingOption(
                        title: "account_and_password".tr,
                        onTap: () {
                          Get.toNamed('/account-password-settings');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingOption extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SettingOption({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          gradient: context.cardGradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.isLightTheme
                ? context.borderColor
                : context.accentColor.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: context.cardShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: context.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: context.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
