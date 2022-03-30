import 'package:flutter/cupertino.dart';
import 'package:kite/util/alert_dialog.dart';
import 'package:kite/util/launcher.dart';
import 'package:kite/util/rule.dart';

class GlobalLauncher {
  static late BuildContext _context;
  static final _schemeLauncher = SchemeLauncher(
    schemes: [
      LaunchScheme(
        launchRule: FunctionalRule((scheme) => scheme.startsWith('http')),
        onLaunch: (scheme) {
          Navigator.of(_context).pushNamed(
            scheme,
            arguments: {
              'initialUrl': scheme,
            },
          );
        },
      ),
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
