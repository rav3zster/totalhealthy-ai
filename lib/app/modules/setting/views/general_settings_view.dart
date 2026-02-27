import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/global_settings_controller.dart';
import '../../../core/theme/theme_helper.dart';

class GeneralSettingsView extends StatelessWidget {
  const GeneralSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = GlobalSettingsController.to;
    final List<String> languages = ['English', 'Hindi', 'Spanish', 'French'];
    final List<String> regions = ['India', 'USA', 'UK', 'Canada'];
    final List<String> themes = ['Dark', 'Light', 'System'];
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
                              const Color(0xFFC2D86A).withValues(alpha: 0.2),
                              const Color(0xFFC2D86A).withValues(alpha: 0.1),
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
                          'general'.tr,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Language Section
                      Text(
                        'language'.tr,
                        style: TextStyle(
                          color: context.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          gradient: context.cardGradient,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: context.isLightTheme
                                ? context.borderColor
                                : const Color(
                                    0xFFC2D86A,
                                  ).withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Obx(
                            () => DropdownButton<String>(
                              value: controller.language.value,
                              dropdownColor: context.cardColor,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: context.textPrimary,
                              ),
                              style: TextStyle(
                                color: const Color(0xFFC2D86A),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              items: languages.map((String language) {
                                return DropdownMenuItem<String>(
                                  value: language,
                                  child: Text(language),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  controller.changeLanguage(newValue);
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Region Section
                      Text(
                        'region'.tr,
                        style: TextStyle(
                          color: context.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          gradient: context.cardGradient,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: context.isLightTheme
                                ? context.borderColor
                                : const Color(
                                    0xFFC2D86A,
                                  ).withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Obx(
                            () => DropdownButton<String>(
                              value: controller.region.value,
                              dropdownColor: context.cardColor,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: context.textPrimary,
                              ),
                              style: TextStyle(
                                color: const Color(0xFFC2D86A),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              items: regions.map((String region) {
                                return DropdownMenuItem<String>(
                                  value: region,
                                  child: Text(region),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  controller.changeRegion(newValue);
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Theme Section
                      Text(
                        'theme'.tr,
                        style: TextStyle(
                          color: context.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          gradient: context.cardGradient,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: context.isLightTheme
                                ? context.borderColor
                                : const Color(
                                    0xFFC2D86A,
                                  ).withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Obx(
                            () => DropdownButton<String>(
                              value: controller.themeString.value,
                              dropdownColor: context.cardColor,
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                color: context.textPrimary,
                              ),
                              style: TextStyle(
                                color: const Color(0xFFC2D86A),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              items: themes.map((String theme) {
                                return DropdownMenuItem<String>(
                                  value: theme,
                                  child: Text(theme),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  controller.changeTheme(newValue);
                                }
                              },
                            ),
                          ),
                        ),
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
