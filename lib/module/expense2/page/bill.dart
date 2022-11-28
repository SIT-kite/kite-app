
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
import 'package:intl/intl.dart';
import 'package:kite/l10n/extension.dart';
import 'package:kite/module/expense2/using.dart';

import '../entity/local.dart';

class BillPage extends StatefulWidget {
  final List<Transaction> records;

  const BillPage({
    Key? key,
    required this.records,
  }) : super(key: key);

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  Widget buildListView() {
    final groupTitleStyle = Theme.of(context).textTheme.headline2;
    final groupSubtitleStyle = Theme.of(context).textTheme.headline6;

    return GroupedListView<Transaction, int>(
      elements: widget.records,
      groupBy: (element) => element.datetime.year * 12 + element.datetime.month,
      useStickyGroupSeparators: true,
      order: GroupedListOrder.DESC,
      itemComparator: (item1, item2) => item1.datetime.compareTo(item2.datetime),
      // 生成每一组的头部
      groupHeaderBuilder: (Transaction firstGroupRecord) {
        double totalOutcome = 0;
        double totalIncome = 0;
        int month = firstGroupRecord.datetime.month;
        int year = firstGroupRecord.datetime.year;

        for (final element in widget.records) {
          if (element.datetime.month == month && element.datetime.year == year) {
            if (element.isConsume) {
              totalOutcome += element.deltaAmount;
            } else {
              totalIncome += element.deltaAmount;
            }
          }
        }
        return ListTile(
          title: Text('$year 年$month 月 ', style: groupTitleStyle),
          subtitle: Text(
            '支出: ${totalOutcome.toStringAsFixed(2)} 元  收入: ${totalIncome.toStringAsFixed(2)} 元',
            style: groupSubtitleStyle,
          ),
        );
      },
      // 生成账单项
      itemBuilder: (context, e) {
        return ListTile(
          title: Text(e.bestTitle ?? i18n.unknown),
          subtitle: Text(DateFormat('yyyy-MM-dd  HH:mm:ss').format(e.datetime)),
          leading: Transform.scale(scale: 1.5, child: Icon(e.type.icon, color: context.themeColor)),
          trailing: Transform.scale(
            scale: 1.2,
            child: Text(
              e.toReadableString(),
              style: TextStyle(color: e.billColor, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildListView();
  }
}
