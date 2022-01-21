import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kite/entity/electricity.dart';

const List<Color> _gradientColors = [
  Color(0xff23b6e6),
  Color(0xff02d39a),
];

class Chart extends StatefulWidget {
  final List<ConditionHours> hoursList;
  final List<ConditionDays> daysList;

  const Chart(this.hoursList, this.daysList, {Key? key}) : super(key: key);

  @override
  _ChartState createState() => _ChartState(hoursList, daysList);
}

class _ChartState extends State<Chart> {
  final List<ConditionHours> hoursList;
  final List<ConditionDays> daysList;
  bool isShowDays = false;

  @override
  _ChartState(this.hoursList, this.daysList);

  List<String> _getBottomTitles() {
    List<String> bottomTitles;
    if (isShowDays)
      bottomTitles = daysList.map((item) => item.date).toList();
    else
      bottomTitles = hoursList.map((item) => item.time).toList();

    return bottomTitles;
  }

  List<FlSpot> _getAxisYData() {
    List<FlSpot> axisYData;

    if (isShowDays) {
      int count = 0;
      axisYData = daysList.map((item) {
        return FlSpot((count++).toDouble(), item.consumption);
      }).toList();
    } else {
      int count = 0;
      axisYData = hoursList.map((item) {
        return FlSpot((count++).toDouble(), item.consumption);
      }).toList();
    }
    return axisYData;
  }

  double _getMaxY() {
    double maxY = 0;
    if (isShowDays) {
      daysList.forEach((item) {
        maxY = maxY > item.consumption ? maxY : item.consumption;
      });
    } else {
      hoursList.forEach((item) {
        maxY = maxY > item.consumption ? maxY : item.consumption;
      });
    }
    return maxY;
  }

  LineChart _buildLineChart(bottomTitles) {
    return LineChart(LineChartData(
      lineTouchData: LineTouchData(touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
        return touchedSpots.map((LineBarSpot touchedSpot) {
          final textStyle = TextStyle(
            color: touchedSpot.bar.colors[0],
            fontWeight: FontWeight.bold,
            fontSize: 14,
          );
          return LineTooltipItem(touchedSpot.y.toStringAsFixed(3), textStyle);
        }).toList();
      })),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 20,
          interval: isShowDays ? 1 : 3,
          getTextStyles: (context, value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 14),
          getTitles: (value) => bottomTitles.length == 8 && value.toInt() > 7
              ? ''
              : bottomTitles[value.toInt()],
          margin: 4,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) => value.toInt().toString(),
          reservedSize: 0,
          margin: 8,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: isShowDays ? 7 : 24,
      minY: 0,
      maxY: _getMaxY() == 0? 1 : _getMaxY(),
      lineBarsData: [
        LineChartBarData(
          spots: _getAxisYData(),
          isCurved: true,
          colors: _gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                _gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            // decoration: const BoxDecoration(
            //   color: Colors.white,
            // ),
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 24, left: 24, top: 0, bottom: 0),
              child: _buildLineChart(_getBottomTitles()),
            ),
          ),
        ),
        Container(
          // color: Colors.white,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextButton(
              onPressed: () => setState(() {
                isShowDays = !isShowDays;
              }),
              child: Row(children: [
                Text(
                  '过去一天',
                  style: TextStyle(
                      fontSize: 20,
                      color: isShowDays ? Colors.grey : Colors.blue),
                ),
                const Text(
                  ' / ',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                Text(
                  '过去一周',
                  style: TextStyle(
                      fontSize: 20,
                      color: isShowDays ? Colors.blue : Colors.grey),
                )
              ]),
            ),
          ]),
        )
      ],
    );
  }
}
