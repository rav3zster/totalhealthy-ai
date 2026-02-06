import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSettingsView extends StatefulWidget {
  const ProfileSettingsView({super.key});

  @override
  State<ProfileSettingsView> createState() => _ProfileSettingsViewState();
}

class _ProfileSettingsViewState extends State<ProfileSettingsView> {
  final TextEditingController firstNameController = TextEditingController(
    text: 'Ayush',
  );
  final TextEditingController lastNameController = TextEditingController(
    text: 'shukla',
  );

  String selectedAge = '25';
  String selectedGender = 'Male';
  String selectedDietType = '';
  bool isDietPreferenceExpanded = true;

  // Food allergies
  Map<String, bool> foodAllergies = {
    'Gluten': false,
    'Dairy': false,
    'Nuts': false,
    'Shellfish': false,
    'Meat': false,
    'Not Specific': false,
  };

  // Diet types
  List<String> dietTypes = [
    'Vegetarian',
    'Vegan',
    'Keto',
    'Paleo',
    'Mediterranean',
    'Not Specific',
  ];

  // Preferred cuisines
  List<String> preferredCuisines = ['Indian', 'Italian', 'Chinese', 'Thai'];

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
                      TextButton(
                        onPressed: () {
                          // Handle save
                        },
                        child: const Text(
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
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Image and Name
                      Center(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(
                                      0xFFC2D86A,
                                    ).withValues(alpha: 0.3),
                                    const Color(
                                      0xFFC2D86A,
                                    ).withValues(alpha: 0.1),
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFC2D86A,
                                    ).withValues(alpha: 0.3),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(3),
                              child: const CircleAvatar(
                                radius: 40,
                                backgroundImage: AssetImage(
                                  'assets/user_avatar.png',
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Ayush shukla',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // First Name and Last Name
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'First Name',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF2A2A2A),
                                        Color(0xFF1A1A1A),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(
                                        0xFFC2D86A,
                                      ).withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: firstNameController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Last Name',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF2A2A2A),
                                        Color(0xFF1A1A1A),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(
                                        0xFFC2D86A,
                                      ).withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: lastNameController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Age and Gender
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Age',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF2A2A2A),
                                        Color(0xFF1A1A1A),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(
                                        0xFFC2D86A,
                                      ).withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedAge,
                                      dropdownColor: const Color(0xFF2A2A2A),
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.white,
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      items:
                                          List.generate(
                                            80,
                                            (index) => (index + 18).toString(),
                                          ).map((String age) {
                                            return DropdownMenuItem<String>(
                                              value: age,
                                              child: Text(age),
                                            );
                                          }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedAge = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF2A2A2A),
                                        Color(0xFF1A1A1A),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(
                                        0xFFC2D86A,
                                      ).withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedGender,
                                      dropdownColor: const Color(0xFF2A2A2A),
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.white,
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                      items: ['Male', 'Female', 'Other'].map((
                                        String gender,
                                      ) {
                                        return DropdownMenuItem<String>(
                                          value: gender,
                                          child: Text(gender),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedGender = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Diet Preference And Restriction
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                isDietPreferenceExpanded =
                                    !isDietPreferenceExpanded;
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
                                  isDietPreferenceExpanded
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: const Color(0xFFC2D86A),
                                ),
                              ],
                            ),
                          ),

                          if (isDietPreferenceExpanded) ...[
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
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                              itemCount: dietTypes.length,
                              itemBuilder: (context, index) {
                                final dietType = dietTypes[index];
                                final isSelected = selectedDietType == dietType;
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedDietType = isSelected
                                          ? ''
                                          : dietType;
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
                                                const Color(
                                                  0xFFC2D86A,
                                                ).withValues(alpha: 0.3),
                                                const Color(
                                                  0xFFC2D86A,
                                                ).withValues(alpha: 0.1),
                                              ],
                                            )
                                          : const LinearGradient(
                                              colors: [
                                                Color(0xFF2A2A2A),
                                                Color(0xFF1A1A1A),
                                              ],
                                            ),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFFC2D86A)
                                            : const Color(
                                                0xFFC2D86A,
                                              ).withValues(alpha: 0.2),
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
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                              itemCount: foodAllergies.length,
                              itemBuilder: (context, index) {
                                final allergy = foodAllergies.keys.elementAt(
                                  index,
                                );
                                final isSelected = foodAllergies[allergy]!;
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      foodAllergies[allergy] = !isSelected;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF2A2A2A),
                                          Color(0xFF1A1A1A),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(
                                          0xFFC2D86A,
                                        ).withValues(alpha: 0.2),
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
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
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

                            const SizedBox(height: 20),

                            // Preferred Cuisine
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Preferred Cuisine',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Preferred Cuisine Grid
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 3,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                  ),
                              itemCount: preferredCuisines.length,
                              itemBuilder: (context, index) {
                                final cuisine = preferredCuisines[index];
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF2A2A2A),
                                        Color(0xFF1A1A1A),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(
                                        0xFFC2D86A,
                                      ).withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      cuisine,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
