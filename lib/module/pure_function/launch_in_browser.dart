import 'package:flutter/material.dart';
import 'package:kite/util/url_launcher.dart';

class LaunchInBrowserFunction extends StatelessWidget {
  final String url;
  const LaunchInBrowserFunction(this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    launchUrlInBrowser(url);
    Navigator.of(context).pop();
    return Container();
  }
}
