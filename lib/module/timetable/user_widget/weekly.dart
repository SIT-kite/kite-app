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
import 'colors.dart';
import 'sheet.dart';
import 'util.dart';
import '../cache.dart';
import '../entity/course.dart';
import 'header.dart';

class WeeklyTimetable extends StatefulWidget {
  /// 教务系统课程列表
  final List<Course> allCourses;

  /// 初始日期
  final DateTime initialDate;

  /// 课表缓存
  final TableCache tableCache;

  @override
  State<StatefulWidget> createState() => WeeklyTimetableState();

  const WeeklyTimetable({
    Key? key,
    required this.allCourses,
    required this.initialDate,
    required this.tableCache,
  }) : super(key: key);
}

class WeeklyTimetableState extends State<WeeklyTimetable> {
  late PageController _pageController;
  late DateTime dateSemesterStart;

  int _currentWeek = 1;

  /// 布局左侧边栏, 显示节次
  Widget _buildLeftColumn() {
    /// 构建每一个格子
    Widget buildCell(BuildContext context, int index) {
      final textStyle = Theme.of(context).textTheme.bodyText2;
      const border = BorderSide(color: Colors.black12, width: 0.8);

      return Container(
        decoration: const BoxDecoration(
          border: Border(top: border, right: border),
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
        itemBuilder: buildCell);
  }

  /// 设置页面为对应日期页.
  void _setDate(DateTime theDay) {
    int days = theDay.clearTime().difference(dateSemesterStart.clearTime()).inDays;

    int week = days ~/ 7 + 1;
    if (days >= 0 && 1 <= week && week <= 20) {
      _currentWeek = week;
    } else {
      _currentWeek = 1;
    }
  }

  void jumpToday() {
    _setDate(DateTime.now());
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        _currentWeek - 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linearToEaseOut,
      );
    }
  }

  /// 跳到某一周
  void jumpWeek(int week) {
    _currentWeek = week;
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        _currentWeek - 1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linearToEaseOut,
      );
    }
  }

  Widget _pageBuilder(int week) {
    return Column(
      children: [
        Expanded(
            flex: 1,
            // Display the week name on top
            child: DateHeader(
              currentWeek: week,
              selectedDay: -1,
              startDate: widget.initialDate,
            )),
        Expanded(
          flex: 10,
          child: widget.allCourses.isEmpty
              ? const Center(child: Text('这周没有课哦'))
              : SingleChildScrollView(
                  controller: ScrollController(),
                  child: Row(
                    textDirection: TextDirection.ltr,
                    children: [
                      Expanded(flex: 2, child: _buildLeftColumn()),
                      Expanded(
                          flex: 21,
                          child: TimetableColumn(
                            allCourses: widget.allCourses,
                            currentWeek: week,
                            cache: widget.tableCache,
                          ))
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    dateSemesterStart = widget.initialDate;

    _setDate(DateTime.now());
    _pageController = PageController(initialPage: _currentWeek - 1, keepPage: false);

    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) => _pageBuilder(index + 1),
    );
  }
}

class TimetableColumn extends StatefulWidget {
  final List<Course> allCourses;
  final TableCache cache;

  final int currentWeek;

  const TimetableColumn({super.key, required this.allCourses, required this.currentWeek, required this.cache});

  @override
  State<StatefulWidget> createState() => _TimetableColumnState();
}

class _TimetableColumnState extends State<TimetableColumn> {
  Size rawCellSize = Size.zero;

  double calcuCellWidth({required Size by}) => rawCellSize.width * 3 / 23;

  double calcuCellHeight({required Size by}) => rawCellSize.height / 11;

  double get cellWidth => calcuCellWidth(by: rawCellSize);

  double get cellHeight => calcuCellHeight(by: rawCellSize);

  Widget _buildCourseCell(BuildContext context, Course? grid) {
    final textStyle = Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.bold);
    final textStyle2 = Theme.of(context).textTheme.bodyText2;
    Widget buildCourseGrid(Course course) {
      Text buildText(text, maxLines, {TextStyle? myTextStyle}) => Text(
            text,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
            style: myTextStyle ?? textStyle,
          );
      final decoration = BoxDecoration(
        color: CourseColor.get(from: Theme.of(context), by: course.courseId.hashCode),
        borderRadius: const BorderRadius.all(Radius.circular(3.0)),
        border: const Border(),
      );

      return InkWell(
        onTap: () {
          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) => Sheet(course.courseId, widget.allCourses),
              context: context);
        },
        child: Container(
          width: cellWidth - 3,
          height: cellHeight * course.duration - 4,
          decoration: decoration,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                buildText(stylizeCourseName(course.courseName), 3),
                const SizedBox(height: 3),
                buildText(formatPlace(course.place), 2, myTextStyle: textStyle2),
                const SizedBox(height: 3),
                buildText(course.teacher.join(','), 2, myTextStyle: textStyle2),
              ],
            ),
          ),
        ),
      );
    }

    Widget buildEmptyGrid() {
      return SizedBox(
        width: cellWidth - 3,
        height: cellHeight - 4,
      );
    }

    return Container(
      width: cellWidth,
      height: (grid?.duration ?? 1) * cellHeight,
      alignment: const Alignment(0, 0),
      child: grid != null ? buildCourseGrid(grid) : buildEmptyGrid(),
    );
  }

  /// 该函数就是用来计算有课程和无课程格子数量, 供 ListView 使用
  ///
  /// 如：1-2, 5-6, 7-8
  /// 合并得：[duration = 2, null, null, duration = 2, duration = 2]
  List<Course?> _buildGrids(List<Course> dayCourseList) {
    // 使用列表, 将每一门课放到其开始的节次上.
    final List<Course?> l = List.filled(11, null, growable: true);
    for (final course in dayCourseList) {
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

  /// 构建某一天的那一列格子.
  Widget _buildDay(BuildContext context, int day) {
    // 该日的课程列表
    final List<Course> dayCourseList = widget.cache.filterCourseOnDay(widget.allCourses, widget.currentWeek, day);
    // 该日的格子列表
    final List<Course?> grids = _buildGrids(dayCourseList);

    return SizedBox(
      width: cellWidth,
      height: cellHeight * 11,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: grids.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) => _buildCourseCell(context, grids[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      rawCellSize = MediaQuery.of(context).size;
    });

    return SizedBox(
      width: cellWidth * 7,
      height: rawCellSize.height,
      child: ListView.builder(
        itemCount: 7,
        padding: const EdgeInsets.only(left: 1.0),
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) => _buildDay(context, index + 1),
      ),
    );
  }
}
