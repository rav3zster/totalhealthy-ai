import 'package:flutter/material.dart';

import '../../../core/base/constants/appcolor.dart';

class UserDietScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF0C0C0C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              maxRadius: 28,
              backgroundImage: NetworkImage(
                  'https://s3-alpha-sig.figma.com/img/519d/a5b3/5dd7c94081b46b1030716f9a99bda058?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=jenxaaauev~xejor2UuGg8xXNQB-ugvjmHoiV6RcNYBQnj-hr1VQ20Pbprvw3fWQXO15QJFXc0Y3th0TAjya4d2TDqRdQBfcw171WpKTXMLmNMY0JHYemzsMAxDhHBEj-YGN~mHOiegyTMzi0~RjHZygBWfR4QbwdmR1ec3ITjoqefk8JaSfq4fbIXemlAvJsTO4-vTxp0ZGSZ2U24NawVgj0FP9BkCADm41VTdZg7bQLe0quP~0-~oUARPGRnm83vvDLQSjdFNn3sKVNMMXsbNSYLKtZOyA6OdcroUS8lEZvrKXyLjLYffXv~3IGOH1yVMMFdwyNId06kR32T468g__'), // Profile image
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome!',
                    style: TextStyle(fontSize: 20, color: Color(0XFFFFFFFF))),
                SizedBox(
                  height: 5,
                ),
                Text('Ayush Shukla',
                    style: TextStyle(fontSize: 16, color: Color(0XFF7B7B7A))),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            decoration:
            BoxDecoration(color: Color(0XFF242424), shape: BoxShape.circle),
            child: IconButton(
              icon: Icon(
                Icons.notifications_none,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          UserCard(),
          SizedBox(height: 20),
          AddMealButton(),
          SizedBox(height: 20),
          MealTypeSelector(),
          SizedBox(height: 20),
          NutritionalCard(
            title: "Scrambled Eggs With Spinach",
            kcal: 500,
            weight: 100,
            protein: 20,
            fat: 21,
            carbs: 30,
          ),
          SizedBox(height: 15,),
          NutritionalCard(
            title: "Salad Without Eggs",
            kcal: 300,
            weight: 150,
            protein: 25,
            fat: 21,
            carbs: 14,
          ),
          SizedBox(height: 15,),
          NutritionalCard(
            title: "Vegetables",
            kcal: 394,
            weight: 200,
            protein: 27,
            fat: 32,
            carbs: 42,
          ),
          SizedBox(height: 15,),
          NutritionalCard(
            title: "Fruits",
            kcal: 197,
            weight: 250,
            protein: 8,
            fat: 9,
            carbs: 72,
          ),
          SizedBox(height: 15,),
          NutritionalCard(
            title: "Pancakes",
            kcal: 874,
            weight: 200,
            protein: 90,
            fat: 100,
            carbs: 80,
          ),
          SizedBox(height: 15,)
        ],
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Color(0XFF242424),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 70,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          fit: BoxFit.cover,
                          height: 90,
                          'https://s3-alpha-sig.figma.com/img/4edc/c0b0/bdaf584c291418ad88b679516504a43c?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=IbcOURmNXhwmkM99WKqGORFkJ7KSTt0pp1OmymlK631~CIyf1SmXCL1KpE48OQ-5lUnzil5KzGReYJzSCncgs5qVicHLfvqkeM0ZeVv8dxIoaRluWoWbtDIq~8o~rFf5dObR7~UjhQpLyoNdgm8McqhDSxuRwT-oaTTV5ytgkQD3z0Nx75TsIBf~CgAgnxoDPMa-VLnkFrYU8n-wqj5sZW2VF8GFLzywTbLHjCst79zdudCa-1ZUMKV3jaMnCKcsDONFeJtfUFUZMAgTXV7RbQ7~5UAxyWeTgjeEDwN5K7wBOJOtLKAtyA7lbf019miLdNDr~xAzxDgZidpkm~9Rbg__',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 15),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'User Name:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0XFFFFFFFF).withOpacity(0.75),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Ayush Shukla',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0XFFFFFFFF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Plan Name:',
                            style: TextStyle(
                              color: Color(0XFFFFFFFF).withOpacity(0.75),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Keto Plan',
                            style: TextStyle(
                              color: Color(0XFFFFFFFF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Plan Duration:',
                            style: TextStyle(
                              color: Color(0XFFFFFFFF).withOpacity(0.75),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Oct 1 - Nov 1',
                            style: TextStyle(
                              color: Color(0XFFFFFFFF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Email:',
                            style: TextStyle(
                              color: Color(0XFFFFFFFF).withOpacity(0.75),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'ayush@gmail.com',
                            style: TextStyle(
                              color: Color(0XFFFFFFFF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.local_post_office_outlined,
                        color: Color(0XFF242522),
                      ),
                      decoration: BoxDecoration(
                          color: Color(0XFFCDE26D), shape: BoxShape.circle),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Color(0XFFF5D657), shape: BoxShape.circle),
                      child: Icon(
                        Icons.call_outlined,
                        color: Color(0XFF242522),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              '85% Progress',
              style: TextStyle(
                  fontSize: 14,
                  color: Color(0XFFFFFFFF),
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            LinearProgressIndicator(
              value: 0.85,
              backgroundColor: Colors.grey,
              color: Color(0XFFF57552),
              minHeight: 8, // Thickness of the progress bar
            ),
          ],
        ),
      ),
    );
  }
}

class NutritionalCard extends StatelessWidget {
  final String title;
  final int kcal;
  final int weight;
  final int protein;
  final int fat;
  final int carbs;
  final String? image;

  NutritionalCard({
    required this.title,
    required this.kcal,
    required this.weight,
    required this.protein,
    required this.fat,
    required this.carbs,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0XFF242522), // Card background color
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/salad.png",
                    height: 50,
                    width: 50,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.local_fire_department,
                              color: Colors.red, size: 25),
                          SizedBox(width: 4),
                          Text(
                            "$kcal Kcal",
                            style: TextStyle(
                              color: AppColors.neplesYellow,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 8,
                                color: AppColors.neplesYellow,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "$weight g",
                                style: TextStyle(
                                  color: AppColors.neplesYellow,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                      color: AppColors.chineseGreen, shape: BoxShape.circle),
                  child: Icon(Icons.more_horiz, color: Colors.black)),
            ],
          ),
          SizedBox(height: 8),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NutrientIndicator(
                  label: "Protein", amount: "$protein g", color: Colors.green),
              NutrientIndicator(
                  label: "Fat", amount: "$fat g", color: Colors.blue),
              NutrientIndicator(
                  label: "Carbs", amount: "$carbs g", color: Colors.red),
            ],
          ),
        ],
      ),
    );
  }
}

