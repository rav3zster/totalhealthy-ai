import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/user_controller.dart';
import '../../../widgets/loading_state_widget.dart';
import '../../../widgets/error_state_widget.dart';
import '../../../core/utitlity/appvalidator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileEditView extends StatefulWidget {
  const ProfileEditView({super.key});

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  final _formKey = GlobalKey<FormState>();
  final userController = Get.find<UserController>();

  // Form controllers
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _weightController;
  late TextEditingController _heightController;
  late TextEditingController _ageController;

  // Selected values
  String? _selectedActivityLevel;
  List<String> _selectedGoals = [];

  // Activity level options
  final List<String> _activityLevels = [
    'Sedentary',
    'Light',
    'Moderate',
    'Active',
    'Very Active',
  ];

  // Goal options
  final List<String> _goalOptions = [
    'Weight Loss',
    'Muscle Gain',
    'Maintenance',
    'Endurance',
    'Strength',
    'Flexibility',
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final user = userController.currentUser;
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _weightController = TextEditingController(
      text: user?.weight.toString() ?? '',
    );
    _heightController = TextEditingController(
      text: user?.height.toString() ?? '',
    );
    _ageController = TextEditingController(text: user?.age.toString() ?? '');
    _selectedActivityLevel = user?.activityLevel ?? 'Moderate';
    _selectedGoals = List<String>.from(user?.goals ?? []);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(
            () => TextButton(
              onPressed: userController.isLoading ? null : _saveProfile,
              child: Text(
                'Save',
                style: TextStyle(
                  color: userController.isLoading
                      ? Colors.white54
                      : const Color(0xFFC2D86A),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (userController.error.isNotEmpty) {
          return ErrorStateWidget(
            error: userController.error,
            onRetry: () => userController.refreshUserData(),
          );
        }

        return LoadingStateWidget(
          isLoading: userController.isLoading,
          loadingText: 'Saving profile...',
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image Section
                  _buildProfileImageSection(),

                  const SizedBox(height: 30),

                  // Personal Information
                  _buildSectionTitle('Personal Information'),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTextFormField(
                          controller: _firstNameController,
                          label: 'First Name',
                          validator: AppValidator.validateName,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextFormField(
                          controller: _lastNameController,
                          label: 'Last Name',
                          validator: AppValidator.validateName,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _buildTextFormField(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: AppValidator.validateEmail,
                    enabled: false, // Email usually shouldn't be editable
                  ),

                  const SizedBox(height: 16),

                  _buildTextFormField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    keyboardType: TextInputType.phone,
                    validator: AppValidator.validatePhone,
                  ),

                  const SizedBox(height: 30),

                  // Physical Information
                  _buildSectionTitle('Physical Information'),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTextFormField(
                          controller: _ageController,
                          label: 'Age',
                          keyboardType: TextInputType.number,
                          validator: (value) => AppValidator.validateAge(
                            int.tryParse(value ?? ''),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextFormField(
                          controller: _weightController,
                          label: 'Weight (kg)',
                          keyboardType: TextInputType.number,
                          validator: (value) => AppValidator.validateWeight(
                            double.tryParse(value ?? ''),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextFormField(
                          controller: _heightController,
                          label: 'Height (cm)',
                          keyboardType: TextInputType.number,
                          validator: (value) => AppValidator.validateHeight(
                            int.tryParse(value ?? ''),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Activity Level
                  _buildSectionTitle('Activity Level'),
                  const SizedBox(height: 16),
                  _buildActivityLevelSelector(),

                  const SizedBox(height: 30),

                  // Goals
                  _buildSectionTitle('Fitness Goals'),
                  const SizedBox(height: 16),
                  _buildGoalsSelector(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildProfileImageSection() {
    return Center(
      child: GestureDetector(
        onTap: _showImagePickerOptions,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: const Color(0xFF2A2A2A),
              backgroundImage: UserController.getImageProvider(
                userController.profileImage,
              ),
              child: userController.profileImage.isEmpty
                  ? const Icon(Icons.person, size: 50, color: Colors.white24)
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFC2D86A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Profile Photo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: Color(0xFFC2D86A),
              ),
              title: const Text(
                'Gallery',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFFC2D86A)),
              title: const Text(
                'Camera',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
            ),
            if (userController.profileImage.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Remove Photo',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Get.back();
                  _removePhoto();
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 50, // Reduced quality for Base64 storage
        maxWidth: 256, // Smaller size for Base64 storage
        maxHeight: 256, // Smaller size for Base64 storage
      );

      if (image != null) {
        await userController.uploadProfileImage(File(image.path));
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _removePhoto() async {
    try {
      await userController.updateUserProfile(profileImage: '');
      Get.snackbar(
        'Success',
        'Profile photo removed',
        backgroundColor: const Color(0xFFC2D86A),
        colorText: Colors.black,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to remove photo: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      enabled: enabled,
      style: TextStyle(
        color: enabled ? Colors.white : Colors.white54,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFC2D86A)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3A3A3A)),
        ),
      ),
    );
  }

  Widget _buildActivityLevelSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedActivityLevel,
          isExpanded: true,
          dropdownColor: const Color(0xFF2A2A2A),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          items: _activityLevels.map((level) {
            return DropdownMenuItem<String>(value: level, child: Text(level));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedActivityLevel = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildGoalsSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _goalOptions.map((goal) {
        final isSelected = _selectedGoals.contains(goal);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedGoals.remove(goal);
              } else {
                _selectedGoals.add(goal);
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFC2D86A)
                  : const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFC2D86A)
                    : const Color(0xFF3A3A3A),
              ),
            ),
            child: Text(
              goal,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedGoals.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please select at least one fitness goal',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      await userController.updateUserProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
        age: int.parse(_ageController.text.trim()),
        weight: double.parse(_weightController.text.trim()),
        height: int.parse(_heightController.text.trim()),
        activityLevel: _selectedActivityLevel!,
        goals: _selectedGoals,
      );

      Get.back();
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        backgroundColor: const Color(0xFFC2D86A),
        colorText: Colors.black,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
