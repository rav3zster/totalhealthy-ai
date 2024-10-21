import 'package:flutter/material.dart';
import 'package:totalhealthy/app/modules/Login_Screen/Login_view.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  bool isMaleSelected = false; // Track Male selection
  bool isFemaleSelected = false; // Track Female selection
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: const BoxDecoration(
          //gradient: LinearGradient(
          //colors: [
          // Color(0xFF272e23),
          //Color.fromARGB(255, 12,12,12),

          // Color.fromARGB(255, 12, 12, 12),
          // Color(0xFF272e23),
          // ],
          // begin: Alignment.topRight,

          // end: Alignment.bottomLeft,
          color: Colors.black,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 110, left: 95),
                child: const Row(
                  children: [
                    Text(
                      "Create Your",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Account",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 205, 226, 109),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
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
                          const SizedBox(height: 115),
                          const Text(
                            "Trainer",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
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
                              ? const Color.fromARGB(
                                  255, 205, 226, 109) // Yellow when selected
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
                          const SizedBox(height: 115),
                          const Text(
                            "Trainer",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 360),
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
                    "Login",
                    style: TextStyle(color: Colors.black54, fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
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
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 115),
                    child: Text(
                      "Don't have an account yet?",
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
                                builder: (context) => LoginView(),
                              ));
                        },
                        child: Text(
                          "Sign up",
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
