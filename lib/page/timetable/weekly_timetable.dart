import 'package:flutter/material.dart';

import '../../entity/edu/timetable.dart';

class WeeklyTimetable extends StatefulWidget {
  List<Course> courseList = <Course>[];

  // index1 -- 周数  index2 -- 天数
  Map<int, List<List<int>>> dailyCourseList = {};
  List<List<String>> dateTableList = [];

  WeeklyTimetable({Key? key, required this.courseList, required this.dailyCourseList, required this.dateTableList})
      : super(key: key);

  @override
  _WeeklyTimetableState createState() => _WeeklyTimetableState();
}

class _WeeklyTimetableState extends State<WeeklyTimetable> {
  late Size _deviceSize;
  static const double gridAspectRatioHeight = 1 / 1.7;
  late double singleGridHeight;
  late double singleGridWidth;

  final PageController _pageController = PageController(initialPage: 2, viewportFraction: 1.0);

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

  @override
  Widget build(BuildContext context) {
    _deviceSize = MediaQuery.of(context).size;
    singleGridHeight = _deviceSize.width * 2 / 23 / gridAspectRatioHeight;
    singleGridWidth = _deviceSize.width * 3 / 23;
    return PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        itemCount: 20,
        // index 从0开始
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Expanded(flex: 1, child: _buildDateTable(index)),
              Expanded(
                  flex: 10,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    controller: ScrollController(),
                    child: Row(
                      textDirection: TextDirection.ltr,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildLeftSectionColumn(),
                        ),
                        Expanded(flex: 21, child: _buildCourseGridView())
                      ],
                    ),
                  )),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //为了避免内存泄露，需要调用_controller.dispose
    _pageController.dispose();
    super.dispose();
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
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              bottom: BorderSide(color: Colors.black12, width: 0.8),
                              right: BorderSide(color: Colors.black12, width: 0.8))),
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
                      )))
              : SizedBox(
                  width: _deviceSize.width * 3 / 23,
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              bottom: BorderSide(color: Colors.black12, width: 0.8),
                              right: BorderSide(color: Colors.black12, width: 0.8))),
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
                );
        });
  }

  Widget _buildLeftSectionColumn() {
    return GridView.builder(
        shrinkWrap: true,
        //  防止滚动超出边界
        // physics: const ClampingScrollPhysics(),
        itemCount: 11,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, childAspectRatio: gridAspectRatioHeight),
        itemBuilder: (BuildContext context, int index) {
          return Container(
              child: Center(
                child: Text(
                  (index + 1).toInt().toString(),
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                // border: Border.all(color: Colors.black12, width: 0.5),
                border: Border(
                  top: BorderSide(color: Colors.black12, width: 0.8),
                  right: BorderSide(color: Colors.black12, width: 0.8),
                ),
              ));
        });
  }

  _getCourseListByWeek() {}

  Widget _buildCourseGridView() {
    return SizedBox(
      width: singleGridWidth * 7,
      height: singleGridHeight * 11,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(1, 0, 0, 0),
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return SizedBox(
              width: singleGridWidth,
              height: singleGridHeight * 11,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: singleGridWidth,
                    height: singleGridHeight * 2,
                    alignment: const Alignment(0, 0),
                    child: InkWell(
                      onTapDown: (TapDownDetails tapDownDetails) {},
                      onTap: () {
                        print("press");
                      },
                      child: Container(
                        width: singleGridWidth - 3,
                        height: singleGridHeight * 2 - 4,
                        decoration: const BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.all(Radius.circular(3.0)),
                            border: Border(
                              top: BorderSide(color: Colors.lightBlueAccent, width: 1),
                              right: BorderSide(color: Colors.lightBlueAccent, width: 1),
                              left: BorderSide(color: Colors.lightBlueAccent, width: 1),
                              bottom: BorderSide(color: Colors.lightBlueAccent, width: 1),
                            )),
                        child: const Text("123"),
                      ),
                    ),
                  );
                },
              ));
        },
      ),
    );
  }
}
