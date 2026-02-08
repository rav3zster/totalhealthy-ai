import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../controllers/user_controller.dart';
import '../../../widgets/loading_state_widget.dart';
import '../../../widgets/error_state_widget.dart';
import '../../../core/utitlity/appvalidator.dart';
import '../../../routes/app_pages.dart';

class ProfileSettingsView extends StatefulWidget {
  const ProfileSettingsView({super.key});

  @override
  State<ProfileSettingsView> createState() => _ProfileSettingsViewState();
}

class _ProfileSettingsViewState extends State<ProfileSettingsView> {
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
  String _selectedGender = 'Male';
  String _selectedDietType = '';
  bool _isDietPreferenceExpanded = true;

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

  // Diet types
  final List<String> _dietTypes = [
    'Vegetarian',
    'Vegan',
    'Keto',
    'Paleo',
    'Mediterranean',
    'Not Specific',
  ];

  // Food allergies
  final Map<String, bool> _foodAllergies = {
    'Gluten': false,
    'Dairy': false,
    'Nuts': false,
    'Shellfish': false,
    'Meat': false,
    'Not Specific': false,
  };

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
                          'Profile',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'inter',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Obx(
                        () => TextButton(
                          onPressed: userController.isLoading
                              ? null
                              : _saveProfile,
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
                ),
              ),

              // Content
              Expanded(
                child: Obx(() {
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile Image Section
                            _buildProfileImageSection(),

                            const SizedBox(height: 30),

                            // Personal Information Section
                            _buildSectionTitle('Personal Information'),
                            const SizedBox(height: 16),

                            // First Name and Last Name
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextFormField(
                                    controller: _firstNameController,
                                    label: 'First Name',
                                    validator: AppValidator.validateName,
                                  ),
                                ),
                                const SizedBox(width: 15),
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

                            // Email
                            _buildTextFormField(
                              controller: _emailController,
                              label: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              validator: AppValidator.validateEmail,
                              enabled:
                                  false, // Email usually shouldn't be editable
                            ),

                            const SizedBox(height: 16),

                            // Phone Number
                            _buildTextFormField(
                              controller: _phoneController,
                              label: 'Phone Number',
                              keyboardType: TextInputType.phone,
                              validator: AppValidator.validatePhone,
                            ),

                            const SizedBox(height: 30),

                            // Physical Information Section
                            _buildSectionTitle('Physical Information'),
                            const SizedBox(height: 16),

                            // Age, Weight, Height
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextFormField(
                                    controller: _ageController,
                                    label: 'Age',
                                    keyboardType: TextInputType.number,
                                    validator: (value) =>
                                        AppValidator.validateAge(
                                          int.tryParse(value ?? ''),
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildTextFormField(
                                    controller: _weightController,
                                    label: 'Weight (kg)',
                                    keyboardType: TextInputType.number,
                                    validator: (value) =>
                                        AppValidator.validateWeight(
                                          double.tryParse(value ?? ''),
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildTextFormField(
                                    controller: _heightController,
                                    label: 'Height (cm)',
                                    keyboardType: TextInputType.number,
                                    validator: (value) =>
                                        AppValidator.validateHeight(
                                          int.tryParse(value ?? ''),
                                        ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Gender
                            _buildGenderSelector(),

                            const SizedBox(height: 30),

                            // Activity Level Section
                            _buildSectionTitle('Activity Level'),
                            const SizedBox(height: 16),
                            _buildActivityLevelSelector(),

                            const SizedBox(height: 30),

                            // Fitness Goals Section
                            _buildSectionTitle('Fitness Goals'),
                            const SizedBox(height: 16),
                            _buildGoalsSelector(),

                            const SizedBox(height: 30),

                            // Diet Preference And Restriction Section
                            _buildDietPreferenceSection(),

                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Center(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFC2D86A).withValues(alpha: 0.3),
                  const Color(0xFFC2D86A).withValues(alpha: 0.1),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFC2D86A).withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.all(3),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: userController.profileImage.isNotEmpty
                  ? NetworkImage(userController.profileImage)
                  : const AssetImage('assets/user_avatar.png') as ImageProvider,
            ),
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
    );
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFC2D86A).withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            enabled: enabled,
            style: TextStyle(
              color: enabled ? Colors.white : Colors.white54,
              fontSize: 16,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFC2D86A).withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedGender,
              isExpanded: true,
              dropdownColor: const Color(0xFF2A2A2A),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              items: ['Male', 'Female', 'Other'].map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivityLevelSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFC2D86A).withValues(alpha: 0.2),
          width: 1,
        ),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFFC2D86A), Color(0xFFB8CC5A)],
                    )
                  : const LinearGradient(
                      colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                    ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFC2D86A)
                    : const Color(0xFFC2D86A).withValues(alpha: 0.2),
                width: 1,
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

  Widget _buildDietPreferenceSection() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isDietPreferenceExpanded = !_isDietPreferenceExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Diet Preference And Restriction',
                style: TextStyle(
                  color: Color(0xFFC2D86A),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                _isDietPreferenceExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: const Color(0xFFC2D86A),
              ),
            ],
          ),
        ),

        if (_isDietPreferenceExpanded) ...[
          const SizedBox(height: 20),

          // Diet Type
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Diet Type',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Diet Type Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _dietTypes.length,
            itemBuilder: (context, index) {
              final dietType = _dietTypes[index];
              final isSelected = _selectedDietType == dietType;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedDietType = isSelected ? '' : dietType;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              const Color(0xFFC2D86A).withValues(alpha: 0.3),
                              const Color(0xFFC2D86A).withValues(alpha: 0.1),
                            ],
                          )
                        : const LinearGradient(
                            colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                          ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFC2D86A)
                          : const Color(0xFFC2D86A).withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      dietType,
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFFC2D86A)
                            : Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // Food Allergies
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Food Allergies',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Food Allergies Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: _foodAllergies.length,
            itemBuilder: (context, index) {
              final allergy = _foodAllergies.keys.elementAt(index);
              final isSelected = _foodAllergies[allergy]!;
              return InkWell(
                onTap: () {
                  setState(() {
                    _foodAllergies[allergy] = !isSelected;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFC2D86A).withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFC2D86A)
                              : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFC2D86A)
                                : Colors.white54,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.black,
                                size: 14,
                              )
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          allergy,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ],
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

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        backgroundColor: const Color(0xFFC2D86A),
        colorText: Colors.black,
      );

      // Check if user came from incomplete profile flow
      // If so, redirect to appropriate dashboard
      final box = GetStorage();

      // If user doesn't have a role yet, they need to choose one
      if (!box.hasData("role") || box.read("role").isEmpty) {
        Get.offAllNamed(Routes.SWITCHROLE);
      } else {
        // User has a role, go to their dashboard
        Get.back();
      }
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
