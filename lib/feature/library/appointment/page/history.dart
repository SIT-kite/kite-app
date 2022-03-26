import 'package:flutter/material.dart';
import 'package:kite/component/future_builder.dart';
import 'package:kite/feature/library/appointment/init.dart';
import 'package:kite/feature/library/appointment/page/qrcode.dart';
import 'package:kite/setting/init.dart';

import '../entity.dart';

class HistoryPage extends StatelessWidget {
  final service = LibraryAppointmentInitializer.appointmentService;
  late BuildContext context;
  HistoryPage({Key? key}) : super(key: key);

  String periodToString(int period) {
    final a = {1: '上午', 2: '下午', 3: '晚上'}[period % 10] ?? '未知时间段';
    return '20${period ~/ 1e5}-${period ~/ 1e3 % 100}-${period ~/ 10 % 100}    ($a)';
  }

  void loadQrPage(int applyId) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => QrcodePage(applyId: applyId)));
  }

  Widget buildListView(List<ApplicationRecord> records) {
    int currentPeriod = 2203262;
    return ListView(
      children: records.map((e) {
        print(e);
        return Column(
          children: [
            ListTile(
              title: Text(periodToString(e.period)),
              subtitle: Text('${e.text}    座位号: ${e.index}'),
              trailing: (() {
                if (e.status == 1) {
                  return Text(
                    '成功打卡',
                    style: TextStyle(color: Colors.green),
                  );
                }
                // 已过期的
                if (e.period < currentPeriod && e.status == 0) {
                  return Text(
                    '预约成功但未去',
                    style: TextStyle(color: Colors.red),
                  );
                } else if (e.period == currentPeriod) {
                  return Column(
                    children: [
                      Text('当前场次'),
                      SizedBox(height: 2),
                      ElevatedButton(
                        onPressed: () {
                          loadQrPage(e.id);
                        },
                        child: Text('出示二维码'),
                      ),
                    ],
                  );
                } else {
                  return Text('未到规定打卡时段');
                }
              })(),
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
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: const Text('预约历史'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: buildMyHistoryList(),
      ),
    );
  }
}
