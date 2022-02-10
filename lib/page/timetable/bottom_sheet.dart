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

import '../../entity/edu/timetable.dart';

class CourseBottomSheet extends StatelessWidget {
  final Size _deviceSize;
  final String _courseName;
  final String _courseId;
  final String _dynClassId;
  final String _campus;
  late List<String> _courseDetail;
  final List<Course> courseList;

  CourseBottomSheet(this._deviceSize, this.courseList, this._courseName, this._courseId, this._dynClassId, this._campus,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ParseCourse parseCourse = ParseCourse(courseList);
    _courseDetail = parseCourse.parseCourseDetail(_courseId);
    return Container(
      constraints: const BoxConstraints(maxHeight: 600),
      // color: Colors.transparent,
      // padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
      child: Container(
          // clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
          ),
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.fromLTRB(0, 25, 0, 5),
                  child: Container(
                    width: _deviceSize.width * 0.85,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Text(_courseName,
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            ?.copyWith(color: Colors.black, fontWeight: FontWeight.w600)),
                  )),
              Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(9.0),
                    ),
                  ),
                  height: _deviceSize.height * 0.43,
                  width: _deviceSize.width * 0.85,
                  child: ListView(
                    controller: ScrollController(),
                    scrollDirection: Axis.vertical,
                    children: [
                      Column(
                        children: [
                          _buildDetailItem(context, 'courseId.png', _courseId),
                          _buildDetailItem(context, 'dynClassId.png', _dynClassId),
                          _buildDetailItem(context, 'campus.png', _campus),
                        ],
                      ),
                      Column(
                        children: _courseDetail.map((e) => _buildDetailItem(context, "day.png", e)).toList(),
                      )
                    ],
                  )),
            ],
          )),
    );
  }

  Widget _buildDetailItem(BuildContext context, String iconName, String detail) {
    String iconPath = 'assets/timetable/' + iconName;
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
        child: Row(
          children: [
            Image(
              image: AssetImage(iconPath),
              width: 35,
              height: 35,
            ),
            Container(
              width: 15,
            ),
            Expanded(
                child: Text(detail,
                    softWrap: true,
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(color: Colors.black, fontWeight: FontWeight.w500))),
          ],
        ));
  }
}

class ParseCourse {
  final List<Course> courseList;

  ParseCourse(this.courseList);

  // 周次 日期x7 月份
  static final List<String> num2word = [
    "一",
    "二",
    "三",
    "四",
    "五",
    "六",
    "日",
  ];

  static Map<int, String> courseStartTime = {
    1: "8:20",
    2: "9:10",
    3: "10:15",
    // 由于疫情 没有课间的五分钟 所以第四节课上课时间为11:00
    4: "11:00",
    5: "13:00",
    6: "13:50",
    7: "14:55",
    8: "15:45",
    9: "18:00",
    10: "18:50",
    11: "19:40"
  };

  static Map<int, String> courseEndTime = {
    1: "9:05",
    2: "9:55",
    3: "11:00",
    4: "11:45",
    5: "13:45",
    6: "14:35",
    7: "15:40",
    8: "16:30",
    9: "18:45",
    10: "19:35",
    11: "20:25"
  };

  // 解析课程ID对应的不同时间段的课程信息
  List<String> parseCourseDetail(String courseId) {
    // 周数 星期 节次 地点
    List<String> courseDetail = [];
    for (Course course in courseList) {
      if (course.courseId == courseId) {
        courseDetail.add(course.weekText! +
            " 周" +
            num2word[course.dayIndex! - 1] +
            "\n" +
            parseCourseTimeIndex(course.timeIndex!) +
            course.place!);
      }
    }
    return courseDetail;
  }

  // 解析出来的时间默认尾部有一个空格 eg:"13:00-16:30 "
  static String parseCourseTimeIndex(int timeIndex) {
    // 除去首个0
    timeIndex = timeIndex >> 1;
    int count = 1;
    String parsedTime = "";
    bool isConstant = false;
    bool isAddEndTime = false;
    while (timeIndex != 0) {
      // 当前最低位为1 并且为首次或者上一位为0
      if ((timeIndex & 1) == 1 && isConstant == false) {
        parsedTime += courseStartTime[count]!;
        isConstant = true;
      } else if (isConstant && (timeIndex & 1) == 0) {
        parsedTime += "-" + courseEndTime[count - 1]! + " ";
        isConstant = false;
        isAddEndTime = true;
      }
      timeIndex = timeIndex >> 1;
      count++;
    }
    if (!isAddEndTime) {
      parsedTime += "-" + courseEndTime[count - 1]! + " ";
    }
    return parsedTime;
  }
}
