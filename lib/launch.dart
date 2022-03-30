import 'package:flutter/cupertino.dart';
import 'package:kite/route.dart';
import 'package:kite/util/alert_dialog.dart';
import 'package:kite/util/launcher.dart';
import 'package:kite/util/logger.dart';
import 'package:kite/util/rule.dart';
import 'package:kite/util/url_launcher.dart';
import 'package:universal_platform/universal_platform.dart';

class GlobalLauncher {
  static late BuildContext _context;
  static final _schemeLauncher = SchemeLauncher(
    schemes: [
      LaunchScheme(
        launchRule: FunctionalRule((scheme) => scheme.startsWith('http')),
        onLaunch: (scheme) {
          if (!UniversalPlatform.isDesktopOrWeb) {
            Log.info('启动浏览器');
            Navigator.of(_context).pushNamed(
              RouteTable.browser,
              arguments: {'initialUrl': scheme},
            );
          } else {
            launchUrlInBuiltinWebView(_context, scheme);
          }
        },
      ),
      LaunchScheme(
        launchRule: FunctionalRule((s) => s.startsWith('QY')),
        onLaunch: (scheme) {
          Log.info('启动场所码');
        },
      ),
      LaunchScheme(
        launchRule: FunctionalRule((s) => s.contains(':')),
        onLaunch: (scheme) {
          launchUrl(scheme);
        },
      )
    ],
    onNotFound: (scheme) {
      showAlertDialog(
        _context,
        title: '无法识别',
        content: [
          Text(
            '无法识别的内容: \n'
            '$scheme',
          ),
        ],
        actionTextList: ['我知道了'],
      );
    },
  );

  static void launch(String schemeText) {
    _schemeLauncher.launch(schemeText);
  }

  static void init(BuildContext context) {
    GlobalLauncher._context = context;
  }
}
