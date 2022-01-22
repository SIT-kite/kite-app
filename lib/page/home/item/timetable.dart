import 'package:flutter/material.dart';
import 'package:kite/global/bus.dart';
import 'package:kite/page/home/item.dart';

class TimetableItem extends StatefulWidget {
  const TimetableItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TimetableItemState();
}

class _TimetableItemState extends State<TimetableItem> {
  String content = '查看近期课程';

  @override
  void initState() {
    eventBus.on('onHomeRefresh', (arg) {});

    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const HomeItem(
      route: '/timetable',
      icon: 'assets/home/icon_timetable.svg',
      title: '课程表',
      subtitle: '查看近期课程',
    );
  }
}
