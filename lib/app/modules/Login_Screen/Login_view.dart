import 'package:flutter/material.dart';
import 'package:totalhealthy/app/modules/Registration_Screen/Registration_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  bool isMaleSelected = false; // Track Male selection
  bool isFemaleSelected = false; // Track Female selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 70, left: 95),
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
              const SizedBox(height: 60),
              // Gender Selection Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Male Box
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isMaleSelected = true;
                        isFemaleSelected =
                            false; // Deselect female when male is selected
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 36, 36, 36),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isMaleSelected
                              ? const Color.fromARGB(255, 146, 159, 83)
                              // Yellow when selected
                              : Colors
                                  .transparent, // Transparent when not selected
                          width: 3,
                        ),
                      ),
                      width: 200,
                      height: 220,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //   Image.asset(
                          //   'assets/male.png', // Add your male image path here
                          //   height: 40,
                          //   color: const Color.fromARGB(255, 160, 141, 60), // Adjust color if needed
                          //   ),
                          const SizedBox(height: 70),
                          const Text(
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
                  // Female Box
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isFemaleSelected = true;
                        isMaleSelected =
                            false; // Deselect male when female is selected
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 36, 36, 36),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isFemaleSelected
                              ?  Colors
                              .amberAccent // Yellow when selected
                              : Colors
                                  .transparent, // Transparent when not selected
                          width: 3,
                        ),
                      ),
                      width: 200,
                      height: 220,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //  Image.network(
                          //   'assets/female.png', // Add your female image path here
                          //    height: 60,
                          //    color: const Color.fromARGB(255, 160, 141, 60), // Adjust color if needed
                          //   ),
                          const SizedBox(height: 70),
                          const Text(
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
              const SizedBox(height: 40), // Moved this inside the Column
              // Your Name
              Container(
                margin: const EdgeInsets.only(right: 350),
                child: const Text(
                  "Full Name",
                  style: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 420,
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon:
                        Icon(Icons.person_2_outlined, color: Colors.white54),
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
              const SizedBox(height: 30),
              // Email
              Container(
                margin: const EdgeInsets.only(right: 322),
                child: const Text(
                  "Email Address",
                  style: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 420,
                child: TextField(
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
              const SizedBox(height: 30),
              // Date of Birth
              Container(
                margin: const EdgeInsets.only(right: 350),
                child: const Text(
                  "Password",
                  style: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 420,
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline_rounded,
                        color: Colors.white54),suffixIcon: Icon(Icons.remove_red_eye_outlined,color: Colors.white30,),
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
              const SizedBox(height: 70),
              // Continue Button
              SizedBox(
                width: 400,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 205, 226, 109),
                  ),
                  child: const Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.black54, fontSize: 18),
                  ),
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 150, top: 20),
                      child: Text(
                        "----------",
                        style: TextStyle(
                            color: Colors.white30,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5, top: 20),
                      child: Text(
                        "Or",
                        style: TextStyle(
                            color: Colors.white30,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(left: 5, top: 20),
                        child: Text(
                          "----------",
                          style: TextStyle(
                              color: Colors.white30,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        )),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 115),
                    child: Text(
                      "Already have an account?",
                      style: TextStyle(
                          color: Colors.white54, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 0),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegistrationView(),
                              ));
                        },
                        child: Text(
                          "Sign in",
                          style: TextStyle(
                              color: Color.fromARGB(255, 205, 226, 109),
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
