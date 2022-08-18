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
import 'package:kite/feature/edu/timetable/entity.dart';

import '../../init.dart';
import '../util.dart';
import 'grid.dart';
import 'header.dart';

class WeeklyTimetable extends StatefulWidget {
  /// 教务系统课程列表
  final List<Course> allCourses;

  /// 初始日期
  /// TODO 暂时还没用上？
  final DateTime? initialDate;

  @override
  State<StatefulWidget> createState() => WeeklyTimetableState();

  const WeeklyTimetable(this.allCourses, {Key? key, this.initialDate}) : super(key: key);
}

class WeeklyTimetableState extends State<WeeklyTimetable> {
  late PageController _pageController;

  int _currentWeek = 1;

  /// 布局左侧边栏, 显示节次
  Widget _buildLeftColumn() {
    /// 构建每一个格子
    Widget buildGrid(BuildContext context, int index) {
      final textStyle = Theme.of(context).textTheme.bodyText2;
      const border = BorderSide(color: Colors.black12, width: 0.8);

      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
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
        itemBuilder: buildGrid);
  }

  /// 设置页面为对应日期页.
  void _setDate(DateTime theDay) {
    int days = theDay.difference(dateSemesterStart).inDays;

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

  Widget _pageBuilder(int week) {
    return Column(
      children: [
        Expanded(flex: 1, child: DateHeader(week, -1)),
        Expanded(
          flex: 10,
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Row(
              textDirection: TextDirection.ltr,
              children: [
                Expanded(flex: 2, child: _buildLeftColumn()),
                Expanded(flex: 21, child: TableGrids(widget.allCourses, week))
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    dateSemesterStart = TimetableInitializer.timetableStorage.startDate ?? DateTime(2022, 2, 14);

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
