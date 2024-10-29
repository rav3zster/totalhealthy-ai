import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/create_meal/controllers/create_meal_controller.dart';

class CreateMealPage extends StatelessWidget {
  final CreateMealController controller;

  const CreateMealPage({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Color(0XFFDBDBDB)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Distribute space evenly
          children: [
            SizedBox(
                width: 20), // Adjust width to create space from the back icon
            Expanded(
              child: Text(
                'Creating A Meal',
                textAlign: TextAlign.center, // Center the text
                style: TextStyle(color: Color(0XFFFFFFFF)),
              ),
            ),
            SizedBox(
                width: 50), // Adjust width to create space on the right side
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                  alignment:
                      Alignment.center, // Align camera icon at the center
                  children: [
                    // Background Image
                    Container(
                      width:
                          double.infinity, // Make the image take the full width
                      height: 150, // Set a fixed height for the image
                      child: Image.network(
                        'https://s3-alpha-sig.figma.com/img/3c1a/8b73/f12c753174438513bb473ac491b98e1b?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=nHOajTx9R8evhyppeuXSCl2rWzoMsJzzqfKmhm4MlC3nGvxxdlJGimhkp7i8PmVn-3X5wzMSDkFvD9ru16pIJy0QOFRZVC8~LygE-aulG5T2vwBhfhOHYxSitCiVEainNEKDSsiYBVYlIq0FJqfrMgnC-O9vgADedKMrW-6ccNvgkuZm0vo4WPuhUfQ8e-UeH61Py64PR0raE-L4ockW5ngYPjxyhbet04NTGT0yKema4-HMZ7aHISVeLbze3KEbr4De4MCw9y-OCiboM2EB3UwHalU4gq1sGfPteg7KBSOJ3IdSO75Cg87fBI-eJLEU7HyecZt~lMNMNUlJCv1Fkw__',
                        fit: BoxFit.cover, // Ensure the image covers the space
                      ),
                    ),
                    // Blackish Overlay
                    Container(
                      width: double.infinity, // Full width
                      height: 150, // Fixed height to match the image
                      color: Colors.black
                          .withOpacity(0.3), // Semi-transparent black overlay
                    ),
                    // Camera Icon with Circle Background
                    Positioned(
                      top: 60, // Position the icon a bit lower
                      child: Container(
                        width: 40, // Reduced circle width
                        height: 40, // Reduced circle height
                        decoration: BoxDecoration(
                          color: Colors.white, // Circle color
                          shape: BoxShape.circle, // Make it circular
                          border: Border.all(
                              color: Colors.white,
                              width: 3), // White outline (thicker)
                        ),
                        child: Center(
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.black, // Icon color (black)
                            size: 24, // Adjusted icon size
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Full Name",
                style: TextStyle(color: Color(0XFFDBDBDB)),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: controller.fullNameController,
                decoration: InputDecoration(
                  labelText: "Enter your recipe name",
                  labelStyle: TextStyle(color: Color(0XFF7E7E7E)),
                  filled: true,
                  fillColor: Color(0XFF242522),
                  border: InputBorder.none, // No border visible
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    borderSide: BorderSide(
                        color: Colors
                            .transparent), // Transparent border when focused
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    borderSide: BorderSide(
                        color: Colors
                            .transparent), // Transparent border when enabled
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Category",
                style: TextStyle(color: Color(0XFFDBDBDB)),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0XFF242522), // Background color for the box
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54, // Shadow color
                      blurRadius: 4, // Shadow blur
                      offset: Offset(0, 2), // Shadow position
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Title of the ExpansionTile
                    ExpansionTile(
                      title: Text(
                        "Breakfast",
                        style: TextStyle(color: Color(0XFF7E7E7E)),
                      ),
                      children: controller.categories.map((category) {
                        return Obx(() {
                          return CheckboxListTile(
                            title: Text(category,
                                style: TextStyle(color: Colors.white)),
                            value: controller.selectedCategories
                                .contains(category),
                            onChanged: (selected) {
                              if (selected == true) {
                                controller.selectedCategories.add(category);
                              } else {
                                controller.selectedCategories.remove(category);
                              }
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: Colors.greenAccent,
                          );
                        });
                      }).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Description",
                style: TextStyle(color: Color(0XFFDBDBDB)),
              ),
              SizedBox(height: 10),
              TextField(
                controller: controller.descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Describe the recipe",
                  labelStyle: TextStyle(color: Color(0XFF7E7E7E)),
                  filled: true,
                  fillColor: Color(0XFF242522),
                  // Setting the border with a slight rounding effect
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    borderSide: BorderSide(
                        color: Colors.transparent), // Transparent border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    borderSide: BorderSide(
                        color: Colors.transparent), // Transparent border
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                    borderSide: BorderSide(
                        color: Colors.transparent), // Transparent border
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text('Ingredients',
                  style: TextStyle(
                    color: Color(0XFFDBDBDB),
                  )),
              SizedBox(
                height: 10,
              ),
              Obx(() {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.ingredientControllers.length,
                  itemBuilder: (context, index) {
                    final ingredient = controller.ingredientControllers[index];
                    return IngredientInput(
                      nameController: ingredient['name']!,
                      amountController: ingredient['amount']!,
                      onRemove: () => controller.removeIngredientRow(index),
                    );
                  },
                );
              }),
              SizedBox(height: 12),
              Center(
                child: ElevatedButton.icon(
                  onPressed: controller.addIngredientRow,
                  icon: Icon(Icons.add),
                  label: Text("Add Meal"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Color(0XFF242522),
                    backgroundColor: Color(0XFFCDE26D),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Calculate Automatically",
                      style: TextStyle(color: Color(0XFFDBDBDB))),
                  Obx(() {
                    return Switch(
                      value: controller.calculateAutomatically.value,
                      onChanged: (value) {
                        controller.calculateAutomatically.value = value;
                      },
                      activeColor:
                          Colors.greenAccent, // Color when the switch is on
                      inactiveTrackColor: Color(
                          0XFF7E7E7E), // Track color when the switch is off
                      inactiveThumbColor:
                          Colors.white, // Thumb color when the switch is off
                    );
                  })
                ],
              ),
              SizedBox(height: 10),
              Obx(() {
                if (!controller.calculateAutomatically.value) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.kcalController,
                              decoration: InputDecoration(
                                labelText: "kcal",
                                labelStyle: TextStyle(color: Color(0XFF7E7E7E)),
                                filled: true,
                                fillColor: Color(0XFF242522),
                                // Setting the border with a slight rounding effect
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Rounded corners
                                  borderSide: BorderSide(
                                      color: Colors
                                          .transparent), // Transparent border
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Rounded corners
                                  borderSide: BorderSide(
                                      color: Colors
                                          .transparent), // Transparent border
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Rounded corners
                                  borderSide: BorderSide(
                                      color: Colors
                                          .transparent), // Transparent border
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10), // Space between the fields
                          Expanded(
                            child: TextField(
                              controller: controller.carbsController,
                              decoration: InputDecoration(
                                labelText: "Carbs",
                                labelStyle: TextStyle(color: Color(0XFF7E7E7E)),
                                filled: true,
                                fillColor: Color(0XFF242522),
                                // Setting the border with a slight rounding effect
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Rounded corners
                                  borderSide: BorderSide(
                                      color: Colors
                                          .transparent), // Transparent border
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Rounded corners
                                  borderSide: BorderSide(
                                      color: Colors
                                          .transparent), // Transparent border
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Rounded corners
                                  borderSide: BorderSide(
                                      color: Colors
                                          .transparent), // Transparent border
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10), // Space between the rows
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.proteinController,
                              decoration: InputDecoration(
                                labelText: "Protein",
                                labelStyle: TextStyle(color: Color(0XFF7E7E7E)),
                                filled: true,
                                fillColor: Color(0XFF242522),
                                // Setting the border with a slight rounding effect
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Rounded corners
                                  borderSide: BorderSide(
                                      color: Colors
                                          .transparent), // Transparent border
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Rounded corners
                                  borderSide: BorderSide(
                                      color: Colors
                                          .transparent), // Transparent border
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Rounded corners
                                  borderSide: BorderSide(
                                      color: Colors
                                          .transparent), // Transparent border
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10), // Space between the fields
                          Expanded(
                            child: TextField(
                              controller: controller.fatsController,
                              decoration: InputDecoration(
                                labelText: "Fats",
                                labelStyle: TextStyle(color: Color(0XFF7E7E7E)),
                                filled: true,
                                fillColor: Color(0XFF242522),
                                // Setting the border with a slight rounding effect
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Rounded corners
                                  borderSide: BorderSide(
                                      color: Colors
                                          .transparent), // Transparent border
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Rounded corners
                                  borderSide: BorderSide(
                                      color: Colors
                                          .transparent), // Transparent border
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Rounded corners
                                  borderSide: BorderSide(
                                      color: Colors
                                          .transparent), // Transparent border
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                } else {
                  return SizedBox(); // Or any other widget for the case when calculateAutomatically is true
                }
              }),
              Center(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center the button vertically
                  children: [
                    SizedBox(height: 25), // Add space above the button
                    Obx(() {
                      return SizedBox(
                        width: double
                            .infinity, // Make the button take the full width
                        child: ElevatedButton(
                          onPressed: () {
                            controller.submitUser(context);
                          },
                          child: controller.isLoading.value
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Text(
                                  "Create Meal",
                                  style: TextStyle(fontSize: 17),
                                ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Color(0XFF242522),
                            backgroundColor: Color(0XFFCDE26D),
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class IngredientInput extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController amountController;
  final VoidCallback onRemove;

  IngredientInput({
    required this.nameController,
    required this.amountController,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(bottom: 10), // Add margin at the bottom for spacing
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: nameController,
              maxLines: 1,
              decoration: InputDecoration(
                labelText: "Describe the recipe",
                labelStyle: TextStyle(color: Color(0XFF7E7E7E)),
                filled: true,
                fillColor: Color(0XFF242522),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                  borderSide: BorderSide(
                      color: Colors
                          .transparent), // Transparent border when focused
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                  borderSide: BorderSide(
                      color: Colors
                          .transparent), // Transparent border when enabled
                ),
              ),
            ),
          ),
          SizedBox(width: 10), // Space between the two fields
          Container(
            width: 80, // Set width for the quantity field to make it smaller
            child: TextField(
              controller: amountController,
              maxLines: 1,
              decoration: InputDecoration(
                labelText: "Q-Ty",
                labelStyle: TextStyle(color: Color(0XFF7E7E7E)),
                filled: true,
                fillColor: Color(0XFF242522),
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                  borderSide: BorderSide(
                      color: Colors
                          .transparent), // Transparent border when focused
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                  borderSide: BorderSide(
                      color: Colors
                          .transparent), // Transparent border when enabled
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.remove_circle_outline, color: Colors.red),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
