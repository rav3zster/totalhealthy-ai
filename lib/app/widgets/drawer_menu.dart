import 'package:totalhealthy/app/core/utitlity/debug_print.dart';

import '../core/base/controllers/auth_controller.dart';
import '../routes/app_pages.dart';
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
  bool isTrainer = false;

  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context)
        ? Drawer(
            backgroundColor: AppColors.cardbackground,
            width: 300,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
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
                                    AssetImage("assets/user_avatar.png"),
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
                                      "Aysuh Shukla",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: "Public Sans",
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      "Ayush Shukla",
                                      style: TextStyle(
                                          fontFamily: "inter",
                                          fontSize: 12,
                                          color: Color(0xff7B7B7A)),
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                        // const SizedBox(
                        //   height: 20,
                        // ),
                        ListView(
                          shrinkWrap: true,
                          children: [
                            // Swtich user switch bar


                            nav_row(
                                redirect: () {},
                                heading: "Profile",
                                icon_v: Icons.perm_identity_outlined),
                            nav_row(
                                redirect: () {},
                                heading: "Setting",
                                icon_v: Icons.settings_outlined),
                            nav_row(
                                redirect: () {},
                                heading: "Your Deit History",
                                icon_v: Icons.list_alt_rounded),

                            nav_row(
                                redirect: () {
                                  Get.offAllNamed(OntapStore.routes[0]);
                                      Get.toNamed(Routes.UserDiet);
                                      setState(() {
                                        OntapStore.index = 0;});
                                },
                                heading: "Switch as Trainer ",
                                icon_v: Icons.supervised_user_circle_outlined),
                            nav_row(
                                redirect: () {
                                  Get.toNamed(Routes.USER_GROUP_VIEW);
                                      setState(() {
                                        OntapStore.index = 1;
                                      });
                                },
                                heading: "Switch as user",
                                icon_v: Icons.person),

                            nav_row(
                                redirect: () {},
                                heading: "Help & Support",
                                icon_v: Icons.headset_mic_outlined),
                            // ListTile(
                            //   onTap: () {
                            //     Get.offAllNamed(OntapStore.routes[1]);
                            //
                            //     setState(() {
                            //       OntapStore.index = 1;
                            //     });
                            //   },
                            //   title: const Text(
                            //     "Group",
                            //   ),
                            //   leading: const Icon(Icons.group),
                            // ),
                            // ListTile(
                            //   onTap: () {
                            //     Get.offAllNamed(OntapStore.routes[0]);
                            //
                            //     setState(() {
                            //       OntapStore.index = 0;
                            //     });
                            //   },
                            //   title: Text(
                            //     "User",
                            //   ),
                            //   leading: Icon(Icons.person),
                            // ),
                            // ListTile(
                            //   onTap: () {
                            //     Get.toNamed(Routes.USER_GROUP_VIEW);
                            //     setState(() {
                            //       OntapStore.index = 1;
                            //     });
                            //   },
                            //   title: Text(
                            //     "SwitchUser",
                            //   ),
                            //   leading: Icon(Icons.person),
                            // ),
                            // ListTile(
                            //   onTap: () {
                            //     // Get.offAllNamed(OntapStore.routes[0]);
                            //     Get.toNamed(Routes.UserDiet);
                            //     // setState(() {
                            //     //   OntapStore.index = 0;
                            //     // });
                            //   },
                            //   title: Text(
                            //     "SwitchAdmin",
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
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.cardbackground,
                          ),
                          child: IconButton(
                            icon: Row(
                              children: [
                                Text("Logout"),
                                Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            onPressed: () {
                              Get.find<AuthController>().clearAuth();
                            },
                          ),
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

class nav_row extends StatelessWidget {
  const nav_row(
      {super.key,
      required this.redirect,
      required this.heading,
      required this.icon_v});

  final VoidCallback redirect;
  final String heading;
  final IconData icon_v;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      alignment: Alignment.center,
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xff333333),
      ),
      child: ListTile(
        onTap: () {
          redirect();
        },
        leading: Icon(
          icon_v,
          color: Color(0xffDBDBDB),
        ),
        title: Text(
          "$heading",
          style: TextStyle(color: Color(0xffDBDBDB)),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Color(0xffDBDBDB)),
      ),
    );
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
