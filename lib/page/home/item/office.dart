import 'package:flutter/material.dart';
import 'package:kite/global/bus.dart';
import 'package:kite/page/home/item.dart';

class OfficeItem extends StatefulWidget {
  const OfficeItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OfficeItemState();
}

class _OfficeItemState extends State<OfficeItem> {
  @override
  void initState() {
    eventBus.on('onHomeRefresh', (arg) {});

    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const HomeItem(route: '/office', icon: AssetImage('assets/home/icon_daily_report.png'), title: '办公');
  }
}
