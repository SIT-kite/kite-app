import 'package:flutter/material.dart';
import 'package:kite/global/bus.dart';
import 'package:kite/page/home/item.dart';

class ReportItem extends StatefulWidget {
  const ReportItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReportItemState();
}

class _ReportItemState extends State<ReportItem> {
  @override
  void initState() {
    eventBus.on('onHomeRefresh', (arg) {});

    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const HomeItem(route: '/report', icon: AssetImage('assets/home/icon_daily_report.png'), title: '体温上报');
  }
}
