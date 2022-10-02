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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kite/component/my_switcher.dart';
import 'package:kite/component/webview.dart';
import 'package:kite/component/webview_page.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/storage/init.dart';
import 'package:kite/util/alert_dialog.dart';
import 'package:kite/util/dsl.dart';
import 'package:kite/util/rule.dart';

const _reportUrlPrefix = 'http://xgfy.sit.edu.cn/h5/#/';
const _reportUrlIndex = '${_reportUrlPrefix}pages/index/index';

class ReminderDialog extends StatefulWidget {
  const ReminderDialog({Key? key}) : super(key: key);

  @override
  State<ReminderDialog> createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<ReminderDialog> {
  final ValueNotifier<TimeOfDay?> _notifier =
      ValueNotifier(Kv.report.time == null ? null : TimeOfDay.fromDateTime(Kv.report.time!));

  @override
  Widget build(BuildContext context) {
    final reportTime = Kv.report.time;
    if (reportTime != null) {
      _notifier.value = TimeOfDay(hour: reportTime.hour, minute: reportTime.minute);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        i18n.reportTempReminderDesc.txt,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            i18n.reportTempReminderSwitch.txt,
            MySwitcher(
              Kv.report.enable ?? false,
              onChanged: (value) {
                Kv.report.enable = value;
                setState(() {}); // Notify UI update
              },
            ),
          ],
        ),
        if (Kv.report.enable ?? false)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              i18n.reportTempRemindTime.txt,
              TextButton(
                onPressed: () async {
                  final selectTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(reportTime ?? DateTime.now()),
                  );
                  if (selectTime == null) return;
                  _notifier.value = selectTime;
                  Kv.report.time = DateTime(0, 0, 0, selectTime.hour, selectTime.minute);
                },
                child: ValueListenableBuilder<TimeOfDay?>(
                  valueListenable: _notifier,
                  builder: (context, data, widget) {
                    if (data == null) {
                      return const TimeOfDay(hour: 0, minute: 0).format(context).txt;
                    }
                    return data.format(context).txt;
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
