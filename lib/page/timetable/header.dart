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

import 'package:flutter/material.dart';

import 'util.dart';

class DateHeader extends StatefulWidget {
  /// 当前显示的周次
  int currentWeek;

  /// 当前选中的日
  int selectedDay;

  DateHeader(this.currentWeek, this.selectedDay, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DateHeaderState(dateSemesterStart, currentWeek, selectedDay);
}

class _DateHeaderState extends State<DateHeader> {
  /// 学期开始日期
  final DateTime semesterBegin;

  /// 当前显示的周次
  int currentWeek;

  /// 当前选中的日
  int selectedDay = 0;

  _DateHeaderState(this.semesterBegin, this.currentWeek, this.selectedDay);

  BoxDecoration getDecoration(int day) {
    return BoxDecoration(
      color: selectedDay == day ? const Color(0x0ff4ebf5) : Colors.white,
      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
    );
  }

  Widget _buildWeekColumn() {
    final style = Theme.of(context).textTheme.bodyText2;
    return Expanded(flex: 2, child: Text('$currentWeek\n周', style: style, textAlign: TextAlign.center));
  }

  Widget _buildDayColumn(int day) {
    final date = getDateFromWeekDay(dateSemesterStart, currentWeek, day);
    final dateString = '${date.month}/${date.day}';

    final style = Theme.of(context).textTheme.bodyText2;
    return Expanded(
      flex: 3,
      child: InkWell(
        onTap: () => setState(() => selectedDay = day),
        child: Container(
          decoration: getDecoration(day),
          child: Text('周${weekWord[day - 1]}\n$dateString', style: style, textAlign: TextAlign.center),
        ),
      ),
    );
  }

  /// 布局标题栏下方的时间选择行
  ///
  /// 将该行分为 2 + 7 * 3 一共 23 个小份, 左侧的周数占 2 份, 每天的日期占 3 份.
  @override
  Widget build(BuildContext context) {
    final columns = [_buildWeekColumn()];
    for (int i = 1; i <= 7; ++i) {
      columns.add(_buildDayColumn(i));
    }
    return Row(children: columns);
  }
}
