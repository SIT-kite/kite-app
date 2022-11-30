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

import '../cache.dart';
import '../entity/course.dart';
import '../using.dart';
import '../utils.dart';
import 'header.dart';
import 'sheet.dart';
import 'timetable.dart';
import 'package:tuple/tuple.dart';

class DailyTimetable extends StatefulWidget implements InitialTimeProtocol {
  /// 教务系统课程列表
  final List<Course> allCourses;

  /// 初始日期
  @override
  final DateTime initialDate;

  /// 课表缓存
  final TableCache tableCache;

  /// 视图切换回调
  final Function()? viewChangingCallback;

  @override
  State<StatefulWidget> createState() => DailyTimetableState();
  final ValueNotifier<int> $currentWeek;

  const DailyTimetable({
    super.key,
    required this.allCourses,
    required this.initialDate,
    required this.tableCache,
    required this.$currentWeek,
    this.viewChangingCallback,
  });
}

class DailyTimetableState extends State<DailyTimetable> implements ITimetableView {
  static const String _courseIconPath = 'assets/course/';

  /// 课表应该显示的周（页数 + 1）
  int _currentWeek = 0;

  /// 当前页应显示的星期几
  int _currentDay = 0;

  /// 翻页控制
  late PageController _pageController;

  int weekNDay2Page(int week, int day) => (week - 1) * 7 + day - 1;

  Tuple2<int, int> page2WeekNDay(int page) {
    final week = page ~/ 7 + 1;
    final day = page % 7 + 1;
    return Tuple2(week, day);
  }

  void onPageChange() {
    setState(() {
      final page = (_pageController.page ?? 0).round();
      final weekNDay = page2WeekNDay(page);
      final newWeek = weekNDay.item1;
      final newDay = weekNDay.item2;
      if (newWeek != _currentWeek || newDay != _currentDay) {
        _currentWeek = newWeek;
        _currentDay = newDay;
        widget.$currentWeek.value = newWeek;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    final pos = widget.locateInTimetable(DateTime.now());
    _currentWeek = pos.week;
    _currentDay = pos.day;
    _pageController = PageController(initialPage: weekNDay2Page(pos.week, pos.day))..addListener(onPageChange);
    Future.delayed(Duration.zero, () {
      setState(() {
        widget.$currentWeek.value = _currentWeek;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  /// 跳转到指定星期与天
  @override
  void jumpToDay(int targetWeek, int targetDay) {
    if (_pageController.hasClients) {
      final targetPos = weekNDay2Page(targetWeek, targetDay);
      /*final currentPos = _pageController.page ?? targetPos;
      final distance = (targetPos - currentPos).abs();
      _pageController.animateToPage(
        targetPos,
        duration: calcuSwitchAnimationDuration(distance),
        curve: Curves.easeOut,
      );*/
      // Jumping brings a terrible UX
      _pageController.jumpToPage(
        targetPos,
      );
    }
    setState(() {
      _currentWeek = targetWeek;
      _currentDay = targetDay;
    });
  }

  /// 跳转到今天
  @override
  void jumpToToday() {
    var pos = widget.locateInTimetable(DateTime.now());
    jumpToDay(pos.week, pos.day);
  }

  /// 跳到某一周
  @override
  void jumpToWeek(int targetWeek) {
    jumpToDay(targetWeek, _currentDay);
    setState(() {
      _currentWeek = targetWeek;
    });
  }

  @override
  bool get isTodayView {
    var pos = widget.locateInTimetable(DateTime.now());
    return _currentWeek == pos.week && _currentDay == pos.day;
  }

  Widget _buildCourseCard(BuildContext context, Course course, List<Course> allCourses) {
    final TextStyle? textStyle = Theme.of(context).textTheme.bodyText2;
    final Widget courseIcon = Image.asset('$_courseIconPath${CourseCategory.query(course.courseName)}.png');
    final timetable = getBuildingTimetable(course.campus, course.place);
    final description =
        formatTimeIndex(timetable, course.timeIndex, '${course.weekText} 周${weekWord[course.dayIndex - 1]}\nss-ee');
    return Card(
        margin: const EdgeInsets.all(8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        clipBehavior: Clip.antiAlias,
        color: CourseColor.get(from: Theme.of(context), by: course.courseId.hashCode),
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('太棒啦，今天没有课'),
          if (widget.viewChangingCallback != null)
            TextButton(
              child: const Text('转到到周课表'),
              onPressed: () {
                (widget.viewChangingCallback)!();
              },
            )
        ],
      ),
    );
  }

  /// 构建第 index 页视图
  Widget _pageBuilder(BuildContext context, int index, List<Course> allCourses, List<String> dayHeaders) {
    int week = index ~/ 7 + 1;
    int day = index % 7 + 1;
    final List<Course> todayCourse = widget.tableCache.filterCourseOnDay(allCourses, week, day);

    return Column(
      children: [
        // 翻页不影响选择的星期, 因此沿用 _currentDay.
        Expanded(
          child: TimetableHeader(
            dayHeaders: dayHeaders,
            selectedDay: day,
            currentWeek: week,
            startDate: widget.initialDate,
            onTap: (selectedDay) {
              day = selectedDay;
              jumpToDay(week, day);
            },
          ),
        ),
        Expanded(
          flex: 10,
          child: todayCourse.isNotEmpty
              ? ListView(
                  controller: ScrollController(),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  children: todayCourse.map((e) => _buildCourseCard(context, e, widget.allCourses)).toList())
              : _buildEmptyPage(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final dayHeaders = makeWeakdaysShortText();
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      // TODO: 存储
      itemCount: 20 * 7,
      itemBuilder: (_, int index) => _pageBuilder(context, index, widget.allCourses, dayHeaders),
    );
  }
}
