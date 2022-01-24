import 'package:flutter/material.dart';
import 'package:kite/dao/edu/timetable.dart';
import 'package:kite/entity/edu.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/mock/edu/timetable.dart';
import 'package:kite/page/timetable/daily_timetable.dart';
import 'package:kite/service/edu.dart';
import 'package:kite/storage/timetable.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key? key}) : super(key: key);

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  TimetableDao timetableDaoService = TimetableService();
  final SchoolYear currSchoolYear = const SchoolYear(2021);
  final currSemester = Semester.firstTerm;
  Map<int, List<List<int>>> dailyCourseList = {};
  List<Course> courseList = <Course>[];
  List<List<String>> dateTableList = [];
  DateTime startTime = DateTime(2021, 9, 6);
  static const int maxWeekCount = 20;
  bool isRefresh = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("课程表"),
        actions: <Widget>[
          _MorePopupMenuButton(context),
        ],
      ),
      body: FutureBuilder(
        builder: _buildFuture,
        future: _getData(),
      ),
    );
  }

  Future<void> _getData() async {
    if (isRefresh) {
      print("refresh");
      StoragePool.course.clear();
      courseList = await timetableDaoService.getTimetable(currSchoolYear, currSemester);
      StoragePool.course.addAll(courseList);
      isRefresh = false;
    } else {
      if (StoragePool.course.isEmpty() == true) {
        print("get courseList from network");
        courseList = await timetableDaoService.getTimetable(currSchoolYear, currSemester);
        StoragePool.course.addAll(courseList);
      } else {
        print("read courseList from storage");
        courseList = await StoragePool.course.getTimetable(currSchoolYear, currSemester);
      }
    }
    // print(courseList);
    generateDailyTimetable();
    generateDateTable();
  }

  void generateDateTable() {
    int currYear = startTime.year;
    int currDay = startTime.day;
    int currMonth = startTime.month;
    int currMonthDayCount = DateUtils.getDaysInMonth(currYear, currMonth);
    for (int weekIndex = 0; weekIndex < maxWeekCount; weekIndex++) {
      dateTableList.add([]);
      for (int dayIndex = 0; dayIndex < 7; dayIndex++) {
        dateTableList[weekIndex].add(currMonth.toString() + "/" + currDay.toString());
        currDay++;
        if (currDay > currMonthDayCount) {
          currDay = 1;
          currMonth++;
          if (currMonth > 12) {
            currMonth = 1;
            currYear++;
          }
          currMonthDayCount = DateUtils.getDaysInMonth(currYear, currMonth);
        }
      }
    }
  }

  void generateDailyTimetable() {
    print("process courseList data");
    for (int weekIndex = 0; weekIndex < maxWeekCount; weekIndex++) {
      dailyCourseList[weekIndex] = [[], [], [], [], [], [], []];
    }
    for (int i = 0; i < courseList.length; i++) {
      int weekIndex = 0;
      int dayIndex = 0;
      int? week = courseList[i].week;
      week = (week! >> 1);
      while ((week as int) != 0) {
        if ((week & 1) == 1) {
          dayIndex = courseList[i].day!.toInt() - 1;
          if (dailyCourseList[weekIndex] == null) {
            dailyCourseList[weekIndex] = [[], [], [], [], [], [], []];
          }
          dailyCourseList[weekIndex]![dayIndex].add(i);
        }
        weekIndex++;
        week = week >> 1;
      }
    }
  }

  Widget _buildFuture(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasError) {
        // 请求失败，显示错误
        return Text("Error: ${snapshot.error}");
      } else {
        // 请求成功，显示数据
        return DailyTimetable(courseList: courseList, dailyCourseList: dailyCourseList, dateTableList: dateTableList);
      }
    } else {
      // 请求未结束，显示loading
      return const Center(child: CircularProgressIndicator());
    }
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
  Future<void> _RefreshClassSchedule() async {
    setState(() {
      isRefresh = true;
    });
    print("get courseList from network");
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
}
