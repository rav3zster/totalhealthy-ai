import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/core/utitlity/appvalidator.dart';

import '../../../core/base/controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  bool isMaleSelected = false; // Track Male selection
  bool isFemaleSelected = false; // Track Female selection
  bool _isObscured = true;

  GlobalKey<FormState> key = GlobalKey<FormState>();

  bool isLoading = false;
  Future<void> submitUser() async {
    try {
      if (key.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        var data = {
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
          "phone_number": phoneNumberController.text.trim(),
        };
        print(data);

        // Use real authentication
        final authController = Get.find<AuthController>();
        bool success = await authController.register(
          emailController.text.trim(),
          passwordController.text.trim(),
        );

        if (success) {
          // You might want to save other user details (name, phone) to Firestore here
          print("User registered: ${emailController.text}");

          Get.toNamed(Routes.SWITCHROLE);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Sign Up Successful! Please choose your role to continue.',
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sign up failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    // if (_formKey.currentState!.validate()) {
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevents the page from moving up
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF272e23),
              Color.fromARGB(255, 12, 12, 12),
              Color.fromARGB(255, 12, 12, 12),
              Color(0xFF272e23),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: key,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 50, left: 85),
                    child: const Row(
                      children: [
                        Text(
                          "Please Provide",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          "Details",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.amberAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Kindly Share The Required Information To",
                    style: TextStyle(
                      color: Colors.white54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    "Proceed Further.",
                    style: TextStyle(
                      color: Colors.white54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Gender Selection Boxes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isMaleSelected = true;
                            isFemaleSelected = false; // Deselect female
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 36, 36, 36),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: isMaleSelected
                                  ? const Color.fromARGB(255, 146, 159, 83)
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          width: 110,
                          height: 110,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.male,
                                size: 40,
                                color: isMaleSelected
                                    ? const Color.fromARGB(255, 146, 159, 83)
                                    : Colors.white54,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Male",
                                style: TextStyle(
                                  color: isMaleSelected
                                      ? Colors.white
                                      : Colors.white30,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isFemaleSelected = true;
                            isMaleSelected = false; // Deselect male
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 36, 36, 36),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: isFemaleSelected
                                  ? Colors.amberAccent
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          width: 110,
                          height: 110,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.female,
                                size: 40,
                                color: isFemaleSelected
                                    ? Colors.amberAccent
                                    : Colors.white54,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Female",
                                style: TextStyle(
                                  color: isFemaleSelected
                                      ? Colors.white
                                      : Colors.white30,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(right: 320),
                    child: const Text(
                      "Full Name",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 380,
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.person_2_outlined,
                          color: Colors.white54,
                        ),
                        hintText: "enter your full name",
                        hintStyle: const TextStyle(color: Colors.white30),
                        fillColor: const Color.fromARGB(255, 36, 36, 36),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: AppValidator().validateUsername,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    margin: const EdgeInsets.only(right: 294),
                    child: const Text(
                      "Email Address",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 380,
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.mail_outline_rounded,
                          color: Colors.white54,
                        ),
                        hintText: "enter your email address",
                        hintStyle: const TextStyle(color: Colors.white30),
                        fillColor: const Color.fromARGB(255, 36, 36, 36),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: AppValidator().validateEmail,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    margin: const EdgeInsets.only(right: 320),
                    child: const Text(
                      "Password",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 380,
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: _isObscured,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0XFF242522),
                        hintText: 'Enter Your Password',
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Colors.white54,
                        ),

                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.white54,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                        ),
                        hintStyle: TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        // Custom Border Properties
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: AppValidator().validatePassword,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(right: 290),
                    child: const Text(
                      "Phone Number",
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 380,
                    child: TextFormField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0XFF242522),
                        hintText: 'Enter Your Number',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        // Custom Border Properties
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      validator: AppValidator().validatePhoneNumber,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Login Button
                  SizedBox(
                    width: 380,
                    child: ElevatedButton(
                      onPressed: () => submitUser(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0XFFCDE26D),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: isLoading
                          ? Center(child: CircularProgressIndicator())
                          : Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Color(0XFF242522),
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 150, top: 20),
                          child: const Text(
                            "----------",
                            style: TextStyle(
                              color: Colors.white30,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5, top: 20),
                          child: const Text(
                            "Or",
                            style: TextStyle(
                              color: Colors.white30,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5, top: 20),
                          child: const Text(
                            "----------",
                            style: TextStyle(
                              color: Colors.white30,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 115),
                        child: const Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 3),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.Login);
                        },
                        child: const Text(
                          "Sign in",
                          style: TextStyle(
                            color: Color.fromARGB(255, 194, 216, 106),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
