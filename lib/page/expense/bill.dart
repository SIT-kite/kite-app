import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:kite/entity/expense.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/service/expense.dart';

import 'icon.dart';

class BillPage extends StatelessWidget {
  static const _typeKeywords = {
    'water': ExpenseType.water,
    'shower': ExpenseType.shower,
    'coffee': ExpenseType.coffee,
    'canteen': ExpenseType.canteen,
    'store': ExpenseType.store,
    'unknown': ExpenseType.unknown,
  };
  final int _stateindex;
  final String _expensetype;

  BillPage(this._stateindex, this._expensetype, {Key? key}) : super(key: key);
  List<ExpenseRecord> expenseData = StoragePool.expenseRecordStorage.getAllByTimeDesc();

  Future<List<ExpenseRecord>> _expenseBills() async {
    ExpensePage firstPage = await ExpenseRemoteService(SessionPool.ssoSession).getExpensePage(1);
    List<Future<ExpensePage>> getPage = [];
    for (int i = 2; i <= firstPage.total; i++) {
      ExpenseRemoteService(SessionPool.ssoSession).getExpensePage(i);
    }
    await Future.wait(getPage);
    return StoragePool.expenseRecordStorage.getAllByTimeDesc();
  }

  Widget _requestStatus(BuildContext context, int _stateindex) {
    if (_stateindex == 0) {
      return _buildBody(
          context,
          _expensetype == 'all'
              ? expenseData
              : expenseData.where((e) => e.type == _typeKeywords[_expensetype]).toList());
    } else {
      return FutureBuilder(
        future: StoragePool.expenseRecordStorage.getAllByTimeDesc().isEmpty
            ? _expenseBills()
            : ExpenseRemoteService(SessionPool.ssoSession).refreshExpenseRecord(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            expenseData = StoragePool.expenseRecordStorage.getAllByTimeDesc();
            return _buildBody(
                context,
                _expensetype == 'all'
                    ? expenseData
                    : expenseData.where((e) => e.type == _typeKeywords[_expensetype]).toList());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [CircularProgressIndicator(), Text('数据来自学校所以速度你懂的~_~')],
          ));
        },
      );
    }
  }

  Widget _buildBody(BuildContext context, List<ExpenseRecord> expenseData) {
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
          title: Text(detail.place),
          trailing: Text(detail.amount.toString(), textScaleFactor: 1.5),
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
          title: Text('$year 年$month 月 ', textScaleFactor: 1.3),
          subtitle: Text('支出: ${total.toStringAsFixed(2)} 元'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _requestStatus(context, _stateindex);
  }
}
