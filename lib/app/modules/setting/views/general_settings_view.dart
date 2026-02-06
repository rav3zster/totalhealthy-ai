import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GeneralSettingsView extends StatefulWidget {
  const GeneralSettingsView({super.key});

  @override
  State<GeneralSettingsView> createState() => _GeneralSettingsViewState();
}

class _GeneralSettingsViewState extends State<GeneralSettingsView> {
  String selectedLanguage = 'English';
  String selectedRegion = 'India';
  String selectedTheme = 'Dark';

  final List<String> languages = ['English', 'Hindi', 'Spanish', 'French'];
  final List<String> regions = ['India', 'USA', 'UK', 'Canada'];
  final List<String> themes = ['Dark', 'Light', 'System'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF1A1A1A), Colors.black],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
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
                          icon: const Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'General',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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
                          onPressed: () {},
                          icon: const Icon(
                            Icons.search,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
                      const Text(
                        'Language',
                        style: TextStyle(
                          color: Colors.white,
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
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(
                              0xFFC2D86A,
                            ).withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedLanguage,
                            dropdownColor: const Color(0xFF2A2A2A),
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                            style: const TextStyle(
                              color: Color(0xFFC2D86A),
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
                              setState(() {
                                selectedLanguage = newValue!;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Region Section
                      const Text(
                        'Region',
                        style: TextStyle(
                          color: Colors.white,
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
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(
                              0xFFC2D86A,
                            ).withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedRegion,
                            dropdownColor: const Color(0xFF2A2A2A),
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                            style: const TextStyle(
                              color: Color(0xFFC2D86A),
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
                              setState(() {
                                selectedRegion = newValue!;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Theme Section
                      const Text(
                        'Theme',
                        style: TextStyle(
                          color: Colors.white,
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
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(
                              0xFFC2D86A,
                            ).withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedTheme,
                            dropdownColor: const Color(0xFF2A2A2A),
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                            style: const TextStyle(
                              color: Color(0xFFC2D86A),
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
                              setState(() {
                                selectedTheme = newValue!;
                              });
                            },
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
