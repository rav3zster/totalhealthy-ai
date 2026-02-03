import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/core/utitlity/appvalidator.dart';

import '../../../core/base/controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/dummy_data_service.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var email = TextEditingController();
  var pass = TextEditingController();

  GlobalKey<FormState> key = GlobalKey<FormState>();

  bool isLoading = false;
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    // Pre-fill with credentials for easy testing
    email.text = DummyDataService.mockEmail;
    pass.text = DummyDataService.mockPassword;
  }

  Future<void> submitUser() async {
    try {
      if (key.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });

        // Simulate network delay
        await Future.delayed(Duration(milliseconds: 1500));

        // Use real authentication
        bool loginSuccess = await Get.find<AuthController>().login(
          email.text.trim(),
          pass.text.trim(),
        );

        if (loginSuccess) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login Successful!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Invalid credentials! Please check your email and password.',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      print("Login error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
                  SizedBox(height: 40),

                  // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Login To Total',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFFFFFFFF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        'Healthy',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF5D657),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Color(0XFFFFFFFF),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 70),

                  // Email Label
                  Text(
                    'Email Address',
                    style: TextStyle(fontSize: 16, color: Color(0XFFDBDBDB)),
                  ),
                  SizedBox(height: 10),

                  // Email Field
                  TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0XFF242522),
                      hintText: 'Enter your email address',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Colors.white54,
                      ),
                      hintStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
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
                    validator: AppValidator.validateEmail,
                  ),
                  SizedBox(height: 25),

                  // Password Label
                  Text(
                    'Password',
                    style: TextStyle(fontSize: 16, color: Color(0XFFDBDBDB)),
                  ),
                  SizedBox(height: 5),

                  // Password Field
                  TextFormField(
                    controller: pass,
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
                    validator: AppValidator.validatePassword,
                  ),
                  SizedBox(height: 10),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.FORGETPASSWORD);
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Color(0XFFCDE26D),
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0XFFCDE26D),
                          decorationThickness: 2,
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
                            child: CircularProgressIndicator(
                              color: Color(0XFF242522),
                            ),
                          )
                        : Text(
                            'Login',
                            style: TextStyle(
                              color: Color(0XFF242522),
                              fontSize: 18,
                            ),
                          ),
                  ),
                  SizedBox(height: 50),

                  // Dotted Line and "Or"
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 50, child: DottedLine()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or',
                            style: TextStyle(color: Color(0XFFB0AFAF)),
                          ),
                        ),
                        SizedBox(width: 50, child: DottedLine()),
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
                        onPressed: () {
                          Get.toNamed(Routes.SIGNUP);
                        },
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
