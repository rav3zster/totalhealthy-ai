import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/modules/forget_passowrd_screen/views/verify_screen.dart';

class ForgetPasswordScreenViews extends StatefulWidget {
  const ForgetPasswordScreenViews({super.key});

  @override
  State<ForgetPasswordScreenViews> createState() => _ForgetPasswordScreenViewsState();
}

class _ForgetPasswordScreenViewsState extends State<ForgetPasswordScreenViews> {
  final TextEditingController forgetPasswordController = TextEditingController();


  @override
  void dispose() {
    forgetPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF0C0C0C),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 120),
            const Text(
              "Forget Password",
              style: TextStyle(
                  color: Color(0XFFDBDBDB),
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "No worries! Enter your email address belo and we",
                  style: TextStyle(
                    color: Color(0XFFDBDBDB),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Text(
              "will send you a code to reset password",
              style: TextStyle(
                color: Color(0XFFDBDBDB),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 28),
            Container(
              margin: const EdgeInsets.only(left: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    "Email Address",
                    style: TextStyle(
                        color: Color(0XFFDBDBDB), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18),
              child: Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0XFF242522),
                    hintText: 'enter your email address',
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
              ),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(VerifyScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFFCDE26D),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Next',
                        style:
                        TextStyle(color: Color(0XFF242522), fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }


}
