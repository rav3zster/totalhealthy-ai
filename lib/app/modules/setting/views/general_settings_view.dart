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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              size: 24,
              color: Colors.white,
            ),
          )
        ],
        title: Text(
          'General',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Section
            Text(
              'Language',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedLanguage,
                  dropdownColor: Color(0xFF2A2A2A),
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  style: TextStyle(
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
            
            SizedBox(height: 30),
            
            // Region Section
            Text(
              'Region',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedRegion,
                  dropdownColor: Color(0xFF2A2A2A),
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  style: TextStyle(
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
            
            SizedBox(height: 30),
            
            // Theme Section
            Text(
              'Theme',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedTheme,
                  dropdownColor: Color(0xFF2A2A2A),
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                  style: TextStyle(
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
    );
  }
}