import 'package:flutter/material.dart';
import 'package:kite/entity/edu.dart';
import 'package:kite/page/timetable/bottom_sheet.dart';
import 'package:kite/util/edu/icon.dart';

class DailyTimetable extends StatefulWidget {
  List<Course> courseList = <Course>[];
  Map<int, List<List<int>>> dailyCourseList = {};
  List<List<String>> dateTableList = [];

  DailyTimetable({Key? key, required this.courseList, required this.dailyCourseList, required this.dateTableList})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _DailyTimetableState createState() =>
      _DailyTimetableState(courseList: courseList, dailyCourseList: dailyCourseList, dateTableList: dateTableList);
}

class _DailyTimetableState extends State<DailyTimetable> {
  _DailyTimetableState({required this.courseList, required this.dailyCourseList, required this.dateTableList});

  static const String courseIconPath = 'assets/course/';
  bool firstOpen = true;
  late Size _deviceSize;

  // index1 -- 周数  index2 -- 天数
  Map<int, List<List<int>>> dailyCourseList = {};
  List<Course> courseList = <Course>[];
  List<Course> currDayCourseList = <Course>[];
  final List<int> tapped = [0, 0];
  bool isInitialized = false;

  // 周次 日期x7 月份
  List<List<String>> dateTableList = [];
  final List<String> num2word = [
    "一",
    "二",
    "三",
    "四",
    "五",
    "六",
    "日",
  ];
  Map<int?, String> timeIndex2Time = {
    6: "8:20-9:55",
    24: "10:15-11:50",
    96: "13:00-14:35",
    384: "14:55-16:30",
    30: "8:20-11:50",
    126: "8:20-11:50 13:00-14:35",
    510: "8:20-11:50 13:00-16:30",
    504: "10:15-11:50 13:00-16:30",
    480: "13:00-16:30",
    1536: "18:00-19:35",
    3584: "18:00-20:25",
    4064: "13:00-20:25",
    null: "XXX"
  };

  List<Course> _getCourseListByWeekAndDay(int weekIndex, int dayIndex) {
    List<Course> res = <Course>[];
    print(weekIndex);
    print(dayIndex);
    for (var i in dailyCourseList[weekIndex]![dayIndex]) {
      res.add(courseList[i]);
    }
    print("this is getCourseListByWeekAndDay");
    print(res);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    if (firstOpen) {
      currDayCourseList = _getCourseListByWeekAndDay(0, 0);
      firstOpen = false;
    }
    _deviceSize = MediaQuery.of(context).size;
    return PageView.builder(
      controller: PageController(viewportFraction: 1.0),
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
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                      children: currDayCourseList == []
                          ? [
                              const Center(
                                child: Text("今天没有课哦"),
                              )
                            ]
                          : currDayCourseList.map((e) => _buildClassCard(context, e)).toList()),
                ))
          ],
        );
      },
    );
  }

  Widget _buildDateTable(int weekIndex) {
    List<String> currWeek = dateTableList[weekIndex];
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
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      const Text(
                        "周",
                        style: TextStyle(fontSize: 14),
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
                            print("tapped");
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
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  currWeek[index - 1],
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            )),
                      )),
                );
        });
  }

  Widget _buildClassCard(BuildContext context, Course course) {
    // 测试数据
    List<String> detail = ["1-5周 星期一(1~2节) 一教A205"];
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
          const Padding(padding: EdgeInsets.all(5)),
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
                                  Text(timeIndex2Time[course.timeIndex]!),
                                ],
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Text(course.place.toString()),
                                  ],
                                )),
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
