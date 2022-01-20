import 'package:flutter/material.dart';
import 'package:kite/global/bus.dart';
import 'package:kite/page/home/item.dart';

class ScoreItem extends StatefulWidget {
  const ScoreItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScoreItemState();
}

class _ScoreItemState extends State<ScoreItem> {
  @override
  void initState() {
    eventBus.on('onHomeRefresh', (arg) {});

    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomeItem(route: '/score', icon: 'assets/home/icon_score.svg', title: '成绩');
  }
}
