import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kite/component/future_builder.dart';
import 'package:kite/component/multibutton_switch.dart';
import 'package:kite/feature/library/appointment/init.dart';
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

class AppointmentPage extends StatelessWidget {
  final ValueNotifier<DateTime> date = ValueNotifier(DateTime.now());
  final service = LibraryAppointmentInitializer.appointmentService;

  AppointmentPage({Key? key}) : super(key: key);

  Widget buildSelectList(List<PeriodStatusRecord> records) {
    return ListView(
      children: records.map((e) {
        final a = {1: '上午', 2: '下午'}[e.period % 10]!;
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
                SizedBox(
                  height: 30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LinearProgressIndicator(
                        value: e.applied / e.count,
                        backgroundColor: Colors.grey,
                        minHeight: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all()),
              child: const Text('预约'),
            ),
            onTap: () async {
              await service.apply(e.period);
            },
          ),
          const Divider(),
        ]);
      }).toList(),
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
              if (await signUpIfNecessary(context, '查询预约记录')) {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HistoryPage()));
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TodayTomorrowSwitch(
              onSwitchToday: () {
                date.value = DateTime.now();
              },
              onSwitchTomorrow: () {
                date.value = DateTime.now().add(const Duration(days: 1));
              },
            ),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: date,
                builder: (BuildContext context, DateTime value, Widget? child) {
                  return MyFutureBuilder<List<PeriodStatusRecord>>(
                    future: service.getPeriodStatus(value),
                    builder: (context, List<PeriodStatusRecord> records) => buildSelectList(records),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
