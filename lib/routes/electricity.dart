import 'package:flutter/material.dart';

class ElectricityWidget extends StatefulWidget {
  const ElectricityWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ElectricityState();
}

class _ElectricityState extends State<ElectricityWidget> {
  var room = "1011111";
  var balance = 43.21;
  var power = 54.32;
  var datetime = "4 分钟前";

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: const IconButton(
            icon: Icon(Icons.menu),
            onPressed: null,
          ),
          title: const TabBar(
            tabs: [
              Tab(text: '电费余额'),
              Tab(text: '使用情况'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Row(
              children: [
                Text('　房间号：$room'),
                Text('剩余金额：$balance 元'),
                Text('剩余电量：$power 度'),
                Text('更新时间：$datetime'),
              ],
            ),
            const Center(child: Text('使用情况')),
          ],
        ),
      ),
    );
  }
}
