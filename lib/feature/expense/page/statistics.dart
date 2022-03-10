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
import '../entity/expense.dart';
import '../init.dart';
import '../page/icon.dart';

import 'chart.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final now = DateTime.now();

  late int selectedYear;
  late int selectedMonth;
  List<ExpenseRecord> _expenseBill = [];

  @override
  void initState() {
    selectedYear = now.year;
    selectedMonth = now.month;
    _expenseBill = ExpenseInitializer.expenseRecord.getAllByTimeDesc();
    super.initState();
  }

  List<int> _getYear(List<ExpenseRecord> _expenseBillDesc) {
    List<int> years = [];

    final currentYear = now.year;
    final int startYear = _expenseBillDesc.isNotEmpty ? _expenseBillDesc.last.ts.year : currentYear;
    for (int year = startYear; year <= currentYear; year++) {
      years.add(year);
    }
    return years;
  }

  List<int> _getMonth(List<ExpenseRecord> _expenseBill, List<int> years, int year) {
    List<int> result = [];
    if (now.year == year) {
      for (int month = 1; month <= now.month; month++) {
        result.add(month);
      }
    } else if (years.first == year) {
      for (int month = _expenseBill.last.ts.month; month <= 12; month++) {
        result.add(month);
      }
    } else {
      result = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    }
    return result;
  }

  Widget _buildDateSelector() {
    // TODO: 支持查看全年统计, 此时 chart line 也需要修改.
    final List<int> years = _getYear(_expenseBill);
    final List<int> months = _getMonth(_expenseBill, years, selectedYear);

    // TODO: 年月不超过当前日期.
    final yearWidgets = years.map((e) => PopupMenuItem<int>(value: e, child: Text(e.toString()))).toList();
    final monthWidgets = months.map((e) => PopupMenuItem<int>(value: e, child: Text(e.toString()))).toList();

    final titleStyle = Theme.of(context).textTheme.headline2;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          PopupMenuButton(
            onSelected: (int value) => setState(() {
              selectedYear = value;
              final monthList = _getMonth(_expenseBill, years, selectedYear);
              if (!monthList.toSet().contains(selectedMonth)) {
                selectedMonth = monthList[0];
              }
            }),
            child: Text('$selectedYear 年', style: titleStyle),
            itemBuilder: (_) => yearWidgets,
          ),
          PopupMenuButton(
            onSelected: (int value) => setState(() => selectedMonth = value),
            child: Text('$selectedMonth 月', style: titleStyle),
            itemBuilder: (_) => monthWidgets,
          ),
        ],
      ),
    );
  }

  // TODO: 这个函数应该放在 DAO 或 service
  List<ExpenseRecord> _filterExpense() {
    return _expenseBill
        .where((element) => element.ts.year == selectedYear && element.ts.month == selectedMonth)
        .toList();
  }

  static int _getDayCountOfMonth(int year, int month) {
    final int daysFeb = (year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)) ? 29 : 28;
    List<int> days = [31, daysFeb, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    return days[month - 1];
  }

  Widget _buildChartView() {
    // 得到该年该月有多少天, 生成数组记录每一天的消费.
    final List<double> daysAmount = List.filled(_getDayCountOfMonth(selectedYear, selectedMonth), 0.00);
    // 便利该月消费情况, 加到上述统计列表中.
    _filterExpense().forEach((e) => daysAmount[e.ts.day - 1] += e.amount);

    if (daysAmount.every((double e) => e.abs() < 0.01)) {
      return const SizedBox(height: 70, child: Center(child: Text('该月无消费数据')));
    }

    final width = MediaQuery.of(context).size.width - 70;
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
              child: Text('支出对比', style: Theme.of(context).textTheme.headline2),
            ),
            // const SizedBox(height: 5),
            Center(
              child: SizedBox(height: width * 0.5, width: width, child: ExpenseChart(daysAmount)),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildClassifiedStat() {
    // 各分类下消费的统计
    List<double> sumByClassification = List.filled(ExpenseType.values.length, 0.0);
    for (final line in _filterExpense()) {
      sumByClassification[line.type.index] += line.amount;
    }
    double sum = sumByClassification.fold(0.0, (previousValue, element) => previousValue += element);

    return ExpenseType.values.where((element) => element != ExpenseType.all).map(
      (expenseType) {
        final double sumInType = sumByClassification[expenseType.index];
        final double percentage = sum != 0 ? sumInType / sum : 0;

        return ListTile(
          leading: buildIcon(expenseType, context),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(expenseTypeMapping[expenseType]!, style: Theme.of(context).textTheme.headline5),
              Text('  ${(percentage * 100).toStringAsFixed(2)} %'),
            ],
          ),
          subtitle: LinearProgressIndicator(value: percentage),
          // 下方 SizedBox 用于限制文字宽度, 使左侧进度条的右端对齐.
          trailing: SizedBox(width: 80, child: Text('￥${sumInType.toStringAsFixed(2)}')),
          dense: true,
        );
      },
    ).toList();
  }

  Widget _buildClassificationView() {
    return Card(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
            child: Text('支出分类', style: Theme.of(context).textTheme.headline2),
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
