import 'package:flutter/material.dart';

class GenerateAiPage extends StatefulWidget {
  @override
  _GenerateAiPageState createState() => _GenerateAiPageState();
}

class _GenerateAiPageState extends State<GenerateAiPage> {
  bool isDietaryGoalsExpanded = true;
  bool isDietPreferenceExpanded = true;
  bool isMealPreferenceExpanded = true;
  bool isPhysicalActivityExpanded = true;
  bool isAdditionalInfoExpanded = true;

  // Selections
  String selectedDietaryGoal = "Weight Loss";
  String selectedDietType = "Vegetarian";
  String selectedCuisine = "Indian";
  String exerciseFrequency = "1-2 Days/Week";
  String typeOfExercise = "Cardio";
  bool prePostWorkoutNutrition = true;
  int numberOfMeals = 2;

  // Food Allergies
  List<String> foodAllergies = [];

  // Text Controllers
  TextEditingController currentWeightController = TextEditingController();
  TextEditingController targetWeightController = TextEditingController();
  TextEditingController nutritionalController = TextEditingController();
  TextEditingController specificFoodsController = TextEditingController();
  TextEditingController foodsToAvoidController = TextEditingController();
  TextEditingController medicalConditionController = TextEditingController();
  TextEditingController specialInstructionsController = TextEditingController();
  TextEditingController preferredStartDateController = TextEditingController();

