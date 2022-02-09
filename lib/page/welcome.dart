/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'login.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                Text('上应小风筝', style: Theme.of(context).textTheme.headline2?.copyWith(color: Colors.white)),
                // Subtitle
                Text('便利校园，一步到位', style: Theme.of(context).textTheme.headline3?.copyWith(color: Colors.white)),
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
                  child: Text('登录', style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
