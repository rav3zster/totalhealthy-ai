import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClientDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Enlarged Daily Calories Tracking Section
              Container(
                height: 250, // Increase the height of the container
                decoration: BoxDecoration(
                  color: Color(0XFFCDE26D),
                  borderRadius: BorderRadius.circular(
                      16), // Increase the border radius for smoother edges
                ),
                padding: EdgeInsets.all(20), // Increase padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // Align items to the far ends
                  children: [
                    // Text content on the left
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Track \nYour Daily \nCalories',
                          style: TextStyle(
                              color: Color(0XFF000000),
                              fontWeight: FontWeight.bold,
                              fontSize: 30), // Increase font size
                        ),
                        SizedBox(height: 10),
                        // More space between the title and summary
                        Row(
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.circle_outlined,
                                  color: Color(0XFFFFFFFF),
                                ),
                                Text(
                                  'Gain',
                                  style: TextStyle(
                                      color: Color(0XFF000000),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                // Slightly bigger text
                                Text(
                                  '1258 Kcal',
                                  style: TextStyle(
                                      color: Color(0XFF000000),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(width: 24),
                            // More space between 'Gain' and 'Burn'
                            Column(
                              children: [
                                Icon(
                                  Icons.circle_outlined,
                                  color: Color(0XFFFFFFFF),
                                ),
                                Text(
                                  'Burn',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0XFF000000),
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '658 Kcal',
                                  style: TextStyle(
                                    color: Color(0XFF000000),
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

                    // Image on the right
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        // Match the container's border radius
                        child: Image.network(
                          'https://s3-alpha-sig.figma.com/img/aa46/ce5c/25f392ef813edfc388ecc9ed434b2756?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=LHuB591vRnvEVBOpHOCngxfNp4AwL-YESi5~qFq6bmZkyp6lo94Y~Vf-wU40M5hYl7aY8cymBMa54f7IQ4Pva1HFFM5wHt70EBT89zgwQRwjvCue1xXX20WDeslIE2ZNTCKt50hKHm72948keAWryeOjCKuP~ZEPN~-hqj-7w5NhbHkbOQh9EahSHJoFRI-mv3Q-VojJCBw4u6nHZYRa6dl-yIeuLe6msjVH0X93-CHLq5MAKodID-cyHCxC3GVPZuKry--zU2wzrTwGQHLaP11nJojaSB7V-yOxs1B5NmadqeJncGj-8ncSAhuTglHEtVQxKYVua3qK7gUFJS-brA__',
                          fit: BoxFit
                              .cover, // Image will cover the entire container
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

// Daily Nutrient Summary Section with more space between sections
              Container(
                margin: EdgeInsets.only(top: 16, bottom: 16),
                // Space around the container
                decoration: BoxDecoration(
                  color: Color(0XFF222222),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(20),
                // Added more padding inside the container
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header for the Daily Nutrient Summary
                    Text(
                      'Daily Nutrient Summary',
                      style: TextStyle(
                        color: Color(0XFFFFFFFF),
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    // Added more space between the header and the content
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // Align labels and values to the left
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              // Ensures alignment of text sizes
                              children: [
                                // Large size for the value before "/"
                                Text(
                                  '60',
                                  style: TextStyle(
                                    color: Color(0XFFF57552),
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        22, // Increased font size for the value before "/"
                                  ),
                                ),
                                // Smaller size for the value after "/"
                                Text(
                                  ' / 150',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        14, // Decreased font size for the value after "/"
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            // Space between value and title
                            // Title (Proteins, Carbs, Fats) below the values
                            Text(
                              'Proteins',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        // Adjusted for Proteins
                        _buildVerticalDivider(),
                        // Vertical divider
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // Align labels and values to the left
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              // Ensures alignment of text sizes
                              children: [
                                // Large size for the value before "/"
                                Text(
                                  '120',
                                  style: TextStyle(
                                    color: Color(0XFFF5D657),
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        22, // Increased font size for the value before "/"
                                  ),
                                ),
                                // Smaller size for the value after "/"
                                Text(
                                  ' / 200',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        14, // Decreased font size for the value after "/"
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            // Space between value and title
                            // Title (Proteins, Carbs, Fats) below the values
                            Text(
                              'Carbs',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        // Adjusted for Carbs
                        _buildVerticalDivider(),
                        // Vertical divider
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // Align labels and values to the left
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              // Ensures alignment of text sizes
                              children: [
                                // Large size for the value before "/"
                                Text(
                                  '35',
                                  style: TextStyle(
                                    color: Color(0XFFD0B4F9),
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        22, // Increased font size for the value before "/"
                                  ),
                                ),
                                // Smaller size for the value after "/"
                                Text(
                                  ' / 75',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        14, // Decreased font size for the value after "/"
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            // Space between value and title
                            // Title (Proteins, Carbs, Fats) below the values
                            Text(
                              'Fats',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        // Adjusted for Fats
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Search bar, Filter button, Today's Diet Plan, and Add Meal button
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0XFF242522),
                          borderRadius: BorderRadius.circular(50)),
                      child: TextField(
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          hintText: 'Search here...',
                          hintStyle: TextStyle(color: Color(0XFFDBDBDB)),
                          prefixIcon:
                              Icon(Icons.search, color: Color(0XFFDBDBDB)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.filter_list, color: Colors.white, size: 30),
                ],
              ),
              SizedBox(height: 16),

              // "Today's Diet Plan" and "Add Meal" button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's Diet Plan",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 26),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(
                      Icons.add,
                      color: Color(0XFF242522),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFCDE26D),
                      // Add Client Button Color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {},
                    label: Text('Add Meal',
                        style: TextStyle(color: Color(0XFF242522))),
                  ),
                ],
              ),

              MealTypeSelector(),
              SizedBox(height: 16),

              // Meal Items (ListView inside SingleChildScrollView)
              _buildMealItem('Oats And Banana Smoothie', '1000 Kcal',
                  '250 Carbs, 50 Protein, 25 Fats', 'assets/oats_smoothie.png'),
              _buildMealItem('Scrambled Eggs With Spinach', '500 Kcal',
                  '150 Carbs, 30 Protein, 15 Fats', 'assets/eggs_spinach.png'),
              _buildMealItem(
                  'Greek Yogurt With Mixed Berries',
                  '1050 Kcal',
                  '180 Carbs, 45 Protein, 20 Fats',
                  'assets/yogurt_berries.png'),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build the vertical divider
  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white30, // Light color for the divider
    );
  }

  Widget _buildMealItem(
      String title, String kcal, String nutrients, String imageUrl) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        child: Stack(
          children: [
            Image.network(
                'https://s3-alpha-sig.figma.com/img/42a5/0ea7/5b8574861966061d01ca70419a885f64?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=TNP2-OtEW8U7dcWblP4c7AMYU6zc0888Du5vY8Djd7sIsZOlBM6mmzO1nejuXhQp~XT~qIrnwQ~NDuf13jw~VImXOMCRrA6q~on5D7piCoMGv-97~gybVs2~iR0e5q6yoBNJfDKrmZE4Pow8cTwyDk~J0y-Bn702hR6X-dI7tEDtOYt1rfo2QWbVUkRLumS1PtGYfpViAZG-9Pkvo6IiU9DcY0O4utrk2LF~Igl2ci~wU-e0f9TX-fMDUp1sRhvOZ9qbn1YWU9JcOafLjRLzFXPRrplp385UktkybQrUxxhW0CwYE-0X1VmHa1pEe8mtTV0g3Zp9W5GNIJYTLfYAFA__',
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.only(top: 190),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 14),
                
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: Colors.white,fontSize: 18)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(kcal, style: TextStyle(color: Color(0XFFF5D657),fontSize: 18)),
                        SizedBox(height: 4),
                        Text(nutrients,
                            style: TextStyle(color: Color(0XFFDBDBDB),fontSize: 16)),
                      ],
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Color(0XFF242522).withOpacity(0.50),
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
            )
          ],
        )

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