class NutrientIndicator extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;

  NutrientIndicator(
      {required this.label, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            width: 8,
            child: RotatedBox(
              quarterTurns: 3,
              child: LinearProgressIndicator(
                value: 0.5, // value should be a fraction (0.0 to 1.0)
                valueColor: AlwaysStoppedAnimation<Color>(
                    color), // Correctly set the value color
                backgroundColor: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                amount,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                label,
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


class MealTypeSelector extends StatelessWidget {
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
              icon: Icon(Icons.set_meal,color: Color(0XFFDBDBDB),),
              onPressed: () {},
              label: Text("Brekfast",style: TextStyle(color: Color(0XFFDBDBDB)),)),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Color(0XFF242522),
          ),
          child: TextButton.icon(
              icon: Icon(Icons.lunch_dining,color: Color(0XFFDBDBDB),),
              onPressed: () {},
              label: Text("Lunch",style: TextStyle(color: Color(0XFFDBDBDB)),)),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Color(0XFF242522),
          ),
          child: TextButton.icon(
              icon: Icon(Icons.dinner_dining,color: Color(0XFFDBDBDB),),
              onPressed: () {},
              label: Text("Dinner",style: TextStyle(color: Color(0XFFDBDBDB)),)),
        ),
      ],
    );
  }
}

class AddMealButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Today's Diet Plan",
          style: TextStyle(
              color: Color(0XFFFFFFFF),
              fontWeight: FontWeight.bold,
              fontSize: 24),
        ),
        Spacer(),
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(
            Icons.add,
            color: Color(0XFF242522),
          ),
          label: Text(
            'Add Meal',
            style: TextStyle(color: Color(0XFF242522), fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0XFFCDE26D),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
        ),
      ],
    );
  }
}