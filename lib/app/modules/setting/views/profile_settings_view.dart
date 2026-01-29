import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSettingsView extends StatefulWidget {
  const ProfileSettingsView({super.key});

  @override
  State<ProfileSettingsView> createState() => _ProfileSettingsViewState();
}

class _ProfileSettingsViewState extends State<ProfileSettingsView> {
  final TextEditingController firstNameController = TextEditingController(text: 'Ayush');
  final TextEditingController lastNameController = TextEditingController(text: 'shukla');
  
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
  List<String> dietTypes = ['Vegetarian', 'Vegan', 'Keto', 'Paleo', 'Mediterranean', 'Not Specific'];
  
  // Preferred cuisines
  List<String> preferredCuisines = ['Indian', 'Italian', 'Chinese', 'Thai'];

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
          'Profile',
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
              // Handle save
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image and Name
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/user_avatar.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
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
            
            SizedBox(height: 30),
            
            // First Name and Last Name
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'First Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        decoration: BoxDecoration(
                          color: Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: firstNameController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                        decoration: BoxDecoration(
                          color: Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: lastNameController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
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
            
            SizedBox(height: 20),
            
            // Age and Gender
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Age',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          color: Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedAge,
                            dropdownColor: Color(0xFF2A2A2A),
                            icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            items: List.generate(80, (index) => (index + 18).toString())
                                .map((String age) {
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
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gender',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                          color: Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedGender,
                            dropdownColor: Color(0xFF2A2A2A),
                            icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            items: ['Male', 'Female', 'Other'].map((String gender) {
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
            
            SizedBox(height: 30),
            
            // Diet Preference And Restriction
            Container(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        isDietPreferenceExpanded = !isDietPreferenceExpanded;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
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
                          color: Color(0xFFC2D86A),
                        ),
                      ],
                    ),
                  ),
                  
                  if (isDietPreferenceExpanded) ...[
                    SizedBox(height: 20),
                    
                    // Diet Type
                    Align(
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
                    SizedBox(height: 10),
                    
                    // Diet Type Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                              selectedDietType = isSelected ? '' : dietType;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? Color(0xFFC2D86A).withOpacity(0.2) : Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(10),
                              border: isSelected ? Border.all(color: Color(0xFFC2D86A)) : null,
                            ),
                            child: Center(
                              child: Text(
                                dietType,
                                style: TextStyle(
                                  color: isSelected ? Color(0xFFC2D86A) : Colors.white70,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Food Allergies
                    Align(
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
                    SizedBox(height: 10),
                    
                    // Food Allergies Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: foodAllergies.length,
                      itemBuilder: (context, index) {
                        final allergy = foodAllergies.keys.elementAt(index);
                        final isSelected = foodAllergies[allergy]!;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              foodAllergies[allergy] = !isSelected;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: isSelected ? Color(0xFFC2D86A) : Colors.transparent,
                                    border: Border.all(
                                      color: isSelected ? Color(0xFFC2D86A) : Colors.white54,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: isSelected
                                    ? Icon(Icons.check, color: Colors.black, size: 14)
                                    : null,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    allergy,
                                    style: TextStyle(
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
                    
                    SizedBox(height: 20),
                    
                    // Preferred Cuisine
                    Align(
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
                    SizedBox(height: 10),
                    
                    // Preferred Cuisine Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: preferredCuisines.length,
                      itemBuilder: (context, index) {
                        final cuisine = preferredCuisines[index];
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              cuisine,
                              style: TextStyle(
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
            ),
            
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}