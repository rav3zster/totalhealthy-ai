import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/setting_controller.dart';

class HelpAndSupport extends StatefulWidget {
  const HelpAndSupport({super.key});

  @override
  State<HelpAndSupport> createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Help & Support",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white, size: 24),
            onPressed: () {
              // Add search functionality here
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Consult Your Dietician Section
                  _buildCard(
                    imagePath: 'assets/dietician.jpeg',
                    title: 'Consult Your Dietician',
                    buttons: [
                      _ButtonData(
                        icon: Icons.chat_bubble_outline,
                        label: 'Chat',
                        onPressed: controller.onChatPressed,
                      ),
                      _ButtonData(
                        icon: Icons.phone_outlined,
                        label: 'Voice Call',
                        onPressed: controller.onVoiceCallPressed,
                      ),
                      _ButtonData(
                        icon: Icons.videocam_outlined,
                        label: 'Video Call',
                        onPressed: controller.onVideoCallPressed,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Chat With Chatbot Section
                  _buildCard(
                    imagePath: 'assets/chatbot.jpeg',
                    title: 'Chat With Chatbot',
                    buttons: [
                      _ButtonData(
                        icon: Icons.chat_bubble_outline,
                        label: 'Chat',
                        onPressed: controller.onChatbotPressed,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required String imagePath,
    required String title,
    required List<_ButtonData> buttons,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Image
            Image.asset(
              imagePath,
              height: 120,
              width: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
            ...buttons.map(
              (buttonData) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildButton(
                  icon: buttonData.icon,
                  label: buttonData.label,
                  onPressed: buttonData.onPressed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: const Color(0xFF3A3A3A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFFC2D86A), size: 22),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFFC2D86A),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonData {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  _ButtonData({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
}
