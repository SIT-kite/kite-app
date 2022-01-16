import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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

class CourseInfo {
  late final String showCourse;
  late final String showTutor;
  late final String showLocation;
  late final String startTime;
  late final String endTime;
  late final String classCode;
  late final String classOrderNumber;
  late final List<String> allShowLocation;
  late final List<List<String>> allWeek;

  CourseInfo(this.showCourse, this.showTutor, this.showLocation, this.startTime, this.endTime, this.classCode,
      this.classOrderNumber, this.allShowLocation, this.allWeek);
}


class _TimetablePageState extends State<TimetablePage> {
  late Size deviceSize;
  final ScrollController _dateTableController = ScrollController();
  final Time _selectedTime = Time("2022", "01", "02", "12", "58", "12");
  List<CourseInfo> _currClassInfoList = <CourseInfo>[
    CourseInfo("信息安全技术", "张成姝", "综合实验楼A521", "8:20", "9:45", "B4045126", "2002356", [
      "二教F206",
      "综合实验楼521",
      "二教H305"
    ], [
      ["1-5周", "周一 1~2节"],
      ["6-9周", "周一 1~2节"],
      ["1-9周", "周三 5~6节"]
    ]),
    CourseInfo("测试管理与质量保证", "张蕊", "二教H204", "10:15", "11:45", "B2045126", "1002356", [
      "二教F206",
      "综合实验楼521",
      "二教H305"
    ], [
      ["1-5周", "周一 1~2节"],
      ["6-9周", "周一 1~2节"],
      ["1-9周", "周三 5~6节"]
    ]),
  ];
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

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 30.0,
        title: Text(_selectedTime.toStr_YearMonth()),
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
                children: _currClassInfoList.map((e) => _buildClassCard(context, e)).toList(),
              ),
            )
          ],
        );
      },
    );
  }

  List<CourseInfo> _getcurrDayClassInfo(int weekIndex, int dayIndex) {
    return <CourseInfo>[
      CourseInfo("体育", "谢晴", "东操场", "8:20", "9:45", "B4045126", "2002356", [
        "二教F206",
        "综合实验楼521",
        "二教H305"
      ], [
        ["1-5周 周一 1~2节"],
        ["6-9周 周一 1~2节"],
        ["1-9周 周三 5~6节"],
        ["1-9周 周三 5~6节 "]
      ])
    ];
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
                _currClassInfoList = _getcurrDayClassInfo(weekIndex, index);
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

  Widget _buildBottomSheet(CourseInfo courseInfo, Size phoneSize) {
    List<List<String>> detailList = [
      ["assets/timetable/icons/courseId.png", courseInfo.classCode],
      ["assets/timetable/icons/dynClassId.png", courseInfo.classOrderNumber],
      ["assets/timetable/icons/campus.png"] + courseInfo.allShowLocation,
    ];
    for (int i = 0; i < courseInfo.allWeek.length; i++) {
      detailList.add(["assets/timetable/icons/day.png"] + courseInfo.allWeek[i]);
    }
    //用于在底部打开弹框的效果
    return Container(
      constraints: BoxConstraints(maxHeight: 600),
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
      child: Container(
        // clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 228, 235, 245),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(50.0),
              topRight: const Radius.circular(50.0),
            ),
          ),
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 228, 235, 245),
                      borderRadius: BorderRadius.all(
                        const Radius.circular(5.0),
                      ),
                    ),
                    child: Text(
                      courseInfo.showCourse,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  )),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      const Radius.circular(20.0),
                    ),
                  ),
                  height: deviceSize.height * 0.43,
                  width: deviceSize.width * 0.7,
                  child: ListView(
                    controller: ScrollController(),
                    scrollDirection: Axis.vertical,
                    children: detailList.map((detail) => _buildClassDetail(detail)).toList(),
                  )),
            ],
          )),
    );
  }

  Widget _buildClassDetail(List<String> detail) {
    String courseIconPath = detail[0];
    return Container(
        padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
        child: Row(
          children: [
            Image(
              image: AssetImage(detail[0]),
              width: 35,
              height: 35,
            ),
            Container(
              width: 15,
            ),
            Text(detail[1],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                )
            ),
          ],
        ));
  }

  Widget _buildClassCard(BuildContext context, CourseInfo courseInfo) {
    return InkWell(
      onTap: () {},
      onTapDown: (TapDownDetails tapDownDetails) {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            // 是否可以滚动
            // isScrollControlled: true,
            builder: (BuildContext context) {
              return _buildBottomSheet(courseInfo, MediaQuery.of(context).size);
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
                    title: Text(courseInfo.showCourse),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Text(courseInfo.showTutor),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                textDirection: TextDirection.ltr,
                                children: [
                                  Text(courseInfo.startTime + "~" + courseInfo.endTime),
                                ],
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Text(courseInfo.showLocation),
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



