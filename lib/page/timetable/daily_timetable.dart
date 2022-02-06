/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:flutter/material.dart';
import 'package:kite/entity/edu/index.dart';
import 'package:kite/page/timetable/bottom_sheet.dart';
import 'package:kite/util/edu/icon.dart';

GlobalKey<_DailyTimetableState> dailyTimeTableKey = GlobalKey();

class DailyTimetable extends StatefulWidget {
  List<Course> courseList = <Course>[];
  // index1 -- 周数  index2 -- 天数
  Map<int, List<List<int>>> dailyCourseList = {};
  List<List<String>> dateTableList = [];

  DailyTimetable({Key? key, required this.courseList, required this.dailyCourseList, required this.dateTableList})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _DailyTimetableState createState() =>
      _DailyTimetableState();
}

class _DailyTimetableState extends State<DailyTimetable> {

  PageController _pageController = PageController(initialPage: 0, viewportFraction: 1.0);


  DateTime currTime = DateTime(2021, 12, 25);
  DateTime startTime = DateTime(2021, 9, 6);

  static const String courseIconPath = 'assets/course/';
  bool firstOpen = true;
  late Size _deviceSize;

  bool isShowReturnCurrDayButton = false;

  List<Course> currDayCourseList = <Course>[];
  final List<int> tapped = [0, 0];
  int currTimeIndex = 0;
  bool isInitialized = false;

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

  Map<int, String> courseStartTime={
    1:"8:20",
    2:"9:10",
    3:"10:15",
    // 由于疫情 没有课间的五分钟
    4:"11:00",
    5:"13:00",
    6:"13:50",
    7:"14:55",
    8:"15:45",
    9:"18:00",
    10:"18:50",
    11:"19:40"
  };

  Map<int, String> courseEndTime={
    1:"9:05",
    2:"9:55",
    3:"11:00",
    4:"11:45",
    5:"13:45",
    6:"14:35",
    7:"15:40",
    8:"16:30",
    9:"18:45",
    10:"19:35",
    11:"20:25"
  };

  @override
  void initState() {
    super.initState();
    int days = currTime.difference(startTime).inDays;
    currTimeIndex = (days-6)~/7+1;
  }

  void gotoCurrPage(){
    print(currTimeIndex);
    // _pageController.animateToPage(currTimeIndex,
    //     duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    _pageController.jumpToPage(currTimeIndex);
    setState(() {
      tapped[0] = currTimeIndex;
      tapped[1] = 0;
      currDayCourseList = _getCourseListByWeekAndDay(tapped[0], tapped[1]);
    });
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _pageController.dispose();
    super.dispose();
  }

  List<Course> _getCourseListByWeekAndDay(int weekIndex, int dayIndex) {
    print("this is getCourseListByWeekAndDay");
    List<Course> res = <Course>[];
    for (var i in widget.dailyCourseList[weekIndex]![dayIndex]) {
      res.add(widget.courseList[i]);
    }
    return res;
  }

  String parseCourseTimeIndex(int timeIndex){
    // 除去首个0
    timeIndex = timeIndex>>1;
    int count = 1;
    String parsedTime = "";
    bool isConstant = false;
    bool isAddEndTime = false;
    while(timeIndex != 0){
      // 当前最低位为1 并且为首次或者上一位为0
      if ((timeIndex & 1) == 1 && isConstant == false) {
        parsedTime += courseStartTime[count]!;
        isConstant = true;
      }else if (isConstant && (timeIndex & 1) == 0){
        parsedTime += "-" + courseEndTime[count-1]! + " ";
        isConstant = false;
        isAddEndTime = true;
      }
      timeIndex = timeIndex >> 1;
      count++;
    }
    if (!isAddEndTime){
      parsedTime += "-" + courseEndTime[count-1]! + " ";
    }
    return parsedTime;
  }

  @override
  Widget build(BuildContext context) {
    if (firstOpen) {
      currDayCourseList = _getCourseListByWeekAndDay(0, 0);
      firstOpen = false;
    }
    _deviceSize = MediaQuery.of(context).size;
    print("currDayCourseList");
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
                      : currDayCourseList.map((e) => _buildClassCard(context, e)).toList()),
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
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                      const Text(
                        "周",
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ))
              : Container(
                  width: _deviceSize.width * 3 / 23,
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            tapped[0] = weekIndex;
                            tapped[1] = index - 1;
                            print("tapped on:"+tapped.toString());
                            currDayCourseList = _getCourseListByWeekAndDay(weekIndex, index - 1);
                          });
                        },
                        onTapDown: (TapDownDetails tapDownDetails) {},
                        child: Container(
                            decoration: BoxDecoration(
                              color: ((tapped[0] == weekIndex) && (tapped[1] == index - 1))
                                  ? const Color.fromARGB(255, 228, 235, 245)
                                  : Colors.white,
                              borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "周" + num2word[index - 1],
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
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
    // 测试数据
    print(course);
    List<String> detail = [course.place.toString()];
    return InkWell(
      onTap: () {},
      onTapDown: (TapDownDetails tapDownDetails) {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return CourseBottomSheet(_deviceSize, course.courseName.toString(), course.courseId.toString(),
                  course.dynClassId.toString(), detail);
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
                    leading: Image.asset(courseIconPath + CourseCategory.query(course.courseName ?? '') + '.png'),
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
                                // TODO: 解析timeIndex
                                children: [
                                  Text(parseCourseTimeIndex(course.timeIndex!)),
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
