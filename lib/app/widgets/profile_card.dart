import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/core/base/controllers/auth_controller.dart';

import '../core/base/constants/appcolor.dart';

class ProfileCard extends StatelessWidget {
  final String? title;
  final bool isDrawer;
  const ProfileCard({
    super.key,
    this.title,
    this.isDrawer = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Builder(
          builder: (context) {
            return Center(
              child: InkWell(
                onTap: () {
                  isDrawer ? Scaffold.of(context).openDrawer() : null;
                },
                child: CircleAvatar(
                  backgroundColor: AppColors.cardbackground,
                  maxRadius: 28,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title ?? 'Welcome!',
                style: TextStyle(fontSize: 20, color: Color(0XFFFFFFFF))),
            SizedBox(
              height: 5,
            ),
            Text(Get.find<AuthController>().userdataget()["name"].toString(),
                style: TextStyle(fontSize: 16, color: Color(0XFF7B7B7A))),
          ],
        ),
      ],
    );
  }
}
