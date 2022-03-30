import 'package:flutter/cupertino.dart';
import 'package:kite/util/alert_dialog.dart';
import 'package:kite/util/launcher.dart';
import 'package:kite/util/rule.dart';

class GlobalLauncher {
  static late BuildContext context;
  static final schemeLauncher = SchemeLauncher(
    schemes: [
      LaunchScheme(
        launchRule: FunctionalRule((scheme) => scheme.startsWith('http')),
        onLaunch: (scheme) {
          Navigator.of(context).pushNamed(
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
        context,
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

  void launch(String schemeText) {
    schemeLauncher.launch(schemeText);
  }

  void init(BuildContext context) {
    GlobalLauncher.context = context;
  }
}
