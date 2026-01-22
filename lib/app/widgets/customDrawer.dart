//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:totalhealthy/app/widgets/sideMenu.dart';
//
// import '../core/base/controllers/auth_controller.dart';
// import '../routes/app_pages.dart';
//
//
// class CustomDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // We create a scaffold to manage the drawer and add a custom drawer layout
//       body: Builder(
//         builder: (context) {
//           return GestureDetector(
//             onTap: () {
//               // Close the drawer when tapping outside (optional)
//               Navigator.of(context).pop();
//             },
//             child: Stack(
//               children: [
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: Container(
//                     color: Color(0xFFFF7BC1B7),
//                     width: MediaQuery.of(context).size.width,
//                     // Full screen width
//                     height: MediaQuery.of(context).size.height,
//                     // Full screen height
//                     padding: EdgeInsets.zero,
//                     child: Column(
//                       // padding: EdgeInsets.zero,
//                       children: <Widget>[
//                         // Custom header with padding, profile image, and user info
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16, vertical: 16),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               SizedBox(height: 40),
//                               Row(
//                                 children: [
//                                   // Profile Image
//                                   // InkWell(
//                                   //   child: CircleAvatar(
//                                   //     radius: 30,
//                                   //     child:
//                                   //     Image.asset("assets/Ellipse 154.png"),
//                                   //
//                                   //   ),
//                                   //   onTap: () {
//                                   //
//                                   //     Get.toNamed(Routes.PERSONALINFO);
//                                   //   },
//                                   // ),
//                                   const SizedBox(width: 16),
//                                   // User Info
//                                   Column(
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.start,
//                                     children: const [
//                                       Text(
//                                         'Krishna',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 18,
//                                         ),
//                                       ),
//                                       SizedBox(height: 4),
//                                       Text(
//                                         'Krishna123@gmail.com',
//                                         style: TextStyle(
//                                           color: Colors.white70,
//                                           fontSize: 14,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const Spacer(),
//                                   // Notification Icon
//                                   Container(
//                                     width: 40,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: Color(
//                                           0xFFFF0000), // Red circle background
//                                     ),
//                                     child: IconButton(
//                                       icon: Icon(
//                                         Icons.close,
//                                         color: Colors.white, // White close icon
//                                       ),
//                                       onPressed: () {
//                                         // Close the drawer when the close icon is clicked
//                                         Navigator.of(context).pop();
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//
//                               // Adjust the space as per your requirement
//                             ],
//                           ),
//                         ),
//                         SideMenu(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: Container(
//         width: MediaQuery.sizeOf(context).width,
//         color: Color(0xFFFF7BC1B7), // Same as background for seamless look
//         padding: EdgeInsets.symmetric(vertical: 10),
//         child: ListTile(
//           leading: Icon(Icons.exit_to_app, color: Colors.white),
//           title: Text(
//             'Logout',
//             style: TextStyle(color: Colors.white),
//           ),
//           onTap: () {
//             Get.find<AuthController>().logout();
//             Get.offAllNamed('/login');
//           },
//         ),
//       ),
//     );
//   }
// }
