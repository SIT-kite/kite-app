import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../component/future_builder.dart';
import '../entity.dart';
import '../init.dart';

class ElectricityChart extends StatefulWidget {
  const ElectricityChart({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ElectricityChartState();
}

class ElectricityChartState extends State<ElectricityChart> {
  bool isDaily = false;
  String get room => '10231001';

  @override
  Widget build(BuildContext context) {
    return chartCard();
  }

  ///统计图卡片
  Widget chartCard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        cardTitle('用电视图'),
        const SizedBox(height: 30),
        MyFutureBuilder<List<DailyBill>>(
          future: ElectricityInitializer.electricityService.getDailyBill(room),
          builder: (context, data) {
            return chartContent(data);
          },
        ),
      ],
    );
  }

  ///统计图内容
  Widget chartContent(List<DailyBill> data) {
    return Column(
      children: [
        Text('近7日用电消费统计图'),
        Container(
            padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
            width: 400,
            height: 200,
            child: electricityChart(data)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    isDaily = !isDaily;
                  });
                },
                icon: const Icon(Icons.change_circle),
                label: const Text(
                  '周模式',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
          ],
        )
      ],
    );
  }

  ///图表实体
  Widget electricityChart(List<DailyBill> data) {
    data.removeLast();

    List<String> timeList =
        data.map((e) => DateFormat('MM-dd').format(e.date)).toList();

    ///底部标题栏
    Widget bottomTitle(double value, TitleMeta mate) {
      const style = TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
        fontSize: 6,
      );
      String text = timeList![value.toInt()];
      return SideTitleWidget(
        axisSide: mate.axisSide,
        child: Text(text, style: style),
      );
    }

    ///左边部标题栏
    Widget leftTitle(double value, TitleMeta mate) {
      const style = TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
        fontSize: 11,
      );
      String text = value.toInt().toString();
      return SideTitleWidget(
        axisSide: mate.axisSide,
        child: Text('$text元', style: style),
      );
    }

    List<double> list = data
        .map((e) => e.consumption.toStringAsFixed(2))
        .map((e) => double.parse(e))
        .toList();

    var dataMapping = list.asMap();
    List<FlSpot> spots;
    spots = dataMapping.keys
        .map((i) => FlSpot((i).toDouble(), dataMapping[i] ?? 0.0))
        .toList();
    print(spots.toString());

    return LineChart(
      LineChartData(
        ///触摸控制
        lineTouchData: LineTouchData(
            touchTooltipData:
                LineTouchTooltipData(tooltipBgColor: Colors.transparent),
            touchSpotThreshold: 10),
        borderData: FlBorderData(
          border: const Border(
            bottom: BorderSide(width: 1.0),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).secondaryHeaderColor.withAlpha(70),
            ),
            spots: spots,
            color: Colors.blueAccent,
            preventCurveOverShooting: false,
            // isCurved: true,
            barWidth: 2,
            preventCurveOvershootingThreshold: 1.0,
          ),
        ],

        ///图表线表线框
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 2,
          verticalInterval: 1,
        ),
        titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: leftTitle)),
            topTitles: AxisTitles(),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 55,
                    getTitlesWidget: bottomTitle))),
      ),
    );
  }

  Widget cardTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
