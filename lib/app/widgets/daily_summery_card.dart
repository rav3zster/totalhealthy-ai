import 'package:flutter/material.dart';

class DailySummeryCard extends StatelessWidget {
  const DailySummeryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Color(0XFF222222),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
}
