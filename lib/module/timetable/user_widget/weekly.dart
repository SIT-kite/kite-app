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
import 'package:rettulf/rettulf.dart';

import '../cache.dart';
import '../entity/course.dart';
import '../entity/entity.dart';
import '../using.dart';
import '../utils.dart';
import 'header.dart';
import 'palette.dart';
import 'sheet.dart';
import 'timetable.dart';

class WeeklyTimetable extends StatefulWidget implements InitialTimeProtocol {
  final SitTimetable timetable;

  @override
  DateTime get initialDate => timetable.startDate;

  /// 课表缓存
  final TableCache tableCache;

  final ValueNotifier<TimetablePosition> $currentPos;

  @override
  State<StatefulWidget> createState() => WeeklyTimetableState();

  const WeeklyTimetable({
    super.key,
    required this.timetable,
    required this.tableCache,
    required this.$currentPos,
  });
}

class WeeklyTimetableState extends State<WeeklyTimetable> {
  late PageController _pageController;
  late DateTime dateSemesterStart;
  final $cellSize = ValueNotifier(Size.zero);
  final faceIndex = 0;

  SitTimetable get timetable => widget.timetable;

  TimetablePosition get currentPos => widget.$currentPos.value;

  set currentPos(TimetablePosition newValue) => widget.$currentPos.value = newValue;

  int page2Week(int page) => page + 1;

  int week2PageOffset(int week) => week - 1;
  TimetablePosition? _lastPos;
  bool isJumping = false;
  int mood = 0;

  @override
  void initState() {
    super.initState();
    dateSemesterStart = widget.initialDate;
    _pageController = PageController(initialPage: currentPos.week - 1)..addListener(onPageChange);
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
      final targetOffset = week2PageOffset(currentPos.week);
      final currentOffset = _pageController.page?.round() ?? targetOffset;
      if (currentOffset != targetOffset) {
        _pageController.jumpToPage(targetOffset);
      }
    });
    final dayHeaders = makeWeekdaysShortText();
    final side = getBorderSide(context);

    return [
      [
        buildMood(context).align(at: Alignment.center).flexible(flex: 2),
        widget.$currentPos <<
            (ctx, cur, _) => TimetableHeader(
                  dayHeaders: dayHeaders,
                  selectedDay: 0,
                  currentWeek: cur.week,
                  startDate: widget.initialDate,
                ).flexible(flex: 22)
      ].row().container(
            decoration: BoxDecoration(
              border: Border(left: side, top: side, right: side, bottom: side),
            ),
          ),
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
          itemCount: 20,
          itemBuilder: (BuildContext ctx, int index) => buildPageBody(ctx, index),
        ),
      ).expanded()
    ].column(mas: MainAxisSize.min, maa: MainAxisAlignment.start, caa: CrossAxisAlignment.start);
  }

  Widget buildMood(BuildContext ctx) {
    return Text(
      "😁",
      style: TextStyle(fontSize: 25),
    );
    return Icon(
      Mood.get(mood),
      color: context.darkSafeThemeColor,
    ).onTap(key: ValueKey(mood), () {
      setState(() {
        mood = Mood.next(mood);
      });
    }).animatedSwitched(d: const Duration(milliseconds: 400));
  }

  void onPageChange() {
    if (!isJumping) {
      setState(() {
        final page = (_pageController.page ?? 0).round();
        final newWeek = page2Week(page);
        if (newWeek != currentPos.week) {
          currentPos = currentPos.copyWith(week: newWeek);
        }
      });
    }
  }

  /// 跳到某一周
  void jumpTo(TimetablePosition pos) {
    if (_pageController.hasClients) {
      final targetOffset = week2PageOffset(pos.week);
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

  Widget buildPageBody(BuildContext ctx, int weekIndex) {
    final timetableWeek = timetable.weeks[weekIndex];
    if (timetableWeek != null) {
      return [
        buildLeftColumn(ctx).flexible(flex: 2),
        TimetableSingleWeekView(
          timetableWeek: timetableWeek,
          courseKey2Entity: timetable.courseKey2Entity,
          currentWeek: weekIndex,
          cache: widget.tableCache,
        ).flexible(flex: 21)
      ].row(textDirection: TextDirection.ltr).scrolled();
    } else {
      return [
        buildLeftColumn(ctx).flexible(flex: 2),
        buildFreeWeekTip(ctx, weekIndex).flexible(flex: 21),
      ].row(textDirection: TextDirection.ltr);
    }
  }

  /// 布局左侧边栏, 显示节次
  Widget buildLeftColumn(BuildContext ctx) {
    // 用 [GridView] 构造整个左侧边栏
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 11,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 22 / 23 * (1.sw) / (1.sh),
      ),
      itemBuilder: _buildCell,
    );
  }

  /// 构建每一个格子
  Widget _buildCell(BuildContext ctx, int index) {
    final textStyle = ctx.textTheme.bodyText2;
    final side = getBorderSide(ctx);

    return Container(
      decoration: BoxDecoration(
        border: Border(
            top: index != 0 ? side : BorderSide.none,
            right: side,
            left: side,
            bottom: side),
      ),
      child: (index + 1).text(style: textStyle).center(),
    );
  }

  Widget buildFreeWeekTip(BuildContext ctx, int weekIndex) {
    final isThisWeek = widget.locateInTimetable(DateTime.now()).week == (weekIndex + 1);
    final String desc;
    if (isThisWeek) {
      desc = i18n.timetableFreeWeekIsThisWeekTip;
    } else {
      desc = i18n.timetableFreeWeekTip;
    }
    return LeavingBlank(
      icon: Icons.free_cancellation_rounded,
      desc: desc,
      subtitle: buildJumpToNearestWeekWithClassBtn(ctx, weekIndex),
    );
  }

  Widget buildJumpToNearestWeekWithClassBtn(BuildContext ctx, int weekIndex) {
    return CupertinoButton(
      onPressed: () async {
        await jumpToNearestWeekWithClass(ctx, weekIndex);
      },
      child: i18n.timetableFindNearestWeekWithClassBtn.text(),
    );
  }

  /// Find the nearest week with class forward.
  /// No need to look back to passed weeks, unless there's no week after [weekIndex] that has any class.
  Future<void> jumpToNearestWeekWithClass(BuildContext ctx, int weekIndex) async {
    for (int i = weekIndex; i < timetable.weeks.length; i++) {
      final week = timetable.weeks[i];
      if (week != null) {
        currentPos = currentPos.copyWith(week: i + 1);
        return;
      }
    }
    // Now there's no class forward, so let's search backward.
    for (int i = weekIndex; 0 <= i; i--) {
      final week = timetable.weeks[i];
      if (week != null) {
        currentPos = currentPos.copyWith(week: i + 1);
        return;
      }
    }
    // WHAT? NO CLASS IN THE WHOLE TERM?
    // Alright, let's congratulate them!
    await ctx.showTip(title: i18n.congratulations, desc: i18n.timetableFreeTermTip, ok: i18n.thanks);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}

