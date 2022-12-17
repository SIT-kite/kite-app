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

import '../../cache.dart';
import '../../entity/course.dart';
import '../../entity/entity.dart';
import '../../events.dart';
import '../../using.dart';
import '../../utils.dart';
import '../shared.dart';
import 'header.dart';
import '../style.dart';
import '../classic_ui/sheet.dart';
import '../interface.dart';
import 'shared.dart';

class WeeklyTimetable extends StatefulWidget implements InitialTimeProtocol {
  final SitTimetable timetable;

  @override
  DateTime get initialDate => timetable.startDate;

  final ValueNotifier<TimetablePosition> $currentPos;

  @override
  State<StatefulWidget> createState() => WeeklyTimetableState();

  const WeeklyTimetable({
    super.key,
    required this.timetable,
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

  @override
  void initState() {
    super.initState();
    dateSemesterStart = widget.initialDate;
    _pageController = PageController(initialPage: currentPos.week - 1)..addListener(onPageChange);
    eventBus.on<JumpToPosEvent>().listen((event) {
      jumpTo(event.where);
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

    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      itemCount: 20,
      itemBuilder: (BuildContext ctx, int weekIndex) {
        final todayPos = widget.locateInTimetable(DateTime.now());
        return _OneWeekPage(
          timetable: timetable,
          todayPos: todayPos,
          weekIndex: weekIndex,
          $currentPos: widget.$currentPos,
        );
      },
    );
  }

  void onPageChange() {
    setState(() {
      final page = (_pageController.page ?? 0).round();
      final newWeek = page2Week(page);
      if (newWeek != currentPos.week) {
        currentPos = currentPos.copyWith(week: newWeek);
      }
    });
  }

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
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}

class _OneWeekPage extends StatefulWidget {
  final SitTimetable timetable;
  final ValueNotifier<TimetablePosition> $currentPos;
  final int weekIndex;
  final TimetablePosition todayPos;

  const _OneWeekPage({
    super.key,
    required this.timetable,
    required this.$currentPos,
    required this.weekIndex,
    required this.todayPos,
  });

  @override
  State<_OneWeekPage> createState() => _OneWeekPageState();
}

class _OneWeekPageState extends State<_OneWeekPage> with AutomaticKeepAliveClientMixin {
  SitTimetable get timetable => widget.timetable;

  /// Cache the who page to avoid expensive rebuilding.
  Widget? _cached;

  TimetablePosition get currentPos => widget.$currentPos.value;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final cache = _cached;
    if (cache != null) {
      return cache;
    } else {
      final res = buildPage(context);
      _cached = res;
      return res;
    }
  }

  Widget buildPage(BuildContext ctx) {
    final weekIndex = widget.weekIndex;
    final timetableWeek = timetable.weeks[weekIndex];
    if (timetableWeek != null) {
      return [
        for (int dayIndex = 0; dayIndex < timetableWeek.days.length; dayIndex++)
          widget.$currentPos <<
              (ctx, pos, _) => _CourseDayColumn(
                    timetableWeek: timetableWeek,
                    courseKey2Entity: timetable.courseKey2Entity,
                    currentWeek: weekIndex,
                    currentPos: pos,
                    dayIndex: dayIndex,
                  ),
      ].row().scrolled();
    } else {
      return buildFreeWeekTip(ctx, weekIndex);
    }
  }

  Widget buildFreeWeekTip(BuildContext ctx, int weekIndex) {
    final isThisWeek = widget.todayPos.week == (weekIndex + 1);
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
        eventBus.fire(JumpToPosEvent(currentPos.copyWith(week: i + 1)));
        return;
      }
    }
    // Now there's no class forward, so let's search backward.
    for (int i = weekIndex; 0 <= i; i--) {
      final week = timetable.weeks[i];
      if (week != null) {
        eventBus.fire(JumpToPosEvent(currentPos.copyWith(week: i + 1)));
        return;
      }
    }
    // WHAT? NO CLASS IN THE WHOLE TERM?
    // Alright, let's congratulate them!
    if (!mounted) return;
    await ctx.showTip(title: i18n.congratulations, desc: i18n.timetableFreeTermTip, ok: i18n.thanks);
  }

  @override
  bool get wantKeepAlive => true;
}

class _CourseDayColumn extends StatefulWidget {
  final SitTimetableWeek timetableWeek;
  final List<SitCourse> courseKey2Entity;
  final int currentWeek;
  final TimetablePosition currentPos;
  final int dayIndex;

  const _CourseDayColumn({
    super.key,
    required this.timetableWeek,
    required this.courseKey2Entity,
    required this.currentWeek,
    required this.currentPos,
    required this.dayIndex,
  });

