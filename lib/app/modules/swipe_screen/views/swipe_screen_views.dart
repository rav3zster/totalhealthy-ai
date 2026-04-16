import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/swipe_screen_controllers.dart';

class SwipeScreenView extends GetView<SwipeScreenController> {
  const SwipeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          // Upper half - background image
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    'https://s3-alpha-sig.figma.com/img/54a6/b69f/d884001c5891fba41e86429bf259274d?Expires=1730073600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=eBA~XMLK~27lvrMu2M0sj~79JFpd4jDHZKHWsjocUj47yR4-I01MGPc1oZ3k1m-Wcb0AejLb93glCll-vfkZxreeOD0r9VUDAiipnnhyJjb0YYOjfv0~bgytHxBeVpVoZ78uTU6BCyomWvArVXJAplUx--BFnf0vrW3BvR7ee~w7zVgzR3mrlwPU~JJEFmBF4png82IRdNRTLnvrpO~o8POvqBABDnDDf9HOYGcHKA37eyDB-mGhci2I8FSMcPALhO16x5i~AVDCbaALrfcI5JFncQ52iG7wPHIn1iseqcMPSrdC7d3Sr4OlAucWwecC3jeme3SATkeRK72s5p2B5A__',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 650),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 3),
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        SizedBox(height: 20), // Space for the avatar to overlap
                        Text(
                          'Boost Your Fitness \nAdventure',
                          style: TextStyle(
                            color: Color(0XFFDBDBD8),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'LeanLush is your ultimate companion on \n your journey to a healthier lifestyle.',
                          style: TextStyle(
                            color: Color(0XFF878884),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                              color: Color(0XFF3B3C38),
                              borderRadius: BorderRadius.circular(40)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Handle swipe confirmation
                                },
                                child: Image.network(
                                  'https://s3-alpha-sig.figma.com/img/9048/599a/782ef6bf047ccaaab848e212c973c08a?Expires=1730073600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=GNCU~52OJSmQ7tiRu5xGU8C9~AOt9p34EFGhyWgtO73C42x7-VgHPtK8ajB6uVya6HVfMHuNBxPVLMDxTFlIiT2g8wcY6EE2VmJc-4Wu9DMJTpil7siRY4xg3JQjbTqybjl-atNyRHnDhABsyp~uWyZBGQn5rDMb-YeuqPcN6KcGnKK81X8j874THLvlYF0iTyaknHdyfEMMVdxSoNTyJej7-Q7d6gBdqqFBNQG0xq5sZJl8f5gOyLFLfFJC5FgNFa9Z8EBKYTeJ71Vz4VnJ4DmnETPBtbgHGAWGZo84DqeuCKG9n5FSfXKZ3UgH8xHMxOd3uu7P7FbnCtApcqVwaA__',
                                  width: 50, // Set the size of the image
                                ),
                              ),
                              Text(
                                "Swipe to Explore",
                                style: TextStyle(color: Color(0XFFB2B2AF)),
                              ),
                              // Replace check circle button with image
                              GestureDetector(
                                onTap: () {
                                  // Handle swipe confirmation
                                },
                                child: Image.network(
                                  'https://s3-alpha-sig.figma.com/img/306f/ba42/e458c866579a7b98abb799e7a1b5143a?Expires=1730073600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=OOa8XMlIwOeYw4pQNnoQBLqJvFwmh8tDxqtFMQqelqwqnxFukHGhetqfjdr4f-~mRXz12MnsWEMmbaLr7j4mHv5mXIH5BnR4uMfs89HZPztGTl0gc2JC~WcEmnpyQnwQ7tk86EtWQdmf-RTSgqhFWdWLdrmHwqcXBAMj0qrf1BIm0WJkGcqjGqrISGevSPEfFgF17acpB90qVOeUNIlOj5VVSlyyL2NmwQJ8ar3dVJ-ZL4Sq87yTksTpNp3D-frsrYYtN51iBYeWcOG2yPusDsysuqz2qg1YNiSsQfsmdvaBNfSGFSelGJtDcaAhd-A8w9Y-rAaUwNCAgrQ5nWzQvQ__',
                                  width: 50, // Set the size of the image
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Positioned CircleAvatar
                Positioned(
                  top: 610, // Move avatar upwards
                  left: 0,
                  right: 0,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://s3-alpha-sig.figma.com/img/2c93/37b4/92899d16033c9d13161f2ec453ccda8a?Expires=1730073600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=cERUbOrCbeScbWvkgmYuM9wn2Q8uPSh3tG8wQAy5D1U4URy13l5kztLfsMex9zTDFtMZ7RtQ6A5UEGZZLMkcZxrfT57gpf2Wo10n~f9HIrSG6ZS3wDXzfsxSLQQPwARMzqHKCqFyzwaws70bygAW1dKQfKBhmGDaIGGWZg4kE4WWoFz~XvTNpp1b9SCCnzSGenb23gmCocbOjqJonHi3Ts8H1LBmtqAxI9UH93KIW2pMBv9xHaeIh0wQ9N-j51SC7Xq6c5Zy9OciZ-0c0-06a4sWoBqnNoCwhRyM4n-wGoxcKtx-wwZz8AKVkZPoi78u6g9N5T5l6AayzhFgUXWSwA__',
                        ),
                        fit: BoxFit
                            .cover, // Ensures image covers the circle without zooming
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 100,bottom: 820),
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.sizeOf(context).width,
                      child: Row(
                                    children: [
                  Text("Home",style: TextStyle(
                    color: Color(0XFFDFE0DF),fontSize: 40,fontWeight: FontWeight.bold
                  ),),
                  Text(
                    "Healthy",
                    style: TextStyle(color: Color(0XFFA0B057),fontSize: 40,fontWeight: FontWeight.bold),
                  ),
                                    ],
                                  )),
                )
              ],
            ),
          ),
          // Lower half - text container with avatar
        ],
      ),
    );
  }
}
