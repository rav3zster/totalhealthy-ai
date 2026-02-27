import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_helper.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: Container(
        decoration: BoxDecoration(gradient: context.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSection(
                          context,
                          "introduction".tr,
                          "privacy_intro_text".tr,
                        ),
                        const SizedBox(height: 24),
                        _buildSection(
                          context,
                          "information_we_collect".tr,
                          "info_collect_text".tr,
                        ),
                        const SizedBox(height: 24),
                        _buildSection(
                          context,
                          "how_we_use_info".tr,
                          "how_use_info_text".tr,
                        ),
                        const SizedBox(height: 24),
                        _buildSection(
                          context,
                          "sharing_your_info".tr,
                          "sharing_info_text".tr,
                        ),
                        const SizedBox(height: 24),
                        _buildSection(
                          context,
                          "data_security".tr,
                          "data_security_text".tr,
                        ),
                        const SizedBox(height: 24),
                        _buildSection(
                          context,
                          "your_rights".tr,
                          "your_rights_text".tr,
                        ),
                        const SizedBox(height: 40),
                        Center(
                          child: Text(
                            "last_updated".tr,
                            style: TextStyle(
                              color: context.textTertiary,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: context.accent,
                size: 20,
              ),
              onPressed: () => Get.back(),
            ),
          ),
          Text(
            "privacy_policy".tr,
            style: TextStyle(
              color: context.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(width: 48), // Spacer for balance
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: context.accent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.border, width: 1),
          ),
          child: Text(
            content,
            style: TextStyle(
              color: context.textSecondary,
              fontSize: 15,
              height: 1.6,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }
}
