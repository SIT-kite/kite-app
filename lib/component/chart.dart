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
        ///触摸控制
        lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(tooltipBgColor: Colors.transparent), touchSpotThreshold: 10),
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
              color: Theme.of(context).secondaryHeaderColor,
            ),
            spots: spots,
            color: primaryColor,
            preventCurveOverShooting: false,
            // isCurved: true,//我觉得折线图更好看一点
            barWidth: 2,
            preventCurveOvershootingThreshold: 3.0,
          ),
        ],
        titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(),
            leftTitles: AxisTitles(),
            topTitles: AxisTitles(),
            bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 25))),
      ),
    );
  }
}
