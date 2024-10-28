import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/Registration_Screen/Registration_view.dart';

import '../../../core/base/apiservice/api_endpoints.dart';
import '../../../core/base/apiservice/api_status.dart';
import '../../../core/base/apiservice/base_methods.dart';
import '../../../routes/app_pages.dart';

import '../../../core/utitlity/debug_print.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  bool isMaleSelected = false; // Track Male selection
  bool isFemaleSelected = false; // Track Female selection
  var email = TextEditingController();
  var pass = TextEditingController();

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
          "phone_number": phoneNumberController.text.trim()
        };
        print(data);
        // signupUser(
        //   APIEndpoints.auth.signup,
        //   data,
        // );
        await APIMethods.post
            .post(url: APIEndpoints.auth.signup, map: data)
            .then((value) {
          if (APIStatus.success(value.statusCode)) {
            print(value.data);
            // clearDetails();
            Get.toNamed(Routes.Login);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sign Up Successful!'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            printError("Error ", "Signup", value.data);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('You must agree to the Terms & Privacy to sign up.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
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
                              color: Colors.white),
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
                        color: Colors.white54, fontWeight: FontWeight.w500),
                  ),
                  const Text(
                    "Proceed Further.",
                    style: TextStyle(
                        color: Colors.white54, fontWeight: FontWeight.w500),
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
                          width: 175,
                          height: 195,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 70),
                              Text(
                                "Male",
                                style: TextStyle(
                                  color: Colors.white30,
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
                          width: 175,
                          height: 195,
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 70),
                              Text(
                                "Female",
                                style: TextStyle(
                                  color: Colors.white30,
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
                  const SizedBox(height: 40),
                  Container(
                    margin: const EdgeInsets.only(right: 320),
                    child: const Text(
                      "Full Name",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 390,
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person_2_outlined,
                            color: Colors.white54),
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
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    margin: const EdgeInsets.only(right: 294),
                    child: const Text(
                      "Email Address",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 390,
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.mail_outline_rounded,
                            color: Colors.white54),
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
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    margin: const EdgeInsets.only(right: 320),
                    child: const Text(
                      "Password",
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 390,
                    child: TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline_rounded,
                            color: Colors.white54),
                        suffixIcon: const Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.white54,
                        ),
                        hintText: "enter your password",
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
                    ),
                  ),
                  const SizedBox(height: 60),
                  // Login Button
                  SizedBox(
                    width: 390,
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
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: Color(0XFF242522), fontSize: 18),
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
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 5, top: 20),
                          child: const Text(
                            "Or",
                            style: TextStyle(
                                color: Colors.white30,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 5, top: 20),
                            child: const Text(
                              "----------",
                              style: TextStyle(
                                  color: Colors.white30,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            )),
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
                              fontWeight: FontWeight.w500),
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
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
