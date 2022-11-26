import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

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
      // 生成账单项
      itemBuilder: (context, e) {
        return ListTile(
          title: Text(e.deviceName),
          subtitle: Text(DateFormat('yyyy-MM-dd  HH:mm:ss').format(e.datetime)),
          leading: Transform.scale(scale: 1.5, child: Icon(e.type.icon, color: Theme.of(context).primaryColor)),
          trailing: () {
            final delta = e.balanceAfter - e.balanceBefore;
            final text = '${delta > 0 ? '+' : ''}${delta.toStringAsFixed(2)}';
            final color = delta > 0 ? Colors.green : Colors.red;
            return Transform.scale(
              scale: 1.2,
              child: Text(
                text,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            );
          }(),
        );
      },
      // 生成每一组的头部
      groupHeaderBuilder: (Transaction firstGroupRecord) {
        double totalOutcome = 0;
        double totalIncome = 0;
        int month = firstGroupRecord.datetime.month;
        int year = firstGroupRecord.datetime.year;

        for (final element in widget.records) {
          if (element.datetime.month == month && element.datetime.year == year) {
            final delta = element.balanceAfter - element.balanceBefore;
            if (delta < 0) {
              totalOutcome += delta;
            } else {
              totalIncome += delta;
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildListView();
  }
}
