import 'package:flutter/material.dart';
import 'package:kite/component/unsupported_platform_launch.dart';
import 'package:kite/util/url_launcher.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:webview_flutter/webview_flutter.dart';

const String _feedbackUrl = 'https://support.qq.com/product/377648';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('反馈'),
        actions: [
          IconButton(onPressed: () => launchInBrowser(_feedbackUrl), icon: const Icon(Icons.open_in_browser)),
        ],
      ),
      body: UniversalPlatform.isDesktopOrWeb
          ? const UnsupportedPlatformUrlLauncher(_feedbackUrl)
          : const WebView(initialUrl: _feedbackUrl),
    );
  }
}
