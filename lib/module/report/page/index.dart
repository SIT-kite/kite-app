
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/storage/init.dart';
import 'package:kite/user_widget/webview/page.dart';
import 'package:kite/user_widget/webview/view.dart';
import 'package:kite/util/alert_dialog.dart';
import 'package:kite/util/rule.dart';

import 'reminder.dart';

const _reportUrlPrefix = 'http://xgfy.sit.edu.cn/h5/#/';
const _reportUrlIndex = '${_reportUrlPrefix}pages/index/index';


class DailyReportPage extends StatelessWidget {
  const DailyReportPage({Key? key}) : super(key: key);

  static Future<String> _getInjectJs() async {
    // TODO: 把 replace 完的 JS 缓存了
    final String username = Kv.auth.currentUsername ?? '';
    final String css = await rootBundle.loadString('assets/report/inject.css');
    final String js = await rootBundle.loadString('assets/report/inject.js');
    return js.replaceFirst('{{username}}', username).replaceFirst('{{injectCSS}}', css);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleWebViewPage(
      initialUrl: _reportUrlIndex,
      fixedTitle: i18n.ftype_reportTemp,
      otherActions: [
        IconButton(
          onPressed: () {
            showAlertDialog(context,
                title: i18n.reportTempReminderTitle,
                content: const SingleChildScrollView(
                  child: ReminderDialog(),
                ));
          },
          icon: const Icon(Icons.sms),
        ),
      ],
      injectJsRules: [
        InjectJsRuleItem(
          rule: FunctionalRule((url) => url.startsWith(_reportUrlPrefix)),
          asyncJavascript: _getInjectJs(),
        ),
      ],
    );
  }
}