  @override
  void dispose() {
    currentWeightController.dispose();
    targetWeightController.dispose();
    nutritionalController.dispose();
    specificFoodsController.dispose();
    foodsToAvoidController.dispose();
    medicalConditionController.dispose();
    specialInstructionsController.dispose();
    preferredStartDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(Icons.arrow_back, color: Colors.white),
        title: Text('Creating A Meal', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dietary Goals Section
              buildAccordion(
                title: "Dietary Goals",
                isExpanded: isDietaryGoalsExpanded,
                onToggle: () {
                  setState(() {
                    isDietaryGoalsExpanded = !isDietaryGoalsExpanded;
                  });
                },
                content: Column(
                  children: [
                    buildSelectableContainerRow(
                      [
                        "Weight Loss",
                        "Weight Gain",
                        "Maintenance",
                        "Muscle Build"
                      ],
                      selectedDietaryGoal,
                      (value) => setState(() => selectedDietaryGoal = value),
                    ),
                    buildTextInputRow(
                        "Current Weight", currentWeightController),
                    buildTextInputRow("Target Weight", targetWeightController),
                    buildTextInputRow(
                        "Nutritional Breakdown", nutritionalController),
                  ],
                ),
              ),

              // Diet Preference and Restriction Section
              buildAccordion(
                title: "Diet Preference And Restriction",
                isExpanded: isDietPreferenceExpanded,
                onToggle: () {
                  setState(() {
                    isDietPreferenceExpanded = !isDietPreferenceExpanded;
                  });
                },
                content: Column(
                  children: [
                    buildSelectableContainerRow(
                      ["Vegetarian", "Vegan", "Keto", "Paleo"],
                      selectedDietType,
                      (value) => setState(() => selectedDietType = value),
                    ),
                    buildCheckboxRow(
                      ["Gluten", "Dairy", "Nuts", "Shellfish", "Meat"],
                      foodAllergies,
                      (value) => setState(() {}),
                    ),
                    buildSelectableContainerRow(
                      ["Indian", "Italian", "Chinese", "Thai"],
                      selectedCuisine,
                      (value) => setState(() => selectedCuisine = value),
                    ),
                  ],
                ),
              ),

              // Meal Preference Section
              buildAccordion(
                title: "Meal Preference",
                isExpanded: isMealPreferenceExpanded,
                onToggle: () {
                  setState(() {
                    isMealPreferenceExpanded = !isMealPreferenceExpanded;
                  });
                },
                content: Column(
                  children: [
                    buildIncrementDecrementRow(
                      "Number of Meals Per Day",
                      numberOfMeals,
                      () => setState(() => numberOfMeals++),
                      () => setState(() => numberOfMeals--),
                    ),
                    buildCheckboxRow(
                      [
                        "Breakfast",
                        "Lunch",
                        "Dinner",
                        "Morning Snack",
                        "Preworkout"
                      ],
                      foodAllergies, // For example purposes, adjust according to real data
                      (value) => setState(() {}),
                    ),
                    buildRadioButtonRow(
                      ["Yes", "No"],
                      prePostWorkoutNutrition ? "Yes" : "No",
                      (value) => setState(
                          () => prePostWorkoutNutrition = value == "Yes"),
                    ),
                  ],
                ),
              ),

              // Physical Activity Section
              buildAccordion(
                title: "Physical Activity",
                isExpanded: isPhysicalActivityExpanded,
                onToggle: () {
                  setState(() {
                    isPhysicalActivityExpanded = !isPhysicalActivityExpanded;
                  });
                },
                content: Column(
                  children: [
                    buildSelectableContainerRow(
                      ["1-2 Days/Week", "3-4 Days/Week", "5-7 Days/Week"],
                      exerciseFrequency,
                      (value) => setState(() => exerciseFrequency = value),
                    ),
                    buildSelectableContainerRow(
                      ["Cardio", "Strength Training", "Mixed", "Zumba"],
                      typeOfExercise,
                      (value) => setState(() => typeOfExercise = value),
                    ),
                  ],
                ),
              ),

              // Additional Info Section
              buildAccordion(
                title: "Additional Info",
                isExpanded: isAdditionalInfoExpanded,
                onToggle: () {
                  setState(() {
                    isAdditionalInfoExpanded = !isAdditionalInfoExpanded;
                  });
                },
                content: Column(
                  children: [
                    buildTextInputRow(
                        "Any Medical Condition", medicalConditionController),
                    buildTextInputRow(
                        "Preferred Start Date", preferredStartDateController),
                    buildTextInputRow(
                        "Special Instructions", specialInstructionsController),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Generate Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    // Action on submit (print the selected values)
                    printData();
                  },
                  child: Text("Generate Using AI",
                      style: TextStyle(color: Colors.black, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to print selected data
  void printData() {
    print("Selected Dietary Goal: $selectedDietaryGoal");
    print("Current Weight: ${currentWeightController.text}");
    print("Target Weight: ${targetWeightController.text}");
    print("Selected Diet Type: $selectedDietType");
    print("Selected Cuisine: $selectedCuisine");
    print("Number of Meals: $numberOfMeals");
    print("Exercise Frequency: $exerciseFrequency");
    print("Type of Exercise: $typeOfExercise");
    print("Pre/Post Workout Nutrition: $prePostWorkoutNutrition");
    print("Medical Condition: ${medicalConditionController.text}");
    print("Preferred Start Date: ${preferredStartDateController.text}");
    print("Special Instructions: ${specialInstructionsController.text}");
  }

  // Reusable accordion (collapsible section)
  Widget buildAccordion(
      {required String title,
      required bool isExpanded,
      required VoidCallback onToggle,
      required Widget content}) {
    return Card(
      color: Colors.grey.withOpacity(0.1),
      child: ExpansionTile(
        title: Text(title,
            style: TextStyle(
                color: Colors.greenAccent, fontWeight: FontWeight.bold)),
        trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more,
            color: Colors.white),
        onExpansionChanged: (value) => onToggle(),
        children: [content],
      ),
    );
  }

  // Reusable selectable container row
  Widget buildSelectableContainerRow(
      List<String> options, String selectedValue, Function(String) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: options.map((option) {
        return GestureDetector(
          onTap: () {
            onChanged(option);
          },
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: selectedValue == option
                  ? Colors.greenAccent.withOpacity(0.2)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selectedValue == option
                    ? Colors.greenAccent
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Text(
              option,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Reusable checkbox row for multiple selections
  Widget buildCheckboxRow(List<String> options, List<String> selectedItems,
      Function(bool) onChanged) {
    return Wrap(
      spacing: 10,
      children: options.map((option) {
        return FilterChip(
          label: Text(option, style: TextStyle(color: Colors.white)),
          selected: selectedItems.contains(option),
          selectedColor: Colors.greenAccent.withOpacity(0.2),
          onSelected: (selected) {
            setState(() {
              if (selected) {
                selectedItems.add(option);
              } else {
                selectedItems.remove(option);
              }
            });
          },
        );
      }).toList(),
    );
  }

  // Reusable text input field (single line)
  Widget buildTextInputRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.grey.withOpacity(0.2),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  // Reusable increment/decrement row
  Widget buildIncrementDecrementRow(String label, int value,
      VoidCallback onIncrement, VoidCallback onDecrement) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white)),
        Row(
          children: [
            IconButton(
                onPressed: onDecrement,
                icon: Icon(Icons.remove_circle_outline, color: Colors.white)),
            Text(value.toString(), style: TextStyle(color: Colors.white)),
            IconButton(
                onPressed: onIncrement,
                icon: Icon(Icons.add_circle_outline, color: Colors.white)),
          ],
        ),
      ],
    );
  }

  // Reusable row with radio buttons for binary choices (like Yes/No)
  Widget buildRadioButtonRow(
      List<String> options, String selectedValue, Function(String) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: options.map((option) {
        return ChoiceChip(
          label: Text(option,
              style: TextStyle(
                  color:
                      selectedValue == option ? Colors.black : Colors.white)),
          selected: selectedValue == option,
          selectedColor: Colors.greenAccent,
          onSelected: (selected) {
            if (selected) onChanged(option);
          },
        );
      }).toList(),
    );
  }
}
