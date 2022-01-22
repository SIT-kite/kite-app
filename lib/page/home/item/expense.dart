import 'package:flutter/material.dart';
import 'package:kite/entity/expense.dart';
import 'package:kite/global/bus.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/page/home/item.dart';

class ExpenseItem extends StatefulWidget {
  const ExpenseItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExpenseItemState();
}

class _ExpenseItemState extends State<ExpenseItem> {
  final ExpenseRecord? lastExpense = StoragePool.homeSetting.lastExpense;
  late String content = '校园卡消费记录';

  @override
  void initState() {
    eventBus.on('onHomeRefresh', (arg) {});

    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (lastExpense != null) {
      content = '${lastExpense!.amount} 元 ${lastExpense!.place}';
    }
    return HomeItem(
      route: '/expense',
      icon: 'assets/home/icon_expense.svg',
      title: '消费',
      subtitle: content,
    );
  }
}
