import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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

  Widget buildHistoryItemTrailing(ApplicationRecord item, int currentPeriod) {
    int applyId = item.id;
    int status = item.status;
    int period = item.period;

    if (status == 1) {
      return const Text(
        '成功打卡',
        style: TextStyle(color: Colors.green),
      );
    }
    // 已过期的
    if (period < currentPeriod && status == 0) {
      return const Text('已过期', style: TextStyle(color: Colors.red));
    } else if (period == currentPeriod) {
      return ElevatedButton(
        onPressed: () {
          loadQrPage(applyId);
        },
        child: const Text('预约码'),
      );
    } else {
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
  }

  Widget buildListView(List<ApplicationRecord> records) {
    int currentPeriod = 2203262;
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
    return MyFutureBuilder<List<ApplicationRecord>>(
      future: service.getApplication(username: SettingInitializer.auth.currentUsername),
      builder: (context, data) {
        data.sort((a, b) {
          return b.period - a.period;
        });
        return buildListView(data);
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
