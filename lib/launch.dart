import 'package:catcher/catcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:kite/route.dart';
import 'package:kite/util/alert_dialog.dart';
import 'package:kite/util/launcher.dart';
import 'package:kite/util/logger.dart';
import 'package:kite/util/rule.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';

import 'feature/sit_app/arrive_code/dialog.dart';

class GlobalLauncher {
  static get _context => Catcher.navigatorKey!.currentContext!;
  static final _schemeLauncher = SchemeLauncher(
    schemes: [
      LaunchScheme(
        launchRule: FunctionalRule((scheme) => scheme.startsWith('http')),
        onLaunch: (scheme) async {
          if (!UniversalPlatform.isDesktopOrWeb) {
            Log.info('启动浏览器');
            Navigator.of(_context).pushNamed(
              RouteTable.browser,
              arguments: {'initialUrl': scheme},
            );
            return true;
          } else {
            final uri = Uri.tryParse(scheme);
            if (uri == null) return false;
            return await launchUrl(uri);
          }
        },
      ),
      LaunchScheme(
        launchRule: FunctionalRule((s) => s.startsWith('QY')),
        onLaunch: (scheme) async {
          Log.info('启动场所码');
          ArriveCodeDialog.scan(_context, scheme.substring(2));
          return true;
        },
      ),
      LaunchScheme(
        // 其他协议，就调用launchUrl启动某个本地app
        launchRule: FunctionalRule((s) => s.contains(':')),
        onLaunch: (scheme) async {
          final uri = Uri.tryParse(scheme);
          if (uri == null) return false;
          return await launchUrl(uri);
        },
      )
    ],
    onNotFound: (scheme) async {
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
      return true;
    },
  );

  static Future<bool> launch(String schemeText) {
    return _schemeLauncher.launch(schemeText);
  }

  static Future<bool> launchTel(String tel) => launch('tel://$tel');

  static Future<bool> launchQqContact(String qq) =>
      launch('mqqapi://card/show_pslcard?src_type=internal&version=1&uin=$qq');
}
