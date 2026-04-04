import 'package:flutter/material.dart';

class MealTypeSelector extends StatelessWidget {
  const MealTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            border: Border.all(color: Color(0XFFCDE26D)),
            borderRadius: BorderRadius.circular(40),
            color: Color(0XFF242522),
          ),
          child: TextButton.icon(
              icon: Icon(
                Icons.set_meal,
                color: Color(0XFFDBDBDB),
              ),
              onPressed: () {},
              label: Text(
                "Brekfast",
                style: TextStyle(color: Color(0XFFDBDBDB)),
              )),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Color(0XFF242522),
          ),
          child: TextButton.icon(
              icon: Icon(
                Icons.lunch_dining,
                color: Color(0XFFDBDBDB),
              ),
              onPressed: () {},
              label: Text(
                "Lunch",
                style: TextStyle(color: Color(0XFFDBDBDB)),
              )),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Color(0XFF242522),
          ),
          child: TextButton.icon(
              icon: Icon(
                Icons.dinner_dining,
                color: Color(0XFFDBDBDB),
              ),
              onPressed: () {},
              label: Text(
                "Dinner",
                style: TextStyle(color: Color(0XFFDBDBDB)),
              )),
        ),
      ],
    );
  }
}
