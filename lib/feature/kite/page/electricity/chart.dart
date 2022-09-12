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
import 'package:intl/intl.dart';
import 'package:kite/component/chart.dart';
import 'package:kite/feature/kite/page/electricity/rank.dart';

import '../../../../component/future_builder.dart';
import '../../entity/electricity.dart';
import '../../init.dart';

/* const List<Color> _gradientColors = [
  Color(0xff23b6e6),
  Color(0xff02d39a),
]; */

class ChartSection extends StatefulWidget {
  final String room;

  const ChartSection(this.room, {Key? key}) : super(key: key);

  @override
  _ChartSectionState createState() => _ChartSectionState(room);
}

class _ChartSectionState extends State<ChartSection> {
  final String room;
  bool isShowDays = false;

  _ChartSectionState(this.room);

  Widget _buildModeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () => setState(() {
            isShowDays = !isShowDays;
          }),
          child: Row(
            children: [
              Text('过去一天', style: TextStyle(fontSize: 20, color: isShowDays ? Colors.grey : Colors.blue)),
              const Text(' / ', style: TextStyle(fontSize: 20, color: Colors.black)),
              Text('过去一周', style: TextStyle(fontSize: 20, color: isShowDays ? Colors.blue : Colors.grey))
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildView({List<HourlyBill>? hour, List<DailyBill>? day}) {
    List<double> list = [0];
    List<String>? timeList;

    if (hour != null) {
      list = hour.map((e) => e.consumption.toStringAsFixed(2)).map((e) => double.parse(e)).toList();
      timeList = hour.map((e) => DateFormat('HH:mm').format(e.time)).toList();
    }
    if (day != null) {
      list = day.map((e) => e.consumption.toStringAsFixed(2)).map((e) => double.parse(e)).toList();
      timeList = day.map((e) => DateFormat('MM-dd').format(e.date)).toList();
    }

    Widget bottomTitle(double value, TitleMeta mate) {
      const style = TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
        fontSize: 12,
      );

      String text;
      text = timeList![value.toInt()];
      return SideTitleWidget(
        axisSide: mate.axisSide,
        child: Text(text, style: style),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          isShowDays ? const Text('📒过去一周电费消耗金额统计图') : const Text('📒过去一天电费消耗金额统计图'),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 1.70,
            child: Padding(
                padding: const EdgeInsets.only(right: 24, left: 24, top: 0, bottom: 0),
                child: ExpenseChart(
                  list,
                  bottomTitle: bottomTitle,
                  // xAxis: timeList,
                  isZero: true,
                )),
          ),
          _buildModeSelector(),
          const SizedBox(height: 20),
          isShowDays ? const SizedBox() : RankView(room)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isShowDays) {
      return MyFutureBuilder<List<DailyBill>>(
          futureGetter: () => KiteInitializer.electricityService.getDailyBill(room),
          builder: (context, data) {
            return _buildView(day: data);
          });
    }
    return MyFutureBuilder<List<HourlyBill>>(
        futureGetter: () => KiteInitializer.electricityService.getHourlyBill(room),
        builder: (context, data) {
          return _buildView(hour: data);
        });
  }
}
