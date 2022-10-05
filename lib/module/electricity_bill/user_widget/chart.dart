/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:flutter/material.dart';

import '../entity/statistics.dart';
import '../init.dart';
import '../using.dart';
import 'daily_chart.dart';
import 'hourly_chart.dart';

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
        i18n.elecBillHourlyChart24.txt,
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
        i18n.elecBillDailyChart7.txt,
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
          future: ElectricityBillInit.electricityService.getDailyBill(room),
          builder: (context, data) {
            return buildDailyChart(data);
          },
        );
      case ElectricityChartMode.hourly:
        return MyFutureBuilder<List<HourlyBill>>(
          future: ElectricityBillInit.electricityService.getHourlyBill(room),
          builder: (context, data) {
            return buildHourlyChart(data);
          },
        );
    }
  }
}