class TimetableSingleWeekView extends StatefulWidget {
  final SitTimetableWeek timetableWeek;
  final List<SitCourse> courseKey2Entity;
  final TableCache cache;
  final int currentWeek;

  const TimetableSingleWeekView({
    super.key,
    required this.timetableWeek,
    required this.courseKey2Entity,
    required this.cache,
    required this.currentWeek,
  });

  @override
  State<StatefulWidget> createState() => _TimetableSingleWeekViewState();
}

class _TimetableSingleWeekViewState extends State<TimetableSingleWeekView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final rawColumnSize = MediaQuery.of(context).size;
    final cellSize = Size(rawColumnSize.width * 3 / 23, rawColumnSize.height / 11);
    return SizedBox(
      width: rawColumnSize.width * 7,
      height: rawColumnSize.height,
      child: ListView.builder(
        itemCount: 7,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(), // The scrolling has been handled outside
        itemBuilder: (BuildContext context, int index) =>
            _buildCellsByDay(context, widget.timetableWeek.days[index], cellSize).center(),
      ),
    );
  }

  /// 构建某一天的那一列格子.
  Widget _buildCellsByDay(BuildContext context, SitTimetableDay day, Size cellSize) {
    final cells = <Widget>[];
    for (int timeslot = 0; timeslot < day.timeslots2Lessons.length; timeslot++) {
      final lessons = day.timeslots2Lessons[timeslot];
      if (lessons.isEmpty) {
        cells.add(const SizedBox().sized(width: cellSize.width, height: cellSize.height));
      } else {
        /// TODO: Multi-layer lessons
        final firstLayerLesson = lessons[0];

        /// TODO: Range checking
        final course = widget.courseKey2Entity[firstLayerLesson.courseKey];
        final cell = _CourseCell(
          lesson: firstLayerLesson,
          courseKey2Entity: widget.courseKey2Entity,
          course: course,
        );
        cells.add(cell.sized(width: cellSize.width, height: cellSize.height * firstLayerLesson.duration));

        /// Skip to the end
        timeslot = firstLayerLesson.endIndex;
      }
    }

    return SizedBox(
      width: cellSize.width,
      height: cellSize.height * 11,
      child: Column(children: cells),
    );
  }
}

class _CourseCell extends StatefulWidget {
  final SitTimetableLesson lesson;
  final SitCourse course;
  final List<SitCourse> courseKey2Entity;

  const _CourseCell({super.key, required this.lesson, required this.courseKey2Entity, required this.course});

  @override
  State<_CourseCell> createState() => _CourseCellState();
}

class _CourseCellState extends State<_CourseCell> {
  SitTimetableLesson get lesson => widget.lesson;

  SitCourse get course => widget.course;

  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuery.size;

    final colors = TimetablePalette.of(context).colors;
    final decoration = BoxDecoration(
      color: colors[course.courseCode.hashCode.abs() % colors.length].byTheme(context.theme),
      borderRadius: const BorderRadius.all(Radius.circular(3.0)),
      border: const Border(),
    );

    return Container(
      width: size.width - 3,
      height: size.height * lesson.duration - 4,
      decoration: decoration,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildText(stylizeCourseName(course.courseName), 3),
            const SizedBox(height: 3),
            buildText(formatPlace(course.place), 2),
            const SizedBox(height: 3),
            buildText(course.teachers.join(','), 2),
          ],
        ),
      ),
    ).onTap(() async {
      /* await showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) => Sheet(course.courseCode, widget.allCourse),
          context: context);*/
    });
  }

  Text buildText(String text, int maxLines) {
    return Text(
      text,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
    );
  }
}
