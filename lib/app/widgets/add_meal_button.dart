import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';

const _lime = Color(0xFFC2D86A);
const _card = Color(0xFF141414);
const _bdr = Color(0xFF2A2A2A);

class AddMealButton extends StatelessWidget {
  final String id;
  final String? groupId;
  const AddMealButton({super.key, required this.id, this.groupId});

  void _show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _AddMealSheet(id: id, groupId: groupId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _show(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: _lime,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: _lime.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, color: Colors.black, size: 20),
            SizedBox(width: 6),
            Text(
              'Add Meal',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bottom sheet ──────────────────────────────────────────────────────────────

class _AddMealSheet extends StatelessWidget {
  final String id;
  final String? groupId;
  const _AddMealSheet({required this.id, this.groupId});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F0F0F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // header
          const Row(
            children: [
              Icon(Icons.restaurant_rounded, color: _lime, size: 20),
              SizedBox(width: 10),
              Text(
                'Add a Meal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Choose how you want to add your meal',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Option 1 — Create manually
          _OptionTile(
            icon: Icons.edit_note_rounded,
            iconColor: const Color(0xFF4FC3F7),
            title: 'Create Manually',
            subtitle: 'Enter meal details, ingredients & macros yourself',
            badge: null,
            onTap: () {
              Navigator.pop(context);
              Get.toNamed('${Routes.createMeal}?id=$id');
            },
          ),
          const SizedBox(height: 10),

          // Option 2 — Generate with AI
          _OptionTile(
            icon: Icons.auto_awesome_rounded,
            iconColor: _lime,
            title: 'Generate with AI',
            subtitle: 'Get a personalised meal plan based on your goals',
            badge: 'AI',
            onTap: () {
              Navigator.pop(context);
              Get.toNamed(
                '${Routes.generateAi}?id=$id',
                arguments: groupId != null ? {'groupId': groupId} : null,
              );
            },
          ),
          const SizedBox(height: 10),

          // Option 3 — Scan food
          _OptionTile(
            icon: Icons.camera_alt_rounded,
            iconColor: const Color(0xFFFFB347),
            title: 'Scan Food',
            subtitle: 'Take a photo and AI fills in the nutrition data',
            badge: 'NEW',
            onTap: () {
              Navigator.pop(context);
              // Navigate to create meal with scan mode
              Get.toNamed(
                '${Routes.createMeal}?id=$id',
                arguments: {'scanMode': true},
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Option tile ───────────────────────────────────────────────────────────────

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String? badge;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _bdr),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: iconColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            badge!,
                            style: TextStyle(
                              color: iconColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white24,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
