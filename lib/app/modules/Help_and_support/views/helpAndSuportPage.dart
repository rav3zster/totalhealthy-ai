import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF0F0F0F), Colors.black],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _buildHeroSection(),
                        const SizedBox(height: 30),
                        _buildSectionTitle("Direct Assistance"),
                        const SizedBox(height: 16),
                        _buildSupportChannels(),
                        const SizedBox(height: 40),
                        _buildSectionTitle("Contact Information"),
                        const SizedBox(height: 16),
                        _buildContactInfoCards(),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFC2D86A).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Color(0xFFC2D86A),
                size: 20,
              ),
              onPressed: () => Get.back(),
            ),
          ),
          const Text(
            "Support",
            style: TextStyle(
              color: Colors.white,
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

  Widget _buildHeroSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How can we\nhelp you today?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                height: 1.1,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        color: const Color(0xFFC2D86A).withValues(alpha: 0.6),
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 2.0,
      ),
    );
  }

  Widget _buildSupportChannels() {
    return Column(
      children: [
        _buildSupportCard(
          title: "Personal Dietician",
          subtitle: "Expert guidance for your journey",
          icon: Icons.person_search_rounded,
          gradient: [const Color(0xFFC2D86A), const Color(0xFFB8CC5A)],
          isFeatureDisabled: true,
        ),
        const SizedBox(height: 16),
        _buildSupportCard(
          title: "AI Chatbot",
          subtitle: "Instant answers 24/7",
          icon: Icons.auto_awesome_rounded,
          gradient: [const Color(0xFF4FC3F7), const Color(0xFF29B6F6)],
          isFeatureDisabled: false,
        ),
      ],
    );
  }

  Widget _buildSupportCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Color> gradient,
    required bool isFeatureDisabled,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    gradient[0].withValues(alpha: 0.2),
                    gradient[0].withValues(alpha: 0.05),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: gradient[0], size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (isFeatureDisabled)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Offline",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white24,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfoCards() {
    return Column(
      children: [
        _buildInfoTile(
          icon: Icons.help_outline_rounded,
          title: "Help Center",
          content: "Are you having any trouble?\nFind help here.",
          linkText: "Get Help",
          color: const Color(0xFFC2D86A),
        ),
        const SizedBox(height: 16),
        _buildInfoTile(
          icon: Icons.alternate_email_rounded,
          title: "Media Inquiries",
          content: "Journalists and bloggers, please reach out to:",
          linkText: "press@totalhealthy.com",
          color: const Color(0xFF4FC3F7),
        ),
        const SizedBox(height: 16),
        _buildInfoTile(
          icon: Icons.handshake_outlined,
          title: "Partnerships",
          content: "Looking to partner with us?\nGet in touch:",
          linkText: "partnerships@totalhealthy.com",
          color: const Color(0xFFFFB74D),
        ),
      ],
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String content,
    required String linkText,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: color.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Text(
                linkText,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
