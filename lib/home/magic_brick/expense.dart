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
import 'package:kite/events/bus.dart';
import 'package:kite/events/symbol.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/module/expense/entity/local.dart';
import 'package:kite/module/expense/init.dart';
import 'package:kite/route.dart';

import '../user_widget/brick.dart';

class ExpenseItem extends StatefulWidget {
  const ExpenseItem({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExpenseItemState();
}

class _ExpenseItemState extends State<ExpenseItem> {
  Transaction? lastExpense;
  String? content;

  @override
  void initState() {
    super.initState();
    On.home<HomeRefreshEvent>((event) {
      refreshTracker();
    });
    On.expenseTracker<ExpenseTackerRefreshEvent>((event) {
      refreshTracker();
    });
    refreshTracker();
  }

  void refreshTracker() {
    final tsl = ExpenseTrackerInit.local.transactionTsList;
    if (tsl.isNotEmpty) {
      if (!mounted) return;
      setState(() {
        lastExpense = ExpenseTrackerInit.local.getTransactionByTs(tsl.last);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final last = lastExpense;
    if (last != null) {
      content = i18n.expenseContent(last.deltaAmount.toStringAsFixed(2), last.note);
    }
    return Brick(
      route: RouteTable.expense,
      icon: SvgAssetIcon('assets/home/icon_expense.svg'),
      title: i18n.ftype_expense,
      subtitle: content ?? i18n.ftype_expense_desc,
    );
  }
}
