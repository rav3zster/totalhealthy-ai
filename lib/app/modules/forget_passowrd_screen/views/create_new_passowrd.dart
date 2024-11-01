import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:totalhealthy/app/modules/forget_passowrd_screen/views/verify_screen.dart';
import 'package:totalhealthy/app/modules/login/views/login_view.dart';

class CreateNewPasswordViews extends StatefulWidget {
  const CreateNewPasswordViews({super.key});

  @override
  State<CreateNewPasswordViews> createState() => _CreateNewPasswordViewsState();
}

class _CreateNewPasswordViewsState extends State<CreateNewPasswordViews> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();


  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
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
              "Create New Password",
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
                  "Please enter and confirm your new password.",
                  style: TextStyle(
                    color: Color(0XFFDBDBDB),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Text(
              "You will need to login after you reset.",
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
                    "Password",
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
                child:   TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0XFF242522),
                    hintText: '******',
                    suffixIcon:
                    Icon(Icons.visibility_outlined, color: Colors.white54),
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
            SizedBox(height: 20,),
            Container(
              margin: const EdgeInsets.only(left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    "must contain 8 char.",
                    style: TextStyle(
                        color: Color(0XFFDBDBDB)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Container(
              margin: const EdgeInsets.only(left: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    "Confirm Password",
                    style: TextStyle(
                        color: Color(0XFFDBDBDB), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18),
              child: Expanded(
                child:   TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0XFF242522),
                    hintText: '******',
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
                        Get.to(LoginView());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFFCDE26D),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Reset Password',
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
