import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kite/component/future_builder.dart';
import 'package:kite/component/multibutton_switch.dart';
import 'package:kite/feature/library/appointment/init.dart';

import '../entity.dart';

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
      "$todayWeekText\n"
      "今天($todayDateText)",
      textAlign: TextAlign.center,
    );
  }

  Widget buildTomorrowWidget() {
    final DateTime today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final tomorrowWeekText = '周' + _weekText.substring(tomorrow.weekday - 1, tomorrow.weekday);
    final tomorrowDateText = '${tomorrow.month}-${tomorrow.day}';
    return Text(
      "$tomorrowWeekText\n"
      "明天($tomorrowDateText)",
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

class AddAppointment extends StatelessWidget {
  final ValueNotifier<DateTime> date = ValueNotifier(DateTime.now());
  final service = LibraryAppointmentInitializer.appointmentService;
  AddAppointment({Key? key}) : super(key: key);

  Widget buildSelectList(List<PeriodStatusRecord> records) {
    return ListView(
      children: records.map((e) {
        final a = {1: '上午场', 2: '下午场'}[e.period % 10]!;
        return Column(children: [
          ListTile(
            title: Text('$a   (${e.text})'),
            subtitle: SizedBox(
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
            trailing: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all()),
              child: Text('已预约(${e.applied}) / 预计总量(${e.count})'),
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
        title: const Text('添加预约'),
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
