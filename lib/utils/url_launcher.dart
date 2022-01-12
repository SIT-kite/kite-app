import 'package:url_launcher/url_launcher.dart';

Future<void> launchInBrowser(String url) async {
  if (!await launch(
    url,
    forceSafariVC: false,
    forceWebView: false,
  )) {
    throw 'Could not launch $url';
  }
}
