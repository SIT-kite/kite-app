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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kite/module/freshman/entity/relationship.dart';
import 'package:kite/module/timetable/events.dart';
import 'package:rettulf/rettulf.dart';

import '../../cache.dart';
import '../../entity/course.dart';
import '../../entity/entity.dart';
import '../../using.dart';
import '../../utils.dart';
import 'header.dart';
import '../style.dart';
import '../classic_ui/sheet.dart';
import '../interface.dart';
import 'shared.dart';

const String _courseIconPath = 'assets/course/';

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

  @override
  void initState() {
    super.initState();
    final pos = widget.locateInTimetable(DateTime.now());
    _pageController = PageController(initialPage: pos2PageOffset(pos))..addListener(onPageChange);
    eventBus.on<JumpToPosEvent>().listen((event) {
      jumpTo(event.where);
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
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      itemCount: 20 * 7,
      itemBuilder: (_, int index) => _buildPage(context, index),
    );
  }

  /// 构建第 index 页视图
  Widget _buildPage(BuildContext ctx, int index) {
    int weekIndex = index ~/ 7;
    int dayIndex = index % 7;
    final week = timetable.weeks[weekIndex];
    if (week == null) {
      return _buildFreeDayTip(ctx, weekIndex, dayIndex);
    } else {
      final day = week.days[dayIndex];
      if (!day.hasAnyLesson()) {
        return _buildFreeDayTip(ctx, weekIndex, dayIndex);
      } else {
        final rows = <Widget>[];
        rows.add(const SizedBox(height: 60));
        for (int timeslot = 0; timeslot < day.timeslots2Lessons.length; timeslot++) {
          rows.add(buildLessonsInTimeslot(ctx, day.timeslots2Lessons[timeslot], timeslot));
        }
        // Since the course list is small, no need to use [ListView.builder].
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: rows,
        );
      }
    }
  }

  Widget buildLessonsInTimeslot(BuildContext ctx, List<SitTimetableLesson> lessonsInSlot, int timeslot) {
    if (lessonsInSlot.isEmpty) {
      return SizedBox();
    } else if (lessonsInSlot.length == 1) {
      final lesson = lessonsInSlot[0];
      return buildSingleLesson(ctx, lesson, timeslot);
    } else {
      for (int lessonIndex = 0; lessonIndex < lessonsInSlot.length; lessonIndex++) {
        // TODO: Lesson overlap.
      }
      final lesson = lessonsInSlot[0];
      return buildSingleLesson(ctx, lesson, timeslot);
    }
  }

  Widget buildSingleLesson(BuildContext ctx, SitTimetableLesson lesson, int timeslot) {
    final colors = TimetableStyle.of(ctx).colors;
    final course = timetable.courseKey2Entity[lesson.courseKey];
    final color = colors[course.courseCode.hashCode.abs() % colors.length].byTheme(context.theme);
    final buildingTimetable = course.buildingTimetable;
    final classTime = buildingTimetable[timeslot];
    return [
      ElevatedText(
        color: color,
        margin: 10,
        elevation: 15,
        child: [
          classTime.begin.toStringPrefixed0().text(style: const TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 5.h),
          classTime.end.toStringPrefixed0().text(),
        ].column(),
      ),
      LessonCard(
        lesson: lesson,
        course: course,
        courseKey2Entity: timetable.courseKey2Entity,
        color: color,
      ).expanded()
    ].row();
  }

  void onPageChange() {
    setState(() {
      final page = (_pageController.page ?? 0).round();
      final newPos = page2Pos(page);
      if (currentPos != newPos) {
        currentPos = newPos;
      }
    });
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
          if (day.hasAnyLesson()) {
            eventBus.fire(JumpToPosEvent(TimetablePosition(week: i + 1, day: j + 1)));
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
          if (day.hasAnyLesson()) {
            eventBus.fire(JumpToPosEvent(TimetablePosition(week: i + 1, day: j + 1)));
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

class LessonCard extends StatefulWidget {
  final SitTimetableLesson lesson;
  final SitCourse course;
  final List<SitCourse> courseKey2Entity;
  final Color color;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.course,
    required this.courseKey2Entity,
    required this.color,
  });

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  static const iconSize = 45.0;

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final Widget courseIcon = Image.asset(
      CourseCategory.iconPathOf(iconName: course.iconName),
      width: iconSize,
      height: iconSize,
    );
    return ListTile(
      leading: courseIcon,
      title: Text(stylizeCourseName(course.courseName), textScaleFactor: 1.1),
      subtitle: [
        Text(formatPlace(course.place), softWrap: true, overflow: TextOverflow.ellipsis),
        course.teachers.join(', ').text(),
      ].column(caa: CrossAxisAlignment.start),
    ).inCard(
      margin: const EdgeInsets.all(8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      clip: Clip.antiAlias,
      elevation: 10,
      color: widget.color,
    );
  }
}
