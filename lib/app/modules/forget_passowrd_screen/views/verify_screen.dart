import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_common/get_reset.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:totalhealthy/app/modules/forget_passowrd_screen/views/create_new_passowrd.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final TextEditingController verify1Controller = TextEditingController();
  final TextEditingController verify2Controller = TextEditingController();
  final TextEditingController verify3Controller = TextEditingController();
  final TextEditingController verify4Controller = TextEditingController();
  final FocusNode focusNode1 = FocusNode();
  final FocusNode focusNode2 = FocusNode();
  final FocusNode focusNode3 = FocusNode();
  final FocusNode focusNode4 = FocusNode();

  @override
  void dispose() {
    verify1Controller.dispose();
    verify2Controller.dispose();
    verify3Controller.dispose();
    verify4Controller.dispose();
    focusNode1.dispose();
    focusNode2.dispose();
    focusNode3.dispose();
    focusNode4.dispose();
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
              "Verify Account",
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
                  "Code has been sent to ",
                  style: TextStyle(
                    color: Color(0XFFDBDBDB),
                    fontSize: 16,
                  ),
                ),
                Text(
                  "johndoe@gmail.com",
                  style: const TextStyle(
                      color: Color(0XFFDBDBDB),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Text(
              "Enter the code to verify your account.",
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
                    "Enter Code",
                    style: TextStyle(
                        color: Color(0XFFDBDBDB), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildOtpBox(verify1Controller, focusNode1, focusNode2),
                const SizedBox(width: 10),
                buildOtpBox(verify2Controller, focusNode2, focusNode3),
                const SizedBox(width: 10),
                buildOtpBox(verify3Controller, focusNode3, focusNode4),
                const SizedBox(width: 10),
                buildOtpBox(verify4Controller, focusNode4, null),
              ],
            ),
            const SizedBox(height: 140),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Didn't Receive Code?",
                  style: TextStyle(color: Color(0XFF7E7E7E), fontSize: 16),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Resend Code",
                    style: TextStyle(
                      color: Color(0XFFDBDBDB),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Text(
              "Resend code in 00:59",
              style: TextStyle(color: Color(0XFF7E7E7E), fontSize: 16),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(CreateNewPasswordViews());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFFCDE26D),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Verify Account',
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

  Widget buildOtpBox(TextEditingController controller, FocusNode currentFocus, FocusNode? nextFocus) {
    return SizedBox(
      width: 95,
      child: TextField(
        controller: controller,
        focusNode: currentFocus,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (nextFocus != null) {
              FocusScope.of(context).requestFocus(nextFocus);
            } else {
              currentFocus.unfocus();
            }
          }
        },
        decoration: InputDecoration(
          counterText: "", // Hide the counter text
          filled: true,
          fillColor: const Color(0XFF242522),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
        ),
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}
