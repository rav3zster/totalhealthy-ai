import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.grey.shade400),
      ),
      child: IconButton(
        padding: EdgeInsets.all(0),
        alignment: Alignment.center,
        icon: Icon(Icons.arrow_back_ios, size: 15),
        onPressed: () {
          Navigator.pop(context);
        },
        color: Colors.grey.shade400,
      ),
    );
  }
}
