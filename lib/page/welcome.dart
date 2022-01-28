import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'login.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.normal);

    return Scaffold(
      body: Stack(
        children: [
          // Background image.
          SizedBox(
              width: 1.sw,
              height: 1.sh,
              child: const Image(image: AssetImage("assets/welcome/background.jpg"), fit: BoxFit.cover)),
          // Transparent layer.
          Container(color: Colors.black.withOpacity(0.35)),
          // Front weights. Texts and buttons are on the left bottom of the screen.
          Container(
            width: 1.sw,
            height: 1.sh,
            alignment: Alignment.bottomLeft,
            // 150 px from the bottom edge and 20 px from the left edge.
            padding: EdgeInsets.fromLTRB(40.w, 20.h, 0, 150.h),
            child: Column(
              // If MainAxisSize.min is ignored, the height of the Container will be full.
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text('上应小风筝', style: textStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 35.sp)),
                // Subtitle
                Text('便利校园，一步到位', style: textStyle.copyWith(fontSize: 25.sp)),
                // Space
                SizedBox(height: 40.h),
                // Login button
                OutlinedButton(
                    autofocus: true,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      side: BorderSide(width: 1.sm, color: Colors.white),
                    ),
                    child: Text('登录', style: textStyle.copyWith(fontSize: 20.sp)),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
                    }),
                // Text button
                TextButton(
                    style: TextButton.styleFrom(padding: const EdgeInsets.fromLTRB(0, 10, 0, 0)),
                    child: const Text('我们为什么转做 APP', style: textStyle),
                    onPressed: () {})
              ],
            ),
          )
        ],
      ),
    );
  }
}
