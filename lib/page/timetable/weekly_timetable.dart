import 'package:flutter/cupertino.dart';
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
    return Column(
      children: [
        Expanded(flex: 1, child: _buildDateTable(1)),
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
                          bottom:  BorderSide(color: Colors.black12, width: 0.8),
                          right: BorderSide(color: Colors.black12, width: 0.8)
                      )
                  ),
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
                        bottom:  BorderSide(color: Colors.black12, width: 0.8),
                        right: BorderSide(color: Colors.black12, width: 0.8)
                    )
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
          );
        });
  }

  Widget _buildLeftSectionColumn() {
    return GridView.builder(
        shrinkWrap: true,
        //  防止滚动超出边界
        // physics: const ClampingScrollPhysics(),
        itemCount: 11,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 1 / 1.5
        ),
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

  Widget _buildCourseGridView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7, mainAxisExtent: 50, mainAxisSpacing: 20.0, childAspectRatio: 1),
      itemCount: 77,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 228, 235, 245),
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          child: const Text("1231\n23"),
        );
      },
    );
  }


}
