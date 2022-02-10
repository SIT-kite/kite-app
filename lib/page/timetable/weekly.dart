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
import 'package:kite/entity/edu/timetable.dart';

import 'grid.dart';
import 'header.dart';

class WeeklyTimetable extends StatefulWidget {
  /// 教务系统课程列表
  final List<Course> allCourses;

  /// 初始日期
  final DateTime? initialDate;

  WeeklyTimetable(this.allCourses, {Key? key, this.initialDate}) : super(key: key);

  @override
  _WeeklyTimetableState createState() => _WeeklyTimetableState(allCourses, initialDate);
}

class _WeeklyTimetableState extends State<WeeklyTimetable> {
  /// 左侧方块的宽高比
  static const double gridAspectRatioHeight = 1 / 1.8;

  /// 教务系统课程列表
  final List<Course> allCourses;

  /// 初始日期
  final DateTime? initialDate;

  int currTimePageIndex = 0;

  late PageController _pageController;

  _WeeklyTimetableState(this.allCourses, this.initialDate);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currTimePageIndex, viewportFraction: 1.0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// 布局左侧边栏, 显示节次
  Widget _buildLeftColumn() {
    /// 构建每一个格子
    Widget buildGrid(BuildContext context, int index) {
      final textStyle = Theme.of(context).textTheme.bodyText2;
      const border = BorderSide(color: Colors.black12, width: 0.8);

      return Container(
        child: Center(child: Text((index + 1).toString(), style: textStyle)),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: border, right: border),
        ),
      );
    }

    // 用 [GridView] 构造整个左侧边栏
    return GridView.builder(
        shrinkWrap: true,
        itemCount: 11,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: gridAspectRatioHeight,
        ),
        itemBuilder: buildGrid);
  }

  void gotoCurrPage() {
    _pageController.jumpToPage(currTimePageIndex);
  }

  Widget _pageBuilder(int index) {
    return Column(
      children: [
        Expanded(flex: 1, child: DateHeader(index, -1)),
        Expanded(
          flex: 10,
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Row(
              textDirection: TextDirection.ltr,
              children: [
                Expanded(flex: 2, child: _buildLeftColumn()),
                Expanded(flex: 21, child: TableGrids(allCourses, index))
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) => _pageBuilder(index),
    );
  }
}
