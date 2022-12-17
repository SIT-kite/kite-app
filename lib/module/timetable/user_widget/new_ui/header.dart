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

import '../../using.dart';

class TimetableHeader extends StatefulWidget {
  final List<String> weekdayAbbr;

  /// 当前显示的周次
  final int currentWeek;

  /// 当前初始选中的日 (1-7)
  final int selectedDay;

  /// 点击的回调
  final Function(int)? onDayTap;

  final DateTime startDate;

  const TimetableHeader({
    super.key,
    required this.weekdayAbbr,
    required this.currentWeek,
    required this.selectedDay,
    required this.startDate,
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

  /// 布局标题栏下方的时间选择行
  ///
  /// 将该行分为 2 + 7 * 3 一共 23 个小份, 左侧的周数占 2 份, 每天的日期占 3 份.
  @override
  Widget build(BuildContext context) {
    return [
      for (int i = 1; i <= 7; ++i) buildDayNameHeader(i),
    ].row();
  }

  ///每天的列
  Widget buildDayNameHeader(int day) {
    final onDayTap = widget.onDayTap;
    Widget res = buildDayHeader(context, day).on(
        tap: onDayTap == null
            ? null
            : () {
                widget.onDayTap?.call(day);
              });
    res = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: res,
    );
    return res.expanded();
  }

  Widget buildDayHeader(BuildContext ctx, int day) {
    final isSelected = day == selectedDay;
    final textNBgColors = ctx.makeTabHeaderTextBgColors(isSelected);
    final textColor = textNBgColors.item1;
    final bgColor = textNBgColors.item2;

    return AnimatedSlide(
      offset: isSelected ? const Offset(0.01, -0.04) : Offset.zero,
      duration: const Duration(milliseconds: 100),
      child: AnimatedContainer(
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
        duration: const Duration(milliseconds: 1000),
        curve: Curves.fastLinearToSlowEaseIn,
        child: buildHeaderText(ctx, day, textColor),
      ).inCard(
        elevation: isSelected ? 25 : 8,
      ),
    );
  }

  Widget buildHeaderText(BuildContext ctx, int day, Color textColor) {
    final date = getDateFromWeekDay(widget.startDate, widget.currentWeek, day);
    final name = '${widget.weekdayAbbr[day - 1]}\n${date.month}/${date.day}';

    return LayoutBuilder(builder: (ctx, box) {
      final span = TextSpan(
        text: name,
      );
      final painter = TextPainter(
        text: span,
        maxLines: 2,
        textDirection: TextDirection.ltr,
      );
      painter.layout();
      final overflow = painter.size.width > box.maxWidth || painter.size.height > box.maxHeight;
      final String realText;
      if (overflow) {
        realText = widget.weekdayAbbr[day - 1][0];
      } else {
        realText = name;
      }
      return realText
          .text(
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor),
          )
          .padOnly(t: 5, b: 5);
    });
  }
}
