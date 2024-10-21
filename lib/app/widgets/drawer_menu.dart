import '/app/core/base/constants/appcolor.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/utitlity/responsive_settings.dart';
import 'phone_nav_bar.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context)
        ? Drawer(
            backgroundColor: AppColors.white,
            width: 300,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: const BoxDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          width: double.infinity,
                          child: Row(
                            // crossAxisAlignment: WrapCrossAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    AssetImage("assets/screen_1.jpg"),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  // mainAxisAlignment: MainAxisAlignment,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "Username",
                                      // style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "User@gmail.com",
                                      // style: TextStyle(color: Colors.white)),
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ListView(
                          shrinkWrap: true,
                          children: [
                            ListTile(
                              onTap: () {
                                Get.offAllNamed(OntapStore.routes[0]);

                                setState(() {
                                  OntapStore.index = 0;
                                });
                              },
                              title: const Text(
                                "Home",
                                style: TextStyle(color: Colors.black),
                              ),
                              leading: const Icon(Icons.person),
                            ),
                            // ListTile(
                            //   onTap: () {
                            //     Get.offAllNamed(OntapStore.routes[1]);

                            //     setState(() {
                            //       OntapStore.index = 1;
                            //     });
                            //   },
                            //   title: Text(
                            //     "Food Details",
                            //     style: TextStyle(color: Colors.black),
                            //   ),
                            //   leading: Icon(Icons.person),
                            // ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 20,
                        ),
                        IconButton(
                          onPressed: () async {},
                          icon: const Icon(
                            color: Colors.grey,
                            Icons.exit_to_app,
                          ),
                          tooltip: 'Logout',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}

class AvatarWithLetter extends StatelessWidget {
  final String username;

  const AvatarWithLetter({super.key, required this.username});

  // Generate a color based on the ASCII value of the first letter
  Color _getColorForLetter(String letter) {
    int asciiValue = letter.codeUnitAt(0);
    // Generate a color using the ASCII value, you can tweak the numbers to get different color variations
    return Color.fromARGB(
      255, // Opaque color
      (asciiValue * 3) % 256,
      (asciiValue * 5) % 256,
      (asciiValue * 7) % 256,
    );
  }

  @override
  Widget build(BuildContext context) {
    String firstLetter = username.isNotEmpty ? username[0].toUpperCase() : '?';

    return CircleAvatar(
      radius: 30, // You can change the size of the avatar here
      backgroundColor: _getColorForLetter(firstLetter),
      child: Text(
        firstLetter,
        style: const TextStyle(
          fontSize: 24, // Adjust font size here
          color: Colors.white, // Text color
        ),
      ),
    );
  }
}
