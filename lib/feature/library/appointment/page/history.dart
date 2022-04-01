import 'package:flutter/material.dart';
import 'package:kite/component/future_builder.dart';
import 'package:kite/feature/library/appointment/init.dart';
import 'package:kite/feature/library/appointment/page/qrcode.dart';
import 'package:kite/setting/init.dart';
import 'package:kite/util/alert_dialog.dart';

import '../entity.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final service = LibraryAppointmentInitializer.appointmentService;

  String periodToString(int period) {
    final a = {1: '上午', 2: '下午', 3: '晚上'}[period % 10] ?? '未知时间段';
    return '${period ~/ 1e3 % 100} 月 ${period ~/ 10 % 100} 日  （$a）';
  }

  void loadQrPage(int applyId) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => QrcodePage(applyId: applyId)));
  }

  Widget buildHistoryItemTrailing(ApplicationRecord item, CurrentPeriodResponse currentPeriod) {
    int applyId = item.id;
    int status = item.status;
    int period = item.period;

    Widget buildCancelButton() {
      return TextButton(
        onPressed: () async {
          final select = await showAlertDialog(
            context,
            title: '取消预约',
            content: [
              const Text('是否想要取消本次预约'),
            ],
            actionWidgetList: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('确认取消'),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('手滑了'),
              ),
            ],
          );
          if (select == 0) {
            try {
              await service.cancelApplication(applyId);
              await showAlertDialog(
                context,
                title: '取消成功',
                actionWidgetList: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('知道了'),
                  ),
                ],
              );
              setState(() {});
            } catch (e) {
              await showAlertDialog(
                context,
                title: '出错了',
                content: [
                  Text(e.toString()),
                ],
                actionWidgetList: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('知道了'),
                  ),
                ],
              );
            }
          }
        },
        child: const Text('取消预约'),
      );
    }

    Widget buildSuccessfulText() {
      return const Text(
        '成功打卡',
        style: TextStyle(color: Colors.green),
      );
    }

    Widget buildQrCodeButton() {
      return ElevatedButton(
        onPressed: () {
          loadQrPage(applyId);
        },
        child: const Text('预约码'),
      );
    }

    Widget buildFailedText() {
      return const Text('已过期', style: TextStyle(color: Colors.red));
    }

    // 成功打卡了
    if (status == 1) return buildSuccessfulText();

    // 现在开着
    if (currentPeriod.period != null) {
      if (period == currentPeriod.period) return buildQrCodeButton();
      if (period > currentPeriod.period!) return buildCancelButton();
      if (period < currentPeriod.period!) return buildFailedText();
    } else {
      // 现在没开门
      // next必然存在
      if (period >= currentPeriod.next!) return buildCancelButton();
      if (period < currentPeriod.next!) return buildFailedText();
    }

    return const Text('未知状态', style: TextStyle(color: Colors.orange));
  }

  Widget buildListView(
    List<ApplicationRecord> records,
    CurrentPeriodResponse currentPeriod,
  ) {
    records.sort((a, b) {
      return b.period - a.period;
    });
    return ListView(
      children: records.map((e) {
        return Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              title: Text(periodToString(e.period)),
              subtitle: Text('${e.text}    座位号: ${e.index}'),
              trailing: buildHistoryItemTrailing(e, currentPeriod),
            ),
            const Divider(),
          ],
        );
      }).toList(),
    );
  }

  Widget buildMyHistoryList() {
    return MyFutureBuilder<List>(
      future: Future.wait([
        service.getApplication(username: SettingInitializer.auth.currentUsername),
        service.getCurrentPeriod(),
      ]),
      builder: (context, tuple) {
        List<ApplicationRecord> applicationRecordList = tuple[0];
        CurrentPeriodResponse currentPeriod = tuple[1];
        return buildListView(applicationRecordList, currentPeriod);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('预约历史'),
      ),
      body: buildMyHistoryList(),
    );
  }
}
