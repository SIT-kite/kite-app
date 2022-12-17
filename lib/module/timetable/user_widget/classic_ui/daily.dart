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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../../cache.dart';
import '../../entity/course.dart';
import '../../entity/entity.dart';
import '../../using.dart';
import '../../utils.dart';
import 'header.dart';
import '../style.dart';
import 'sheet.dart';
import '../interface.dart';


class DailyTimetable extends StatefulWidget implements InitialTimeProtocol {
  final SitTimetable timetable;

  @override
  DateTime get initialDate => timetable.startDate;

  final ValueNotifier<TimetablePosition> $currentPos;

  @override
  State<StatefulWidget> createState() => DailyTimetableState();

  const DailyTimetable({
    super.key,
    required this.timetable,
    required this.$currentPos,
  });
}

class DailyTimetableState extends State<DailyTimetable> {
  SitTimetable get timetable => widget.timetable;

  TimetablePosition get currentPos => widget.$currentPos.value;

  set currentPos(TimetablePosition newValue) => widget.$currentPos.value = newValue;

  /// 翻页控制
  late PageController _pageController;

  int pos2PageOffset(TimetablePosition pos) => (pos.week - 1) * 7 + pos.day - 1;

  TimetablePosition page2Pos(int page) {
    final week = page ~/ 7 + 1;
    final day = page % 7 + 1;
    return TimetablePosition(week: week, day: day);
  }

  TimetablePosition? _lastPos;
  bool isJumping = false;

  @override
  void initState() {
    super.initState();
    final pos = widget.locateInTimetable(DateTime.now());
    _pageController = PageController(initialPage: pos2PageOffset(pos))..addListener(onPageChange);
    widget.$currentPos.addListener(() {
      final curPos = widget.$currentPos.value;
      if (_lastPos != curPos) {
        jumpTo(curPos);
        _lastPos = curPos;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final targetOffset = pos2PageOffset(currentPos);
      final currentOffset = _pageController.page?.round() ?? targetOffset;
      if (currentOffset != targetOffset) {
        _pageController.jumpToPage(targetOffset);
      }
    });
    final dayHeaders = makeWeekdaysShortText();
    final side = getBorderSide(context);
    final weekdayNames = makeWeekdaysText();
    return [
      widget.$currentPos <<
          (ctx, cur, _) => TimetableHeader(
                dayHeaders: dayHeaders,
                selectedDay: cur.day,
                currentWeek: cur.week,
                startDate: widget.initialDate,
                onDayTap: (selectedDay) {
                  currentPos = TimetablePosition(week: cur.week, day: selectedDay);
                },
              )
                  .container(decoration: BoxDecoration(border: Border(top: side, bottom: side, right: side)))
                  .flexible(flex: 2),
      NotificationListener<ScrollNotification>(
          onNotification: (e) {
            if (e is ScrollEndNotification) {
              isJumping = false;
            }
            return false;
          },
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            // TODO: 存储
            itemCount: 20 * 7,
            itemBuilder: (_, int index) => _buildPage(context, index, weekdayNames),
          )).flexible(flex: 10)
    ].column();
  }

  void onPageChange() {
    if (!isJumping) {
      setState(() {
        final page = (_pageController.page ?? 0).round();
        final newPos = page2Pos(page);
        if (currentPos != newPos) {
          currentPos = newPos;
        }
      });
    }
  }

  /// 跳转到指定星期与天
  void jumpTo(TimetablePosition pos) {
    if (_pageController.hasClients) {
      final targetOffset = pos2PageOffset(pos);
      final currentPos = _pageController.page ?? targetOffset;
      final distance = (targetOffset - currentPos).abs();
      _pageController.animateToPage(
        targetOffset,
        duration: calcuSwitchAnimationDuration(distance),
        curve: Curves.fastLinearToSlowEaseIn,
      );
      isJumping = true;
    }
  }

  /// 构建第 index 页视图
  Widget _buildPage(BuildContext ctx, int index, List<String> weekdayNames) {
    int weekIndex = index ~/ 7;
    int dayIndex = index % 7;
    final week = timetable.weeks[weekIndex];
    if (week == null) {
      return _buildFreeDayTip(ctx, weekIndex, dayIndex);
    } else {
      final day = week.days[dayIndex];
      final lessonsInDay = day.browseUniqueLessons(atLayer: 0).toList();
      if (lessonsInDay.isEmpty) {
        return _buildFreeDayTip(ctx, weekIndex, dayIndex);
      } else {
        return ListView.builder(
          controller: ScrollController(),
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          itemCount: lessonsInDay.length,
          itemBuilder: (ctx, indexOfLessons) {
            final lesson = lessonsInDay[indexOfLessons];
            final course = timetable.courseKey2Entity[lesson.courseKey];
            return LessonBlock(
              lesson: lesson,
              course: course,
              courseKey2Entity: timetable.courseKey2Entity,
              weekdayNames: weekdayNames,
            );
          },
        );
      }
    }
  }

