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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../init.dart';
import '../../using.dart';

import '../entity.dart';
import 'history.dart';
import 'qrcode.dart';

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
    // TODO: I18n
    final DateTime today = DateTime.now();
    final todayWeekText = '周${_weekText.substring(today.weekday - 1, today.weekday)}';
    final todayDateText = '${today.month}-${today.day}';
    return Text(
      '今天\n'
      '$todayWeekText（$todayDateText）',
      textAlign: TextAlign.center,
    );
  }

  Widget buildTomorrowWidget() {
    final DateTime today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final tomorrowWeekText = '周${_weekText.substring(tomorrow.weekday - 1, tomorrow.weekday)}';
    final tomorrowDateText = '${tomorrow.month}-${tomorrow.day}';
    return Text(
      '明天\n'
      '$tomorrowWeekText（$tomorrowDateText）',
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiButtonSwitch(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: buildTodayWidget(),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: buildTomorrowWidget(),
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

  final service = LibraryAppointmentInit.appointmentService;

  void loadQrPage(int applyId) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => QrcodePage(applyId: applyId)));
  }

  @override
  void initState() {
    service.getCurrentPeriod().then((value) => currentPeriod.value = value);
    super.initState();
  }

  Future<void> showAppointPeriodDialog(PeriodStatusRecord e) async {
    final applyDialogResult = await context.showRequest(
        title: '是否要预约本场',
        desc: '场次编号: ${e.period}\n'
            '已预约人数: ${e.applied}\n'
            '预计开放座位: ${e.count}\n'
            '开放时间段: ${e.text}\n'
            '\n'
            '注意: 请务必在预约时段内进馆，未到将影响下一次预约。\n',
        yes: '确定预约',
        no: '取消预约');
    // 确定预约
    if (applyDialogResult == true) {
      if (!mounted) return;
      final signed = await signUpIfNecessary(context, '预约图书馆');
      if (signed) return;
    }
    try {
      await service.apply(e.period);
      if (!mounted) return;
      await context.showTip(
        title: "预约图书馆",
        desc: '预约成功',
        ok: '关闭',
      );
    } catch (e, _) {
      if (!mounted) return;
      await context.showTip(
        title: '预约失败',
        desc: e.toString(),
        ok: '关闭',
      );
    } finally {
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
          Widget buildOutdated() => const Text('已结束', style: TextStyle(color: Colors.redAccent));
          Widget buildAppointed() => const Icon(Icons.check, color: Colors.green);
          Widget buildAvailable() => Text(
                e.applied == e.count ? '已满' : '可预约',
                style: const TextStyle(color: Colors.blue),
              );
          Widget buildQrCode() => IconButton(
              onPressed: () async {
                final response = await service.apply(e.period);
                final applyId = response.id;
                loadQrPage(applyId);
              },
              icon: const Icon(Icons.qr_code));

          return ValueListenableBuilder<CurrentPeriodResponse?>(
            valueListenable: currentPeriod,
            builder: (context, data, child) {
              if (data == null) return Placeholders.loading();
              if (e.appointed) {
                if (e.period == data.period) {
                  return buildQrCode();
                } else {
                  return buildAppointed();
                }
              } else {
                if (data.period != null) {
                  if (e.period < data.period!) {
                    return buildOutdated();
                  } else {
                    return buildAvailable();
                  }
                } else {
                  if (e.period < data.next!) {
                    return buildOutdated();
                  } else {
                    return buildAvailable();
                  }
                }
              }
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
            trailing: SizedBox(width: 50, child: Center(child: buildTrailingWidget())),
            onTap: () async {
              showHasAppointed() {
                showBasicFlash(context, const Text('您已预约过本场'), duration: const Duration(seconds: 1));
              }

              showOutdated() {
                showBasicFlash(context, const Text('该预约已过期'), duration: const Duration(seconds: 1));
              }

              final data = currentPeriod.value;
              if ((data != null && data.period != null && e.period < data.period!) ||
                  (data != null && data.next != null && e.period < data.next!)) {
                showOutdated();
                return;
              }

              if (e.appointed) {
                showHasAppointed();
                return;
              } else {
                await showAppointPeriodDialog(e);
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
            if (data == null) return Placeholders.loading();
            if (data.period == null) {
              return const Text(
                '当前不在进馆时段',
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
