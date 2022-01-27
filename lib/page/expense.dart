import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('消费记录'),
        // actions: [
        //   _currentIndex == 0
        //        _buildPopupMenuItems()
        //       : const Padding(padding: EdgeInsets.all(0)),
        // ],
      ),
      body: _currentIndex == 0 ? BillPage() : const StatisticsPage(),
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
          setState(() => _currentIndex = tapIndex);
        },
      ),
    );
  }

  ///筛选
  _buildPopupMenuItems() {
    return PopupMenuButton(
      tooltip: '筛选',
      onSelected: (String value) {
        // setState(() {});
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
        const PopupMenuItem(
          value: "食堂",
          child: Icon(Icons.food_bank_outlined, color: Colors.grey),
        ),
        const PopupMenuItem(
          value: "超市",
          child: Icon(Icons.storefront, color: Colors.grey),
        )
      ],
    );
  }
}
