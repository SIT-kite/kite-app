import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UnsupportedPlatformUrlLauncher extends StatelessWidget {
  final String url;
  const UnsupportedPlatformUrlLauncher(this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('电脑端暂不支持直接查看'),
          TextButton(
              onPressed: () {
                launch(url);
              },
              child: const Text('点击在弹出浏览器中打开')),
        ],
      ),
    );
  }
}
