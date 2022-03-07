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

import '../util.dart';

class Sheet extends StatelessWidget {
  final String courseId;
  final List<Course> allCourses;

  /// 一门课可能包括实践和理论课. 由于正方不支持这种设置, 实际教务系统在处理中会把这两部分拆开, 但是它们的课程名称和课程代码是一样的
  /// classes 中存放的就是对应的所有课程, 我们在这把它称为班级.
  late final List<Course> classes;

  Sheet(this.courseId, this.allCourses, {Key? key}) : super(key: key) {
    // 初始化 classes
    classes = allCourses.where((e) => e.courseId == courseId).toList();
  }

  /// 解析课程ID对应的不同时间段的课程信息
  List<String> generateTimeString() {
    return classes.map((e) {
      final timetable = getBuildingTimetable(e.campus, e.place);

      return formatTimeIndex(
        timetable,
        e.timeIndex,
        '第${e.weekText} 周${weekWord[e.dayIndex - 1]}\nss - ee ${e.place}',
      );
    }).toList();
  }

  Widget _buildTitle(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headline2?.copyWith(fontWeight: FontWeight.w600);

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 5),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Text(classes[0].courseName, style: titleStyle),
      ),
    );
  }

  Widget _buildItem(BuildContext context, String icon, String text) {
    final itemStyle = Theme.of(context).textTheme.bodyText2;
    final iconImage = AssetImage('assets/timetable/' + icon);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
      child: Row(
        children: [
          Image(image: iconImage, width: 35, height: 35),
          Container(width: 15),
          Expanded(child: Text(text, softWrap: true, style: itemStyle))
        ],
      ),
    );
  }

  List<Widget> _buildItems(BuildContext context) {
    final fixedItems = [
      _buildItem(context, 'courseId.png', courseId),
      _buildItem(context, 'dynClassId.png', classes[0].dynClassId),
      _buildItem(context, 'campus.png', classes[0].campus),
    ];
    final List<String> timeStrings = generateTimeString();
    return fixedItems + timeStrings.map((e) => _buildItem(context, "day.png", e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildTitle(context)] + _buildItems(context),
          ),
        ),
      ),
    );
  }
}
