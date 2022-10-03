import 'package:flutter/material.dart';
import 'package:kite/module/edu/timetable/cache.dart';
import 'package:kite/module/edu/timetable/entity.dart';

import 'component/daily_and_weekly.dart';

class TimetablePreviewPage extends StatelessWidget {
  final TimetableMeta meta;
  final List<Course> courses;
  const TimetablePreviewPage({
    required this.meta,
    required this.courses,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tableViewerController = TimetableViewerController();

    return Scaffold(
      appBar: AppBar(
        title: Text('预览 ${meta.name}'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: tableViewerController.switchDisplayMode,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => tableViewerController.jumpToToday(),
          child: Text('今', style: Theme.of(context).textTheme.headline2?.copyWith(color: Colors.white))),
      body: TimetableViewer(
        controller: tableViewerController,
        initialTableMeta: meta,
        initialTableCourses: courses,
        tableCache: TableCache(),
        initialDisplayMode: DisplayMode.weekly,
      ),
    );
  }
}
