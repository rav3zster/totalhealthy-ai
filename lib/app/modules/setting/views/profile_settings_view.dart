import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../../../controllers/user_controller.dart';
import '../../../widgets/loading_state_widget.dart';
import '../../../widgets/error_state_widget.dart';
import '../../../core/utitlity/appvalidator.dart';
import '../../../core/theme/theme_helper.dart';

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
  String? _selectedMealFrequency;
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
    'Improved Overall Health',
  ];

  // Meal frequency options
  final List<String> _mealFrequencies = [
    "3 times a day (breakfast, lunch, dinner)",
    "4-5 times a day (adding snacks)",
    "I don't have a specific schedule",
  ];

  // Diet types
  final List<String> _dietTypes = [
    'Vegetarian',
    'Vegan',
    'Keto',
    'Paleo',
    'Mediterranean',
    'Gluten-free',
    'Lactose-free',
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

  // Translation keys for dropdowns
  String _getActivityLevelKey(String level) {
    switch (level) {
      case 'Sedentary':
        return 'sedentary';
      case 'Light':
        return 'light_activity';
      case 'Moderate':
        return 'moderate';
      case 'Active':
        return 'active';
      case 'Very Active':
        return 'very_active';
      default:
        return 'moderate';
    }
  }

  String _getGoalKey(String goal) {
    switch (goal) {
      case 'Weight Loss':
        return 'weight_loss';
      case 'Muscle Gain':
        return 'muscle_gain';
      case 'Maintenance':
        return 'maintenance';
      case 'Endurance':
        return 'endurance';
      case 'Strength':
        return 'strength';
      case 'Flexibility':
        return 'flexibility';
      case 'Improved Overall Health':
        return 'improved_overall_health';
      default:
        return goal;
    }
  }

  String _getMealFrequencyKey(String freq) {
    switch (freq) {
      case "3 times a day (breakfast, lunch, dinner)":
        return 'meal_3_times';
      case "4-5 times a day (adding snacks)":
        return 'meal_4_5_times';
      case "I don't have a specific schedule":
        return 'meal_no_schedule';
      default:
        return freq;
    }
  }

  String _getDietTypeKey(String type) {
    switch (type) {
      case 'Vegetarian':
        return 'vegetarian';
      case 'Vegan':
        return 'vegan';
      case 'Keto':
        return 'keto';
      case 'Paleo':
        return 'paleo';
      case 'Mediterranean':
        return 'mediterranean';
      case 'Gluten-free':
        return 'gluten_free';
      case 'Lactose-free':
        return 'lactose_free';
      case 'Not Specific':
        return 'not_specific';
      default:
        return type;
    }
  }

  String _getAllergyKey(String allergy) {
    switch (allergy) {
      case 'Gluten':
        return 'gluten';
      case 'Dairy':
        return 'dairy';
      case 'Nuts':
        return 'nuts';
      case 'Shellfish':
        return 'shellfish';
      case 'Meat':
        return 'meat';
      case 'Not Specific':
        return 'not_specific';
      default:
        return allergy;
    }
  }

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

    // Ensure activity level is valid
    final activityLevel = user?.activityLevel ?? 'Moderate';
    _selectedActivityLevel = _activityLevels.contains(activityLevel)
        ? activityLevel
        : 'Moderate';

    // Ensure meal frequency is valid
    final mealFreq = user?.mealFrequency ?? "I don't have a specific schedule";
    _selectedMealFrequency = _mealFrequencies.contains(mealFreq)
        ? mealFreq
        : "I don't have a specific schedule";

    _selectedGoals = List<String>.from(user?.goals ?? []);
    _selectedGender = user?.gender ?? 'Male';
    _selectedDietType = user?.dietType ?? 'Not Specific';
    if (user?.allergies != null) {
      _foodAllergies.clear();
      _foodAllergies.addAll(user!.allergies);
    }
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
        decoration: BoxDecoration(gradient: context.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  gradient: context.headerGradient,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  boxShadow: context.cardShadow,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              context.accent.withValues(alpha: 0.2),
                              context.accent.withValues(alpha: 0.1),
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: context.textPrimary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'profile'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: context.textPrimary,
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
                            'save'.tr,
                            style: TextStyle(
                              color: userController.isLoading
                                  ? context.textTertiary
                                  : context.accent,
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
                    loadingText: 'saving_profile'.tr,
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
                            _buildSectionTitle('personal_information'.tr),
                            const SizedBox(height: 16),

                            // First Name and Last Name
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextFormField(
                                    controller: _firstNameController,
                                    label: 'first_name'.tr,
                                    validator: AppValidator.validateName,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: _buildTextFormField(
                                    controller: _lastNameController,
                                    label: 'last_name'.tr,
                                    validator: AppValidator.validateName,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Email
                            _buildTextFormField(
                              controller: _emailController,
                              label: 'email'.tr,
                              keyboardType: TextInputType.emailAddress,
                              validator: AppValidator.validateEmail,
                              enabled:
                                  false, // Email usually shouldn't be editable
                            ),

                            const SizedBox(height: 16),

                            // Phone Number
                            _buildTextFormField(
                              controller: _phoneController,
                              label: 'phone_number'.tr,
                              keyboardType: TextInputType.phone,
                              validator: AppValidator.validatePhone,
                            ),

                            const SizedBox(height: 30),

                            // Physical Information Section
                            _buildSectionTitle('physical_information'.tr),
                            const SizedBox(height: 16),

                            // Age, Weight, Height
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextFormField(
                                    controller: _ageController,
                                    label: 'age'.tr,
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
                                    label: 'weight_kg'.tr,
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
                                    label: 'height_cm'.tr,
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
                            _buildSectionTitle('activity_level'.tr),
                            const SizedBox(height: 16),
                            _buildActivityLevelSelector(),

                            const SizedBox(height: 30),

                            // Meal Frequency Section
                            _buildSectionTitle('meal_frequency'.tr),
                            const SizedBox(height: 16),
                            _buildMealFrequencySelector(),

                            const SizedBox(height: 30),

                            // Fitness Goals Section
                            _buildSectionTitle('fitness_goals'.tr),
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
    return Builder(
      builder: (context) => Center(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.accent.withValues(alpha: 0.3),
                    context.accent.withValues(alpha: 0.1),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: context.accent.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(3),
              child: GestureDetector(
                onTap: _pickAndUploadImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: context.cardSecondary,
                  backgroundImage:
                      UserController.getImageProvider(
                        userController.profileImage,
                      ) ??
                      const AssetImage('assets/user_avatar.png')
                          as ImageProvider,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _pickAndUploadImage,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.accent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Builder(
      builder: (context) => Text(
        title,
        style: TextStyle(
          color: context.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
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
    return Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: context.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            decoration: BoxDecoration(
              gradient: context.cardGradient,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.accent.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              validator: validator,
              enabled: enabled,
              style: TextStyle(
                color: enabled ? context.textPrimary : context.textSecondary,
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
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'gender'.tr,
            style: TextStyle(
              color: context.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              gradient: context.cardGradient,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: context.accent.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedGender,
                isExpanded: true,
                dropdownColor: context.cardColor,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: context.textPrimary,
                ),
                style: TextStyle(color: context.textPrimary, fontSize: 16),
                items: ['Male', 'Female', 'Other'].map((String gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender.toLowerCase().tr),
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
      ),
    );
  }

  Widget _buildActivityLevelSelector() {
    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          gradient: context.cardGradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.accent.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedActivityLevel,
            isExpanded: true,
            dropdownColor: context.cardColor,
            icon: Icon(Icons.keyboard_arrow_down, color: context.textPrimary),
            style: TextStyle(color: context.textPrimary, fontSize: 16),
            items: _activityLevels.map((level) {
              return DropdownMenuItem<String>(
                value: level,
                child: Text(_getActivityLevelKey(level).tr),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedActivityLevel = value;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMealFrequencySelector() {
    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          gradient: context.cardGradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.accent.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedMealFrequency,
            icon: Icon(Icons.keyboard_arrow_down, color: context.textPrimary),
            isExpanded: true,
            dropdownColor: context.cardColor,
            style: TextStyle(color: context.textPrimary, fontSize: 16),
            items: _mealFrequencies.map((freq) {
              return DropdownMenuItem<String>(
                value: freq,
                child: Text(_getMealFrequencyKey(freq).tr),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedMealFrequency = value;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGoalsSelector() {
    return Builder(
      builder: (context) => Wrap(
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
                    ? context.accentGradient
                    : context.cardGradient,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? context.accent
                      : context.accent.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Text(
                _getGoalKey(goal).tr,
                style: TextStyle(
                  color: isSelected ? Colors.black : context.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDietPreferenceSection() {
    return Builder(
      builder: (context) => Column(
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
                Text(
                  'diet_preference_restriction'.tr,
                  style: TextStyle(
                    color: context.accent,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  _isDietPreferenceExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: context.accent,
                ),
              ],
            ),
          ),

          if (_isDietPreferenceExpanded) ...[
            const SizedBox(height: 20),

            // Diet Type
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'diet_type'.tr,
                style: TextStyle(
                  color: context.textPrimary,
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
                                context.accent.withValues(alpha: 0.3),
                                context.accent.withValues(alpha: 0.1),
                              ],
                            )
                          : context.cardGradient,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? context.accent
                            : context.accent.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _getDietTypeKey(dietType).tr,
                        style: TextStyle(
                          color: isSelected
                              ? context.accent
                              : context.textSecondary,
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
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'food_allergies'.tr,
                style: TextStyle(
                  color: context.textPrimary,
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
                      gradient: context.cardGradient,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: context.accent.withValues(alpha: 0.2),
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
                                ? context.accent
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? context.accent
                                  : context.textSecondary,
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
                            _getAllergyKey(allergy).tr,
                            style: TextStyle(
                              color: context.textSecondary,
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
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedGoals.isEmpty) {
      Get.snackbar(
        'validation_error'.tr,
        'select_one_fitness_goal'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final accentColor = context.accent;
      await userController.updateUserProfile(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
        age: int.parse(_ageController.text.trim()),
        weight: double.parse(_weightController.text.trim()),
        height: int.parse(_heightController.text.trim()),
        activityLevel: _selectedActivityLevel!,
        mealFrequency: _selectedMealFrequency!,
        goals: _selectedGoals,
        gender: _selectedGender,
        dietType: _selectedDietType,
        allergies: _foodAllergies,
      );

      Get.snackbar(
        'success'.tr,
        'profile_updated_successfully'.tr,
        backgroundColor: accentColor,
        colorText: Colors.black,
      );

      // Just go back - don't force navigation
      Get.back();
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        '${'failed_to_update_profile'.tr}: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _pickAndUploadImage() async {
    final accentColor = Get.context?.accent;
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image != null) {
        await userController.uploadProfileImage(File(image.path));
        Get.snackbar(
          'success'.tr,
          'profile_picture_updated'.tr,
          backgroundColor: accentColor,
          colorText: Colors.black,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        '${'failed_to_upload_image'.tr}: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
