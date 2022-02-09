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
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpenseChart extends StatelessWidget {
  final List<double> dailyExpense;

  const ExpenseChart(this.dailyExpense, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    final expenseMapping = dailyExpense.asMap();
    final spots = expenseMapping.keys.map((i) => FlSpot((i + 1).toDouble(), expenseMapping[i] ?? 0.0)).toList();

    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(touchTooltipData: LineTouchTooltipData(tooltipBgColor: primaryColor)),
        borderData: FlBorderData(
          border: const Border(
            bottom: BorderSide(width: 1.0),
          ),
        ),
        lineBarsData: [
          // 每一个 LineChartBarData 代表一条曲线.
          LineChartBarData(
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              colors: [Theme.of(context).secondaryHeaderColor],
            ),
            spots: spots,
            colors: [primaryColor],
            preventCurveOverShooting: false,
            // isCurved: true,//我觉得折线图更好看一点
            barWidth: 2,
            preventCurveOvershootingThreshold: 3.0,
          ),
        ],
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: primaryColor,
              strokeWidth: 1,
              dashArray: [20, 10],
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: SideTitles(showTitles: false),
          leftTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false),
        ),
      ),
    );
  }
}
