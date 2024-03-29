/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/local.dart';
import '../using.dart';

class BillPage extends StatelessWidget {
  final List<Transaction> records;

  const BillPage({
    Key? key,
    required this.records,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final groupTitleStyle = textTheme.headline5;
    final groupSubtitleStyle = textTheme.headline3;

    return GroupedListView<Transaction, int>(
      elements: records,
      groupBy: (element) => element.datetime.year * 12 + element.datetime.month,
      useStickyGroupSeparators: true,
      stickyHeaderBackgroundColor: context.bgColor,
      order: GroupedListOrder.DESC,
      itemComparator: (item1, item2) => item1.datetime.compareTo(item2.datetime),
      // 生成每一组的头部
      groupHeaderBuilder: (Transaction firstGroupRecord) {
        double totalSpent = 0;
        double totalIncome = 0;
        int month = firstGroupRecord.datetime.month;
        int year = firstGroupRecord.datetime.year;

        for (final element in records) {
          if (element.datetime.month == month && element.datetime.year == year) {
            if (element.isConsume) {
              totalSpent += element.deltaAmount;
            } else {
              totalIncome += element.deltaAmount;
            }
          }
        }
        return ListTile(
          tileColor: context.bgColor,
          title: context.dateYearMonth(firstGroupRecord.datetime).text(style: groupTitleStyle),
          subtitle:
              "${i18n.expenseSpentStatistics(totalSpent.toStringAsFixed(2))} ${i18n.expenseIncomeStatistics(totalIncome.toStringAsFixed(2))}"
                  .text(style: groupSubtitleStyle),
        );
      },
      // 生成账单项
      itemBuilder: (ctx, e) {
        return TransactionTile(trans: e);
      },
    );
  }
}

class TransactionTile extends StatelessWidget {
  final Transaction trans;

  const TransactionTile({super.key, required this.trans});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(trans.bestTitle ?? i18n.unknown, style: context.textTheme.titleSmall),
      subtitle: context.dateFullNum(trans.datetime).text(),
      leading: trans.type.icon.make(color: trans.type.color, size: 32),
      trailing: trans.toReadableString().text(
            style: TextStyle(color: trans.billColor, fontWeight: FontWeight.bold, fontSize: 18),
          ),
    );
  }
}
