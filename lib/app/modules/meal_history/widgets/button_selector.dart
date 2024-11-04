import 'package:flutter/material.dart';

class ButtonSelector extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool active;
  const ButtonSelector(
      {super.key,
      required this.title,
      required this.icon,
      required this.active});

  @override
  State<ButtonSelector> createState() => _ButtonSelectorState();
}

class _ButtonSelectorState extends State<ButtonSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        border: Border.all(
            color: widget.active ? Color(0XFFCDE26D) : Color(0XFF242522)),
        borderRadius: BorderRadius.circular(40),
        color: Color(0XFF242522),
      ),
      child: Row(
        children: [
          Icon(
            widget.icon,
            color: Color(0XFFDBDBDB),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            widget.title,
            style: TextStyle(color: Color(0XFFDBDBDB)),
          ),
        ],
      ),
    );
  }
}
