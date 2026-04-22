import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_helper.dart';
import '../../../widgets/web/web_scaffold.dart';

class SettingWebView extends StatelessWidget {
  const SettingWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return WebScaffold(
      title: 'Settings',
      maxContentWidth: 700,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SettingsGroup(
              title: 'Preferences',
              items: [
                _SettingsTile(
                  icon: Icons.tune_rounded,
                  title: 'General Settings',
                  subtitle: 'Language, region, theme',
                  onTap: () => Get.toNamed('/general-settings'),
                ),
                _SettingsTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Meal reminders, alerts',
                  onTap: () => Get.toNamed('/notification-settings'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _SettingsGroup(
              title: 'Account',
              items: [
                _SettingsTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Account & Password',
                  subtitle: 'Change password, security',
                  onTap: () => Get.toNamed('/account-password-settings'),
                ),
                _SettingsTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Profile Settings',
                  subtitle: 'Edit your profile',
                  onTap: () => Get.toNamed('/profile-settings'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _SettingsGroup(
              title: 'Support',
              items: [
                _SettingsTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & Support',
                  subtitle: 'FAQs, contact us',
                  onTap: () => Get.toNamed('/help-support'),
                ),
                _SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'How we use your data',
                  onTap: () => Get.toNamed('/privacy-policy'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> items;
  const _SettingsGroup({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            title,
            style: TextStyle(
              color: context.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: context.cardGradient,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.borderColor),
            boxShadow: context.cardShadow,
          ),
          child: Column(
            children: items.asMap().entries.map((e) {
              final isLast = e.key == items.length - 1;
              return Column(
                children: [
                  e.value,
                  if (!isLast)
                    Divider(
                      height: 1,
                      color: context.borderColor.withValues(alpha: 0.5),
                      indent: 56,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<_SettingsTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: _hovered
                ? context.accentColor.withValues(alpha: 0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: context.accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(widget.icon, color: context.accentColor, size: 18),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: context.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        color: context.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: context.textTertiary,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
