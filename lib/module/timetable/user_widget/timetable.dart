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

import '../cache.dart';
import '../entity/course.dart';
import '../entity/meta.dart';
import '../using.dart';
import 'daily.dart';
import 'weekly.dart';

abstract class InitialTimeProtocol {
  DateTime get initialDate;
}

extension InitialTimeUtils on InitialTimeProtocol {
  TimetablePosition locateInTimetable(DateTime target) => TimetablePosition.locate(initialDate, target);
}

class TimetablePosition {
  final int week;
  final int day;

  const TimetablePosition({this.week = 1, this.day = 1});

  static const initial = TimetablePosition();

  static TimetablePosition locate(DateTime initial, DateTime time) {
    // 求一下过了多少天
    int days = time.clearTime().difference(initial.clearTime()).inDays;

    int week = days ~/ 7 + 1;
    int day = days % 7 + 1;
    if (days >= 0 && 1 <= week && week <= 20 && 1 <= day && day <= 7) {
      return TimetablePosition(week: week, day: day);
    } else {
      return const TimetablePosition(week: 1, day: 1);
    }
  }
}

abstract class ITimetableView {
  void jumpToToday();

  void jumpToWeek(int targetWeek);

  void jumpToDay(int targetWeek, int targetDay);

  bool get isTodayView;
}

class TimetableViewerController {
  _TimetableViewerState? _state;

  TimetableViewerController();

  void toggleDisplayMode() {
    _state?.switchDisplayMode();
  }

  void jumpToToday() {
    _state?.jumpToday();
  }

  void jumpToWeek(int week) {
    _state?.jumpWeek(week);
  }

  bool get isTodayView => _state?.isTodayView ?? true;

  void _bindState(State<TimetableViewer> state) {
    _state = state as _TimetableViewerState;
  }
}

class TimetableViewer extends StatefulWidget {
  /// 初始课表元数据
  final TimetableMeta? initialTableMeta;

  /// 初始课表课程
  final List<Course> initialTableCourses;

  /// 初始显示模式
  final ValueNotifier<DisplayMode> $displayMode;

  final VoidCallback? onJumpedToday;

  /// 课表视图使用的缓存
  final TableCache tableCache;

  /// 课表控制器
  final TimetableViewerController? controller;

  final ValueNotifier<TimetablePosition> $currentPos;

  const TimetableViewer({
    required this.initialTableMeta,
    required this.initialTableCourses,
    required this.$displayMode,
    required this.tableCache,
    required this.$currentPos,
    this.onJumpedToday,
    this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<TimetableViewer> createState() => _TimetableViewerState();
}

class _TimetableViewerState extends State<TimetableViewer> {
  /// 最大周数
  /// TODO 还没用上
  // static const int maxWeekCount = 20;

  final cache = TableCache();

  GlobalKey get currentKey => widget.$displayMode.value == DisplayMode.daily ? dailyTimetableKey : weeklyTimetableKey;
  final dailyTimetableKey = GlobalKey();
  final weeklyTimetableKey = GlobalKey();

  /// 课程表
  late List<Course> tableCoursesState;

  /// 起始时间
  late TimetableMeta? tableMetaState;

  @override
  void initState() {
    Log.info('TimetableViewer init');
    super.initState();
    tableCoursesState = widget.initialTableCourses;
    tableMetaState = widget.initialTableMeta;
    widget.controller?._bindState(this);
  }

  void switchDisplayMode() {
    // 显示有0和1两种模式，可通过(x+1) & 2进行来会切换
    setState(() {
      widget.$displayMode.value = DisplayMode.values[(widget.$displayMode.value.index + 1) & 1];
    });
  }

  ///跳到今天的方法
  void jumpToday() {
    (currentKey.currentState as ITimetableView?)?.jumpToToday();
  }

  /// 跳到某一周
  void jumpWeek(int week) {
    (currentKey.currentState as ITimetableView?)?.jumpToWeek(week);
  }

  bool get isTodayView => (currentKey.currentState as ITimetableView?)?.isTodayView ?? true;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.ease,
      child: (widget.$displayMode.value == DisplayMode.daily)
          ? DailyTimetable(
              key: dailyTimetableKey,
          $currentPos: widget.$currentPos,
              allCourses: tableCoursesState,
              initialDate: tableMetaState?.startDate ?? DateTime.now(),
              tableCache: widget.tableCache,
              viewChangingCallback: switchDisplayMode)
          : WeeklyTimetable(
              key: weeklyTimetableKey,
          $currentPos: widget.$currentPos,
              allCourses: tableCoursesState,
              initialDate: tableMetaState?.startDate ?? DateTime.now(),
              tableCache: widget.tableCache),
    );
  }
}
