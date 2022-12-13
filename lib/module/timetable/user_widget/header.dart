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
import 'package:rettulf/rettulf.dart';
import '../using.dart';

class TimetableHeader extends StatefulWidget {
  final List<String> dayHeaders;

  /// 当前显示的周次
  final int currentWeek;

  /// 当前初始选中的日 (1-7)
  final int selectedDay;

  /// 点击的回调
  final Function(int)? onDayTap;

  final DateTime startDate;
  final bool leadingSpace;

  const TimetableHeader({
    super.key,
    required this.dayHeaders,
    required this.currentWeek,
    required this.selectedDay,
    required this.startDate,
    this.leadingSpace = false,
    this.onDayTap,
  });

  @override
  State<StatefulWidget> createState() => _TimetableHeaderState();
}

class _TimetableHeaderState extends State<TimetableHeader> {
  int get selectedDay => widget.selectedDay;

  @override
  void initState() {
    super.initState();
  }

  Widget buildDayHeader(BuildContext ctx, int day, String name) {
    final isSelected = day == selectedDay;
    final textNBgColors = ctx.makeTabHeaderTextNBgColors(isSelected);
    final textColor = textNBgColors.item1;
    final bgColor = textNBgColors.item2;

    return AnimatedContainer(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: Colors.black12, width: 0.8),
      ),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.fastLinearToSlowEaseIn,
      child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor),
          )),
    );
  }

  Widget buildLeadingSpace() {
    return Expanded(flex: 2, child: Container());
  }

  ///每天的列
  Widget buildDayNameHeader(int day) {
    final date = getDateFromWeekDay(widget.startDate, widget.currentWeek, day);
    final dateString = '${date.month}/${date.day}';
    final onDayTap = widget.onDayTap;
    return Expanded(
      flex: 3,
      child: InkWell(
          onTap: onDayTap != null
              ? () {
                  widget.onDayTap?.call(day);
                }
              : null,
          child: buildDayHeader(context, day, '${widget.dayHeaders[day - 1]}\n$dateString')),
    );
  }

  /// 布局标题栏下方的时间选择行
  ///
  /// 将该行分为 2 + 7 * 3 一共 23 个小份, 左侧的周数占 2 份, 每天的日期占 3 份.
  @override
  Widget build(BuildContext context) {
    final columns = <Widget>[if (widget.leadingSpace) buildLeadingSpace()];
    for (int i = 1; i <= 7; ++i) {
      columns.add(buildDayNameHeader(i));
    }
    return Row(children: columns);
  }
}
