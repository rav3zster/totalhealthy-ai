import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  String selectedLanguage = 'English';
  String selectedRegion = 'India';
  String selectedTheme = 'Dark';

  String selectedMeal = "on";
  String selectedWater = "off";
  String selectedExercise = "on";
  String selectedNotification = "on";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(
          Icons.arrow_back_ios_new_outlined,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.search, size: 35, color: Colors.white),
          ),
        ],
        title: const SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(right: 35),
            child: Text(
              'Notifications',
              style: TextStyle(
                color: Color(0XFFFFFFFF),
                fontFamily: 'inter',
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NotificationSettingOption(
              title: 'Meal Reminder',
              value: selectedMeal,
              items: const ['on', 'off'],
              onChanged: (value) {
                setState(() {
                  selectedMeal = value!;
                });
              },
            ),
            NotificationSettingOption(
              title: 'Water Reminder ',
              value: selectedWater,
              items: const ['on', 'off'],
              onChanged: (value) {
                setState(() {
                  selectedWater = value!;
                });
              },
            ),
            NotificationSettingOption(
              title: 'Exercise Reminder',
              value: selectedExercise,
              items: const ['on', 'off'],
              onChanged: (value) {
                setState(() {
                  selectedExercise = value!;
                });
              },
            ),
            NotificationSettingOption(
              title: 'Update Notification',
              value: selectedNotification,
              items: const ['on', 'off'],
              onChanged: (value) {
                setState(() {
                  selectedNotification = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationSettingOption extends StatelessWidget {
  final String title;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const NotificationSettingOption({
    super.key,
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
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: DropdownButton<String>(
              value: value,
              dropdownColor: Colors.grey[900],
              underline: const SizedBox(),
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xffCCE16B),
              ),
              style: const TextStyle(color: Color(0xffCCE16B), fontSize: 16),
              onChanged: onChanged,
              items: items.map((item) {
                return DropdownMenuItem(value: item, child: Text(item));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
