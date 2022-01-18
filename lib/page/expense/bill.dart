import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:kite/entity/expense.dart';
import 'package:kite/mock/expense.dart';

import 'icon.dart';

class BillPage extends StatelessWidget {
  const BillPage({Key? key}) : super(key: key);

  Widget _buildBody(BuildContext context, List<ExpenseDetail> expenseData) {
    return GroupedListView<ExpenseDetail, int>(
      elements: expenseData,
      groupBy: (element) => element.ts.month,
      useStickyGroupSeparators: true,
      order: GroupedListOrder.DESC,
      itemComparator: (item1, item2) => item1.ts.compareTo(item2.ts),
      // 生成账单项
      itemBuilder: (context, detail) {
        final icon = buildIcon(detail.type);

        return ListTile(
          leading: icon,
          title: Text(detail.place),
          trailing: Text(detail.amount.toString(), textScaleFactor: 1.5),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[Text(detail.ts.toString())], // TODO: 可能太长
          ),
        );
      },
      // 生成每一组的头部
      groupHeaderBuilder: (ExpenseDetail firstGroupRecord) {
        double total = 0;
        int month = firstGroupRecord.ts.month;

        for (var element in expenseData) {
          total += (element.ts.month == month) ? element.amount : 0;
        }
        return ListTile(
          title: Text('$month 月', textScaleFactor: 1.5),
          subtitle: Text('支出: $total 元'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ExpenseDetail>>(
      // future: ExpenseService(SessionPool.ssoSession).getExpenseBill(1),
      future: getMockedExpenseBill(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          return _buildBody(context, data);
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
