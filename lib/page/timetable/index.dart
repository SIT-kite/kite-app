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
import 'package:kite/dao/edu/timetable.dart';
import 'package:kite/entity/edu/index.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/page/timetable/daily_timetable.dart';
import 'package:kite/page/timetable/weekly_timetable.dart';
import 'package:kite/service/edu/index.dart';
import 'package:kite/util/logger.dart';

// 最大周数
const int maxWeekCount = 20;
// 课表模式
// 周课表 日课表
enum DisplayMode { daily, weekly }

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key? key}) : super(key: key);

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  // 模式：周课表 日课表
  DisplayMode displayMode = DisplayMode.daily;
  TimetableDao timetableDaoService = TimetableService(SessionPool.eduSession);

  // TODO：更改为正确的学期
  final SchoolYear currSchoolYear = const SchoolYear(2020);
  final currSemester = Semester.secondTerm;

  // TODO：更改为正确的开学日期
  DateTime termBeginDate = DateTime(2021, 9, 6);

  Map<int, List<List<int>>> dailyCourseList = {};
  List<Course> courseList = <Course>[];
  List<List<String>> dateTableList = [];

  // 当前学期开学时间
  // 学期最大周数
  bool isRefresh = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "课程表",
          style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.white),
        ),
        actions: <Widget>[
          _MorePopupMenuButton(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Text(
          "今",
          style: Theme.of(context).textTheme.headline4?.copyWith(color: Colors.white),
        ),
        onPressed: () {
          Log.debug("press goto current day button");
          displayMode == DisplayMode.daily
              ? dailyTimeTableKey.currentState?.gotoCurrPage()
              : weeklyTimeTableKey.currentState?.gotoCurrPage();
        },
      ),
      body: FutureBuilder(
        builder: _buildFuture,
        future: _getData(),
      ),
    );
  }

  Future<void> _getData() async {
    if (isRefresh) {
      Log.debug("refresh");
      StoragePool.course.clear();
      courseList = await timetableDaoService.getTimetable(currSchoolYear, currSemester);
      StoragePool.course.addAll(courseList);
      isRefresh = false;
    } else {
      if (StoragePool.course.isEmpty() == true) {
        Log.debug("get courseList from network");
        courseList = await timetableDaoService.getTimetable(currSchoolYear, currSemester);
        StoragePool.course.addAll(courseList);
      } else {
        Log.debug("read courseList from storage");
        courseList = await StoragePool.course.getTimetable(currSchoolYear, currSemester);
      }
    }
    generateDailyCourse();
    generateDateTable();
  }

  void generateDateTable() {
    int currYear = termBeginDate.year;
    int currDay = termBeginDate.day;
    int currMonth = termBeginDate.month;
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

  void generateDailyCourse() {
    for (int weekIndex = 0; weekIndex < maxWeekCount; weekIndex++) {
      dailyCourseList[weekIndex] = [[], [], [], [], [], [], []];
    }
    for (int i = 0; i < courseList.length; i++) {
      int weekIndex = 0;
      int dayIndex = 0;
      int? week = courseList[i].weekIndex;
      week = (week! >> 1);
      while ((week as int) != 0) {
        if ((week & 1) == 1) {
          dayIndex = courseList[i].dayIndex!.toInt() - 1;
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
        return displayMode == DisplayMode.daily
            ? DailyTimetable(
                key: dailyTimeTableKey,
                courseList: courseList,
                dailyCourseList: dailyCourseList,
                dateTableList: dateTableList,
                termBeginDate: termBeginDate,
              )
            : WeeklyTimetable(
                key: weeklyTimeTableKey,
                courseList: courseList,
                dailyCourseList: dailyCourseList,
                dateTableList: dateTableList,
                termBeginDate: termBeginDate,
              );
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
  }

  bool _LoadClassSchedule() {
    // TODO：导入课表
    return true;
  }

  // ignore: non_constant_identifier_names
  bool _DeriveClassSchedule() {
    // TODO：导出课表
    return true;
  }
}
