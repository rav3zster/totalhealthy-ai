import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/setting_controller.dart';

class HelpAndSupport extends StatelessWidget {
  var controller = Get.find<SettingController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Help & Support",
          style: TextStyle(
              color: Color(0XFFB3B3B3),
              fontSize: 25,
              fontWeight: FontWeight.normal), // Set title color to white
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Add search functionality here
            },
          ),
        ],
      ),
      backgroundColor: Colors.black, // Set the background to black
      body: Column(
        children: [
          // Consult Your Dietician Section
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFF242522),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/dietician.jpeg', height: 100),
                    SizedBox(height: 10),
                    Text(
                      "Consult Your Dietician",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    // Using Column to stack buttons vertically
                    Column(
                      children: [
                        _buildFullWidthButton(
                            Icons.chat, "Chat", controller.onChatPressed),
                        SizedBox(height: 8), // Space between buttons
                        _buildFullWidthButton(Icons.call, "Voice Call",
                            controller.onVoiceCallPressed),
                        SizedBox(height: 8), // Space between buttons
                        _buildFullWidthButton(Icons.video_call, "Video Call",
                            controller.onVideoCallPressed),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Chat With Chatbot Section
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFF242522),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/chatbot.jpeg', height: 100),
                    SizedBox(height: 10),
                    Text(
                      "Chat With Chatbot",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    // Using Column to stack buttons vertically
                    Column(
                      children: [
                        _buildFullWidthButton(
                            Icons.chat, "Chat", controller.onChatbotPressed),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullWidthButton(
      IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0XFF333333),
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Round the buttons
        ),
        minimumSize: Size(double.infinity, 48), // Full width
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          SizedBox(width: 8), // Space from the left edge
          Icon(icon, color: Color(0XFFCCE16B)), // Set icon color
          SizedBox(width: 8), // Space between icon and text
          Text(
            label,
            style: TextStyle(
                color: Color(0XFFCCE16B)), // Change text color to CCE16B
          ),
        ],
      ),
    );
  }
}
