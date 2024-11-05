import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';



class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedLanguage = 'English';
  String selectedRegion = 'India';
  String selectedTheme = 'Dark';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(
            Icons.arrow_back_ios_new_outlined, color: Color(0XFFDBDBDB)),
        actions: [
          IconButton(onPressed: () {
            Get.back();
          },
              icon: Icon(Icons.search, size: 35, color: Colors.white,))
        ],
        title: const SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(right: 35),
            // Adjust this value to control the left shift
            child: Text(
              'General',
              style: TextStyle(color: Color(0XFFFFFFFF),
                  fontFamily: 'inter',
                  fontSize: 24,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingOption(
              title: 'Language',
              value: selectedLanguage,
              items: ['English', 'Spanish', 'French'],
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
              },
            ),
            SettingOption(
              title: 'Region',
              value: selectedRegion,
              items: ['India', 'USA', 'UK'],
              onChanged: (value) {
                setState(() {
                  selectedRegion = value!;
                });
              },
            ),
            SettingOption(
              title: 'Theme',
              value: selectedTheme,
              items: ['Light', 'Dark'],
              onChanged: (value) {
                setState(() {
                  selectedTheme = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingOption extends StatelessWidget {
  final String title;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  SettingOption({
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: DropdownButton<String>(
              value: value,
              dropdownColor: Colors.grey[900],
              underline: SizedBox(),
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: Color(0xffCCE16B)),
              style: TextStyle(color: Color(0xffCCE16B), fontSize: 16),
              onChanged: onChanged,
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// class general_setting_page extends StatefulWidget {
//   const general_setting_page({super.key});
//
//   @override
//   State<general_setting_page> createState() => _setting_pageState();
// }
//
// class _setting_pageState extends State<general_setting_page> {
//
//   String? selectedValue; // Variable to hold the selected value
//   List<String> items = [
//     'Item 1',
//     'Item 2',
//     'Item 3',
//     'Item 4'
//   ]; // Dropdown items
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: const Icon(
//             Icons.arrow_back_ios_new_outlined, color: Color(0XFFDBDBDB)),
//         actions: [
//           IconButton(onPressed: () {
//             Get.back();
//           },
//               icon: Icon(Icons.search, size: 35, color: Colors.white,))
//         ],
//         title: const SizedBox(
//           width: double.infinity,
//           child: Padding(
//             padding: EdgeInsets.only(right: 35),
//             // Adjust this value to control the left shift
//             child: Text(
//               'General',
//               style: TextStyle(color: Color(0XFFFFFFFF),
//                   fontFamily: 'inter',
//                   fontSize: 24,
//                   fontWeight: FontWeight.w400),
//             ),
//           ),
//         ),
//
//       ),
//
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.only(left: 10),
//           child: Column(
//             children: [
//                custom_dropdown(heading: "Language", values: ["English","b"], selectedValue:"English"),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class custom_dropdown extends StatefulWidget {
//   final String heading;
//   final List<String> values;
//    String selectedValue;
//
//    custom_dropdown(
//       {super.key, required this.heading, required this.values, required this.selectedValue});
//
//   @override
//   State<custom_dropdown> createState() => _custom_dropdownState();
// }
//
// class _custom_dropdownState extends State<custom_dropdown> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: Alignment.centerLeft,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // heading
//           Text("Language",style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//           ),),
//           SizedBox(height: 20,),
//           Padding(padding: EdgeInsets.only(left: 10,right: 20),
//             child: Container(
//               width: double.infinity,
//               child: Container(
//                 padding: EdgeInsets.all(10),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                    color: Colors.white10,
//                    borderRadius: BorderRadius.circular(10)
//                 ),
//                 child: Container(
//                   padding: EdgeInsets.all(1),
//                   child: DropdownButton<String>(
//                     dropdownColor:Colors.white10,
//                     isExpanded: true,
//                     style: TextStyle(color: Color(0xffCCE16B),fontSize: 18),
//                     hint: Text("Select an item"),
//                     value: widget.selectedValue,
//                     items: widget.values.map((String item) {
//                       return DropdownMenuItem<String>(
//                         value: item,
//                         child: Text(item),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         widget.selectedValue = newValue!;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//             ),)
//         ],
//       ),
//     );
//   }
// }



