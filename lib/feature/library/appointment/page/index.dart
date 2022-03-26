import 'package:flutter/material.dart';
import 'package:kite/component/future_builder.dart';
import 'package:kite/component/multibutton_switch.dart';
import 'package:kite/feature/library/appointment/init.dart';
import 'package:kite/util/alert_dialog.dart';
import 'package:kite/util/kite_authorization.dart';

import '../entity.dart';
import 'history.dart';

class TodayTomorrowSwitch extends StatelessWidget {
  final VoidCallback onSwitchToday;
  final VoidCallback onSwitchTomorrow;

  static const _weekText = '一二三四五六日';

  const TodayTomorrowSwitch({
    Key? key,
    required this.onSwitchToday,
    required this.onSwitchTomorrow,
  }) : super(key: key);

  Widget buildTodayWidget() {
    final DateTime today = DateTime.now();
    final todayWeekText = '周' + _weekText.substring(today.weekday - 1, today.weekday);
    final todayDateText = '${today.month}-${today.day}';
    return Text(
      "今天\n"
      "$todayWeekText（$todayDateText）",
      textAlign: TextAlign.center,
    );
  }

  Widget buildTomorrowWidget() {
    final DateTime today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final tomorrowWeekText = '周' + _weekText.substring(tomorrow.weekday - 1, tomorrow.weekday);
    final tomorrowDateText = '${tomorrow.month}-${tomorrow.day}';
    return Text(
      "明天\n"
      "$tomorrowWeekText（$tomorrowDateText）",
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiButtonSwitch(
      children: [
        Container(
          child: buildTodayWidget(),
          margin: const EdgeInsets.symmetric(vertical: 10),
        ),
        Container(
          child: buildTomorrowWidget(),
          margin: const EdgeInsets.symmetric(vertical: 10),
        ),
      ],
      onSwitch: (i) {
        [onSwitchToday, onSwitchTomorrow][i]();
      },
    );
  }
}

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final ValueNotifier<DateTime> date = ValueNotifier(DateTime.now());

  final service = LibraryAppointmentInitializer.appointmentService;

  Future<void> showAppointPeriodDialog(PeriodStatusRecord e) async {
    final applyDialogResult = await showAlertDialog(
      context,
      title: '是否要预约本场',
      content: [
        Text(
          '场次编号: ${e.period}\n'
          '已预约人数: ${e.applied}\n'
          '预计开放座位: ${e.count}\n'
          '开放时间段: ${e.text}\n'
          '注意: 预约成功请在预约时段内打卡,\n'
          '否则后果自负',
        ),
      ],
      actionWidgetList: [
        ElevatedButton(
          onPressed: () {},
          child: const Text('确定预约'),
        ),
        const SizedBox(
          width: 10,
        ),
        TextButton(
          onPressed: () {},
          child: const Text('取消预约'),
        ),
      ],
    );
    // 确定预约
    if (applyDialogResult == 0) {
      if (!await signUpIfNecessary(context, '预约图书馆')) return;
      await service.apply(e.period);
      await showAlertDialog(
        context,
        title: '预约成功',
        actionTextList: ['关闭'],
      );
      setState(() {});
    }
  }

  Widget buildSelectList(List<PeriodStatusRecord> periodStatusList) {
    return ListView(
      children: periodStatusList.map((e) {
        final a = {1: '上午', 2: '下午', 3: '晚上'}[e.period % 10]!;
        Widget buildTrailingWidget() {
          Widget buildTextWithBorder(String text) {
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all()),
              child: Text(text),
            );
          }

          return buildTextWithBorder('预约');
        }

        return Column(children: [
          ListTile(
            isThreeLine: true,
            title: Text('$a (${e.text})'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '已预约(${e.applied}) / 预计总人数(${e.count})',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: e.applied / e.count,
                  backgroundColor: Colors.grey,
                  minHeight: 5,
                ),
              ],
            ),
            trailing: buildTrailingWidget(),
            onTap: () async {
              await showAppointPeriodDialog(e);
            },
          ),
          const Divider(),
        ]);
      }).toList(),
    );
  }

  Widget buildAppointmentListByDate(DateTime date) {
    return MyFutureBuilder<List<PeriodStatusRecord>>(
      future: service.getPeriodStatus(date),
      builder: (context, List<PeriodStatusRecord> periodStatusList) {
        return buildSelectList(periodStatusList);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('预约入馆'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () async {
              if (!await signUpIfNecessary(context, '查询预约记录')) return;
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HistoryPage()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TodayTomorrowSwitch(
              onSwitchToday: () => date.value = DateTime.now(),
              onSwitchTomorrow: () => date.value = DateTime.now().add(const Duration(days: 1)),
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: date,
                builder: (BuildContext context, DateTime value, Widget? child) {
                  return buildAppointmentListByDate(date.value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
