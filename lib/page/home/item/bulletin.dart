import 'package:flutter/material.dart';
import 'package:kite/global/event_bus.dart';
import 'package:kite/page/home/item/item.dart';

class BulletinItem extends StatefulWidget {
  const BulletinItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BulletinItemState();
}

class _BulletinItemState extends State<BulletinItem> {
  late String content = '查看学校的通知';

  @override
  void initState() {
    eventBus.on(EventNameConstants.onHomeRefresh, (arg) {});

    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomeItem(
      route: '/bulletin',
      icon: 'assets/home/icon_bulletin.svg',
      title: 'OA 公告',
      subtitle: content,
    );
  }
}
