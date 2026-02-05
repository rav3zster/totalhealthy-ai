import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';



class notification_SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<notification_SettingsScreen> {
  String selectedLanguage = 'English';
  String selectedRegion = 'India';
  String selectedTheme = 'Dark';

  String selected_meal="on";
  String selected_water="off";
  String selected_expercise="on";
  String selected_notification="on";



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(
            Icons.arrow_back_ios_new_outlined, color: Colors.white),
        actions: [
          IconButton(onPressed: () {
            Get.back();
          },
              icon: Icon(Icons.search, size: 35, color: Colors.white,))
        ],
        title: const SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(right: 35),
            // Adjust this value to control the left shift
            child: Text(
              'Notifications',
              style: TextStyle(color: Color(0XFFFFFFFF),
                  fontFamily: 'inter',
                  fontSize: 24,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingOption(
              title: 'Meal Reminder',
              value: selected_meal,
              items: ['on','off'],
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
              },
            ),
            SettingOption(
              title: 'Water Reminder ',
              value: selected_water,
              items:  ['on','off'],
              onChanged: (value) {
                setState(() {
                  selectedRegion = value!;
                });
              },
            ),
            SettingOption(
              title: 'Exercise Reminder',
              value: selected_expercise,
              items:  ['on','off'],
              onChanged: (value) {
                setState(() {
                  selectedTheme = value!;
                });
              },
            ),
            SettingOption(
              title: 'Update Notification',
              value: selected_notification,
              items:  ['on','off'],
              onChanged: (value) {
                setState(() {
                  selectedTheme = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingOption extends StatelessWidget {
  final String title;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  SettingOption({
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: DropdownButton<String>(
              value: value,
              dropdownColor: Colors.grey[900],
              underline: SizedBox(),
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: Color(0xffCCE16B)),
              style: TextStyle(color: Color(0xffCCE16B), fontSize: 16),
              onChanged: onChanged,
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
