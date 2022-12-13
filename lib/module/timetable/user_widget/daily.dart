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

import '../cache.dart';
import '../entity/course.dart';
import '../using.dart';
import '../utils.dart';
import 'header.dart';
import 'palette.dart';
import 'sheet.dart';
import 'timetable.dart';

class DailyTimetable extends StatefulWidget implements InitialTimeProtocol {
  /// 教务系统课程列表
  final List<Course> allCourses;

  /// 初始日期
  @override
  final DateTime initialDate;

  /// 课表缓存
  final TableCache tableCache;

  final ValueNotifier<TimetablePosition> $currentPos;

  @override
  State<StatefulWidget> createState() => DailyTimetableState();

  const DailyTimetable({
    super.key,
    required this.allCourses,
    required this.initialDate,
    required this.tableCache,
    required this.$currentPos,
  });
}

class DailyTimetableState extends State<DailyTimetable> {
  static const String _courseIconPath = 'assets/course/';

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
              ).flexible(flex: 2),
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
            itemBuilder: (_, int index) => _buildPage(context, index, widget.allCourses),
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
  Widget _buildPage(BuildContext context, int index, List<Course> allCourses) {
    int week = index ~/ 7 + 1;
    int day = index % 7 + 1;
    final List<Course> todayCourse = widget.tableCache.getCoursesWhen(allCourses, week: week, day: day);

    return todayCourse.isNotEmpty
        ? ListView(
            controller: ScrollController(),
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            children: todayCourse.map((e) => _buildCourseCard(context, e, widget.allCourses)).toList())
        : _buildEmptyPage();
  }

  Widget _buildCourseCard(BuildContext context, Course course, List<Course> allCourses) {
    final TextStyle? textStyle = Theme.of(context).textTheme.bodyText2;
    final Widget courseIcon = Image.asset('$_courseIconPath${CourseCategory.query(course.courseName)}.png');
    final timetable = getBuildingTimetable(course.campus, course.place);
    final description =
        formatTimeIndex(timetable, course.timeIndex, '${course.weekText} 周${weekWord[course.dayIndex - 1]}\nss-ee');
    final colors = TimetablePalette.of(context).colors;
    return Card(
        margin: const EdgeInsets.all(8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        clipBehavior: Clip.antiAlias,
        color: colors[course.courseId.hashCode.abs() % colors.length].byTheme(context.theme),
        child: ListTile(
          // 点击卡片打开课程详情.
          onTap: () => showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) => Sheet(course.courseId, allCourses),
            context: context,
          ),
          leading: courseIcon,
          title: Text(stylizeCourseName(course.courseName), textScaleFactor: 1.1),
          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(course.teacher.join(','), style: textStyle),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(description, style: textStyle),
                Text(formatPlace(course.place), softWrap: true, overflow: TextOverflow.ellipsis, style: textStyle),
              ],
            ),
          ]),
        ));
  }

  Widget _buildEmptyPage() {
    final isToday = widget.locateInTimetable(DateTime.now()) == currentPos;
    final String desc;
    if (isToday) {
      desc = i18n.timetableFreeDayIsTodayTip;
    } else {
      desc = i18n.timetableFreeDayTip;
    }
    return LeavingBlank(
      icon: Icons.free_cancellation_rounded,
      desc: desc,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}
