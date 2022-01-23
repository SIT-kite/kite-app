import 'package:flutter/material.dart';
import 'package:kite/component/unsupported_platform_launch.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:webview_flutter/webview_flutter.dart';

const String _aboutUrl = 'https://kite.sunnysab.cn/about';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于'),
      ),
      body: UniversalPlatform.isDesktopOrWeb
          ? const UnsupportedPlatformUrlLauncher(_aboutUrl)
          : const WebView(initialUrl: _aboutUrl),
    );
  }
}
