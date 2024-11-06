import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({
    super.key,
    required this.group,
  });

  final Map<String, dynamic> group;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Color(0XFF242522), borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${group["group_name"]}",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFFDBDBDB)),
              ),
              SizedBox(height: 8),
              Text(
                "${group["description"]}",
                style: TextStyle(fontSize: 16, color: Color(0XFF7E7E7E)),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Color(0XFFCDE26D).withOpacity(0.1),
                          shape: BoxShape.circle),
                      child: Icon(
                        Icons.calendar_today_outlined,
                        color: Color(0XFFCDE26D),
                        size: 18,
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Created On:"),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${group["created_at"]}",
                    style: TextStyle(fontSize: 14, color: Color(0XFFFFFFFF)),
                  ),
                ],
              ),
              // Row(
              //   children: [
              //     Container(
              //         padding: EdgeInsets.all(8),
              //         decoration: BoxDecoration(
              //             color:
              //                 Color(0XFFCDE26D).withOpacity(0.1),
              //             shape: BoxShape.circle),
              //         child: Icon(
              //           Icons.people_outline,
              //           color: Color(0XFFCDE26D),
              //           size: 18,
              //         )),
              //     SizedBox(
              //       width: 5,
              //     ),
              //     // Text("Total Members:"),
              //     // SizedBox(
              //     //   width: 10,
              //     // ),
              //     // Text(
              //     //   "12 Members",
              //     //   style: TextStyle(
              //     //       fontSize: 14, color: Color(0XFFFFFFFF)),
              //     // ),
              //   ],
              // ),
              //
            ],
          ),
        ),
      ),
    );
  }
}
