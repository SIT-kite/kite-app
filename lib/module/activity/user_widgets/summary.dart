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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/score.dart';
import '../using.dart';

ScScoreSummary calcTargetScore(int admissionYear) {
  const table = {
    2013: ScScoreSummary(lecture: 1, campus: 1),
    2014: ScScoreSummary(lecture: 1, practice: 1, campus: 1),
    2015: ScScoreSummary(lecture: 1, practice: 1, creation: 1, campus: 1),
    2016: ScScoreSummary(lecture: 1, practice: 1, creation: 1, campus: 1),
    2017: ScScoreSummary(lecture: 1.5, practice: 2, creation: 1.5, safetyEdu: 1, campus: 2),
    2018: ScScoreSummary(lecture: 1.5, practice: 2, creation: 1.5, safetyEdu: 1, campus: 2),
    2019: ScScoreSummary(lecture: 1.5, practice: 2, creation: 1.5, safetyEdu: 1, voluntary: 1, campus: 1),
    2020: ScScoreSummary(lecture: 1.5, practice: 2, creation: 1.5, safetyEdu: 1, voluntary: 1, campus: 1),
  };
  if (table.keys.contains(admissionYear)) {
    return table[admissionYear]!;
  } else {
    return table[2020]!;
  }
}

FlBorderData _borderData() => FlBorderData(show: false);

FlGridData _gridData() => FlGridData(show: false);

BarTouchData _barTouchData() => BarTouchData(
      enabled: false,
      /*touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.transparent,
        tooltipPadding: const EdgeInsets.all(0),
        tooltipMargin: 0,
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
      ),*/
    );

Widget _buildChart(BuildContext ctx, ScScoreSummary targetScore, ScScoreSummary? summary, {bool showTotal = false}) {
  if (summary == null) {
    return Placeholders.loading();
  }
  List<double> buildScoreList(ScScoreSummary scss) {
    return [scss.voluntary, scss.campus, scss.creation, scss.safetyEdu, scss.lecture, scss.practice];
  }

  final scoreValues = buildScoreList(summary);
  final totals = buildScoreList(targetScore);
  final scoreTitles = (const ['志愿', '校园文化', '三创', '安全文明', '讲座', '社会实践']).asMap().entries.map((e) {
    int index = e.key;
    String text = e.value;
    if (showTotal) {
      return '$text\n${scoreValues[index]}\n⎯⎯⎯\n${totals[index]}';
    } else {
      return '$text\n${scoreValues[index]}';
    }
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
  final titlesData = FlTitlesData(
    show: true,
    leftTitles: AxisTitles(),
    topTitles: AxisTitles(),
    rightTitles: AxisTitles(),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: showTotal ? 84 : 36,
        getTitlesWidget: (double value, TitleMeta meta) {
          const style = TextStyle(
            color: Color(0xff7589a2),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          );
          return Text(
            scoreTitles[value.toInt()],
            textAlign: TextAlign.center,
            style: style,
          );
        },
      ),
    ),
  );
  return BarChart(
    BarChartData(
      maxY: 1,
      barGroups: values,
      borderData: _borderData(),
      gridData: _gridData(),
      barTouchData: _barTouchData(),
      titlesData: titlesData,
    ),
  );
}

Widget buildSummeryCard(BuildContext ctx, ScScoreSummary targetScore, ScScoreSummary? summery) {
  if (ctx.isPortrait) {
    return AspectRatio(
      aspectRatio: 1.8,
      child: Card(
        child: _buildChart(ctx, targetScore, summery).padSymmetric(v: 12),
      ),
    );
  } else {
    return [
      i18n.activityMyScoreTitle.text(style: ctx.textTheme.headline1).padFromLTRB(8, 24, 8, 0),
      _buildChart(ctx, targetScore, summery, showTotal: true)
          .padSymmetric(v: 12)
          .inCard(elevation: 8)
          .padSymmetric(v: 12.w, h: 8.h)
          .expanded()
    ].column(maa: MainAxisAlignment.spaceEvenly);
  }
}
