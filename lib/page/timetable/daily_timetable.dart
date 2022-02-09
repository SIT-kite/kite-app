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
import 'package:kite/page/timetable/bottom_sheet.dart';
import 'package:kite/util/edu/icon.dart';

// TODO: 待测试晚上(18:00-20:25)课程渲染效果

GlobalKey<_DailyTimetableState> dailyTimeTableKey = GlobalKey();

class DailyTimetable extends StatefulWidget {
  late DateTime startTime;
  List<Course> courseList = <Course>[];

  // index1 -- 周数  index2 -- 天数
  Map<int, List<List<int>>> dailyCourseList = {};
  List<List<String>> dateTableList = [];

  DailyTimetable(
      {Key? key,
      required this.courseList,
      required this.dailyCourseList,
      required this.dateTableList,
      required this.startTime})
      : super(key: key);

  @override
  _DailyTimetableState createState() => _DailyTimetableState();
}

class _DailyTimetableState extends State<DailyTimetable> {
  late PageController _pageController;
  DateTime currTime = DateTime(2021, 11, 23);

  static const String courseIconPath = 'assets/course/';
  late Size _deviceSize;

  bool isShowReturnCurrDayButton = false;

  List<Course> currDayCourseList = <Course>[];
  final List<int> tapped = [0, 0];
  // 在当前时间下，课表应该显示的页数为currTimePageIndex
  int currTimePageIndex = 0;
  // 当前页应该显示的天为currDayInWeekIndex
  int currDayInWeekIndex = 0;

  // 周次 日期x7 月份
  final List<String> num2word = [
    "一",
    "二",
    "三",
    "四",
    "五",
    "六",
    "日",
  ];

  Map<int, String> courseStartTime = {
    1: "8:20",
    2: "9:10",
    3: "10:15",
    // 由于疫情 没有课间的五分钟
    4: "11:00",
    5: "13:00",
    6: "13:50",
    7: "14:55",
    8: "15:45",
    9: "18:00",
    10: "18:50",
    11: "19:40"
  };

  Map<int, String> courseEndTime = {
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

  @override
  void initState() {
    super.initState();
    int days = currTime.difference(widget.startTime).inDays;
    currTimePageIndex = (days - 6) ~/ 7 + 1;
    currDayInWeekIndex = days%7;
    _pageController =  PageController(initialPage: currTimePageIndex, viewportFraction: 1.0);
    setState(() {
      tapped[0] = currTimePageIndex;
      tapped[1] = currDayInWeekIndex;
      currDayCourseList = _getCourseListByWeekAndDay(currTimePageIndex, currDayInWeekIndex);
    });
  }

  void gotoCurrPage() {
    _pageController.jumpToPage(currTimePageIndex);
    setState(() {
      tapped[0] = currTimePageIndex;
      tapped[1] = currDayInWeekIndex;
      currDayCourseList = _getCourseListByWeekAndDay(currTimePageIndex, currDayInWeekIndex);
    });
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _pageController.dispose();
    super.dispose();
  }

  List<Course> _getCourseListByWeekAndDay(int weekIndex, int dayIndex) {
    List<Course> res = <Course>[];
    for (var i in widget.dailyCourseList[weekIndex]![dayIndex]) {
      res.add(widget.courseList[i]);
    }
    res.sort((a, b) => (a.timeIndex!).compareTo(b.timeIndex!));
    return res;
  }

  @override
  Widget build(BuildContext context) {
    _deviceSize = MediaQuery.of(context).size;
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.horizontal,
      itemCount: 20,
      // index 从0开始
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  child: _buildDateTable(index),
                )),
            Expanded(
              flex: 10,
              child: ListView(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  children: currDayCourseList == []
                      ? [
                          const Center(
                            child: Text("今天没有课哦"),
                          )
                        ]
                      : currDayCourseList
                          .map((e) => _buildClassCard(context, e))
                          .toList()),
            )
          ],
        );
      },
    );
  }

  Widget _buildDateTable(int weekIndex) {
    List<String> currWeek = widget.dateTableList[weekIndex];
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        itemBuilder: (BuildContext context, int index) {
          return index == 0
              ? SizedBox(
                  width: _deviceSize.width * 2 / 23,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (weekIndex + 1).toString(),
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                      const Text(
                        "周",
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ))
              : SizedBox(
                  width: _deviceSize.width * 3 / 23,
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            tapped[0] = weekIndex;
                            tapped[1] = index - 1;
                            currDayCourseList = _getCourseListByWeekAndDay(
                                weekIndex, index - 1);
                          });
                        },
                        onTapDown: (TapDownDetails tapDownDetails) {},
                        child: Container(
                            decoration: BoxDecoration(
                              color: ((tapped[0] == weekIndex) &&
                                      (tapped[1] == index - 1))
                                  ? const Color.fromARGB(255, 228, 235, 245)
                                  : Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12.0)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "周" + num2word[index - 1],
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  currWeek[index - 1],
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ],
                            )),
                      )),
                );
        });
  }

  Widget _buildClassCard(BuildContext context, Course course) {
    return InkWell(
      onTap: () {},
      onTapDown: (TapDownDetails tapDownDetails) {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return CourseBottomSheet(
                  _deviceSize,
                  widget.courseList,
                  course.courseName.toString(),
                  course.courseId.toString(),
                  course.dynClassId.toString(),
                  course.campus.toString());
            },
            context: context);
      },
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(4)),
          Card(
            child: Column(
              children: [
                ListTile(
                    leading: Image.asset(courseIconPath +
                        CourseCategory.query(course.courseName ?? '') +
                        '.png'),
                    title: Text(course.courseName.toString()),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Text(course.teacher.toString()),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                textDirection: TextDirection.ltr,
                                children: [
                                  Text(ParseCourse.parseCourseTimeIndex(course.timeIndex!)),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                course.place.toString(),
                                textAlign: TextAlign.right,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ],
            ),
            shape: const RoundedRectangleBorder(
              // ignore: prefer_const_constructors
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            clipBehavior: Clip.antiAlias,
            color: const Color.fromARGB(255, 228, 235, 245),
          )
        ],
      ),
    );
  }
}
