import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'statistical.dart';

class PayLineChart extends StatelessWidget {
  const PayLineChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 第一条线
    List<FlSpot> spots1 = daysData;

    return LineChart(
      LineChartData(
        borderData: FlBorderData(border: Border(bottom: BorderSide(width: 1.0))),
        // backgroundColor: Colors.red[100],
        lineBarsData: [
          LineChartBarData(
            belowBarData: BarAreaData(show: true, colors: [const Color.fromRGBO(228, 242, 253, 1)]),
            spots: spots1,
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
