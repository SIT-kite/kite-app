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
import 'package:kite/entity/sc/score.dart';

class SummaryCard extends StatelessWidget {
  final ScScoreSummary summary;

  const SummaryCard(this.summary, {Key? key}) : super(key: key);

  FlBorderData borderData() => FlBorderData(show: false);

  FlGridData gridData() => FlGridData(show: false);

  BarTouchData barTouchData() => BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.y.round().toString(),
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  FlTitlesData titlesData(List<String> titles) => FlTitlesData(
        show: true,
        leftTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => const TextStyle(
            color: Color(0xff7589a2),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (index) => titles[index.toInt()],
        ),
      );

  Widget _buildChart() {
    final scoreValues = [
      summary.campusCulture,
      summary.charity,
      summary.creativity,
      summary.safetyCivilization,
      summary.socialPractice,
      summary.themeReport
    ];
    final totals = [2, 2, 2, 2, 2, 2];
    const scoreTitles = ['校园\n文化', '志愿', '三创', '安全\n教育', '社会\n实践', '讲座'];

    List<BarChartGroupData> values = [];
    for (int i = 0; i < scoreValues.length; ++i) {
      values.add(BarChartGroupData(x: i, barRods: [BarChartRodData(y: scoreValues[i] / totals[i], width: 12)]));
    }
    return BarChart(
      BarChartData(
        maxY: 1,
        barGroups: values,
        borderData: borderData(),
        gridData: gridData(),
        barTouchData: barTouchData(),
        titlesData: titlesData(scoreTitles),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.8,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: _buildChart(),
        ),
      ),
    );
  }
}
