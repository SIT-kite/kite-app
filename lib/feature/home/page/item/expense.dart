/*
 * 上应小风筝  便利校园，一步到位
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
import 'package:kite/feature/expense/entity/expense.dart';
import 'package:kite/feature/expense/init.dart';
import 'package:kite/global/global.dart';

import 'index.dart';

class ExpenseItem extends StatefulWidget {
  const ExpenseItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExpenseItemState();
}

class _ExpenseItemState extends State<ExpenseItem> {
  final ExpenseRecord? lastExpense = ExpenseInitializer.expenseRecord.getLastOne();
  late String content = '校园卡消费记录';

  @override
  void initState() {
    Global.eventBus.on(EventNameConstants.onHomeRefresh, (arg) {});

    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (lastExpense != null) {
      content = '${lastExpense!.amount} 元 ${lastExpense!.place}';
    }
    return HomeFunctionButton(
      route: '/expense',
      icon: 'assets/home/icon_expense.svg',
      title: '查消费',
      subtitle: content,
    );
  }
}
