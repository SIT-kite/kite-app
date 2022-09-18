import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kite/feature/electricity/page/component/hourly_chart.dart';

import '../../../../component/future_builder.dart';
import '../../entity.dart';
import '../../init.dart';
import 'daily_chart.dart';

enum ElectricityChartMode { daily, hourly }

class ElectricityChartWidget extends StatelessWidget {
  final ElectricityChartMode mode;
  final String room;

  const ElectricityChartWidget({
    Key? key,
    required this.mode,
    required this.room,
  }) : super(key: key);

  /// 小时模式
  Widget buildHourlyChart(List<HourlyBill> data) {
    data.removeLast();
    return Column(
      children: [
        const Text('近24小时用电消费统计图'),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
          width: 400,
          height: 200,
          child: HourlyElectricityChart(data),
        ),
      ],
    );
  }

  /// 天模式
  Widget buildDailyChart(List<DailyBill> data) {
    data.removeLast();
    return Column(
      children: [
        const Text('近7日用电消费统计图'),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
          width: 400,
          height: 200,
          child: DailyElectricityChart(data),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case ElectricityChartMode.daily:
        return MyFutureBuilder<List<DailyBill>>(
          future: ElectricityInitializer.electricityService.getDailyBill(room),
          builder: (context, data) {
            return buildDailyChart(data);
          },
        );
      case ElectricityChartMode.hourly:
        return MyFutureBuilder<List<HourlyBill>>(
          future: ElectricityInitializer.electricityService.getHourlyBill(room),
          builder: (context, data) {
            return buildHourlyChart(data);
          },
        );
    }
  }
}
