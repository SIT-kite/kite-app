import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../statistical.dart';

class PayLineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 第一条线
    List<FlSpot> spots1 = daysData;
    // [
    //   FlSpot(1, 1),
    //   FlSpot(2, 1.5),
    //   FlSpot(3, 1.4),
    //   FlSpot(4, 3.4),
    //   FlSpot(5, 2),
    //   FlSpot(6, 1.8),
    //   FlSpot(7, 1.8),
    //   FlSpot(8, 1.8),
    //   FlSpot(9, 1.8),
    //   FlSpot(10, 1.8),
    //   FlSpot(11, 1.8),
    //   FlSpot(12, 2.2),
    //   FlSpot(13, 1.8),
    // ];
    return LineChart(
      LineChartData(
        borderData:
            FlBorderData(border: Border(bottom: BorderSide(width: 1.0))),
        // backgroundColor: Colors.red[100],
        lineBarsData: [
          LineChartBarData(
            belowBarData: BarAreaData(
                show: true, colors: [Color.fromRGBO(228, 242, 253, 1)]),
            spots: spots1,
            colors: [Color.fromRGBO(49, 127, 227, 100)],
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
