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
import 'package:kite/feature/edu/timetable/cache.dart';
import 'package:kite/util/logger.dart';

import '../../entity.dart';
import 'daily.dart';
import 'weekly.dart';

class TimetableViewer extends StatefulWidget {
  /// 初始课表元数据
  final TimetableMeta? initialTableMeta;

  /// 初始课表课程
  final List<Course> initialTableCourses;

  /// 初始显示模式
  final DisplayMode initialDisplayMode;

  /// 显示模式被更改的回调
  final void Function(DisplayMode)? onDisplayChanged;
  final VoidCallback? onJumpedToday;

  /// 课表视图使用的缓存
  final TableCache tableCache;

  /// 课表控制器
  final TimetableViewerController? controller;

  const TimetableViewer({
    required this.initialTableMeta,
    required this.initialTableCourses,
    required this.initialDisplayMode,
    required this.tableCache,
    this.onDisplayChanged,
    this.onJumpedToday,
    this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<TimetableViewer> createState() => _TimetableViewerState();
}

class TimetableViewerController {
  _TimetableViewerState? _state;
  TimetableViewerController();

  void switchDisplayMode() {
    _state?.switchDisplayMode();
  }

  void jumpToToday() {
    _state?.jumpToday();
  }

  void jumpToWeeK(int week) {
    _state?.jumpWeek(week);
  }

  void _bindState(State<TimetableViewer> state) {
    _state = state as _TimetableViewerState;
  }
}

class _TimetableViewerState extends State<TimetableViewer> {
  /// 最大周数
  /// TODO 还没用上
  // static const int maxWeekCount = 20;

  final cache = TableCache();

  final currentKey = GlobalKey();

  /// 模式：周课表 日课表
  late DisplayMode displayModeState;

  /// 课程表
  late List<Course> tableCoursesState;

  /// 起始时间
  late TimetableMeta? tableMetaState;

  @override
  void initState() {
    Log.info('TimetableViewer init');
    displayModeState = widget.initialDisplayMode;
    tableCoursesState = widget.initialTableCourses;
    tableMetaState = widget.initialTableMeta;
    super.initState();
    widget.controller?._bindState(this);
  }

  void switchDisplayMode() {
    // 显示有0和1两种模式，可通过(x+1) & 2进行来会切换
    setState(() {
      displayModeState = DisplayMode.values[(displayModeState.index + 1) & 1];
    });
    if (widget.onDisplayChanged != null) {
      // 通知变更
      widget.onDisplayChanged!(displayModeState);
    }
  }

  ///跳到今天的方法
  void jumpToday() {
    if (displayModeState == DisplayMode.daily) {
      (currentKey.currentState as DailyTimetableState).jumpToday();
    } else {
      (currentKey.currentState as WeeklyTimetableState).jumpToday();
    }
  }

  /// 跳到某一周
  void jumpWeek(int week) {
    if (displayModeState == DisplayMode.daily) {
      (currentKey.currentState as DailyTimetableState).jumpWeek(week);
    } else {
      (currentKey.currentState as WeeklyTimetableState).jumpWeek(week);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (displayModeState == DisplayMode.daily) {
      return DailyTimetable(
        key: currentKey,
        allCourses: tableCoursesState,
        initialDate: tableMetaState == null ? DateTime.now() : tableMetaState!.startDate,
        tableCache: widget.tableCache,
        viewChangingCallback: switchDisplayMode,
      );
    }
    return WeeklyTimetable(
      key: currentKey,
      allCourses: tableCoursesState,
      initialDate: tableMetaState == null ? DateTime.now() : tableMetaState!.startDate,
      tableCache: widget.tableCache,
    );
  }
}
