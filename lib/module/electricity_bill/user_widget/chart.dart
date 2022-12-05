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

import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/statistics.dart';
import '../init.dart';
import '../using.dart';
import 'card.dart';
import 'daily_chart.dart';
import 'hourly_chart.dart';

enum ElectricityChartMode { daily, hourly }

class ElectricityChart extends StatefulWidget {
  final String? room;

  const ElectricityChart({super.key, required this.room});

  @override
  ElectricityChartState createState() => ElectricityChartState();
}

class ElectricityChartState extends State<ElectricityChart> {
  ElectricityChartMode mode = ElectricityChartMode.hourly;
  List<HourlyBill>? hourlyBill;
  List<DailyBill>? dailyBill;

  /// 小时模式
  Widget buildHourlyChart(BuildContext ctx) {
    final bill = hourlyBill;
    return Column(children: [
      i18n.elecBillHourlyChart24.text(),
      _buildHourlyChartContent(ctx, bill)
          .padFromLTRB(0, 20, 10, 0)
          .container(
            width: 400,
            height: 200,
          )
          .padV(20)
    ]);
  }

  Widget _buildHourlyChartContent(BuildContext ctx, List<HourlyBill>? bill) {
    if (bill == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return HourlyElectricityChart(bill);
  }

  /// 天模式
  Widget buildDailyChart(BuildContext ctx) {
    return Column(children: [
      i18n.elecBillDailyChart7.text(),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Container(
              padding: const EdgeInsets.fromLTRB(0, 20, 10, 0),
              width: 400,
              height: 200,
              child: _buildDailyChartContent(ctx, dailyBill)))
    ]);
  }

  Widget _buildDailyChartContent(BuildContext ctx, List<DailyBill>? bill) {
    if (bill == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return DailyElectricityChart(bill);
  }

  Widget _buildChartInCurrentMode(BuildContext context) {
    // TODO: cache this
    switch (mode) {
      case ElectricityChartMode.daily:
        return buildDailyChart(context);
      case ElectricityChartMode.hourly:
        return buildHourlyChart(context);
    }
  }

  void onSetMode(ElectricityChartMode newMode) async {
    if (newMode == mode) return;
    var room = widget.room;
    setState(() {
      dailyBill = null;
      hourlyBill = null;
    });
    if (room != null) {
      if (newMode == ElectricityChartMode.daily) {
        final newDailyBill = await ElectricityBillInit.electricityService.getDailyBill(room);
        setState(() {
          dailyBill = newDailyBill;
          mode = newMode;
        });
      } else {
        final newHourlyBill = await ElectricityBillInit.electricityService.getHourlyBill(room);
        setState(() {
          hourlyBill = newHourlyBill;
          mode = newMode;
        });
      }
    } else {
      setState(() {
        mode = newMode;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        cardTitle(i18n.elecBillElecChart),
        const SizedBox(height: 20),
        SizedBox(
            width: 300.w,
            child: AnimatedButtonBar(
              radius: 20,
              invertedSelection: true,
              foregroundColor: context.isDarkMode ? null : context.themeColor,
              children: [
                ButtonBarEntry(
                    onTap: () => onSetMode(ElectricityChartMode.hourly), child: i18n.elecBillLast24Hour.text()),
                ButtonBarEntry(onTap: () => onSetMode(ElectricityChartMode.daily), child: i18n.elecBillLast7Day.text()),
              ],
            )),
        const SizedBox(height: 20),
        _buildChartInCurrentMode(context),
        const SizedBox(height: 5),
      ],
    );
  }
}
