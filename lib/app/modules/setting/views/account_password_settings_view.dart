import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountPasswordSettingsView extends StatefulWidget {
  const AccountPasswordSettingsView({super.key});

  @override
  State<AccountPasswordSettingsView> createState() => _AccountPasswordSettingsViewState();
}

class _AccountPasswordSettingsViewState extends State<AccountPasswordSettingsView> {
  final TextEditingController usernameController = TextEditingController(text: 'ayushshukla123');
  final TextEditingController emailController = TextEditingController(text: 'ayushshukla@gmail.com');
  final TextEditingController contactController = TextEditingController(text: '9876543210');
  final TextEditingController passwordController = TextEditingController(text: 'Demo123!');
  
  bool isUsernameEditable = false;
  bool isEmailEditable = false;
  bool isContactEditable = false;
  bool isPasswordEditable = false;
  bool showPassword = false;

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
        title: Text(
          'Account & Password',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Handle save functionality
              _saveChanges();
            },
            child: Text(
              'Save',
              style: TextStyle(
                color: Color(0xFFC2D86A),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User name
            _buildInputField(
              'User name',
              usernameController,
              isUsernameEditable,
              () {
                setState(() {
                  isUsernameEditable = !isUsernameEditable;
                });
              },
            ),
            
            SizedBox(height: 25),
            
            // E-mail address
            _buildInputField(
              'E-mail address',
              emailController,
              isEmailEditable,
              () {
                setState(() {
                  isEmailEditable = !isEmailEditable;
                });
              },
            ),
            
            SizedBox(height: 25),
            
            // Contact no.
            _buildInputField(
              'Contact no.',
              contactController,
              isContactEditable,
              () {
                setState(() {
                  isContactEditable = !isContactEditable;
                });
              },
            ),
            
            SizedBox(height: 25),
            
            // Password
            _buildPasswordField(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInputField(String label, TextEditingController controller, bool isEditable, VoidCallback onEditTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  enabled: isEditable,
                  style: TextStyle(
                    color: isEditable ? Colors.white : Colors.white70,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onEditTap,
                child: Icon(
                  Icons.edit,
                  color: Colors.white54,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            color: Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: passwordController,
                  enabled: isPasswordEditable,
                  obscureText: !showPassword && !isPasswordEditable,
                  style: TextStyle(
                    color: isPasswordEditable ? Colors.white : Colors.white70,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: isPasswordEditable ? null : _getPasswordDisplay(),
                    hintStyle: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isPasswordEditable = !isPasswordEditable;
                    if (isPasswordEditable) {
                      showPassword = true;
                    }
                  });
                },
                child: Icon(
                  Icons.edit,
                  color: Colors.white54,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  String _getPasswordDisplay() {
    if (isPasswordEditable || showPassword) {
      return passwordController.text;
    }
    
    // Show dots with last 3 characters
    String password = passwordController.text;
    if (password.length <= 3) {
      return password;
    }
    
    String dots = '•' * (password.length - 3);
    String lastThree = password.substring(password.length - 3);
    return dots + lastThree;
  }
  
  void _saveChanges() {
    // Reset all edit states
    setState(() {
      isUsernameEditable = false;
      isEmailEditable = false;
      isContactEditable = false;
      isPasswordEditable = false;
      showPassword = false;
    });
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Account information saved successfully!'),
        backgroundColor: Color(0xFFC2D86A),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}