import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:kite/component/future_builder.dart';
import 'package:kite/component/multibutton_switch.dart';
import 'package:kite/feature/library/appointment/init.dart';
import 'package:kite/util/alert_dialog.dart';
import 'package:kite/util/flash.dart';
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
          margin: const EdgeInsets.symmetric(vertical: 8),
        ),
        Container(
          child: buildTomorrowWidget(),
          margin: const EdgeInsets.symmetric(vertical: 8),
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
  final ValueNotifier<CurrentPeriodResponse?> currentPeriod = ValueNotifier(null);

  final service = LibraryAppointmentInitializer.appointmentService;

  @override
  void initState() {
    service.getCurrentPeriod().then((value) => currentPeriod.value = value);
    super.initState();
  }

  Future<void> showAppointPeriodDialog(PeriodStatusRecord e) async {
    final applyDialogResult = await showAlertDialog(
      context,
      title: '是否要预约本场',
      content: [
        Text('场次编号: ${e.period}\n'
            '已预约人数: ${e.applied}\n'
            '预计开放座位: ${e.count}\n'
            '开放时间段: ${e.text}\n'
            '\n'
            '注意: 请务必在预约时段内进馆，未到将影响下一次预约。\n'),
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

  Widget buildEmptyList() {
    return const Center(child: Text('该日闭馆'));
  }

  Widget buildSelectList(List<PeriodStatusRecord> periodStatusList) {
    return ListView(
      children: periodStatusList.map((e) {
        final a = {1: '上午', 2: '下午', 3: '晚上'}[e.period % 10]!;
        Widget buildTrailingWidget() {
          Widget buildOutdated() => const Text('已过期', style: TextStyle(color: Colors.red));
          Widget buildAppointed() => const Icon(Icons.check, color: Colors.green);
          Widget buildAvailable() => const Text('可预约', style: TextStyle(color: Colors.blue));

          if (e.appointed) return buildAppointed();
          return ValueListenableBuilder<CurrentPeriodResponse?>(
            valueListenable: currentPeriod,
            builder: (context, data, child) {
              if (data == null) return const CircularProgressIndicator();
              if (data.period != null && e.period < data.period!) return buildOutdated();
              if (data.next != null && e.period < data.next!) return buildOutdated();
              return buildAvailable();
            },
          );
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
            trailing: SizedBox(child: Center(child: buildTrailingWidget()), width: 50),
            onTap: () async {
              if (!e.appointed) {
                await showAppointPeriodDialog(e);
              } else {
                showBasicFlash(context, const Text('您已预约过本场'), duration: const Duration(seconds: 1));
              }
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
        return periodStatusList.isNotEmpty ? buildSelectList(periodStatusList) : buildEmptyList();
      },
    );
  }

  Widget buildCurrentPeriod() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder<CurrentPeriodResponse?>(
          valueListenable: currentPeriod,
          builder: (context, data, child) {
            if (data == null) return const CircularProgressIndicator();
            if (data.period == null) {
              return Text(
                '当前不在进馆时段\n下一时间段 ${data.next}',
                textAlign: TextAlign.center,
              );
            } else {
              return Text('当前开放，请在 ${DateFormat('HH:mm').format(data.before!.toLocal())} 前入馆');
            }
          },
        ));
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
              await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HistoryPage()));
              setState(() {});
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            TodayTomorrowSwitch(
              onSwitchToday: () => date.value = DateTime.now(),
              onSwitchTomorrow: () => date.value = DateTime.now().add(const Duration(days: 1)),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: date,
                builder: (BuildContext context, DateTime value, Widget? child) {
                  return buildAppointmentListByDate(date.value);
                },
              ),
            ),
            buildCurrentPeriod(),
          ],
        ),
      ),
    );
  }
}
