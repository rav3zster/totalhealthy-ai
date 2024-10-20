import 'package:flutter/material.dart';


class Profile_details extends StatefulWidget {
  const Profile_details({super.key});

  @override
  _Profile_detailsState createState() => _Profile_detailsState();
}

class _Profile_detailsState extends State<Profile_details> {
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
              Color.fromARGB(255, 34, 37, 26),
              Color.fromARGB(255, 12, 12, 12),
              Color.fromARGB(255, 31, 33, 20),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 60, left: 95),
                child: const Row(
                  children: [
                    Text(
                      "Please Provide",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.white70),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Details",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 160, 141, 60),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Kindly share the required information to",
                style: TextStyle(color: Colors.white54,fontWeight: FontWeight.w500),
              ),
              const Text(
                "proceed further.",
                style: TextStyle(color: Colors.white54,fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 30),
              // Gender Selection Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Male Box
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isMaleSelected = true;
                        isFemaleSelected = false; // Deselect female when male is selected
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 36, 36, 36),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isMaleSelected
                              ? const Color.fromARGB(255, 206, 225, 107) // Yellow when selected
                              : Colors.transparent, // Transparent when not selected
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
                             color: Colors.white54,fontWeight: FontWeight.w500,
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
                        isMaleSelected = false; // Deselect male when female is selected
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 36, 36, 36),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isFemaleSelected
                              ? const Color.fromARGB(255, 246, 212, 85) // Yellow when selected
                              : Colors.transparent, // Transparent when not selected
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
                              color: Colors.white54,fontWeight: FontWeight.w500,
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
                  "Your Name",
                  style: TextStyle( color:Colors.white54,fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 420,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "name here",
                    hintStyle: const TextStyle(color: Colors.white30),
                    fillColor: const Color.fromARGB(255, 36, 36, 36),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Email
              Container(
                margin: const EdgeInsets.only(right: 380),
                child: const Text(
                  "Email",
                  style: TextStyle( color:Colors.white54,fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 420,
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.mail_outline_rounded, color: Colors.white54
                    ),
                    hintText: "xyz@email.com",
                    hintStyle: const TextStyle(color: Colors.white30),
                    fillColor: const Color.fromARGB(255, 36, 36, 36),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Date of Birth
              Container(
                margin: const EdgeInsets.only(right: 350),
                child: const Text(
                  "Password",
                  style: TextStyle( color:Colors.white54,fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 420,
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline_rounded, color: Colors.white54
                    ),
                    hintText: "********",
                    hintStyle: const TextStyle(color: Colors.white30),
                    fillColor: const Color.fromARGB(255, 36, 36, 36),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
              // Continue Button
              SizedBox(
                width: 400,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 204, 224, 109),
                  ),
                  child: const Text(
                    "Continue",
                    style: TextStyle(color: Colors.black54),
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
