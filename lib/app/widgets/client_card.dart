import 'package:flutter/material.dart';

class ClientCard extends StatelessWidget {
  final String name;
  final String email;
  final int progress;
  const ClientCard(
      {super.key,
      required this.name,
      required this.email,
      required this.progress});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      // Increased height to make space for progress text
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF2E2E2E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          // Content for client card
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 60, // Set the width for the square
                  height: 60, // Set the height for the square
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/clientimage.png"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8), // Rounded corners
                  ),
                ),
                title: Text(
                  'Client Name: $name',
                  style: TextStyle(color: Color(0XFFFFFFFF), fontSize: 16),
                ),
                subtitle: Text(
                  'Email: $email',
                  style: TextStyle(color: Color(0XFFFFFFFF), fontSize: 14),
                ),
              ),
              SizedBox(height: 5),
              // Progress bar

              // Progress Text below the progress bar

              Text(
                '$progress%', // Display progress percentage
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: Colors.grey,
                color: progress > 55 ? Colors.green : Colors.yellow,
              ),
            ],
          ),
          // Positioned Icons inside a circle at the top-right corner
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 0.2, right: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Space between the two icons
                  GestureDetector(
                    child: Container(
                        padding: EdgeInsets.all(8), // Padding inside the circle
                        decoration: BoxDecoration(
                          color: Color(0XFFCDE26D), // Circle color for message
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.local_post_office_outlined,
                          color: Color(0XFF242522),
                        )),
                    onTap: () {},
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                        padding: EdgeInsets.all(8), // Padding inside the circle
                        decoration: BoxDecoration(
                          color: Color(0XFFF5D657), // Circle color for phone
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.call_outlined,
                          color: Color(0XFF242522),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