  @override
  State<_CourseDayColumn> createState() => _CourseDayColumnState();
}

class _CourseDayColumnState extends State<_CourseDayColumn> {
  /// Cache the column to avoid expensive rebuilding.
  Widget? _cached;
  TimetablePosition? lastCurrentPos;
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.currentPos.day - 1 == widget.dayIndex;
  }

  @override
  void didUpdateWidget(covariant _CourseDayColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nowSelected = widget.currentPos.day - 1 == widget.dayIndex;
    if (isSelected != nowSelected) {
      setState(() {
        _cached = null;
        isSelected = nowSelected;
        lastCurrentPos = widget.currentPos;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cache = _cached;
    if (cache != null) {
      return cache;
    } else {
      final res = buildCellsByDay(context);
      _cached = res;
      return res;
    }
  }

  Widget buildCellsByDay(BuildContext ctx) {
    final day = widget.timetableWeek.days[widget.dayIndex];
    final fullSize = ctx.mediaQuery.size;
    // Don't ask me why it's `7.2` but not `7`, idk too.
    final cellSize = Size(fullSize.width / 7.2, fullSize.height / 11);
    final cells = <Widget>[];
    cells.add(const SizedBox(height: 60));

    for (int timeslot = 0; timeslot < day.timeslots2Lessons.length; timeslot++) {
      final lessons = day.timeslots2Lessons[timeslot];
      if (lessons.isEmpty) {
        Widget cell = AnimatedSlide(
                offset: isSelected ? const Offset(0.01, -0.01) : Offset.zero,
                curve: Curves.fastLinearToSlowEaseIn,
                duration: const Duration(milliseconds: 800),
                child: const SizedBox().inCard(elevation: isSelected ? 10 : 1))
            .sized(
          width: cellSize.width,
          height: cellSize.height,
        );
        cells.add(cell);
      } else {
        /// TODO: Multi-layer lessons
        final firstLayerLesson = lessons[0];

        /// TODO: Range checking
        final course = widget.courseKey2Entity[firstLayerLesson.courseKey];
        Widget cell = AnimatedSlide(
            offset: isSelected ? const Offset(0.02, -0.02) : Offset.zero,
            curve: Curves.fastLinearToSlowEaseIn,
            duration: const Duration(milliseconds: 800),
            child: _CourseCell(
              timeslot: timeslot,
              lesson: firstLayerLesson,
              courseKey2Entity: widget.courseKey2Entity,
              course: course,
              elevation: isSelected ? 80 : 8,
            )).sized(width: cellSize.width, height: cellSize.height * firstLayerLesson.duration);
        cells.add(cell);

        /// Skip to the end
        timeslot = firstLayerLesson.endIndex;
      }
    }

    return Column(children: cells).scrolled();
  }
}

class _CourseCell extends StatefulWidget {
  final SitTimetableLesson lesson;
  final SitCourse course;
  final int timeslot;
  final List<SitCourse> courseKey2Entity;
  final double elevation;

  const _CourseCell({
    super.key,
    required this.timeslot,
    required this.lesson,
    required this.courseKey2Entity,
    required this.course,
    this.elevation = 8,
  });

  @override
  State<_CourseCell> createState() => _CourseCellState();
}

class _CourseCellState extends State<_CourseCell> {
  SitTimetableLesson get lesson => widget.lesson;

  SitCourse get course => widget.course;

  @override
  Widget build(BuildContext context) {
    final Widget res;
    final colors = TimetableStyle.of(context).colors;
    final color = colors[course.courseCode.hashCode.abs() % colors.length].byTheme(context.theme);
    final info = buildInfo(
      context,
      course,
      maxLines: context.isPortrait ? 8 : 5,
    );
    if (context.isPortrait) {
      res = [
        ElevatedNumber(
          number: widget.timeslot + 1,
          color: color.withOpacity(0.7),
          margin: 3,
          elevation: 3,
        ).flexible(flex: 1),
        info.flexible(flex: 3),
      ].column();
    } else {
      res = [
        ElevatedNumber(
          number: widget.timeslot + lesson.duration,
          color: color,
          margin: 5,
          elevation: 3,
        ).align(at: Alignment.bottomRight),
        info.center().padOnly(b: 2.h),
      ].stack();
    }

    return res.inCard(color: color, elevation: widget.elevation, margin: EdgeInsets.all(1.5.w));
    return [
      buildText(formatPlace(course.place), 2),
      buildText(course.teachers.join(','), 2),
    ].column().inCard(color: color, elevation: 8).onTap(() async {
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
      overflow: TextOverflow.visible,
      maxLines: maxLines,
    );
  }
}
