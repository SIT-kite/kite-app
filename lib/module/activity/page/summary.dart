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

import '../entity/score.dart';
import '../using.dart';

ScScoreSummary calcTargetScore(String username) {
  int year = int.parse(username.substring(0, 2));
  const table = {
    13: ScScoreSummary(lecture: 1, campus: 1),
    14: ScScoreSummary(lecture: 1, practice: 1, campus: 1),
    15: ScScoreSummary(lecture: 1, practice: 1, creation: 1, campus: 1),
    16: ScScoreSummary(lecture: 1, practice: 1, creation: 1, campus: 1),
    17: ScScoreSummary(lecture: 1.5, practice: 2, creation: 1.5, safetyEdu: 1, campus: 2),
    18: ScScoreSummary(lecture: 1.5, practice: 2, creation: 1.5, safetyEdu: 1, campus: 2),
    19: ScScoreSummary(lecture: 1.5, practice: 2, creation: 1.5, safetyEdu: 1, voluntary: 1, campus: 1),
    20: ScScoreSummary(lecture: 1.5, practice: 2, creation: 1.5, safetyEdu: 1, voluntary: 1, campus: 1),
  };
  if (table.keys.contains(year)) {
    return table[year]!;
  } else {
    return table[20]!;
  }
}

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
              rod.toY.round().toString(),
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
        leftTitles: AxisTitles(),
        topTitles: AxisTitles(),
        rightTitles: AxisTitles(),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 36,
            getTitlesWidget: (double value, TitleMeta meta) {
              const style = TextStyle(
                color: Color(0xff7589a2),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              );
              return Text(
                titles[value.toInt()],
                textAlign: TextAlign.center,
                style: style,
              );
            },
          ),
        ),
      );

  Widget _buildChart() {
    List<double> buildScoreList(ScScoreSummary scss) {
      return [scss.voluntary, scss.campus, scss.creation, scss.safetyEdu, scss.lecture, scss.practice];
    }

    final scoreValues = buildScoreList(summary);
    final totals = buildScoreList(calcTargetScore(Kv.auth.currentUsername!));
    final scoreTitles = ['志愿', '校园文化', '三创', '安全文明', '讲座', '社会实践'].asMap().entries.map((e) {
      int index = e.key;
      String text = e.value;
      return '$text\n'
          '${scoreValues[index]}/${totals[index]}';
    }).toList();

    List<BarChartGroupData> values = [];
    for (int i = 0; i < scoreValues.length; ++i) {
      if (totals[i] == 0) {
        continue;
      }
      values.add(BarChartGroupData(x: i, barRods: [
        BarChartRodData(
          toY: scoreValues[i] / totals[i],
          width: 12,
        )
      ]));
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
