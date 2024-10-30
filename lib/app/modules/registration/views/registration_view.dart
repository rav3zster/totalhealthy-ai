import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:totalhealthy/app/widgets/custom_button.dart';

import '../../../core/base/apiservice/api_endpoints.dart';
import '../../../core/base/apiservice/api_status.dart';
import '../../../core/base/apiservice/base_methods.dart';
import '../../../core/base/controllers/auth_controller.dart';

class RegistrationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF0C0C0C),
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: NetworkImage(
        //         'https://s3-alpha-sig.figma.com/img/38ad/4f6c/538384fa69936c2659d1b9bdf0426f8a?Expires=1730073600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=O-0MQXIs-bA0L4hc1ep1iaMAUgBAN7-156MVlx083husI8dYUFFEWFUORfn5tDB1yUtficvqC1rkPOaVQ92J6~Sly6Be3HOzfE5S0tYLXaIqDrieojmYFyRqgNk09S8tKagoZbH-BitxJAoMOuE0xdGkq36oNqKnbu6WuCQ4fClQfZg94c8OAkHzurKzZGvZ4RAmHoGmBub31iSSjRc8e0rgvQOlbZnw75MIdj8rjvby-e4EqFDc0BFrd3mUIj2QL18KyLgHAIcXYUeCa2FPXoxIsDJzXWGAF8APBv9PqGIrJYHlu85pTXz~NFPSyByxOHq5yaZmFa9fOmoyHC-FeA__'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Column(
          children: [
            // App Bar
            PreferredSize(
              preferredSize: Size.fromHeight(100),
              // Set desired height here
              child: AppBar(
                backgroundColor: Color(0XFF000000).withOpacity(0.1),
                // Semi-transparent app bar color
                elevation: 0,
                centerTitle: true,
                title: Text('Profile',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile Picture
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            'https://example.com/profile-picture.jpg'), // Replace with actual image URL
                      ),
                    ),

                    // Name
                    Text(
                      'Jacob Jones',
                      style: TextStyle(
                          fontSize: 22,
                          color: Color(0XFFB2B2B2),
                          fontWeight: FontWeight.bold),
                    ),

                    SizedBox(height: 16),

                    // Weight, Age, Height in rounded corner boxes
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInfoCard('Weight', '56 kg'),
                        _buildInfoCard('Age', '23 Year'),
                        _buildInfoCard('Height', '164 cm'),
                      ],
                    ),

                    SizedBox(height: 20),

                    // Add spacing before the menu options
                    SizedBox(height: 16),
                    // Add space between the info cards and menu options

                    // Menu Options
                    _buildMenuOption('Manage Account',
                        imageUrl:
                            'https://s3-alpha-sig.figma.com/img/27a7/8251/47767f09ea813a7e6432862d64d01a48?Expires=1731283200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=M2nLA7tK~xdu7S3RgmrvuVZXlMpmqREShWyHsyFWAHC1~4AaXA19GV6XVCZVL9NhDtJKL3qTguhPk00wxZtWdUglgmGIsrH44hsDvjHY-qRKA7THVK4q~-tI7DBoEDknmfbTAzTMTehblbawSxOlAXf2pf1UpEI-aW8Nk7afN3NFsYCbBTNzrGRUWvyTsbbY31lMovlmVqtEWkPf6sogKAZTz0vYYA7uE4sUaVyaquIIlpiXcx2CMVTHRpe1q7DNuDjXHGcltNpuzOdeUwp2qxQB1919j6FZtNty00rehZng9ZeoQyJTgSI2WUGy~OfKksc9Gtezjb0lhDWjQulMdA__'),

                    _buildMenuOption('Goal Setting',
                        imageUrl:
                            'https://s3-alpha-sig.figma.com/img/91a7/6aaa/2a085f2c303b8d2d6a6b5605f976d2a4?Expires=1731283200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Tq-Ij3veOUuGnSm1Q0LEarXmsw67U8Ger53XzsQ287jLo~js6gRTGgIxFW~aLh4Oyb4oOGAzrEWtYsi59wV-CyBJ0QoDaYBZRA1IC-mwPm7rAVYAdMXHg0QiDx26P-B5mRVUTUzdqu0ir54j93tTQ2u4WFfyMsFWhv8IZIoUTrvNdKDjaMXoD3DY3BNiwtbQrjwDG8msCcFnGBrjGfIvQiEzd57DRAhyu8sKguOG6RxmsDefxdQHO7VL4YZN7IuxZ3-7XRiSm-eduyWyOCWwAmxj4-lHf6hWnJD3Fsnfk5srcmNL~msK4B3G7TYGM-1Yio2xkQJljIO6S4afe9DPUQ__'),
                    _buildMenuOption('Active Recipe',
                        imageUrl:
                            'https://s3-alpha-sig.figma.com/img/94d5/cdc2/20998cd9dc945c2a72ab5a3d8591c030?Expires=1731283200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=gAa1TojpjY4Fuvq8YUcm6nFTp5xathZHSYxcAoTAMgX~RCN4Eb6Wz8XC8ynbazIqXSNQUFbRih0WNOMEZtnq9g-ReOevXSWz4RiDT8LI~E0MmELRCJ3OdLcInhcIwt6ouoiciLF2J1wq08L8FnhFh3gwXOhzqK75p1WejXk5PZwBf~DBHDnrbsETaatKgqX6iAxG3ymvykM42GJNf~NlokkywkISEoaG7iKs5HyyYtIs1pRq3uv7DrVx5Pm8FPoxG555RszhUytIHh8K39XxsggXnV3H4FngdaYq9~lUBlektacrQH1FywudPArUwqMQufyNaioKqiOpH-b6eMC5xw__'),
                    _buildMenuOption('Linked Accounts',
                        imageUrl:
                            'https://s3-alpha-sig.figma.com/img/f74c/564c/d2f38b04e5aef386ee70fad5e4309e8d?Expires=1731283200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=D1jDxUhUFxYgqFM8-FHTN9pYaQKC2M~zf8RdwHldbaT5W9EK5YhBns8Mj6FkxocXx84CBuw~gIpLjhqa~L-G4RWbecgjxbixY9v286ULG96wiOFYfMO~I72bTDRpd0bAZWlXr0KT6kJlmRz~y9UEXWyXoCw7EDkv2fXWlDOSTJswi7xeB8manrsRD6Ab2p2rRFY6mWDzhPdKgT64PeW3BZKAbZnSMznaNuAFvXzyOLCc5ekkhewW4KJvBgsCy5ziE9v7HUVykTuOkXxfNN2BkW4uV0jH2nlROeboX9Jf958nbCWyPkkJd9AQvjyzy2LUlS-FN2f-cf~1X6QZdEH29w__'),
                    _buildMenuOption('Help & Support',
                        imageUrl:
                            'https://s3-alpha-sig.figma.com/img/faec/13ab/b0b0470db066027c23b1363cf8c279f4?Expires=1731283200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=IuCggQ8OsK1C6amobo6Za5eOO4kT42QF2LqDSwbg-Tx0kiGLmIRWng3yswy8f7ZVtGw20p-6yPvKbLwZlMYiHn~seITkHQOQk1xbie49wNnaK1NvwLwfzE3Ym-922aJGC3qYSMLn1XlcGG6zjXkvDGntUvEDaCsurux878V7mfTWzLJbbEX4p65cX8QOrVJ9Eg7EstFC51oxJy5RF327Gf-D19P-ArZ9UVlZ4VYyxdoNZw5e8dUIvGypl7FzbPCw6rjJTAPbgXKoZxLjLoAFWxtzSvskfq3zHkffJ1V55XAxeysekU6Anuuz7oZvQzOG1lbiq5eatJCTgIYruHDdvg__'),
                    _buildMenuOption('Settings',
                        imageUrl:
                            'https://s3-alpha-sig.figma.com/img/79c8/eb16/d4ba0866f19f186f0f65be7d8fe01431?Expires=1731283200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=bTptPAQ29iInyyJvhfA-t8MW~6yeqDd03T7gVM0azodC6BB8lwqpqvM61BgG40obFhdbHRBNwmpYOwTx0fPvcHH2PDsmsSuBF1QSvjh2HiznymGcnqhhKZYxh0X78VHMNoQUjPKVDWGaMtLPmZZaozKDaNw0SGAdhqTHgRuaxUiNb1Vg4BPHhje1N8HK19MJX99OXgLFwO3b6z3-gT-v1sXiOiq1reAdxn778RWYzTryJz-pnYIoMyJIOhNk1-DJB74GN2o4M2fsa4BYCpjnuzYQVw4H5lGj8fHzy0tphC75dK6rIPZDBPF734RsxP-t1iaIUjShkU-dwFr~IrrXHw__'),
                  ],
                ),
              ),
            ),
            // Bottom Navigation Bar
            // BottomNavigationBar(
            //   backgroundColor: Color(0xFF000000),
            //   // selectedItemColor: Colors.yellowAccent,
            //   // unselectedItemColor: Colors.grey,
            //   items: [
            //     BottomNavigationBarItem(
            //         icon: Image.network(
            //           'https://s3-alpha-sig.figma.com/img/e129/9c25/bc9c96a9703080238d725fff296b72f5?Expires=1730073600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=WmjjvONqrLsGq9XmX~-~TiE8u-9dal17xnz1IbQa4njJqUa3dOe7hUuXe~Cx4PNCbfXygUzE-4GR7OcetCYiDMBziyGxrvq-9ZxXEkDQUGPms0GaJbTyPhyFmczkQs-hLuC5d1h1876CAbnQSG2~wxLNKz1veUNgY5IhJKqhsE3~-8snJTBGONF9ZYa4gxqpFQDe6cE0mnVkEFQ8v8zmXhstlv1EZEl0oxC6sGayghlJcdc9Owc4RftGHaucsuyF30RqYGPpyCoRZUOaS4mBJOfdZC~MkFzNqSboBs9-DTgWZz7hokeZcp5w36cBfUdxKiMyoaFoknjD-rErA3eKcQ__',
            //           width: 24,
            //           height: 24,
            //         ),
            //         label: 'Home'),
            //     BottomNavigationBarItem(
            //         icon: Image.network(
            //           'https://s3-alpha-sig.figma.com/img/81cd/dd6a/47f3d11c6ff09c1bc2243df7241917fc?Expires=1730073600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=PFzsmKlnsLYcS-L-YPLPu6Mn5eI0iOaDpPHrcrv6UgkZ1jX5EyhWWA93QjXMvxQz3l8QMEubRg6I7ro0oB2BBQjzNgRJkTcECIQN7qgnMW0J-kl-YcDHkiKhmMIn3imIxbjSztHl2GEoukKDI1RZ4njMuhsBFzrxs6eYBweYjzchbVk7GFQpjEOb~rnn3riM8q1k-h6b7yh3Qm7EaXa7Q7CUNm1gio6tdpxm7QRc5CeNdeUbc8ipqJwZ02Wbpqpcb3KD6oN6onv4zwndUKWPv5bhc3ChG7tWyQBQKKV6KtwvbhjhYI6ZWDziDoY~e6FIaWvZWUWGJRc7t35YIurZEQ__',
            //           width: 24,
            //           height: 24,
            //         ),
            //         label: 'Tracking'),
            //     BottomNavigationBarItem(
            //         icon: Image.network(
            //           'https://s3-alpha-sig.figma.com/img/488b/3420/c875cc7ca45f0c4be8cf9ed61fc0fce6?Expires=1730073600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=iJp27Q~x39MM5cW-ExV9BIOKFA1pe2f-n4WjfmMxuToT79r0S~5T9iYfWvBztyuT0HBV-lbgZTmX5hdFxuzpm4Hlbp~75GuuwUUxXNgFG-JXKYLeFXfkWfcWKs8FvK-W0lQVHiN3HvGUi-rZY7-7ptNRdoYso447jNTCdzzPiU1fbl3pRBGWuJRz2vpZJAk-lhJhvaE7d4Wnb5hbJTb4fhKE3TgOqAoZ1rpNO1v~Nxn6~uEWKMZcGLxSqwUjMk8oujTFz5KP3JlwPfbBLdpiG60YelWSDWcTml~W9hf5CC5-u3zTxXlxa-wGGBfJwSEyOD-R22NJxCN-ePTUOPpRIQ__',
            //           width: 24,
            //           height: 24,
            //         ),
            //         label: 'Recipe'),
            //     BottomNavigationBarItem(
            //       icon: Image.network(
            //         'https://s3-alpha-sig.figma.com/img/152e/9d9e/5e47de3dd969bd8e83ea56ba7122ecf0?Expires=1730073600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=OIN-gny7VqppF7rjaVghXfUxt3F~TKPbbgo5LaCoQ2Y9MN0lu9sW5I9~vbuy4bckw4SagdSe-uCWrhUZg5ASDM5INCDhvmJ6EyodFMbXP0yp7czQPg2dQfeYrbBOuzz98v-NhmJyI2yEUUTjPOvfWgGwg-Rp5Jr3VSrjry6iISvUhPVNnU7wQWGFEdP5O178MDyx2-R9w3sHHWgWE2royHnk1it2ZWN23qSmkJOE2gSHL1i6DH3U6LvHQdjpfmySCqcFtC-6N6-V1wlJfuaDqZhmTN388SS4pvsGTUhNvkz~86YH-YEnOWPN5EdKeRDEcmIfkKsUbvauUwYk5HAg~w__',
            //         width: 24,
            //         height: 24,
            //       ),
            //       label: 'Profile',
            //     ),
            //   ],
            // ),
            CustomButton(
                child: Text("Create group"),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CreateGroup();
                      });
                },
                size: ButtonSize.medium,
                type: ButtonType.elevated

            )
          ],
        ),
      ),
    );
  }

  // Info card widget with rounded corners
  Widget _buildInfoCard(String title, String value) {
    return Container(
      width: 140,
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[850], // Background color
        borderRadius: BorderRadius.circular(5), // Rounded corners
      ),
      child: Column(
        children: [
          // Title first
          Text(title, style: TextStyle(color: Color(0XFF848484))),
          // Display title first
          SizedBox(height: 8),
          // Space between title and value
          // Value second
          Text(value,
              style: TextStyle(
                  color: Color(0XFF9DAB5A),
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          // Increased size for value
        ],
      ),
    );
  }

  // Menu option widget
  Widget _buildMenuOption(String title, {String? imageUrl}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        color: Colors.grey[850],
        child: Container(
          color: Color(0XFF00000000),
          height: 62, // Adjust height as needed
          child: Center(
            // Center the content vertically
            child: ListTile(
              leading: imageUrl != null
                  ? Image.network(imageUrl,
                      width: 30, height: 26) // Adjust size if needed
                  : null,
              title: Text(
                title,
                style: TextStyle(
                  color: Color(0XFFBABABA),
                  fontSize: 18, // Increase the font size here
                ),
              ),
              onTap: () {},
            ),
          ),
        ),
      ),
    );
  }
}

