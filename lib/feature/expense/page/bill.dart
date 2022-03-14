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
import 'package:flutter_svg/svg.dart';
import 'package:grouped_list/grouped_list.dart';

import '../entity/expense.dart';
import '../init.dart';
import 'icon.dart';

class BillPage extends StatelessWidget {
  final ExpenseType filter;

  const BillPage({required this.filter, Key? key}) : super(key: key);

  Widget _buildBillList(BuildContext context, List<ExpenseRecord> expenseData) {
    final groupTitleStyle = Theme.of(context).textTheme.headline2;
    final groupSubtitleStyle = Theme.of(context).textTheme.headline6;
    final itemTitleStyle = Theme.of(context).textTheme.bodyText1;
    final itemSubtitleStyle = Theme.of(context).textTheme.bodyText2;

    return GroupedListView<ExpenseRecord, int>(
      elements: expenseData,
      groupBy: (element) => element.ts.year * 12 + element.ts.month,
      useStickyGroupSeparators: true,
      order: GroupedListOrder.DESC,
      itemComparator: (item1, item2) => item1.ts.compareTo(item2.ts),
      // 生成账单项
      itemBuilder: (context, detail) {
        final icon = buildIcon(detail.type, context);

        return ListTile(
          leading: icon,
          title: Text(detail.place, style: itemTitleStyle),
          trailing: Text(detail.amount.toString(), textScaleFactor: 1.5, style: itemSubtitleStyle),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[Text(detail.ts.toString())],
          ),
        );
      },
      // 生成每一组的头部
      groupHeaderBuilder: (ExpenseRecord firstGroupRecord) {
        double total = 0;
        int month = firstGroupRecord.ts.month;
        int year = firstGroupRecord.ts.year;

        for (var element in expenseData) {
          total += (element.ts.month == month && element.ts.year == year) ? element.amount : 0;
        }
        return ListTile(
          title: Text('$year 年$month 月 ', style: groupTitleStyle),
          subtitle: Text('支出: ${total.toStringAsFixed(2)} 元', style: groupSubtitleStyle),
        );
      },
    );
  }

  Widget _buildEmptyResult(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headline5;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // TODO: 不要跨模块使用资源文件.
          SvgPicture.asset('assets/game/empty.svg'),
          Text('这里空空的，\n快点击右上角的刷新按钮更新数据', style: textStyle),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final records = ExpenseInitializer.expenseRecord.getAllByTimeDesc();
    final recordsToShow = filter == ExpenseType.all ? records : records.where((e) => e.type == filter).toList();

    if (recordsToShow.isNotEmpty) {
      return _buildBillList(context, recordsToShow);
    }
    return _buildEmptyResult(context);
  }
}
