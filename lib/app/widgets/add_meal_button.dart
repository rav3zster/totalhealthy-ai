import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:totalhealthy/app/widgets/custom_button.dart';

import '../core/base/apiservice/api_endpoints.dart';
import '../core/base/apiservice/api_status.dart';
import '../core/base/apiservice/base_methods.dart';
import '../core/base/constants/appcolor.dart';
import '../core/base/controllers/auth_controller.dart';
import '../routes/app_pages.dart';

class AddMealButton extends StatefulWidget {
  final String id;
  const AddMealButton({super.key, required this.id});

  @override
  State<AddMealButton> createState() => _AddMealButtonState();
}

class _AddMealButtonState extends State<AddMealButton> {
  var isLoading = false;
  Future<void> copyExisting(context) async {
    try {
      setState(() {
        isLoading = true;
      });
      var data = {
        "userId": widget.id,
        "groupId": Get.find<AuthController>().groupgetId(),
        "meal_ids": ["string"],
        "from_date": "2024-10-30",
        "to_date": "2024-10-30T10:40:19.067Z"
      };
      print(data);
      await APIMethods.post
          .post(
        url: APIEndpoints.createData.copyMeals,
        map: data,
      )
          .then((value) {
        print(value.data);
        if (APIStatus.success(value.statusCode)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Existing Meals Copy Successful!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // printError("Auth Controller", "Signup", value.data);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Meals not copy'),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
      // }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
    // if (_formKey.currentState!.validate()) {
  }

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
          onPressed: () {
            showBottomSheet(
                context: context,
                builder: (contex) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF272e23),
                            Color.fromARGB(255, 12, 12, 12),
                            Color.fromARGB(255, 12, 12, 12),
                            Color(0xFF272e23),
                          ],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: BorderRadius.horizontal()),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // Align items at the start
                      children: [
                        InkWell(
                          mouseCursor: SystemMouseCursors.click,
                          onTap: () {
                            Get.toNamed('/createmeal?id=${widget.id}');
                          },
                          child: buildActionButton(
                              'Create Manually',
                              'Create',
                              Color(0XFF242522),
                              'https://s3-alpha-sig.figma.com/img/ac61/7d63/d22e2690d5c8624e35deda268d9a1882?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=XFUtIQ3nAmRJphMKbKyRb4uUMVXSUm12t~TjF3-FuA7neNw247D0sNXvuRk8AZJDWkaZuwAcwPu8-oR15RKSmYL6XLwaGLFufXdn0MddabVgqGUDQgAt~GmeKQi~ZMa3a4OiyeQAMPVcXc1S8ootksf-bEy3LnlnyUv2ZmN9j-czUQb4cJvHeSVPjYGTGUoowEMvoBWSM3d8CCG9MaJw~JGdlpsx4X3Sz6T7YJ5yS4GoaIp3XIfRkjCR1vbEOB5DtCtREsdeBoIfwxcnGRVnJDcmvJ2SlrL6b5vhS-QxySZdgOTvoJxJ5MBCVme580VB~EEvSLVMpE8EN9aC5vw-aQ__'),
                        ),
                        SizedBox(
                            height: 16), // Add vertical space between buttons
                        InkWell(
                          mouseCursor: SystemMouseCursors.click,
                          onTap: () {
                            Get.toNamed('/generate-ai?id=${widget.id}');
                          },
                          child: buildActionButton(
                              'Generate Using AI',
                              'Generate',
                              Color(0XFF242522),
                              'https://s3-alpha-sig.figma.com/img/3718/a52e/756040d7214bbf9e6ae7af5e14c47433?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Zk8lTcJxC4TlPWWWLW0o7wZKpnRwN9xYWVA~pgvtHM6YR3uYzvCeAKH5ObA6LV~6ki2KqNdmr1KZTygBEtSRIrNlbjCksJhNI8XKnxYYdov4jzWY~xp0YGoHIoUR5m4UQ4OjlipIUO-MjLDU3wvUuQHD778m2cCuICcSmIOEDqlu0s~NGm0xKInmiUGzq69xZPy5-R13kata0ULjUtiavaIdUa~qXV5-ydr-Ipy0svPt1iMuw4pLT7ajRt8jI0XXyX7LrqpYD1agrtf3Wuaob4vBPI0Z-faC0OeNNu75e9J86OmqT7lKTEWZqSSvNt7uXWYSmiD~Y8bZL8JDDZLRAw__'),
                        ),
                        SizedBox(
                            height: 16), // Add vertical space between buttons
                        InkWell(
                          mouseCursor: SystemMouseCursors.click,
                          onTap: () {
                            copyExisting(context);
                          },
                          child: isLoading
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : buildActionButton(
                                  'Copy From Existing',
                                  'Copy',
                                  Color(0XFF242522),
                                  'https://s3-alpha-sig.figma.com/img/998d/f5b8/588e18036288fef4fd3d5749d955121d?Expires=1730678400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Id~jUYUwpPe51lSz5m4r2vLfzLlG2a-aTByInwPUOumEZTNXxO4Z7qyMtvwRdxbIJvPSaGjh1X2zwS7tP7GKcWgLdRhbmm6mcZxTYEyvnqNBfva3E87xRqeVJoLBPhvlj~GGVtWdF7Ey-m7zU9G9FIiq5R9zoLPKMoD5mE0zNaYuQFMJtOZF7drJDjfUDjAXRXZXvJprIv06wYzocMALMV~FDm98XdWj1x752zbXhHTkwSLy9jRUZYK9yA5SOmQ~E0BpvYjsYJVbL6oV96SVS0PZfuhjDnlUoNze72kE9udAVqaBJB9Ow1Tqs-y~m0lFlmkbvaF1-qZR42pAdAmr5Q__'),
                        ),
                      ],
                    ),
                  );
                });
            // Navigator.pop(context);
          },
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

  Widget buildActionButton(
      String label, String label2, Color color, String imageUrl) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Color(0XFF242522)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Image.network(
          //   imageUrl, // Load image from the network
          //   width: 50, // Set the width of the image
          //   height: 50, // Set the height of the image
          // ),
          SizedBox(width: 8), // Add some space between the image and text
          Text(
            label,
            style: TextStyle(
              color: Colors.white, // Change text color to white
            ),
            textAlign: TextAlign.left, // Align text to the left
          ),
          SizedBox(
            width: 30,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
                color: Color(0XFFCDE26D),
                borderRadius: BorderRadius.circular(30)),
            child: Text(
              label2,
              style: TextStyle(color: Color(0XFF242522)),
            ),
          )
        ],
      ),
    );
  }
}