class CreateGroup extends StatefulWidget {
  const CreateGroup({
    super.key,
  });

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {

  var groupName = TextEditingController();
  var description = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> submitUser() async {
    try {
      if (key.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        Map<String, dynamic> data = {
          "group_name": groupName.text.trim(),
          "description": description.text.trim(),
        };
        print(data);

        await APIMethods.post
            .post(url: APIEndpoints.group.createGroup, map: data)
            .then((value) {
          if (APIStatus.success(value.statusCode)) {
            // clearDetails();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Create Group Successful!'),
                backgroundColor: Colors.green,
              ),
            );
            Get.back();
          } else {
            // printError("Auth Controller", "Signup", value.data);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Group is not created.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        });
      }
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
    return Dialog(
      child: Container(
        height: 400,
        padding: EdgeInsets.all(10),
        child: Form(
          key: key,
          child: Column(
            children: [
              SizedBox(height: 30,),
              TextFormField(
                controller: groupName,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0XFF242522),
                  hintText: 'Enter your Group Name',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  // Custom Border Properties
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 30,),
              TextFormField(
                controller: description,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0XFF242522),
                  hintText: 'Enter your Description',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  // Custom Border Properties
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 60,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 18),
                      child: ElevatedButton(
                        onPressed: () => submitUser(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0XFFCDE26D),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : const Text(
                                'Create Group',
                                style:
                                    TextStyle(color: Color(0XFF242522), fontSize: 18),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
