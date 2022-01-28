import 'package:flutter/material.dart';
import 'package:kite/service/expense.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/entity/expense.dart';
import 'package:kite/page/expense/icon.dart';

import 'expense/bill.dart';
import 'expense/statistics.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({Key? key}) : super(key: key);

  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  /// 底部导航键的标志位
  int _currentIndex = 0;
  int _stateindex = 1;
  String _expensetype = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("消费记录"),
        actions: [
          _onBillsRefresh(),
          _currentIndex == 0
              ? _buildPopupMenuItems()
              : const Padding(padding: EdgeInsets.all(0)),
        ],
      ),
      body: _currentIndex == 0
          ? BillPage(_stateindex, _expensetype)
          : const StatisticsPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            label: '账单',
            icon: Icon(Icons.assignment_rounded),
          ),
          BottomNavigationBarItem(
            label: '统计',
            icon: Icon(Icons.data_saver_off),
          )
        ],
        currentIndex: _currentIndex,
        onTap: (int tapIndex) {
          setState(() => {_currentIndex = tapIndex, _stateindex = 0});
        },
      ),
    );
  }

  ///筛选
  _buildPopupMenuItems() {
    return PopupMenuButton(
      tooltip: '筛选',
      onSelected: (String value) {
        setState(() => _expensetype = value);
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
        PopupMenuItem(
          value: 'canteen',
          child: Row(
            children: [
              Icon(Icons.local_mall,
                  size: 30, color: Theme.of(context).primaryColor),
              const Text('全部')
            ],
          ),
        ),
        PopupMenuItem(
          value: 'canteen',
          child: Row(children: [
            buildIcon(ExpenseType.canteen, context),
            const Text('食堂')
          ]),
        ),
        PopupMenuItem(
          value: 'store',
          child: Row(children: [
            buildIcon(ExpenseType.store, context),
            const Text('超市'),
          ]),
        ),
        PopupMenuItem(
          value: 'coffee',
          child: Row(children: [
            buildIcon(ExpenseType.coffee, context),
            const Text('咖啡吧'),
          ]),
        ),
        PopupMenuItem(
          value: 'shower',
          child: Row(children: [
            buildIcon(ExpenseType.shower, context),
            const Text('洗浴'),
          ]),
        ),
        PopupMenuItem(
          value: 'water',
          child: Row(children: [
            buildIcon(ExpenseType.water, context),
            const Text('热水'),
          ]),
        ),
        PopupMenuItem(
          value: 'unknown',
          child: Row(children: [
            buildIcon(ExpenseType.unknown, context),
            const Text('未知'),
          ]),
        )
      ],
    );
  }

  _onBillsRefresh() {
    return IconButton(
      tooltip: '刷新',
      icon: const Icon(Icons.refresh),
      onPressed: () {
        setState(() => _stateindex = 1);
      },
    );
  }
}
