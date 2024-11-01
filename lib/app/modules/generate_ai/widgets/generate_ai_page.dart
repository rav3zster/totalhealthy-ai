import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/base/apiservice/api_endpoints.dart';
import '../../../core/base/apiservice/api_status.dart';
import '../../../core/base/apiservice/base_methods.dart';

class GenerateAiPage extends StatefulWidget {
  final String id;

  const GenerateAiPage({super.key, required this.id});

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

  GlobalKey<FormState> key = GlobalKey<FormState>();

  var isLoading = false;
//  {"name": "string", "amount": "string", "unit": "string"}
  submitUser(
    context,
  ) async {
    // DateTime now = DateTime.now();
    // int timestamp = now.millisecondsSinceEpoch;
    try {
      // String id = userId.toString();
      setState(() {
        isLoading = true;
      });

      Map<String, dynamic> data = {
        "client_details": {
          "weight": targetWeightController.text.trim(),
          "target_weight": targetWeightController.text.trim(),
          "height": "5.5",
          "age": 25,
          "gender": "Male",
          "activity_level": "High",
          "dietary_preferences": selectedDietType,
          "health_conditions": ["string"],
          "caloric_goal": "string",
          "macronutrient_goal": {},
          "preferred_meal_composition": "string",
          "hydration_requirements": "string",
          "meal_timing": {}
        },
        "categories": ["string"]
      };

      print(data);

      await APIMethods.post
          .post(url: APIEndpoints.createData.generateDiet, map: data)
          .then((value) {
        if (APIStatus.success(value.statusCode)) {
          // clearDetails();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Generate Meal Successful!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // printError("Auth Controller", "Signup", value.data);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Meals not created'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
      // }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    // if (_formKey.currentState!.validate()) {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.toNamed('/userdiet?id=${widget.id}');
            },
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: Colors.white,
            )),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: buildSelectableContainerRow(
                            [
                              "Weight Loss",
                              "Weight Gain",
                            ],
                            selectedDietaryGoal,
                            (value) =>
                                setState(() => selectedDietaryGoal = value),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: buildSelectableContainerRow(
                            ["Maintenance", "Muscle Build"],
                            selectedDietaryGoal,
                            (value) =>
                                setState(() => selectedDietaryGoal = value),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildTextInputRow(
                              "Current Weight", currentWeightController),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                            child: buildTextInputRow(
                                "Target Weight", targetWeightController)),
                      ],
                    ),
                    Text(
                      "Nutritional Breakdown",
                      style: TextStyle(
                          color: Color(0XFFDBDBDB),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: buildTextInputRow(
                                "2500",
                                nutritionalController,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: buildTextInputRow(
                                "200",
                                nutritionalController,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: buildTextInputRow(
                                "120",
                                nutritionalController,
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: buildTextInputRow(
                                "60",
                                nutritionalController,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Diet Type",
                      style: TextStyle(
                          color: Color(0XFFDBDBDB),
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildSelectableContainerRow(
                            ["Vegetarian"],
                            selectedDietType,
                            (value) => setState(() => selectedDietType = value),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: buildSelectableContainerRow(
                            ["Keto"],
                            selectedDietType,
                            (value) => setState(() => selectedDietType = value),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildSelectableContainerRow(
                            ["Vegan"],
                            selectedDietType,
                            (value) => setState(() => selectedDietType = value),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: buildSelectableContainerRow(
                            ["Paleo"],
                            selectedDietType,
                            (value) => setState(() => selectedDietType = value),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildSelectableContainerRow(
                            ["Mediterranean"],
                            selectedDietType,
                            (value) => setState(() => selectedDietType = value),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: buildSelectableContainerRow(
                            ["Not Specified"],
                            selectedDietType,
                            (value) => setState(() => selectedDietType = value),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Food Alergies",
                      style: TextStyle(
                          color: Color(0XFFDBDBDB),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildCheckboxRow(
                            ["Gluten"],
                            foodAllergies,
                            (value) => setState(() {}),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: buildCheckboxRow(
                            ["Dairy"],
                            foodAllergies,
                            (value) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildCheckboxRow(
                            ["Nuts"],
                            foodAllergies,
                            (value) => setState(() {}),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: buildCheckboxRow(
                            ["Shellfish"],
                            foodAllergies,
                            (value) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildCheckboxRow(
                            ["Meat"],
                            foodAllergies,
                            (value) => setState(() {}),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: buildCheckboxRow(
                            ["Not Specific"],
                            foodAllergies,
                            (value) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Preferred Cuisine",
                      style: TextStyle(
                          color: Color(0XFFDBDBDB),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildSelectableContainerRow(
                            ["Indian"],
                            selectedCuisine,
                            (value) => setState(() => selectedCuisine = value),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: buildSelectableContainerRow(
                            ["Italian"],
                            selectedCuisine,
                            (value) => setState(() => selectedCuisine = value),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildSelectableContainerRow(
                            ["Chinese"],
                            selectedCuisine,
                            (value) => setState(() => selectedCuisine = value),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: buildSelectableContainerRow(
                            ["Thai"],
                            selectedCuisine,
                            (value) => setState(() => selectedCuisine = value),
                          ),
                        ),
                      ],
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Number of Meals Per Day",
                      style: TextStyle(
                          color: Color(0XFFDBDBDB),
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildIncrementDecrementRow(
                      "Number of Meals Per Day",
                      numberOfMeals,
                      () => setState(() => numberOfMeals++),
                      () => setState(() => numberOfMeals--),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Meal Type",
                      style: TextStyle(
                          color: Color(0XFFDBDBDB),
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildCheckboxRow(
                            [
                              "Breakfast",
                            ],
                            foodAllergies,
                            // For example purposes, adjust according to real data
                            (value) => setState(() {}),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: buildCheckboxRow(
                            [
                              "Morning Snacks",
                            ],
                            foodAllergies,
                            // For example purposes, adjust according to real data
                            (value) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildCheckboxRow(
                            [
                              "Lunch",
                            ],
                            foodAllergies,
                            // For example purposes, adjust according to real data
                            (value) => setState(() {}),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: buildCheckboxRow(
                            [
                              "Preworkout",
                            ],
                            foodAllergies,
                            // For example purposes, adjust according to real data
                            (value) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildCheckboxRow(
                            [
                              "Post Workout",
                            ],
                            foodAllergies,
                            // For example purposes, adjust according to real data
                            (value) => setState(() {}),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: buildCheckboxRow(
                            [
                              "Dinner",
                            ],
                            foodAllergies,
                            // For example purposes, adjust according to real data
                            (value) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                    // buildRadioButtonRow(
                    //   ["Yes", "No"],
                    //   prePostWorkoutNutrition ? "Yes" : "No",
                    //   (value) => setState(
                    //       () => prePostWorkoutNutrition = value == "Yes"),
                    // ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Exercise Frequency",
                      style: TextStyle(
                          color: Color(0XFFDBDBDB),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildSelectableContainerRow(
                            ["1-2 Days/Week"],
                            exerciseFrequency,
                            (value) =>
                                setState(() => exerciseFrequency = value),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: buildSelectableContainerRow(
                            ["3-4 Days/Week"],
                            exerciseFrequency,
                            (value) =>
                                setState(() => exerciseFrequency = value),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildSelectableContainerRow(
                            ["5 Days/Week"],
                            exerciseFrequency,
                            (value) =>
                                setState(() => exerciseFrequency = value),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: buildSelectableContainerRow(
                            ["5-7 Days/Week"],
                            exerciseFrequency,
                            (value) =>
                                setState(() => exerciseFrequency = value),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Types Of Exercise",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0XFFDBDBDB),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildSelectableContainerRow(
                            ["Cardio"],
                            typeOfExercise,
                            (value) => setState(() => typeOfExercise = value),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: buildSelectableContainerRow(
                            ["Strength Training"],
                            typeOfExercise,
                            (value) => setState(() => typeOfExercise = value),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildSelectableContainerRow(
                            ["Calisthenics"],
                            typeOfExercise,
                            (value) => setState(() => typeOfExercise = value),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: buildSelectableContainerRow(
                            ["Zumba"],
                            typeOfExercise,
                            (value) => setState(() => typeOfExercise = value),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildSelectableContainerRow(
                            ["Powerlifting"],
                            typeOfExercise,
                            (value) => setState(() => typeOfExercise = value),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: buildSelectableContainerRow(
                            ["Mixed"],
                            typeOfExercise,
                            (value) => setState(() => typeOfExercise = value),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Pre/Post Workout Nutrition",
                      style: TextStyle(
                          color: Color(0XFFDBDBDB),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildSelectableContainerRow(
                            ["Yes"],
                            typeOfExercise,
                            (value) => setState(() => typeOfExercise = value),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: buildSelectableContainerRow(
                            ["No"],
                            typeOfExercise,
                            (value) => setState(() => typeOfExercise = value),
                          ),
                        ),
                      ],
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Any Medical Condition",
                      style: TextStyle(
                          color: Color(0XFFDBDBDB),
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildTextInputRow(
                        "Any Medical Condition", medicalConditionController),
                    buildTextInputRow(
                        "Preferred Start Date", preferredStartDateController),
                    SizedBox(
                      height: 150,
                      child: buildTextInputRow("Special Instructions",
                          specialInstructionsController),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 410),

              // Generate Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XFFCDE26D),
                    padding:
                        EdgeInsets.symmetric(vertical: 16, horizontal: 130),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    // Action on submit (print the selected values)
                    submitUser(context);
                    printData();
                  },
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Text("Generate Using AI",
                          style: TextStyle(
                              color: Color(0XFF242522), fontSize: 18)),
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
                color: Color(0XFFDBDBDB),
                fontWeight: FontWeight.bold,
                fontSize: 18)),
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: options.map((option) {
        return GestureDetector(
          onTap: () {
            onChanged(option);
          },
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedValue == option
                            ? Color(0XFFCDE26D).withOpacity(0.2)
                            : Color(0XFF292A27),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: selectedValue == option
                              ? Color(0XFFCDE26D)
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
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Reusable checkbox row for multiple selections
  Widget buildCheckboxRow(List<String> options, List<String> selectedItems,
      Function(bool) onChanged) {
    return Column(
      children: options.map((option) {
        return Container(
          width: double.infinity,
          // Forces full width
          padding: EdgeInsets.symmetric(vertical: 4),
          // Optional padding for spacing
          child: FilterChip(
            labelPadding: EdgeInsets.symmetric(horizontal: 16),
            // Adjust label padding
            checkmarkColor: Color(0XFFCDE26D),
            backgroundColor: Color(0XFF292A27),
            label: Align(
              alignment: Alignment.centerLeft, // Aligns text to the left
              child: Text(
                option,
                style: TextStyle(
                  color: Color(0XFF7E7E7E),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            selected: selectedItems.contains(option),
            selectedColor: Color(0XFF292A27),
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  selectedItems.add(option);
                } else {
                  selectedItems.remove(option);
                }
              });
            },
          ),
        );
      }).toList(),
    );
  }

  // Reusable text input field (single line)
  Widget buildTextInputRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          color: Color(0XFF242522),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: controller,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            labelStyle: TextStyle(color: Color(0XFF7E7E7E)),
          ),
        ),
      ),
    );
  }

  // Reusable increment/decrement row
  Widget buildIncrementDecrementRow(String label, int value,
      VoidCallback onIncrement, VoidCallback onDecrement) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Color(0XFFD9D9D9), shape: BoxShape.circle),
              child: IconButton(
                  onPressed: onDecrement,
                  icon: Icon(Icons.arrow_downward, color: Color(0XFF242522))),
            ),
            SizedBox(
              width: 120,
            ),
            Text(value.toString(), style: TextStyle(color: Colors.white)),
            SizedBox(
              width: 120,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color(0XFFCDE26D), shape: BoxShape.circle),
              child: IconButton(
                  onPressed: onIncrement,
                  icon: Icon(Icons.arrow_upward, color: Color(0XFF242522))),
            ),
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
