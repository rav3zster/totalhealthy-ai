import 'package:flutter/material.dart';

import '../../../core/base/apiservice/api_endpoints.dart';
import '../../../core/base/apiservice/api_status.dart';
import '../../../core/base/apiservice/base_methods.dart';

class GroupListPage extends StatefulWidget {
  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  bool isLoading = false;
  var groupData = [];
  Future<void> submitUser() async {
    try {
      setState(() {
        isLoading = true;
      });
      // print(data);  String input = searchController.text.trim();
      // String input = searchController.text.trim();
      // var phone = int.tryParse(input);
      await APIMethods.get
          .get(
        url: APIEndpoints.group.createGroup,
      )
          .then((value) {
        if (APIStatus.success(value.statusCode)) {
          setState(() {
            groupData = value.data;
          });

          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('User  Successful!'),
          //     backgroundColor: Colors.green,
          //   ),
          // );
        } else {
          // printError("Auth Controller", "Signup", value.data);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${value.data["detail"]}'),
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
  void initState() {
    // TODO: implement initState
    super.initState();
    submitUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group List'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: groupData.length,
              itemBuilder: (context, index) {
                final group = groupData[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name :  "${group["group_name"]}"',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Description : "${group["description"]}"',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Created at: "${group["created_at"]}"',
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
