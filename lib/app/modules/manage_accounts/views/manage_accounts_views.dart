import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/core/base/controllers/auth_controller.dart';
import 'package:totalhealthy/app/data/models/user_model.dart';
import 'package:totalhealthy/app/data/services/users_firestore_service.dart';
import 'package:totalhealthy/app/widgets/baseWidget.dart';
import 'package:totalhealthy/app/controllers/user_controller.dart';

class ManageAccountScreen extends StatefulWidget {
  const ManageAccountScreen({super.key});

  @override
  State<ManageAccountScreen> createState() => _ManageAccountScreenState();
}

class _ManageAccountScreenState extends State<ManageAccountScreen> {
  final authController = Get.find<AuthController>();
  final usersService = UsersFirestoreService();

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _ageController;
  late TextEditingController _experienceController;
  late TextEditingController _activeClientsController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _linkedinController;
  late TextEditingController _instagramController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;

  String selectedGender = 'Male';
  String selectedSpecialization = 'Weight Loss';
  bool isTrainerInfoExpanded = true;
  bool isContactInfoExpanded = true;

  @override
  void initState() {
    super.initState();
    final user = authController.getCurrentUser();
    _firstNameController = TextEditingController(text: user.firstName);
    _lastNameController = TextEditingController(text: user.lastName);
    _ageController = TextEditingController(text: user.age.toString());
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phone);
    _weightController = TextEditingController(text: user.weight.toString());
    _heightController = TextEditingController(text: user.height.toString());

    // Dummy values for others as they are not in UserModel yet
    _experienceController = TextEditingController(text: 'No. Of Years');
    _activeClientsController = TextEditingController(text: '12');
    _linkedinController = TextEditingController(text: '');
    _instagramController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _experienceController.dispose();
    _activeClientsController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _linkedinController.dispose();
    _instagramController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    try {
      final currentUser = authController.getCurrentUser();
      final updatedUser = UserModel(
        id: currentUser.id,
        email: _emailController.text,
        username: currentUser.username,
        phone: _phoneController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        profileImage: currentUser.profileImage,
        age: int.tryParse(_ageController.text) ?? 0,
        weight: double.tryParse(_weightController.text) ?? 0.0,
        height: int.tryParse(_heightController.text) ?? 0,
        activityLevel: currentUser.activityLevel,
        goals: currentUser.goals,
        joinDate: currentUser.joinDate,
        planName: currentUser.planName,
        planDuration: currentUser.planDuration,
        progressPercentage: currentUser.progressPercentage,
      );

      await usersService.updateUserProfile(updatedUser);
      await authController.userdataStore(updatedUser.toJson());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Get.back();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving profile: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      title: "Profile",
      appBarAction: [
        TextButton(
          onPressed: _saveProfile,
          child: const Text(
            'Save',
            style: TextStyle(
              color: Color(0xFFC2D86A),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
      body: Container(
        color: const Color(0xFF0C0C0C),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Picture
              CircleAvatar(
                radius: 40,
                backgroundImage: UserController.getImageProvider(
                  authController.getCurrentUser().profileImage,
                ),
                child:
                    UserController.getImageProvider(
                          authController.getCurrentUser().profileImage,
                        ) ==
                        null
                    ? const Icon(Icons.person, size: 40, color: Colors.white54)
                    : null,
              ),
              const SizedBox(height: 8),
              Text(
                '${_firstNameController.text} ${_lastNameController.text}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Basic Information
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('First Name', _firstNameController),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Last Name', _lastNameController),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(child: _buildTextField('Age', _ageController)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownField(
                      'Gender',
                      selectedGender,
                      ['Male', 'Female', 'Other'],
                      (value) {
                        setState(() {
                          selectedGender = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Weight (kg)', _weightController),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField('Height (cm)', _heightController),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Trainer Information Section
              _buildExpandableSection(
                'Trainer Information',
                isTrainerInfoExpanded,
                () {
                  setState(() {
                    isTrainerInfoExpanded = !isTrainerInfoExpanded;
                  });
                },
                [
                  _buildTextField(
                    'Experience',
                    _experienceController,
                    hintText: 'No. Of Years',
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Specialization',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSpecializationChip(
                          'Weight Loss',
                          selectedSpecialization == 'Weight Loss',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildSpecializationChip(
                          'Weight Gain',
                          selectedSpecialization == 'Weight Gain',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSpecializationChip(
                          'Maintenance',
                          selectedSpecialization == 'Maintenance',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildSpecializationChip(
                          'Muscle Build',
                          selectedSpecialization == 'Muscle Build',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Active Clients',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    '',
                    _activeClientsController,
                    showLabel: false,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Contact Information Section
              _buildExpandableSection(
                'Contact Information',
                isContactInfoExpanded,
                () {
                  setState(() {
                    isContactInfoExpanded = !isContactInfoExpanded;
                  });
                },
                [
                  _buildTextField('Email', _emailController),
                  const SizedBox(height: 16),
                  _buildTextField('Phone Number', _phoneController),
                  const SizedBox(height: 16),
                  _buildTextField('LinkedIn', _linkedinController),
                  const SizedBox(height: 16),
                  _buildTextField('Instagram', _instagramController),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? hintText,
    bool showLabel = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              dropdownColor: const Color(0xFF2A2A2A),
              style: const TextStyle(color: Colors.white),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              items: items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpandableSection(
    String title,
    bool isExpanded,
    VoidCallback onTap,
    List<Widget> children,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFC2D86A),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: const Color(0xFFC2D86A),
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSpecializationChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSpecialization = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFC2D86A) : const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(8),
          border: isSelected
              ? Border.all(color: const Color(0xFFC2D86A))
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
