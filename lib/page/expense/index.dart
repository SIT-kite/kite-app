/*
 * 上应小风筝(SIT-kite)  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'package:flutter/material.dart';
import 'package:kite/entity/expense.dart';
import 'package:kite/page/expense/icon.dart';

import 'bill.dart';
import 'statistics.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({Key? key}) : super(key: key);

  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  /// 底部导航键的标志位
  int currentIndex = 0;
  bool isRefreshing = false;
  ExpenseType _filter = ExpenseType.all;

  /// 筛选按钮
  _buildPopupMenuItems() {
    final itemMapping = expenseTypeMapping.map((type, display) {
      final item = PopupMenuItem(
        value: ExpenseType.all,
        child: Row(children: [buildIcon(type, context), Text(display)]),
      );
      return MapEntry(type, item);
    });

    final List<PopupMenuItem<ExpenseType>> items = itemMapping.values.toList();
    return PopupMenuButton(
      tooltip: '筛选',
      onSelected: (ExpenseType v) => setState(() => _filter = v),
      itemBuilder: (_) => items,
    );
  }

  _buildRefreshButton() {
    return IconButton(
      tooltip: '刷新',
      icon: const Icon(Icons.refresh),
      onPressed: () {
        setState(() => isRefreshing = true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("消费记录"),
        actions: [
          _buildRefreshButton(),
          currentIndex == 0 ? _buildPopupMenuItems() : Container(),
        ],
      ),
      body: currentIndex == 0 ? const BillPage(filter: ExpenseType.all) : const StatisticsPage(),
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
        currentIndex: currentIndex,
        onTap: (int tapIndex) {
          setState(() => {currentIndex = tapIndex, isRefreshing = false});
        },
      ),
    );
  }
}
