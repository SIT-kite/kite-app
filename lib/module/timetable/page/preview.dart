/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:flutter/material.dart';

import '../cache.dart';
import '../entity/course.dart';
import '../entity/meta.dart';
import '../user_widget/daily_and_weekly.dart';

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
