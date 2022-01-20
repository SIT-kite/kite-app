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
    return HomeItem(route: '/report', icon: 'assets/home/icon_report.svg', title: '体温上报');
  }
}
