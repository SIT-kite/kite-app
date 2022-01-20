import 'package:flutter/material.dart';
import 'package:kite/global/bus.dart';
import 'package:kite/page/home/item.dart';

class ElectricityItem extends StatefulWidget {
  const ElectricityItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ElectricityItemState();
}

class _ElectricityItemState extends State<ElectricityItem> {
  @override
  void initState() {
    eventBus.on('onHomeRefresh', (arg) {});

    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const HomeItem(route: '/electricity', icon: AssetImage('assets/home/icon_daily_report.png'), title: '查电费');
  }
}
