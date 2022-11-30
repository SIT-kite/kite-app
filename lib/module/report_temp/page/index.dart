/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../using.dart';

import 'reminder.dart';

const _reportUrlPrefix = 'http://xgfy.sit.edu.cn/h5/#/';
const _reportUrlIndex = '${_reportUrlPrefix}pages/index/index';

class DailyReportPage extends StatelessWidget {
  const DailyReportPage({Key? key}) : super(key: key);

  static Future<String> _getInjectJs() async {
    // TODO: 把 replace 完的 JS 缓存了
    final String username = Kv.auth.currentUsername ?? '';
    final String css = await rootBundle.loadString('assets/report_temp/inject.css');
    final String js = await rootBundle.loadString('assets/report_temp/inject.js');
    return js.replaceFirst('{{username}}', username).replaceFirst('{{injectCSS}}', css);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleWebViewPage(
      initialUrl: _reportUrlIndex,
      fixedTitle: i18n.ftype_reportTemp,
      otherActions: [
        IconButton(
          onPressed: () async {
            // TODO: use BuildContext.showTip dialog
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
