import 'package:flutter/material.dart';

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
              preferredSize: Size.fromHeight(100), // Set desired height here
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
                        'https://s3-alpha-sig.figma.com/img/27a7/8251/47767f09ea813a7e6432862d64d01a48?Expires=1730073600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=YqFbiCvKf4s6ARTE-clMv9lwEppng5dkxjmM0Am42bBMB7P2mscenLw6DXQgMOO91XAchMTZsreBR2lzcUjaQFyKdTZjd8gNszCwjs4XWfztNIjTBZWVfZONO~umyqxZmie9ylhIZ9~DCA8DVaGTwP0LxP-2mRIII5zd~3HTK0UVZafzhwzKusLr~8JnCDR~7mZCY6baoPNpcXRqxpoXYxOZ2hRsfncqTwE1tsVOMRXHmCUQ9Npfh3Wlz50l0iYX29gpXzsrj-YgIeCYv6wNsG2Tb03mZZvZfQcZqDobSPuwtjNtIGzWtVoOE8GKCY73J~Vt9YxHlMBigeu~vu3~KA__'),
                    _buildMenuOption('Goal Setting',
                        imageUrl:
                        'https://s3-alpha-sig.figma.com/img/91a7/6aaa/2a085f2c303b8d2d6a6b5605f976d2a4?Expires=1730073600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=ROLKzWryFk2jOhUv72p4CY9DnAJs1AjyQlFkF9gSOIcMsQIZRb4N1HMobV0jaForZXA3VG81l5dQhySV6KCt5xbkiDdVeX7dHLEv~s-S3ILAGv-EJ~xZMd-03ZW~BD-bAjF6-GpTtEKnPzMTLJ1MyCXdKm110cAM8Jv0on00m-sntu0X1H5b-zrCW0mtfkPSBwtweaS30fSXM7yIp~GKnM1ZJI1cFvj-jniRPiLqsjODUVGUvSPlOOMgv2A13~Oz2jsezkXJ3i0y0i1PGHrl7fcTQ5fCz-v9scTO546eOwqVG0Lpp8hz4UKUXDm75RHi7lIyMJF~NhCXR9DbdtJ6rw__'),
                    _buildMenuOption('Active Recipe',
                        imageUrl:
                        'https://s3-alpha-sig.figma.com/img/94d5/cdc2/20998cd9dc945c2a72ab5a3d8591c030?Expires=1730073600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=P1S1iorlmno-r6NoYNqEweO9WuvfzJ2MbHmQkqjLPvqkO-R7gUej8QQQVe4KmV2WQVTVnOeqtlGJJBEtablan7xZAozEowZ8OMBP~ju8CVu4KFc8wZZBWjd~VUB5V91BvCkpuia7QohRHY80tuLgbN3oOT4iv6UrP8x5tyF7Euns5GBqxX5nL83~5ZqlwJp3zmcrKUvLmChWNeHHo3THqfxg8PZGxZgJ5Jjn14vyNxJvKVu2x7Dh23-2~HgjFJEwXiXw0eFi24XdP~Lnzw2Z1ajq69bRnOgJRb62jvfFEzeQiTTNS275dIeXQ5jswTYGJBPcoMSv~40DV3PRoavz2A__'),
                    _buildMenuOption('Linked Accounts',
                        imageUrl:
                        'https://s3-alpha-sig.figma.com/img/f74c/564c/d2f38b04e5aef386ee70fad5e4309e8d?Expires=1730073600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=T5gCq-hrxLxFUSdKlyaJ8FWJH95TMgHtcli1Jy0hoght6t~efDNUKeqHLYC1Ij5Tc1DvHFVM4PuqD6jXJJoejNiK-aYeTCiLWlJ4aA1NgKLGBEL15GHGek-92jKyxQC4QqXopJP3DhYyhoJFDrsQam36wiyjNAkVmVwCohjGs4JgmfJF66LFUNX9nP07vwLWWZtZ1Gam6dny~sCS6npwSUXLV1X4HvtQ8sUZ2x54ME2jWcYl0O2JdcLSRy42o~7E~Su~i~QQ~zaxHjSIl26ckrCbAKfy-jRRE~Hpjn7p2Z~ZptICnQUBKPPJ923sM4VG7cal7EAVme5SxFwJVeyghg__'),
                    _buildMenuOption('Help & Support',
                        imageUrl:
                        'https://s3-alpha-sig.figma.com/img/faec/13ab/b0b0470db066027c23b1363cf8c279f4?Expires=1730073600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=moLPbKvrFcgcxAmTSxh~gBKG9YUbV~~r4AeUre4QG~mtl5qhMWFdHDXaBme-JrFYOtvqd7gCrCe9vOnWizRw9s1lACfm9SElGxwYUm37QZbY~Jz5Q3x0L4MZPC1RY6BGuIOWR72t6Qk3kkFZ1DyijD1jxxmH-JmIZAejTCNuiSuPInUnc3uDuA2zEjwyA4dr0OasyGcFJ3YRp1Fc4vF5gHie-u1eDS940nuwP4WE8J6~W7XtWaa8tKDi0RvQ0l7QZRY6sbvGQehY9x5KKS~BgjyOe72JTwqGns2sPU4BmXbPA-Ye9813DTmlg-EMu7imQKLeoVnybqjDZrv35gK7ng__'),
                    _buildMenuOption('Settings',
                        imageUrl:
                        'https://s3-alpha-sig.figma.com/img/79c8/eb16/d4ba0866f19f186f0f65be7d8fe01431?Expires=1730073600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=fPqoBu298hRs8uaPiCecURtPOO2dxZFWnDSKuzoTD9REFu1gdcF6y0kHka1XNgs7DKLKjUjhON9-xnyS2UbKrSUSGGng-I0hbKrWF5AxQiyM1kIpRPoovBE0esCN0gH8d520c021qnZ7S33HUCOsObcp-0AgF~90imDEYpzd9qXhSIizMA8JBgmfrg2JezNrxbsaQgJthelCtj5fl0VcPILTz4ryK~oGpa15MPB2bDSqXNUi9zJaJYr2jnHuz1CR0fqTIKZNvvTmOg8HW4qDtnovgLRfGfRPpSyeW3lW1X9tbhNbqYawzoQwz6YWPI6~M3vq1YGhE6bkKXKYz3usnA__'),
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
              trailing: Image.network(
                'https://s3-alpha-sig.figma.com/img/360b/a86c/047c7aca834d409183f630868f9de686?Expires=1730073600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=nFk8STNiBbelTWBstWfu-nq52X1M7fDBbdWpr4KopLd0TZbP-M8rX0r1gUSOrvf~Cp93HL-4t1vD7GTSj-Y3Ai4-svgRele2RcMb1njKMT4PCgFcRrFKMS1nPkp-hYcrGz3QS-BcP4tDhXKrrSj5xk6H~PpTJ9aAMhikNlC~wGzsIwGDqYvJkLOKUwTGE0usnyaUhS7pQki4XTepnuZ0Qcs~RQ91Yl37ye6muxVGOb5Mp5KUVBkLjEEEtVT0gR6TLPhEw-hVCK6VlXKlm7HHTmM-Ew9CI0POHQv~NHDMnRA8cnF~jrv5SVezn2r8q8FrJHnVwUHTT~VKxjXtTz8kvw__',
                width: 28, // Adjust size of the trailing image
                height: 20,
              ),
              onTap: () {},
            ),
          ),
        ),
      ),
    );
  }
}