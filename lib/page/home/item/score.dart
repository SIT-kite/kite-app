import 'package:flutter/material.dart';
import 'package:kite/global/event_bus.dart';
import 'package:kite/page/home/item/item.dart';

class ScoreItem extends StatefulWidget {
  const ScoreItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScoreItemState();
}

class _ScoreItemState extends State<ScoreItem> {
  static const defaultContent = '愿每一天都有收获';

  @override
  void initState() {
    eventBus.on(EventNameConstants.onHomeRefresh, (arg) {});

    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomeItem(
      route: '/score',
      icon: 'assets/home/icon_score.svg',
      title: '成绩',
      subtitle: defaultContent,
    );
  }
}
