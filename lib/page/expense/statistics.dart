import 'package:flutter/material.dart';
import 'package:kite/entity/expense.dart';
import 'package:kite/mock/expense.dart';
import 'package:kite/page/expense/icon.dart';

import 'chart.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  int year = DateTime.now().year;
  int month = DateTime.now().month;

  // TODO: Use actual data.
  final List<ExpenseDetail> _expenseBill = mockedData;

  List<Widget> _buildClassifiedStat() {
    // 各分类下消费的统计
    List<double> sumByClassification = List.filled(ExpenseType.values.length, 0.0);
    for (final line in _expenseBill) {
      sumByClassification[line.type.index] += line.amount;
    }
    double sum = sumByClassification.fold(0.0, (previousValue, element) => previousValue += element);

    return ExpenseType.values.map(
      (expenseType) {
        final double sumInType = sumByClassification[expenseType.index];
        final double percentage = sumInType / sum;

        return ListTile(
          leading: buildIcon(expenseType),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(expenseTypeMapping[expenseType]!, textScaleFactor: 1.2),
              Text('  ${(percentage * 100).toInt()} %', textScaleFactor: 1.1),
            ],
          ),
          subtitle: LinearProgressIndicator(value: percentage),
          // 下方 SizedBox 用于限制文字宽度, 使左侧进度条的右端对齐.
          trailing: SizedBox(width: 80, child: Text('￥$sumInType', textScaleFactor: 1.2)),
          dense: true,
        );
      },
    ).toList();
  }

  Widget _buildDateSelector() {
    // TODO: 支持查看全年统计, 此时 chart line 也需要修改.
    final List<String> years = ['2021', '2022'];
    final List<String> months = [/*'全部',*/ '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];

    // TODO: 年月不超过当前日期.
    final yearWidgets = years.map((e) => PopupMenuItem(value: e, child: Text(e))).toList();
    final monthWidgets = months.map((e) => PopupMenuItem(value: e, child: Text(e))).toList();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          PopupMenuButton(
            onSelected: (String value) => setState(() => year = int.parse(value)),
            child: Text('$year 年', textScaleFactor: 1.5),
            itemBuilder: (_) => yearWidgets,
          ),
          PopupMenuButton(
            onSelected: (String value) => setState(() => month = int.parse(value)),
            child: Text('$month 月', textScaleFactor: 1.5),
            itemBuilder: (_) => monthWidgets,
          ),
        ],
      ),
    );
  }

  // TODO: 这个函数应该放在 DAO 或 service
  List<ExpenseDetail> _filterExpense() {
    return _expenseBill.where((element) => element.ts.year == year && element.ts.month == month).toList();
  }

  static int _getDayCountOfMonth(int year, int month) {
    final int daysFeb = (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) ? 29 : 28;
    List<int> days = [31, daysFeb, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return days[month - 1];
  }

  Widget _buildChartView() {
    // 得到该年该月有多少天, 生成数组记录每一天的消费.
    final List<double> daysAmount = List.filled(_getDayCountOfMonth(year, month), 0.001);
    // 便利该月消费情况, 加到上述统计列表中.
    _filterExpense().forEach((e) => daysAmount[e.ts.day - 1] += e.amount);

    final width = MediaQuery.of(context).size.width - 70;

    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
              child: Text('支出对比', textScaleFactor: 1.2),
            ),
            const SizedBox(height: 10),
            Center(
              child: SizedBox(height: width * 0.5, width: width, child: ExpenseChart(daysAmount)),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildClassificationView() {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
            child: Text('支出分类', textScaleFactor: 1.2),
          ),
          Column(
            children: _buildClassifiedStat(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _buildDateSelector(),
          _buildChartView(),
          _buildClassificationView(),
        ],
      ),
    );
  }
}
