import 'package:flutter/material.dart';
import 'package:kite/feature/edu/timetable/cache.dart';

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
  State<TimetableViewer>? state;
  TimetableViewerController();

  void switchDisplayMode() {
    (state as _TimetableViewerState).switchDisplayMode();
  }

  void jumpToToday() {
    (state as _TimetableViewerState).jumpToday();
  }

  void _bindState(State<TimetableViewer> state) {
    this.state = state;
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
    displayModeState = widget.initialDisplayMode;
    tableCoursesState = widget.initialTableCourses;
    tableMetaState = widget.initialTableMeta;
    super.initState();
    if (widget.controller != null) {
      widget.controller!._bindState(this);
    }
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

  @override
  Widget build(BuildContext context) {
    if (displayModeState == DisplayMode.daily) {
      return DailyTimetable(
        key: currentKey,
        allCourses: tableCoursesState,
        initialDate: tableMetaState == null ? DateTime.now() : tableMetaState!.startDate,
        tableCache: widget.tableCache,
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
