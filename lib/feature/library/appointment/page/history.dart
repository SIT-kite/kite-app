import 'package:flutter/material.dart';

import 'qrcode.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('预约历史'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            ListTile(
              title: Text("2022年3月15日下午场"),
              subtitle: Text("未入馆"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const QrcodePage()));
              },
            ),
            ListTile(
              title: Text("2022年3月15日上午场"),
              subtitle: Text("未按预约时间入馆"),
              trailing: Icon(
                Icons.error,
                color: Colors.red,
              ),
            ),
            ListTile(
              title: Text("2022年3月15日上午场"),
              subtitle: Text("已入馆"),
              trailing: Icon(
                Icons.check,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
