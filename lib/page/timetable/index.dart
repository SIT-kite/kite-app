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
import 'package:kite/global/session_pool.dart';
import 'package:kite/global/storage_pool.dart';
import 'package:kite/service/edu/index.dart';
import 'package:kite/util/flash.dart';

import 'daily.dart';

/// 课表模式
enum DisplayMode { daily, weekly }

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key? key}) : super(key: key);

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  /// 最大周数
  static const int maxWeekCount = 20;

  // 模式：周课表 日课表
  DisplayMode displayMode = DisplayMode.daily;

  // TODO：更改为正确的学期
  final SchoolYear currSchoolYear = const SchoolYear(2020);
  final currSemester = Semester.secondTerm;

  // TODO：更改为正确的开学日期
  DateTime termBeginDate = DateTime(2021, 9, 6);

  List<Course> courseList = <Course>[];

  bool isRefreshing = false;

  Future<void> _fetchTimetable() async {
    final service = TimetableService(SessionPool.eduSession);
    final timetable = await service.getTimetable(currSchoolYear, currSemester);

    StoragePool.course.clear();
    StoragePool.course.addAll(timetable);
  }

  Future<void> _onRefresh() async {
    if (isRefreshing) {
      return;
    }
    isRefreshing = true;
    try {
      await _fetchTimetable();
      showBasicFlash(context, const Text('加载成功'));
    } catch (e) {
      showBasicFlash(context, Text('加载失败: ${e.toString().split('\n')[0]}'));
    } finally {
      isRefreshing = false;
    }
    // 刷新界面
    setState(() {});
  }

  bool _onExport() {
    // TODO：导出课表
    return true;
  }

  PopupMenuButton _buildPopupMenu(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry>[
          PopupMenuItem(
            child: const Text('刷新'),
            onTap: _onRefresh,
          ),
          PopupMenuItem(
            child: const Text('导出课表'),
            onTap: _onExport,
          ),
        ];
      },
    );
  }

  void _onPressJumpToday() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('课程表'), actions: <Widget>[_buildPopupMenu(context)]),
      floatingActionButton: FloatingActionButton(child: const Text('今'), onPressed: _onPressJumpToday),
      // TODO: 记住上一次查看的页面.
      body: DailyTimetable(StoragePool.course.getTimetable(currSchoolYear, currSemester)),
    );
  }
}
