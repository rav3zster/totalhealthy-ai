import 'package:get/get.dart';

class SettingController extends GetxController {
  // Define any observable variables or methods if needed, e.g.:
  var isChatSelected = false.obs;

  // Method examples for handling button presses
  void onChatPressed() {
    isChatSelected.value = true;
    // Add your chat functionality here
  }

  void onVoiceCallPressed() {
    // Add your voice call functionality here
  }

  void onVideoCallPressed() {
    // Add your video call functionality here
  }

  void onChatbotPressed() {
    // Add your chatbot chat functionality here
  }
}
