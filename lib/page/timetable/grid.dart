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
import 'package:kite/entity/edu/index.dart';

import 'cache.dart';
import 'sheet.dart';
import 'util.dart';

class TableGrids extends StatelessWidget {
  /// 课程网格中每一小格的高度
  late final double singleGridHeight;

  /// 课程网格中每一小格的宽度
  late final double singleGridWidth;

  final List<Course> allCourses;
  final int currentWeek;

  TableGrids(this.allCourses, this.currentWeek, {Key? key}) : super(key: key);

  Widget _buildCourseGrid(BuildContext context, Course? grid) {
    final textStyle = Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.white);

    Widget buildCourseGrid(Course course) {
      Text buildText(text, maxLines) => Text(
            text,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
            style: textStyle,
          );
      final decoration = BoxDecoration(
        color: getBeautifulColor(course.courseId.hashCode),
        borderRadius: const BorderRadius.all(Radius.circular(3.0)),
        border: const Border(),
      );

      return InkWell(
        onTap: () {
          showModalBottomSheet(
              backgroundColor: Colors.transparent,
              builder: (BuildContext context) => Sheet(course.courseId, allCourses),
              context: context);
        },
        child: Container(
          width: singleGridWidth - 3,
          height: singleGridHeight * course.duration - 4,
          decoration: decoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildText(course.courseName, 3),
              buildText(formatPlace(course.place), 2),
              buildText(course.teacher.join(','), 2),
            ],
          ),
        ),
      );
    }

    Widget buildEmptyGrid() {
      return SizedBox(
        width: singleGridWidth - 3,
        height: singleGridHeight - 4,
      );
    }

    return Container(
      width: singleGridWidth,
      height: (grid?.duration ?? 1) * singleGridHeight,
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
    dayCourseList.forEach((e) => l[getIndexStart(e.timeIndex) - 1] = e);

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
    final List<Course> dayCourseList = TableCache.filterCourseOnDay(allCourses, currentWeek, day);
    // 该日的格子列表
    final List<Course?> grids = _buildGrids(dayCourseList);

    return SizedBox(
      width: singleGridWidth,
      height: singleGridHeight * 11,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: grids.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) => _buildCourseGrid(context, grids[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    singleGridWidth = size.width * 3 / 23;
    singleGridHeight = size.height / 11;

    return SizedBox(
      width: singleGridWidth * 7,
      height: size.height,
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
