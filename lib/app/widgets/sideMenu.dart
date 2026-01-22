// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// class SideMenu extends StatelessWidget {
//   // Define the menu items in a list of maps
//   final List<Map<String, dynamic>> menuItems = [
//     // {
//     //   "icon": Icons.description,
//     //   "text": "Appointment Dashboard",
//     //   "route": "/appointment-deshbord"
//     // },
//     {"icon": Icons.person, "text": "Profile", "route": "/profile"},
//     // {"icon": Icons.accessible, "text": "Employees", "route": "/employee"},
//     // {"icon": Icons.accessible, "text": "Patients", "route": "/patient"},
//     {"icon": Icons.group, "text": "Account Group", "route": "/account-group"},
//     {"icon": Icons.book, "text": "Account", "route": "/account"},
//     // {
//     //   "icon": Icons.screen_rotation_alt_outlined,
//     //   "text": "Onboarding",
//     //   "route": "/onboarding"
//     // },
//     // {
//     //   "icon": Icons.calendar_today,
//     //   "text": "Appointment Management",
//     //   "route": "/appointment-management"
//     // },
//     {
//       "icon": Icons.payment,
//       "text": "Payment Management",
//       "route": "/payment-management"
//     },
//     {
//       "icon": Icons.filter_list,
//       "text": "Reporting & Filtering",
//       "route": "/reporting-filtering"
//     },
//     // {
//     //   "icon": Icons.history,
//     //   "text": "Payment History",
//     //   "route": "/payment-history"
//     // },
//     {
//       "icon": Icons.description_outlined,
//       "text": "Clinic Dashboard",
//       "route": "/clinic-deshboard"
//     },
//     // {
//     //   "icon": Icons.settings,
//     //   "text": "Configuration",
//     //   "route": Routes.CONFIGURATION
//     // },
//
//     {"icon": Icons.help, "text": "Help", "route": "/help"},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: SingleChildScrollView(
//         child: Column(
//           children: List.generate(menuItems.length, (index) {
//             final item = menuItems[index];
//             return Container(
//               margin: EdgeInsets.only(right: 70, left: 7),
//               child: ListTile(
//                 leading: Icon(item["icon"], color: Colors.white),
//                 title:
//                 Text(item["text"], style: TextStyle(color: Colors.white)),
//                 trailing: Icon(Icons.arrow_forward_ios,
//                     size: 15, color: Colors.white),
//                 onTap: () {
//                   Get.toNamed(item["route"]);
//                 },
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }
