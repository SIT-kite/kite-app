import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpenseChart extends StatelessWidget {
  final List<double> dailyExpense;

  const ExpenseChart(this.dailyExpense, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final expenseMapping = dailyExpense.asMap();
    final spots = expenseMapping.keys
        .map((i) => FlSpot((i + 1).toDouble(), expenseMapping[i] ?? 0.0))
        .toList();

    return LineChart(
      LineChartData(
        borderData: FlBorderData(
          border: const Border(
            bottom: BorderSide(width: 1.0),
          ),
        ),
        lineBarsData: [
          // 每一个 LineChartBarData 代表一条曲线.
          LineChartBarData(
            belowBarData: BarAreaData(
              show: true,
              colors: [
                const Color.fromRGBO(228, 242, 253, 1),
              ],
            ),
            spots: spots,
            colors: [const Color.fromRGBO(49, 127, 227, 100)],
            preventCurveOverShooting: false,
            isCurved: true,
            barWidth: 3,
            preventCurveOvershootingThreshold: 3.0,
          ),
        ],
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.blue[100],
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
