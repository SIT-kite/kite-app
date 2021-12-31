import 'package:flutter/material.dart';

import 'login.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textStyle =
        TextStyle(color: Colors.white, fontWeight: FontWeight.normal);
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        // Background image.
        SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: const Image(
                image: AssetImage("welcome/background.jpg"),
                fit: BoxFit.cover)),
        // Transparent layer.
        Container(color: Colors.black.withOpacity(0.6)),
        // Front weights. Texts and buttons are on the left bottom of the screen.
        Container(
          width: screenWidth,
          height: screenHeight,
          alignment: Alignment.bottomLeft,
          // 150 px from the bottom edge and 20 px from the left edge.
          padding: const EdgeInsets.fromLTRB(40, 20, 0, 150),
          child: Column(
            // If MainAxisSize.min is ignored, the height of the Container will be full.
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text('上应小风筝',
                  style: textStyle.copyWith(
                      fontWeight: FontWeight.bold, fontSize: 30)),
              // Subtitle
              Text('便利校园，一步到位', style: textStyle.copyWith(fontSize: 20)),
              // Space
              const SizedBox(height: 40.0),
              // Login button
              OutlinedButton(
                  autofocus: true,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    side: const BorderSide(width: 1, color: Colors.white),
                  ),
                  child: Text('登录', style: textStyle.copyWith(fontSize: 20)),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  }),
              // Text button
              TextButton(
                  style:
                      TextButton.styleFrom(padding: const EdgeInsets.all(0.0)),
                  child: const Text('我们为什么转做 App', style: textStyle),
                  onPressed: () {})
            ],
          ),
        )
      ],
    )));
  }
}
