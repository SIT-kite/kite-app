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
import 'package:intl/intl.dart';

import '../entity/statistics.dart';
import 'base_chart.dart';

class HourlyElectricityChart extends StatelessWidget {
  final List<HourlyBill> data;
  const HourlyElectricityChart(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseElectricityChartWidget(
      values: data.map((e) => e.consumption).toList(),
      bottomTitles: data.map((e) => DateFormat('HH:mm').format(e.time)).toList(),
    );
  }
}
