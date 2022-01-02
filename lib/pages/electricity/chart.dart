import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showDays = false;
  List<String> daysBottomTitles = [];
  List<String> hoursBottomTitles = [];
  List<Map<String, dynamic>> hoursData = [
    {"time": "2021-11-21 22:00", "charge": 0, "consumption": 0},
    {"time": "2021-11-21 23:00", "charge": 0, "consumption": 0.12200165},
    {"time": "2021-11-22 00:00", "charge": 0, "consumption": 0},
    {"time": "2021-11-22 01:00", "charge": 0, "consumption": 0},
    {"time": "2021-11-22 02:00", "charge": 0, "consumption": 0},
    {"time": "2021-11-22 03:00", "charge": 0, "consumption": 0},
    {"time": "2021-11-22 04:00", "charge": 0, "consumption": 0},
    {"time": "2021-11-22 05:00", "charge": 0, "consumption": 0},
    {"time": "2021-11-22 06:00", "charge": 0, "consumption": 0},
    {"time": "2021-11-22 07:00", "charge": 0, "consumption": 0.06099701},
    {"time": "2021-11-22 08:00", "charge": 0, "consumption": 0.061000824},
    {"time": "2021-11-22 09:00", "charge": 0, "consumption": 0.061000824},
    {"time": "2021-11-22 10:00", "charge": 0, "consumption": 0.12200165},
    {"time": "2021-11-22 11:00", "charge": 0, "consumption": 0},
    {"time": "2021-11-22 12:00", "charge": 0, "consumption": 0},
    {"time": "2021-11-22 13:00", "charge": 0, "consumption": 0},
    {"time": "2021-11-22 14:00", "charge": 0, "consumption": 0},
    {"time": "2021-11-22 15:00", "charge": 0, "consumption": 0.12199783},
    {"time": "2021-11-22 16:00", "charge": 0, "consumption": 0.12200165},
    {"time": "2021-11-22 17:00", "charge": 0, "consumption": 0.6100006},
    {"time": "2021-11-22 18:00", "charge": 0, "consumption": 0.18299866},
    {"time": "2021-11-22 19:00", "charge": 0, "consumption": 0.061000824},
    {"time": "2021-11-22 20:00", "charge": 0, "consumption": 0.06099701},
    {"time": "2021-11-22 21:00", "charge": 0, "consumption": 0.12200165},
    {"time": "2021-11-22 22:00", "charge": 0, "consumption": 0.12200165}
  ];
  List<Map<String, dynamic>> daysData = [
    {"date": "2021-11-15", "charge": 0, "consumption": 1.4640007},
    {"date": "2021-11-16", "charge": 0, "consumption": 1.341999},
    {"date": "2021-11-17", "charge": 0, "consumption": 1.2200012},
    {"date": "2021-11-18", "charge": 0, "consumption": 1.9519997},
    {"date": "2021-11-19", "charge": 0, "consumption": 1.0979996},
    {"date": "2021-11-20", "charge": 0, "consumption": 0.8540001},
    {"date": "2021-11-21", "charge": 0, "consumption": 1.8300018},
    {"date": "2021-11-22", "charge": 0, "consumption": 1.6469994}
  ];

  List<FlSpot> hoursAxisYData = [];
  List<FlSpot> daysAxisYData = [];

  initHoursAxisYData(List<Map<String, dynamic>> hoursData) {
    for (int i = 0; i < hoursData.length; i++) {
      hoursAxisYData
          .add((FlSpot(i.toDouble(), hoursData[i]['consumption'] / 0.15)));
    }
  }

  initDaysAxisYData(List<Map<String, dynamic>> daysData) {
    for (int i = 0; i < daysData.length; i++) {
      daysAxisYData.add((FlSpot(i.toDouble(), daysData[i]['consumption'])));
    }
  }

  initHoursBottomTitles(List<Map<String, dynamic>> hoursData) {
    for (int i = 0; i < hoursData.length; i++) {
      hoursBottomTitles.add(hoursData[i]['time'].substring(11));
    }
  }

  initdaysBottomTitles(List<Map<String, dynamic>> daysData) {
    for (int i = 0; i < daysData.length; i++) {
      daysBottomTitles.add(daysData[i]['date'].substring(5));
    }
  }

  @override
  _ChartState() {
    initHoursAxisYData(hoursData);
    initDaysAxisYData(daysData);
    initHoursBottomTitles(hoursData);
    initdaysBottomTitles(daysData);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            decoration: const BoxDecoration(color: Color(0xff232d37)),
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 22.0, left: 2.0, top: 30, bottom: 2),
              child: LineChart(
                showDays ? daysChart() : hoursChart(),
              ),
            ),
          ),
        ),
        SizedBox(
            width: null,
            height: 34,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    showDays = !showDays;
                  });
                },
                child: Row(children: [
                  Text(
                    '过去一天',
                    style:  TextStyle(fontSize: 12, color: showDays? Colors.grey : Colors.blue),
                  ),
                  Text(
                    ' / ',
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  Text(
                    '过去一周',
                    style:  TextStyle(fontSize: 12, color: showDays? Colors.blue : Colors.grey),
                  )
                ]),
              ),
            ])),
      ],
    );
  }

  LineChartData daysChart() {
    return LineChartData(
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
          reservedSize: 22,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 14),
          getTitles: (value) {
            return daysBottomTitles[value.toInt()];
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          interval: 1,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 1:
                return '1.00';
              case 2:
                return '2.00';
              case 3:
                return '3.00';
              case 4:
                return '4.00';
            }
            return '';
          },
          reservedSize: 32,
          margin: 12,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 7,
      minY: 0,
      maxY: 4.50,
      lineBarsData: [
        LineChartBarData(
          spots: daysAxisYData,
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  LineChartData hoursChart() {
    return LineChartData(
      lineTouchData: LineTouchData(touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
        return touchedSpots.map((LineBarSpot touchedSpot) {
          final textStyle = TextStyle(
            color: touchedSpot.bar.colors[0],
            fontWeight: FontWeight.bold,
            fontSize: 14,
          );
          return LineTooltipItem(
              (touchedSpot.y * 0.15).toStringAsFixed(3), textStyle);
        }).toList();
      })),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (context, value) => const TextStyle(
              color: Color(0xff68737d),
              fontWeight: FontWeight.bold,
              fontSize: 14),
          getTitles: (value) {
            return hoursBottomTitles[value.toInt()];
          },
          margin: 8,
          interval: 3,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 1:
                return '0.15';
              case 2:
                return '0.30';
              case 3:
                return '0.45';
              case 4:
                return '0.60';
              case 5:
                return '0.75';
              case 6:
                return '0.90';
            }
            return '';
          },
          reservedSize: 32,
          interval: 1,
          margin: 12,
        ),
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 24,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: hoursAxisYData,
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}
