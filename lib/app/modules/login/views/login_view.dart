import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/base/apiservice/api_endpoints.dart';
import '../../../core/base/apiservice/api_status.dart';
import '../../../core/base/apiservice/base_methods.dart';
import '../../../core/base/controllers/auth_controller.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        Map<String, dynamic> data = {
          "email": email.text.trim(),
          "password": pass.text.trim(),
        };

        await APIMethods.post
            .post(url: APIEndpoints.auth.login, map: data)
            .then((value) {
          if (APIStatus.success(value.statusCode)) {
            // clearDetails();
            Get.find<AuthController>().setAuth(
              value.data["access_token"],
              value.data["refresh_token"],
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login Successful!'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            // printError("Auth Controller", "Signup", value.data);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 200,
                  ),
                  // Title
                  Text(
                    'Login To TotalHealthy',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0XFFFFFFFF),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0XFFFFFFFF),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 70),

                  // Email Label
                  Text(
                    'Email Address',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0XFFDBDBDB),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Email Field
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0XFF242522),
                      hintText: 'enter your email address',
                      prefixIcon:
                          Icon(Icons.email_outlined, color: Colors.white54),
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
                  ),
                  SizedBox(height: 25),

                  // Password Label
                  Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0XFFDBDBDB),
                    ),
                  ),
                  SizedBox(height: 5),

                  // Password Field
                  TextFormField(
                    controller: pass,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0XFF242522),
                      hintText: 'Enter Your Password',
                      prefixIcon:
                          Icon(Icons.lock_outline, color: Colors.white54),
                      suffixIcon: Icon(Icons.visibility_outlined,
                          color: Colors.white54),
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
                  ),
                  SizedBox(height: 10),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => submitUser,
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Color(0XFFCDE26D),
                          decoration: TextDecoration
                              .underline, // Adds underline to the text
                          decorationColor:
                              Color(0XFFCDE26D), // Same color as the text
                          decorationThickness: 2, // Thickness of the underline
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 50),

                  // Login Button
                  ElevatedButton(
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
                            'Login',
                            style: TextStyle(
                                color: Color(0XFF242522), fontSize: 18),
                          ),
                  ),
                  SizedBox(height: 100),

                  // Dotted Line and "Or"
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize
                          .min, // Ensures the row takes minimal space
                      children: [
                        // Dotted line on the left, with a smaller width
                        SizedBox(
                          width: 50, // Adjust the width as needed
                          child: DottedLine(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or',
                            style: TextStyle(color: Color(0XFFB0AFAF)),
                          ),
                        ),
                        // Dotted line on the right, with a smaller width
                        SizedBox(
                          width: 50, // Adjust the width as needed
                          child: DottedLine(),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 5),

                  // Sign Up Option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account yet?",
                        style: TextStyle(color: Color(0XFFB0AFAF)),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Sign up',
                          style: TextStyle(color: Colors.lightGreenAccent),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}

// Custom DottedLine Widget
class DottedLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 5.0;
        const dashSpace = 3.0;
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();

        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.white54),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
