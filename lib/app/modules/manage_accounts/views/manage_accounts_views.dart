import 'package:flutter/material.dart';
import 'package:totalhealthy/app/modules/registration/views/registration_view.dart';

class ManageAccountScreen extends StatefulWidget {
  @override
  _ManageAccountScreenState createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends State<ManageAccountScreen> {
  // Controllers for the fields
  TextEditingController _usernameController = TextEditingController(text: 'ayushshukla123');
  TextEditingController _emailController = TextEditingController(text: 'ayushshukla@gmail.com');
  TextEditingController _contactController = TextEditingController(text: '9876543210');
  TextEditingController _passwordController = TextEditingController(text: '...........o09');

  // Flags to toggle editing
  bool _isUsernameEditable = false;
  bool _isContactEditable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Account & Password',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Save action - navigate to RegistrationScreen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrationView()),
              );
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEditableTextField('User name', _usernameController, _isUsernameEditable, (value) {
              setState(() {
                _isUsernameEditable = value;
              });
            }),
            const SizedBox(height: 20),
            _buildTextField('E-mail address', 'ayushshukla@gmail.com', readOnly: true),
            const SizedBox(height: 20),
            _buildEditableTextField('Contact no.', _contactController, _isContactEditable, (value) {
              setState(() {
                _isContactEditable = value;
              });
            }),
            const SizedBox(height: 20),
            _buildTextField('Password', '...........o09', readOnly: true, isPassword: true),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String value, {bool readOnly = false, bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),  // Changed label color to white
        ),
        const SizedBox(height: 8),
        TextField(
          readOnly: readOnly,
          obscureText: isPassword,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[900],
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.green),
            ),
          ),
          style: const TextStyle(color: Colors.grey),  // Set content text color to grey
          controller: TextEditingController(text: value),
        ),
      ],
    );
  }

  Widget _buildEditableTextField(
      String label,
      TextEditingController controller,
      bool isEditable,
      Function(bool) toggleEditable,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),  // Changed label color to white
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: !isEditable,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[900],
            suffixIcon: IconButton(
              icon: Icon(
                isEditable ? Icons.check : Icons.edit,
                color: Colors.grey,
              ),
              onPressed: () {
                toggleEditable(!isEditable);
              },
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.green),
            ),
          ),
          style: TextStyle(color: isEditable ? Colors.white : Colors.grey),  // Change content color to white when editing
        ),
      ],
    );
  }
}

