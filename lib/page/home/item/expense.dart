import 'package:flutter/material.dart';
import 'package:kite/global/bus.dart';
import 'package:kite/page/home/item.dart';

class ExpenseItem extends StatefulWidget {
  const ExpenseItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExpenseItemState();
}

class _ExpenseItemState extends State<ExpenseItem> {
  @override
  void initState() {
    eventBus.on('onHomeRefresh', (arg) {});

    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HomeItem(route: '/expense', icon: 'assets/home/icon_expense.svg', title: '消费');
  }
}
