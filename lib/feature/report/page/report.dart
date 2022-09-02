/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kite/component/my_switcher.dart';
import 'package:kite/component/webview.dart';
import 'package:kite/component/webview_page.dart';
import 'package:kite/storage/init.dart';
import 'package:kite/util/alert_dialog.dart';
import 'package:kite/util/rule.dart';

const _reportUrlPrefix = 'http://xgfy.sit.edu.cn/h5/#/';
const _reportUrlIndex = '${_reportUrlPrefix}pages/index/index';

class ReminderDialog extends StatelessWidget {
  ReminderDialog({Key? key}) : super(key: key);
  final ValueNotifier<TimeOfDay?> _notifier = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    final reportTime = KvStorageInitializer.report.time;
    if (reportTime != null) {
      _notifier.value = TimeOfDay(hour: reportTime.hour, minute: reportTime.minute);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('打开小风筝时自动检测上报情况并提醒'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('启用'),
            MySwitcher(
              KvStorageInitializer.report.enable ?? false,
              onChanged: (value) => KvStorageInitializer.report.enable = value,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('提醒时间'),
            TextButton(
              onPressed: () async {
                final selectTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(reportTime ?? DateTime.now()),
                );
                if (selectTime == null) return;
                _notifier.value = selectTime;
                KvStorageInitializer.report.time = DateTime(0, 0, 0, selectTime.hour, selectTime.minute);
              },
              child: ValueListenableBuilder(
                valueListenable: _notifier,
                builder: (context, data, widget) {
                  if (reportTime == null) {
                    return const Text('未选择');
                  }
                  final t = _notifier.value!;
                  final hh = t.hour;
                  final mm = t.minute;
                  return Text('$hh:$mm');
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}

class DailyReportPage extends StatelessWidget {
  const DailyReportPage({Key? key}) : super(key: key);

  static Future<String> _getInjectJs() async {
    // TODO: 把 replace 完的 JS 缓存了
    final String username = KvStorageInitializer.auth.currentUsername ?? '';
    final String css = await rootBundle.loadString('assets/report/inject.css');
    final String js = await rootBundle.loadString('assets/report/inject.js');
    return js.replaceFirst('{{username}}', username).replaceFirst('{{injectCSS}}', css);
  }

  @override
  Widget build(BuildContext context) {
    return SimpleWebViewPage(
      initialUrl: _reportUrlIndex,
      fixedTitle: '体温上报',
      otherActions: [
        IconButton(
          onPressed: () {
            showAlertDialog(
              context,
              title: '每日上报提醒',
              content: SingleChildScrollView(
                child: ReminderDialog(),
              ),
              actionTextList: ['关闭窗口'],
            );
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
