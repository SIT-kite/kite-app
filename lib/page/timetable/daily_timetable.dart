import 'package:flutter/material.dart';
import 'package:kite/dao/edu/timetable.dart';
import 'package:kite/entity/edu.dart';
import 'package:kite/mock/edu/timetable.dart';
import 'package:kite/page/timetable/bottom_sheet.dart';
import 'package:kite/util/edu/icon.dart';

class DailyTimetable extends StatefulWidget {
  const DailyTimetable({Key? key}) : super(key: key);

  @override
  _DailyTimetableState createState() => _DailyTimetableState();
}

class _DailyTimetableState extends State<DailyTimetable> {
  TimetableDao timetableDao = TimetableMock();
  final SchoolYear currSchoolYear = const SchoolYear(2021);
  final Semester currSemester = Semester.firstTerm;

  static const String courseIconPath = 'assets/timetable/course/';

  late Size _deviceSize;
  List<Course> courseList = <Course>[];
  List<Course> currDayCourseList = <Course>[];
  List<int> currDay = [0, 0];
  final List<int> tapped = [1, 1];
  bool isInitialized = false;

  // 周次 日期x7 月份
  final List<List<int>> dateTableList = [
    [1, 6, 7, 8, 9, 10, 11, 12, 9],
    [2, 13, 14, 15, 16, 17, 18, 19, 9],
    [3, 20, 21, 22, 23, 24, 25, 26, 9],
    [4, 27, 28, 29, 30, 1, 2, 3, 9]
  ];
  final List<String> num2word = [
    "一",
    "二",
    "三",
    "四",
    "五",
    "六",
    "日",
  ];

  void initialize() async {
    // TODO: 获取课程列表
    // TODO:获取起始日期

    // 拉取课程数据
    // courseList = await timetableDao.getTimetable(currSchoolYear, currSemester);
    // print(courseList.toString());

    // 解析当日课程列表
    currDayCourseList = _getCourseListByWeekAndDay(currDay[0], currDay[1]);
  }

  List<Course> _getCourseListByWeekAndDay(int weekIndex, int dayIndex) {
    // 测试数据
    Map<String, dynamic> testData = {
      "kcmc": "信息安全技术",
      "xqjmc": "星期一",
      "jcs": "5-6",
      "zcd": "1-5周",
      "cdmc": "二教F206",
      "xm": "张成姝",
      "xqmc": "奉贤校区",
      "xf": "2",
      "zxs": "28",
      "jxbmc": "2002356",
      "kch": "B4045126",
    };
    List<Course> res = <Course>[Course.fromJson(testData)];
    print(res);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    print("this is daily_timetable.dart");
    if (isInitialized == false) {
      _deviceSize = MediaQuery.of(context).size;
      initialize();
      isInitialized = true;
    }
    print(currDayCourseList.toString());
    return PageView.builder(
      controller: PageController(viewportFraction: 1.0),
      scrollDirection: Axis.horizontal,
      itemCount: 4,
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
              flex: 9,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                children: currDayCourseList.map((e) => _buildClassCard(context, e)).toList(),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildDateTable(int weekIndex) {
    List<int> currWeek = dateTableList[weekIndex];
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
                        currWeek[0].toString(),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                      const Text(
                        "周",
                        style: TextStyle(fontSize: 9),
                      )
                    ],
                  ))
              : Container(
                  width: _deviceSize.width * 3 / 23,
                  child: Container(
                      padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                      child: InkWell(
                        onTap: () {},
                        onTapDown: (TapDownDetails tapDownDetails) {
                          setState(() {
                            tapped[0] = weekIndex + 1;
                            tapped[1] = index;
                            currDayCourseList = _getCourseListByWeekAndDay(weekIndex + 1, index);
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color: ((tapped[0] == currWeek[0]) && (tapped[1] == index))
                                  ? Colors.blueAccent
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
                                  currWeek[8].toString() + "/" + currWeek[index].toString(),
                                  style: const TextStyle(fontSize: 9),
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
                                children: const [
                                  Text("8:20" + "~" + "9:50"),
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
            color: Colors.blueAccent,
            elevation: 30.0,
          )
        ],
      ),
    );
  }
}
