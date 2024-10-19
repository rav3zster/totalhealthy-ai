import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:totalhealthy/app/core/base/constants/appcolor.dart';

import '../controllers/welcome-screen-controllers.dart';

class WelcomeScreenView extends GetView<WelcomeScreenController> {
  const WelcomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0XFF0C0C0C),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.16,
              ),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Healthy",
                      style: TextStyle(
                          color: Colors.amberAccent,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Center(
                  child: Text(
                "Your Personalized health & Diet",
                style: TextStyle(
                    color: Color(0XFF7B7B7A),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),
              Center(
                  child: Text(
                "Companion",
                style: TextStyle(
                    color: Color(0XFF7B7B7A),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.048,
              ),
              Center(
                child: Image.asset(
                  "assets/welcome.png",
                  width: 400,
                  height: 400,
                  fit: BoxFit.cover,
                ),
              ),

              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                    color: Color(0XFF262723),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    Container(
                      width: 430,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0XFFCDE26D),
                          width: 1
                        ),
                        borderRadius: BorderRadius.circular(30)
                      ),
                      child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Login",
                            style: TextStyle(color: Color(0XFFCDE26D)),
                          )),
                    ),
                    SizedBox(height: 30,),
                    Container(
                      width: 430,
                      decoration: BoxDecoration(
                        color: AppColors.chineseGreen,
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Color(0XFF242522)),
                          )),
                    ),

                  ],
                ),
              )
            ],
          ),
        ));
  }
}
