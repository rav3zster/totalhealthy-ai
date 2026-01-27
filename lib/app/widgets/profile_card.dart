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
    final userData = Get.find<AuthController>().userdataget() ?? {};
    
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
                  maxRadius: 20, // Smaller radius for header
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 20, // Smaller icon
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(width: 8), // Reduced spacing
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title ?? 'Welcome!',
                style: TextStyle(fontSize: 16, color: Color(0XFFFFFFFF), fontWeight: FontWeight.w500)), // Smaller font
            Text(userData["username"] ?? "Ayush Shukla",
                style: TextStyle(fontSize: 14, color: Color(0XFF7B7B7A))), // Smaller font
          ],
        ),
      ],
    );
  }
}
