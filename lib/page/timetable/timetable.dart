import 'package:flutter/material.dart';
import 'package:kite/page/timetable/bottom_sheet.dart';
import 'package:kite/entity/edu/timetable.dart';


class TimetablePage extends StatefulWidget {
  const TimetablePage({Key? key}) : super(key: key);

  @override
  _TimetablePageState createState() => _TimetablePageState();
}



class Time {
  late final String year;
  late final String month;
  late final String day;
  late final String hour;
  late final String minute;
  late final String second;

  Time(this.year, this.month, this.day, this.hour, this.minute, this.second);

  String toStr_YearMonth() {
    return year + "年" + month + "月";
  }
}


class _TimetablePageState extends State<TimetablePage> {
  late Size _deviceSize;
  final ScrollController _dateTableController = ScrollController();
  final Time _selectedTime = Time("2022", "01", "02", "12", "58", "12");
  List<Course> _courseList = <Course>[];
  final TextStyle dateTableTextStyle1 = TextStyle(fontSize: 12, fontWeight: FontWeight.w400);
  final TextStyle dateTableTextStyle2 = TextStyle(fontSize: 9);

  // final Time currSemesterStartTime = Time(2021, 09, 06)
  final List<List<int>> dateTable = [
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
  final List<int> tapped = [1, 1];

  void dateTableGeneration() {}

  @override
  void initState() {
    super.initState();
    _dateTableController.addListener(() {
      print(_dateTableController.offset);
    });
  }

  @override
  void dispose() {
    _dateTableController.dispose();
    super.dispose();
  }


  void _pullCourseList(){
    Map<String, dynamic> testData = {
      "kcmc": "信息安全技术",
      "xqjmc": "星期一",
      "jcs": "1-2",
      "zcd": "1-5周",
      "cdmc": "二教F206",
      "xm": "张成姝",
      "xqmc": "奉贤校区",
      "xf": "2",
      "zxs": "28",
      "jxbmc": "2002356",
      "kch": "B4045126",
    };
    _courseList.add(Course.fromJson(testData));
  }

  @override
  Widget build(BuildContext context) {
    _deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 30.0,
        title: const Text("课程表"),
        actions: <Widget>[
          _MorePopupMenuButton(context),
        ],
      ),
      body: _buildClassSchedule(),
    );
  }

  // ignore: non_constant_identifier_names
  PopupMenuButton _MorePopupMenuButton(BuildContext context) {
    return PopupMenuButton<Function>(
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<Function>>[
          PopupMenuItem<Function>(
            child: const Text("刷新"),
            value: _RefreshClassSchedule,
          ),
          PopupMenuItem<Function>(
            child: const Text("导出课表"),
            value: _DeriveClassSchedule,
          ),
          PopupMenuItem<Function>(
            child: const Text("导入课表"),
            value: _LoadClassSchedule,
          ),
        ];
      },
      onSelected: (Function fun) {
        fun();
      },
    );
  }

  // ignore: non_constant_identifier_names
  bool _RefreshClassSchedule() {
    print("refresh");
    return true;
  }

  // ignore: non_constant_identifier_names
  bool _LoadClassSchedule() {
    print("load class schedule");
    return true;
  }

  // ignore: non_constant_identifier_names
  bool _DeriveClassSchedule() {
    print("derive class schedule");
    return true;
  }

  List<int> _getCurrWeek(int currWeekIndex) {
    return [1, 6, 7, 8, 9, 10, 11, 12, 9];
  }

  Widget _buildClassSchedule() {
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);
    // 获取当前周次
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
                  child: _buildDateTable(index, MediaQuery.of(context).size.width),
                )),
            Expanded(
              flex: 9,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                children: _courseList.map((e) => _buildClassCard(context, e)).toList(),
              ),
            )
          ],
        );
      },
    );
  }

  List<Course> _getCourseListByWeekAndDay(int weekIndex, int dayIndex) {

    Map<String, dynamic> testData = {
      "kcmc": "体育",
      "xqjmc": "星期二",
      "jcs": "5-6",
      "zcd": "1-9周",
      "cdmc": "东操场",
      "xm": "谢晴",
      "xqmc": "奉贤校区",
      "xf": "2",
      "zxs": "24",
      "jxbmc": "2202356",
      "kch": "B4035126",
    };
    List<Course> res = <Course>[Course.fromJson(testData)];
    return  res;
  }

  // i --> 周次
  Widget _buildDateTable(int weekIndex, double parentWidth) {
    List<int> currWeek = dateTable[weekIndex];
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 8,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return SizedBox(
                width: parentWidth * 2 / 23,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currWeek[0].toString(),
                      style: dateTableTextStyle1,
                    ),
                    Text(
                      "周",
                      style: dateTableTextStyle1,
                    )
                  ],
                ));
          }
          return InkWell(
            onTap: () {},
            onTapDown: (TapDownDetails tapDownDetails) {
              print(weekIndex.toString());
              print(index.toString());
              setState(() {
                tapped[0] = weekIndex + 1;
                tapped[1] = index;
                _courseList = _getCourseListByWeekAndDay(weekIndex+1, index+1);
              });
            },
            child: Container(
              width: parentWidth * 3 / 23,
              child: Container(
                padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                child: Container(
                    decoration: BoxDecoration(
                      // 背景
                      color: ((tapped[0] == currWeek[0]) && (tapped[1] == index)) ? Colors.blueAccent : Colors.white,
                      //设置四周圆角 角度
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      //设置四周边框
                    ),
                    width: parentWidth * 3 / 23,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "周" + num2word[index - 1],
                          style: dateTableTextStyle1,
                        ),
                        Text(
                          currWeek[8].toString() + "/" + currWeek[index].toString(),
                          style: dateTableTextStyle2,
                        ),
                      ],
                    )),
              ),
            ),
          );
        });
  }

  Widget _buildClassCard(BuildContext context, Course course) {
    List<String> detail = ["1-5周 星期一(1~2节) 一教A205"];
    return InkWell(
      onTap: () {},
      onTapDown: (TapDownDetails tapDownDetails) {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            // 是否可以滚动
            // isScrollControlled: true,
            builder: (BuildContext context) {
              return CourseBottomSheet(_deviceSize, course.courseName.toString(),
                  course.courseId.toString(), course.dynClassId.toString(), detail);
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
                    leading: const Icon(
                      Icons.cabin,
                      size: 50.0,
                    ),
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



