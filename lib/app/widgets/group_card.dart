import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({super.key, required this.group});

  final Map<String, dynamic> group;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to group details with group data
        Get.toNamed(Routes.GROUP_DETAILS, arguments: group);
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0XFF242522),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${group["group_name"] ?? group["name"] ?? "Unnamed Group"}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0XFFDBDBDB),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${group["description"] ?? "No description"}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0XFF7E7E7E),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0XFFCDE26D).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.calendar_today_outlined,
                        color: Color(0XFFCDE26D),
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text("Created On:"),
                    const SizedBox(width: 10),
                    Text(
                      "${group["created_at"] ?? group["createdDate"] ?? "Unknown"}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0XFFFFFFFF),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