  Widget _buildFreeDayTip(BuildContext ctx, int weekIndex, int dayIndex) {
    final todayPos = widget.locateInTimetable(DateTime.now());
    final isToday = todayPos.week == weekIndex + 1 && todayPos.day == dayIndex + 1;
    final String desc;
    if (isToday) {
      desc = i18n.timetableFreeDayIsTodayTip;
    } else {
      desc = i18n.timetableFreeDayTip;
    }
    return LeavingBlank(
      icon: Icons.free_cancellation_rounded,
      desc: desc,
      subtitle: buildJumpToNearestDayWithClassBtn(ctx, weekIndex, dayIndex),
    );
  }

  Widget buildJumpToNearestDayWithClassBtn(BuildContext ctx, int weekIndex, int dayIndex) {
    return CupertinoButton(
      onPressed: () async {
        await jumpToNearestDayWithClass(ctx, weekIndex, dayIndex);
      },
      child: i18n.timetableFindNearestDayWithClassBtn.text(),
    );
  }

  /// Find the nearest day with class forward.
  /// No need to look back to passed days, unless there's no day after [weekIndex] and [dayIndex] that has any class.
  Future<void> jumpToNearestDayWithClass(BuildContext ctx, int weekIndex, int dayIndex) async {
    for (int i = weekIndex; i < timetable.weeks.length; i++) {
      final week = timetable.weeks[i];
      if (week != null) {
        final dayIndexStart = weekIndex == i ? dayIndex : 0;
        for (int j = dayIndexStart; j < week.days.length; j++) {
          final day = week.days[j];
          if (day.hasAnyLesson(atLayer: 0)) {
            currentPos = TimetablePosition(week: i + 1, day: j + 1);
            return;
          }
        }
      }
    }
    // Now there's no class forward, so let's search backward.
    for (int i = weekIndex; 0 <= i; i--) {
      final week = timetable.weeks[i];
      if (week != null) {
        final dayIndexStart = weekIndex == i ? dayIndex : week.days.length - 1;
        for (int j = dayIndexStart; 0 <= j; j--) {
          final day = week.days[j];
          if (day.hasAnyLesson(atLayer: 0)) {
            currentPos = TimetablePosition(week: i + 1, day: j + 1);
            return;
          }
        }
      }
    }
    // WHAT? NO CLASS IN THE WHOLE TERM?
    // Alright, let's congratulate them!
    if (!mounted) return;
    await ctx.showTip(title: i18n.congratulations, desc: i18n.timetableFreeTermTip, ok: i18n.thanks);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}

class LessonBlock extends StatefulWidget {
  final SitTimetableLesson lesson;
  final SitCourse course;
  final List<SitCourse> courseKey2Entity;
  final List<String> weekdayNames;

  const LessonBlock({
    super.key,
    required this.lesson,
    required this.course,
    required this.courseKey2Entity,
    required this.weekdayNames,
  });

  @override
  State<LessonBlock> createState() => _LessonBlockState();
}

class _LessonBlockState extends State<LessonBlock> {
  static const iconSize = 45.0;

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final TextStyle? textStyle = Theme.of(context).textTheme.bodyText2;
    final Widget courseIcon = Image.asset(
      CourseCategory.iconPathOf(iconName :course.iconName),
      width: iconSize,
      height: iconSize,
    );
    final time = course.formatTime('ss - ee', basedOn: widget.lesson);
    final duration = course.duration(basedOn: widget.lesson);
    final colors = TimetableStyle.of(context).colors;
    final color = colors[course.courseCode.hashCode.abs() % colors.length].byTheme(context.theme);
    return Container(
        margin: const EdgeInsets.all(8),
        decoration: ShapeDecoration(
            color: color,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            )),
        child: ListTile(
          leading: courseIcon,
          title: Text(stylizeCourseName(course.courseName), textScaleFactor: 1.1),
          trailing: [
            Text(formatPlace(course.place), softWrap: true, overflow: TextOverflow.ellipsis, style: textStyle),
            duration.localized().text(style: textStyle, softWrap: true),
          ].column(maa:MainAxisAlignment.spaceBetween),
          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(course.teachers.join(', '), style: textStyle),
            course.localizedWeekNumbers().text(),
            time.text(style: textStyle, softWrap: true),
          ]),
        ).on(tap: () async {
          /*await showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) => Sheet(course.courseId, allCourses),
              context: context,
            );*/
        }));
  }
}
