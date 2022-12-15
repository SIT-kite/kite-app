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
          itemBuilder: (BuildContext context, int index) => _buildPage(index + 1),
        ),
      ).expanded()
    ].column(mas: MainAxisSize.min, maa: MainAxisAlignment.start, caa: CrossAxisAlignment.start);
  }

  Widget buildMood(BuildContext ctx) {
    return Text("😁",style: TextStyle(fontSize: 25),);
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

  /// 布局左侧边栏, 显示节次
  Widget buildLeftColumn() {
    /// 构建每一个格子
    Widget buildCell(BuildContext ctx, int index) {
      final textStyle = ctx.textTheme.bodyText2;
      final side = getBorderSide(ctx);

      return Container(
        decoration: BoxDecoration(
          border: Border(
              top: index != 0 ? side : BorderSide.none,
              right: side,
              left: side,
              bottom: index == 10 ? side : BorderSide.none),
        ),
        child: Center(child: Text((index + 1).toString(), style: textStyle)),
      );
    }

    // 用 [GridView] 构造整个左侧边栏
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 11,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 22 / 23 * (1.sw) / (1.sh),
      ),
      itemBuilder: buildCell,
    );
  }

  Widget _buildPage(int week) {
    return SingleChildScrollView(
      controller: ScrollController(),
      child: Row(
        textDirection: TextDirection.ltr,
        children: [
          buildLeftColumn().flexible(flex: 2),
          TimetableColumns(
            allCourses: widget.allCourses,
            currentWeek: week,
            cache: widget.tableCache,
          ).flexible(flex: 21)
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}

class TimetableColumns extends StatefulWidget {
  final List<Course> allCourses;
  final TableCache cache;

  final int currentWeek;

  const TimetableColumns({super.key, required this.allCourses, required this.currentWeek, required this.cache});

  @override
  State<StatefulWidget> createState() => _TimetableColumnsState();
}

class _TimetableColumnsState extends State<TimetableColumns> {
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
        itemBuilder: (BuildContext context, int index) => _buildCellsByDay(context, index + 1, cellSize).center(),
      ),
    );
  }

  /// 构建某一天的那一列格子.
  Widget _buildCellsByDay(BuildContext context, int day, Size cellSize) {
    // 该日的课程列表
    final List<Course> dayCourseList = widget.cache.getCoursesWhen(
      widget.allCourses,
      week: widget.currentWeek,
      day: day,
    );
    // 该日的格子列表
    final List<Course?> grids = _reduceCourseCells(dayCourseList);

    return SizedBox(
      width: cellSize.width,
      height: cellSize.height * 11,
      child: Column(
        children: [
          for (final course in grids)
            SizedBox(
              width: cellSize.width,
              height: (course?.duration ?? 1) * cellSize.height,
              child: course != null
                  ? _CourseCell(
                      course: course,
                      allCourse: widget.allCourses,
                    )
                  : const SizedBox(),
            )
        ],
      ),
    );
  }
}

class _CourseCell extends StatefulWidget {
  final Course course;
  final List<Course> allCourse;

  const _CourseCell({super.key, required this.course, required this.allCourse});

  @override
  State<_CourseCell> createState() => _CourseCellState();
}

class _CourseCellState extends State<_CourseCell> {
  Course get course => widget.course;

  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuery.size;

    final colors = TimetablePalette.of(context).colors;
    final decoration = BoxDecoration(
      color: colors[course.courseId.hashCode.abs() % colors.length].byTheme(context.theme),
      borderRadius: const BorderRadius.all(Radius.circular(3.0)),
      border: const Border(),
    );

    return Container(
      width: size.width - 3,
      height: size.height * course.duration - 4,
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
            buildText(course.teacher.join(','), 2),
          ],
        ),
      ),
    ).onTap(() async {
      await showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) => Sheet(course.courseId, widget.allCourse),
          context: context);
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

/// 该函数就是用来计算有课程和无课程格子数量, 供 ListView 使用
///
/// 如：1-2, 5-6, 7-8
/// 合并得：[duration = 2, null, null, duration = 2, duration = 2]
List<Course?> _reduceCourseCells(List<Course> all) {
  // 使用列表, 将每一门课放到其开始的节次上.
  final List<Course?> l = List.filled(11, null, growable: true);
  for (final course in all) {
    l[getIndexStart(course.timeIndex) - 1] = course;
  }

  // 此时 l 为 [duration = 2, null, null, null, duration = 2, null, duration = 2, null]
  for (int i = 0; i < l.length; ++i) {
    if (l[i] != null) {
      l.removeRange(i + 1, i + l[i]!.duration);
    }
  }
  return l;
}
