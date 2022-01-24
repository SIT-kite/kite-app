import 'package:flutter/material.dart';
import 'package:kite/entity/electricity.dart';
import 'package:kite/global/event_bus.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/page/home/item.dart';

class ElectricityItem extends StatefulWidget {
  const ElectricityItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ElectricityItemState();
}

class _ElectricityItemState extends State<ElectricityItem> {
  final Balance? lastBalance = StoragePool.homeSetting.lastBalance;
  late String content = '宿舍电费余额和用电记录';

  @override
  void initState() {
    eventBus.on(EventNameConstants.onHomeRefresh, (arg) {});

    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (lastBalance != null) {
      content = '寝室 ${lastBalance!.room} 上次余额 ${lastBalance!.balance.toStringAsPrecision(2)}';
    }
    return HomeItem(
      route: '/electricity',
      icon: 'assets/home/icon_electricity.svg',
      title: '查电费',
      subtitle: content,
    );
  }
}
